Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696DB393975
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 01:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbhE0Xyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 19:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233938AbhE0Xyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 19:54:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C18A61178;
        Thu, 27 May 2021 23:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622159597;
        bh=unu2CwRiIklLEI2TXoBveyWjP3PNdHwKr8/qOcOwHz0=;
        h=From:To:Cc:Subject:Date:From;
        b=hkto4pcLDdjg2amAWXxT+C//4V+e6tlGib27nP72HTOxXnR12jea3mWhtLFQ4dm0E
         7gwn3yhQgn+Q9mY4pgnnWtM19dxKvdC+D3JFlgXKY/zQbcHieUH1I/os3kiQaWnWa8
         7StchJcisGJpEhNQxJQIlaL4KJC1m3VRSS7Ju1ZaDoe77Col5CYNf88ewi/OFQ5RKw
         7Yt6KfSlRbCNsUcDqAKmbR4xtASP6DXqsDDkYHSQCDHe3Giqjl6WSFc6N/76VUO+uy
         lYdSz5Vj1wzt8WHYuF05AytMP14o1V84uCWmMHAo1pYLmHfHcHGtrLFxeYcYzlanQI
         EH1Gc8b/jdHLw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH] fscrypt: don't ignore minor_hash when hash is 0
Date:   Thu, 27 May 2021 16:52:36 -0700
Message-Id: <20210527235236.2376556-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6ca7d16593ff..d00455440d08 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -344,13 +344,9 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 		     offsetof(struct fscrypt_nokey_name, sha256));
 	BUILD_BUG_ON(BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX) > NAME_MAX);
 
-	if (hash) {
-		nokey_name.dirhash[0] = hash;
-		nokey_name.dirhash[1] = minor_hash;
-	} else {
-		nokey_name.dirhash[0] = 0;
-		nokey_name.dirhash[1] = 0;
-	}
+	nokey_name.dirhash[0] = hash;
+	nokey_name.dirhash[1] = minor_hash;
+
 	if (iname->len <= sizeof(nokey_name.bytes)) {
 		memcpy(nokey_name.bytes, iname->name, iname->len);
 		size = offsetof(struct fscrypt_nokey_name, bytes[iname->len]);

base-commit: c4681547bcce777daf576925a966ffa824edd09d
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

