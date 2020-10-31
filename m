Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD5C2A1AF7
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 23:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgJaWJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 18:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgJaWJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 18:09:54 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFED320791;
        Sat, 31 Oct 2020 22:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604182193;
        bh=CzWlU7YvaDDFQzbnSIqzxHmegNpaCZuzfUzquzwdRZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yY0RxRPv8oHtiWbHUr9Cr2hlbEOFT32S6HC5VLY8J6n47d3f61wfgWHeOUEMFvw+T
         NppNyTohL9FVQlvG6x9FMrs9/vt89g7/rn16uLbEkTCRvUtqwoKFauyfLfChrFaKm+
         j1pyh4yr7ZVe3MoRzJf6NfdkBTvrNL2ub+GvZT6Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.19 4/5] fscrypt: only set dentry_operations on ciphertext dentries
Date:   Sat, 31 Oct 2020 15:05:52 -0700
Message-Id: <20201031220553.1085782-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201031220553.1085782-1-ebiggers@kernel.org>
References: <20201031220553.1085782-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit d456a33f041af4b54f3ce495a86d00c246165032 upstream.

Plaintext dentries are always valid, so only set fscrypt_d_ops on
ciphertext dentries.

Besides marginally improved performance, this allows overlayfs to use an
fscrypt-encrypted upperdir, provided that all the following are true:

    (1) The fscrypt encryption key is placed in the keyring before
	mounting overlayfs, and remains while the overlayfs is mounted.

    (2) The overlayfs workdir uses the same encryption policy.

    (3) No dentries for the ciphertext names of subdirectories have been
	created in the upperdir or workdir yet.  (Since otherwise
	d_splice_alias() will reuse the old dentry with ->d_op set.)

One potential use case is using an ephemeral encryption key to encrypt
all files created or changed by a container, so that they can be
securely erased ("crypto-shredded") after the container stops.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/hooks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 2e7498a821a48..9d8910e86ee5d 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -115,9 +115,8 @@ int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry)
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_ENCRYPTED_NAME;
 		spin_unlock(&dentry->d_lock);
+		d_set_d_op(dentry, &fscrypt_d_ops);
 	}
-
-	d_set_d_op(dentry, &fscrypt_d_ops);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_lookup);
-- 
2.29.1

