Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E88D3938DA
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 00:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhE0XAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 19:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0XAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 19:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3324613B4;
        Thu, 27 May 2021 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622156308;
        bh=88+eV716DIdAR5tUqch1HNXLPldwfov0uEMbNQcqzSk=;
        h=From:To:Cc:Subject:Date:From;
        b=USUAUQjUtNWzqcudS3yex3pfLJhCHJxn96LN10teB1uRolUdbFXqmYtAIhr5fZwVA
         ydfAB/sAiwJZiJYP4mh+/NEhElElpFks/CCzimQypgzsvb2wM9zLCYRYhawT2aZHSw
         YKeByIJ7ToHN4hJsxZssdSBwe/YrTkR1XfbC9hb6wBnq001G2B4U3+rHLDHB2u+REG
         4YTCve+HKoYqbBeVbT4kYn8kKkEJrnvsO1I/C+3rp6W7//306k4Vd8CYoUuGSd6dVx
         kALocVvXzUfJtzHWuZ+Zn0rOu3WcOxfmSWx0fOCnHfqkpROnbPbOUQDGugMtsZW5NU
         iPaRCYmERRmtw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: [PATCH] fscrypt: fix derivation of SipHash keys on big endian CPUs
Date:   Thu, 27 May 2021 15:55:25 -0700
Message-Id: <20210527225525.2365513-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Typically, the cryptographic APIs that fscrypt uses take keys as byte
arrays, which avoids endianness issues.  However, siphash_key_t is an
exception.  It is defined as 'u64 key[2];', i.e. the 128-bit key is
expected to be given directly as two 64-bit words in CPU endianness.

fscrypt_derive_dirhash_key() forgot to take this into account.
Therefore, the SipHash keys used to index encrypted+casefolded
directories differ on big endian vs. little endian platforms.
This makes such directories non-portable between these platforms.

Fix this by always using the little endian order.  This is a breaking
change for big endian platforms, but this should be fine in practice
since the encrypt+casefold support isn't known to actually be used on
any big endian platforms yet.

Fixes: aa408f835d02 ("fscrypt: derive dirhash key for casefolded directories")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keysetup.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 261293fb7097..4d98377c07a7 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -221,6 +221,16 @@ int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 				  sizeof(ci->ci_dirhash_key));
 	if (err)
 		return err;
+
+	/*
+	 * The SipHash APIs expect the key as a pair of 64-bit words, not as a
+	 * byte array.  Make sure to use a consistent endianness.
+	 */
+	BUILD_BUG_ON(sizeof(ci->ci_dirhash_key) != 16);
+	BUILD_BUG_ON(ARRAY_SIZE(ci->ci_dirhash_key.key) != 2);
+	le64_to_cpus(&ci->ci_dirhash_key.key[0]);
+	le64_to_cpus(&ci->ci_dirhash_key.key[1]);
+
 	ci->ci_dirhash_key_initialized = true;
 	return 0;
 }
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

