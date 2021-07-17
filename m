Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE713CC001
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 02:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhGQAMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 20:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhGQAMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 20:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8C5B613EB;
        Sat, 17 Jul 2021 00:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626480545;
        bh=mQalqo4yX2/WFHAqcCR3M6bAckgMZv+GoQQVguZUojg=;
        h=From:To:Cc:Subject:Date:From;
        b=Czdd4R2lKv9MIM/JhhYPTXjFLbxHS/3C8TFz1pqtME8vjlwZ9NRvoqylyHr2jab0P
         +SVFWvEPUyuA4cY+/QN6ULoIcIYVyTipq0iG4JGxR2HKvKCVBSM/ja93Tn9DE04BEl
         DmAojerbttD4YAoyHMjgo3Ev8CE8vyZHfZBKXO8tyflhjm5UHuy7UBjPxHn3p+dp/N
         5PtlqH6gVxQnmW77akZG6PPdraU8FzEYObbGcHU0hYtVoSZPIvAgOo9IKU6MuMagIt
         ZQ2rXQFYquYTcQ+kCCYvod+SXBNEJGrJ9QUqaWZo0Yvd0fw6NOlAcKSdGsesL7fZ2u
         3hpOPiPJRcy0A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 4.9] fscrypt: don't ignore minor_hash when hash is 0
Date:   Fri, 16 Jul 2021 19:05:57 -0500
Message-Id: <20210717000557.60029-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 77f30bfcfcf484da7208affd6a9e63406420bf91 upstream.
[Please apply to 4.9-stable.]

When initializing a no-key name, fscrypt_fname_disk_to_usr() sets the
minor_hash to 0 if the (major) hash is 0.

This doesn't make sense because 0 is a valid hash code, so we shouldn't
ignore the filesystem-provided minor_hash in that case.  Fix this by
removing the special case for 'hash == 0'.

This is an old bug that appears to have originated when the encryption
code in ext4 and f2fs was moved into fs/crypto/.  The original ext4 and
f2fs code passed the hash by pointer instead of by value.  So
'if (hash)' actually made sense then, as it was checking whether a
pointer was NULL.  But now the hashes are passed by value, and
filesystems just pass 0 for any hashes they don't have.  There is no
need to handle this any differently from the hashes actually being 0.

It is difficult to reproduce this bug, as it only made a difference in
the case where a filename's 32-bit major hash happened to be 0.
However, it probably had the largest chance of causing problems on
ubifs, since ubifs uses minor_hash to do lookups of no-key names, in
addition to using it as a readdir cookie.  ext4 only uses minor_hash as
a readdir cookie, and f2fs doesn't use minor_hash at all.

Fixes: 0b81d0779072 ("fs crypto: move per-file encryption from f2fs tree to fs/crypto")
Cc: <stable@vger.kernel.org> # v4.6+
Link: https://lore.kernel.org/r/20210527235236.2376556-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index e14bb7b67e9c..5136ea195934 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -294,12 +294,8 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 					   oname->name);
 		return 0;
 	}
-	if (hash) {
-		memcpy(buf, &hash, 4);
-		memcpy(buf + 4, &minor_hash, 4);
-	} else {
-		memset(buf, 0, 8);
-	}
+	memcpy(buf, &hash, 4);
+	memcpy(buf + 4, &minor_hash, 4);
 	memcpy(buf + 8, iname->name + ((iname->len - 17) & ~15), 16);
 	oname->name[0] = '_';
 	oname->len = 1 + digest_encode(buf, 24, oname->name + 1);
-- 
2.32.0

