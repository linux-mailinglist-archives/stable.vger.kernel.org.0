Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C862B77B8
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 09:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgKRH5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 02:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgKRH5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 02:57:40 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2419920B80;
        Wed, 18 Nov 2020 07:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605686260;
        bh=3OsEYdcS4OXEC4S/G7MM1sLUIzE8N1bOkGh+royk33o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7cLjJHQpC3nSDFO4proY4QRa0P96Ih6le3z/91WWyOKE3Z5PochE5fqjTob041/2
         brGZ+WeaJWqgDddJkzN1St9g7Zks55FLOKIMmNgj4ZyafhYDB9odDybtwvl4NrdhlV
         /e1eD0rWkK/diWMI77ke9p3Nzz9WadhOoZc1xss0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/5] ext4: prevent creating duplicate encrypted filenames
Date:   Tue, 17 Nov 2020 23:56:06 -0800
Message-Id: <20201118075609.120337-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118075609.120337-1-ebiggers@kernel.org>
References: <20201118075609.120337-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on ext4 by rejecting no-key dentries in ext4_add_entry().

Note that the duplicate check in ext4_find_dest_de() sometimes prevented
this bug.  However in many cases it didn't, since ext4_find_dest_de()
doesn't examine every dentry.

Fixes: 4461471107b7 ("ext4 crypto: enable filename encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/namei.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 33509266f5a0..793fc7db9d28 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2195,6 +2195,9 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
 #ifdef CONFIG_UNICODE
 	if (sb_has_strict_encoding(sb) && IS_CASEFOLDED(dir) &&
 	    sb->s_encoding && utf8_validate(sb->s_encoding, &dentry->d_name))
-- 
2.29.2

