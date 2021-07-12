Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163D3C5F44
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhGLPcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 11:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhGLPcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 11:32:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2F2160E08;
        Mon, 12 Jul 2021 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626103797;
        bh=EETKv1I4YGOmBxga+KZiuwr9pxvmkfcPdpdY1biTvq4=;
        h=From:To:Cc:Subject:Date:From;
        b=Fy0XJdC9Afif46oIDUjOh7CkNt7rkHuWkO5bg/W29g9l28HGDMYk642gqwjjhMzcP
         M2wYQ2YCpF6IJz99QgyNE4XH2xfuKvuwdjyRVHxzu5irpJIQyGcJIBJOUlDbL/cq67
         4wu9M2xAlhuhUd7AsbOOHjlkqTpCn/0uqO5ZSl/TbmqeLMfuTY0LwCC8p/PzDv62SQ
         yaNBr+sn2Y0P80U1JLCsXsbf+Kgj87aEowjsFa4zE10vVWIK1dIAmdQuQP1dEDr/zG
         qj022gelCSf/nYDgjMefXismo2fRuTeo6KbQU51B8A5R04fSFc9p39OT0e566v/j5m
         8/4+gnrA6dNlQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 5.4/4.19/4.14] fscrypt: don't ignore minor_hash when hash is 0
Date:   Mon, 12 Jul 2021 10:27:17 -0500
Message-Id: <20210712152717.6480-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 77f30bfcfcf484da7208affd6a9e63406420bf91 upstream.
[Please apply to 5.4-stable, 4.19-stable, and 4.14-stable.]

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
 fs/crypto/fname.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 3da3707c10e3..891328f09b3c 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -273,13 +273,8 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 					   oname->name);
 		return 0;
 	}
-	if (hash) {
-		digested_name.hash = hash;
-		digested_name.minor_hash = minor_hash;
-	} else {
-		digested_name.hash = 0;
-		digested_name.minor_hash = 0;
-	}
+	digested_name.hash = hash;
+	digested_name.minor_hash = minor_hash;
 	memcpy(digested_name.digest,
 	       FSCRYPT_FNAME_DIGEST(iname->name, iname->len),
 	       FSCRYPT_FNAME_DIGEST_SIZE);
-- 
2.32.0

