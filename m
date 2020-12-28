Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195A32E6A2F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgL1S4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728869AbgL1S4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:56:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D183A22AAD;
        Mon, 28 Dec 2020 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181729;
        bh=Qv8XPvD4Whz8DkvwGwAf7mmtYtvGPNNWzNeowimMGrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0LLBzMoZ0aHGfOBsg3ITTIW0dgo1gTH+nM+OngQXse5z6gWy3lvNwUyvKs6g+p9M
         WRElB9XR6KPx8r9J9nxTkurn05YA7qHcQ8c89ve1zpJp3m1+uT89+1x2bueSLqkNHh
         3HR9gG6QzcO36mQf1mr1IToFU2ia1oxP6TB107pAeDSlI+9XNgChm5GGD0xvh/uIYP
         5Cv8F1LqjQZ3fb4/NkaXYU9ekLU9g7lHPVkOVRgpEDP+A6Y0ATp2yUuULup5HwyMG5
         4/fQRDmYSPSMECifsZACf/4Fp0VnZXeIUJsGi86UuidY7mBk5IlZQhBtlsqlzYp5w0
         GF1YPOknLE9nA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 5.4 2/4] ext4: prevent creating duplicate encrypted filenames
Date:   Mon, 28 Dec 2020 10:54:31 -0800
Message-Id: <20201228185433.61129-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228185433.61129-1-ebiggers@kernel.org>
References: <20201228185433.61129-1-ebiggers@kernel.org>
MIME-Version: 1.0
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
---
 fs/ext4/namei.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 36a81b57012a5..59038e361337c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2192,6 +2192,9 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
 #ifdef CONFIG_UNICODE
 	if (ext4_has_strict_mode(sbi) && IS_CASEFOLDED(dir) &&
 	    sbi->s_encoding && utf8_validate(sbi->s_encoding, &dentry->d_name))
-- 
2.29.2

