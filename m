Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48A52E997A
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbhADQAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbhADQAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCBD2245C;
        Mon,  4 Jan 2021 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775986;
        bh=Txg8vjG+zm1ySgA6xD9pxK8obTvav+wm5HL9doUGluk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2vXyF40YOzx6wwliZngJ6xcTaTesip7Gu8ZpXUr0yyQpadbcCOukHphhuYRyZbdn
         nQgSeL2ErStgWNwUKo85tKz4PhOeOd8nVB5g++CQKWfEo1YsTTaPZogpUQwSAaGA89
         O1nqmEYC+j2PHujtq5fYZZjq0CiQKNjJZSE3NObE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.4 08/47] fscrypt: remove kernel-internal constants from UAPI header
Date:   Mon,  4 Jan 2021 16:57:07 +0100
Message-Id: <20210104155706.154631213@linuxfoundation.org>
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

commit 3ceb6543e9cf6ed87cc1fbc6f23ca2db903564cd upstream.

There isn't really any valid reason to use __FSCRYPT_MODE_MAX or
FSCRYPT_POLICY_FLAGS_VALID in a userspace program.  These constants are
only meant to be used by the kernel internally, and they are defined in
the UAPI header next to the mode numbers and flags only so that kernel
developers don't forget to update them when adding new modes or flags.

In https://lkml.kernel.org/r/20201005074133.1958633-2-satyat@google.com
there was an example of someone wanting to use __FSCRYPT_MODE_MAX in a
user program, and it was wrong because the program would have broken if
__FSCRYPT_MODE_MAX were ever increased.  So having this definition
available is harmful.  FSCRYPT_POLICY_FLAGS_VALID has the same problem.

So, remove these definitions from the UAPI header.  Replace
FSCRYPT_POLICY_FLAGS_VALID with just listing the valid flags explicitly
in the one kernel function that needs it.  Move __FSCRYPT_MODE_MAX to
fscrypt_private.h, remove the double underscores (which were only
present to discourage use by userspace), and add a BUILD_BUG_ON() and
comments to (hopefully) ensure it is kept in sync.

Keep the old name FS_POLICY_FLAGS_VALID, since it's been around for
longer and there's a greater chance that removing it would break source
compatibility with some program.  Indeed, mtd-utils is using it in
an #ifdef, and removing it would introduce compiler warnings (about
FS_POLICY_FLAGS_PAD_* being redefined) into the mtd-utils build.
However, reduce its value to 0x07 so that it only includes the flags
with old names (the ones present before Linux 5.4), and try to make it
clear that it's now "frozen" and no new flags should be added to it.

Fixes: 2336d0deb2d4 ("fscrypt: use FSCRYPT_ prefix for uapi constants")
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://lore.kernel.org/r/20201024005132.495952-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/crypto/fscrypt_private.h  |    5 ++++-
 fs/crypto/keysetup.c         |    2 ++
 fs/crypto/policy.c           |    6 ++++--
 include/uapi/linux/fscrypt.h |    5 ++---
 4 files changed, 12 insertions(+), 6 deletions(-)

--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -23,6 +23,9 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+/* Keep this in sync with include/uapi/linux/fscrypt.h */
+#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_ADIANTUM
+
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
 	u8 contents_encryption_mode;
@@ -387,7 +390,7 @@ struct fscrypt_master_key {
 	spinlock_t		mk_decrypted_inodes_lock;
 
 	/* Per-mode tfms for DIRECT_KEY policies, allocated on-demand */
-	struct crypto_skcipher	*mk_mode_keys[__FSCRYPT_MODE_MAX + 1];
+	struct crypto_skcipher	*mk_mode_keys[FSCRYPT_MODE_MAX + 1];
 
 } __randomize_layout;
 
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -55,6 +55,8 @@ static struct fscrypt_mode *
 select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(available_modes) != FSCRYPT_MODE_MAX + 1);
+
 	if (S_ISREG(inode->i_mode))
 		return &available_modes[fscrypt_policy_contents_mode(policy)];
 
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -55,7 +55,8 @@ bool fscrypt_supported_policy(const unio
 			return false;
 		}
 
-		if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
+		if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
+				      FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
 			fscrypt_warn(inode,
 				     "Unsupported encryption flags (0x%02x)",
 				     policy->flags);
@@ -76,7 +77,8 @@ bool fscrypt_supported_policy(const unio
 			return false;
 		}
 
-		if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
+		if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
+				      FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
 			fscrypt_warn(inode,
 				     "Unsupported encryption flags (0x%02x)",
 				     policy->flags);
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -17,7 +17,6 @@
 #define FSCRYPT_POLICY_FLAGS_PAD_32		0x03
 #define FSCRYPT_POLICY_FLAGS_PAD_MASK		0x03
 #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
-#define FSCRYPT_POLICY_FLAGS_VALID		0x07
 
 /* Encryption algorithms */
 #define FSCRYPT_MODE_AES_256_XTS		1
@@ -25,7 +24,7 @@
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_ADIANTUM			9
-#define __FSCRYPT_MODE_MAX			9
+/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
@@ -162,7 +161,7 @@ struct fscrypt_get_key_status_arg {
 #define FS_POLICY_FLAGS_PAD_32		FSCRYPT_POLICY_FLAGS_PAD_32
 #define FS_POLICY_FLAGS_PAD_MASK	FSCRYPT_POLICY_FLAGS_PAD_MASK
 #define FS_POLICY_FLAG_DIRECT_KEY	FSCRYPT_POLICY_FLAG_DIRECT_KEY
-#define FS_POLICY_FLAGS_VALID		FSCRYPT_POLICY_FLAGS_VALID
+#define FS_POLICY_FLAGS_VALID		0x07	/* contains old flags only */
 #define FS_ENCRYPTION_MODE_INVALID	0	/* never used */
 #define FS_ENCRYPTION_MODE_AES_256_XTS	FSCRYPT_MODE_AES_256_XTS
 #define FS_ENCRYPTION_MODE_AES_256_GCM	2	/* never used */


