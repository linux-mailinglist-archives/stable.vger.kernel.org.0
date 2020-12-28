Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22F92E6A12
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgL1SuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgL1SuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:50:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87350221F8;
        Mon, 28 Dec 2020 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181379;
        bh=dAFuJzF1b9qGeRQvQOMo1/z2sIG717gVfFInQMDZZkc=;
        h=From:To:Cc:Subject:Date:From;
        b=uN32AtsBVvAECC9TMngB81MNnQaUjIJHHJmgL+hY66pjIZ35M2zJfMET57oQmP61Z
         q6v5KTEK1n1PCZqdOjqEiyniBa8M79tPw712+nz4Bim+9pb4oiyPwOqiiftjr0JW8b
         7smGavViIaKOrZu3875dK4JJOMzHVkKiTW9T8faJxL4PMPjQYYaYbmqvoSBjxvjPo4
         pCv9Udu6p5vM7ELC+2Mn48Wlzz1MuySBMEl4bhOWzCRKfWOtHkkIAn6eghxDtq/b6J
         pXyF+MUOdOLQm4Tfc/NYL3sDeRghwqne1Rfl8HqovEv5a1LNqsSroo/Liw2Py74uDW
         WgCpS9zmSzolA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 5.4] fscrypt: remove kernel-internal constants from UAPI header
Date:   Mon, 28 Dec 2020 10:47:47 -0800
Message-Id: <20201228184747.56259-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 3ceb6543e9cf6ed87cc1fbc6f23ca2db903564cd upstream.
[Please apply to 5.4-stable.]

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
---
 fs/crypto/fscrypt_private.h  | 5 ++++-
 fs/crypto/keysetup.c         | 2 ++
 fs/crypto/policy.c           | 6 ++++--
 include/uapi/linux/fscrypt.h | 5 ++---
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e84efc01512e4..ec73872661902 100644
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
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 75898340eb468..3e86f75b532a2 100644
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
 
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 4072ba644595b..8e1b10861c104 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -55,7 +55,8 @@ bool fscrypt_supported_policy(const union fscrypt_policy *policy_u,
 			return false;
 		}
 
-		if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
+		if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
+				      FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
 			fscrypt_warn(inode,
 				     "Unsupported encryption flags (0x%02x)",
 				     policy->flags);
@@ -76,7 +77,8 @@ bool fscrypt_supported_policy(const union fscrypt_policy *policy_u,
 			return false;
 		}
 
-		if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
+		if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
+				      FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
 			fscrypt_warn(inode,
 				     "Unsupported encryption flags (0x%02x)",
 				     policy->flags);
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 39ccfe9311c38..b14f436f4ebd3 100644
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
-- 
2.29.2

