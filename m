Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67F62E6A5B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 20:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgL1TN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 14:13:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729051AbgL1TN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 14:13:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC1C322B2A;
        Mon, 28 Dec 2020 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609182797;
        bh=wcDIzfW0TdVWW8ZUcFxkhA+O3mFdLmRyWJlQxT4S1QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAQNUpGKbUC6XgijBxKuQ6fLblzIjwttUoUazHLtwrmvyRAc/Hp21PThkFceo2oND
         +20rouDAMTnb8+gPYw32tirqHwpl3Trft2e5ZG0gVJkOImuAdAkPKdMuxaKEVvzoQm
         8od/01VOrXkJqs3NmQuHziqvc8o5IVveuM//bYZRclslEfElrjsTe7NX/6K9O2R9ud
         RPjixOFxq4uHlp3ZDFYPaEDRV2f5+gzHb5j82nO0p0ezNlQYr40a86s5ZeVk9oIWxi
         Pbj7E9prte/MgEp1mkzEDRYpcjCnfd6/Wc287+/VJezxQ6sKGj3VcSH8uHMtx3G5LU
         WYCR6iIAZSi3A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 4.19 2/4] ext4: prevent creating duplicate encrypted filenames
Date:   Mon, 28 Dec 2020 11:12:09 -0800
Message-Id: <20201228191211.138300-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228191211.138300-1-ebiggers@kernel.org>
References: <20201228191211.138300-1-ebiggers@kernel.org>
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
index 4191552880bd7..3c238006870d3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2106,6 +2106,9 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
 	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
 	if (retval)
 		return retval;
-- 
2.29.2

