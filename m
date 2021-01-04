Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24792E9A9E
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbhADQMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:12:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbhADQAD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0DF222509;
        Mon,  4 Jan 2021 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775977;
        bh=hYv88ZhcQDYxxkPWVVQs8IfCZIWBUefAj4Juajj6/HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPS6jW7pLES0Z3b5A1J9tTdjwIn6blPEetZb1OWdxGCWso99VDCCN/9qr4SDc65RE
         Fqg4fvEEcG7Bq8898/Rl7ITjOVza5fdYyZkh8gQw4UjuNq1mocMCHcCY1Z+WccKuif
         to48GPwiRQi3zF2VTzHfe0LA0M59ZCVoctk8ahNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.4 04/47] ext4: prevent creating duplicate encrypted filenames
Date:   Mon,  4 Jan 2021 16:57:03 +0100
Message-Id: <20210104155705.961484814@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 75d18cd1868c2aee43553723872c35d7908f240f upstream.

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on ext4 by rejecting no-key dentries in ext4_add_entry().

Note that the duplicate check in ext4_find_dest_de() sometimes prevented
this bug.  However in many cases it didn't, since ext4_find_dest_de()
doesn't examine every dentry.

Fixes: 4461471107b7 ("ext4 crypto: enable filename encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2192,6 +2192,9 @@ static int ext4_add_entry(handle_t *hand
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
 #ifdef CONFIG_UNICODE
 	if (ext4_has_strict_mode(sbi) && IS_CASEFOLDED(dir) &&
 	    sbi->s_encoding && utf8_validate(sbi->s_encoding, &dentry->d_name))


