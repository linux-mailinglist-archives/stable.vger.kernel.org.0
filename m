Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE39372E1
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfFFLaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:30:05 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32988 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727472AbfFFLaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 07:30:05 -0400
Received: from lhreml705-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 2C5BD1A82F1ADAA7EBC2;
        Thu,  6 Jun 2019 12:30:03 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.46) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 6 Jun 2019 12:29:55 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 1/2] evm: add option to set a random HMAC key at early boot
Date:   Thu, 6 Jun 2019 13:26:19 +0200
Message-ID: <20190606112620.26488-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606112620.26488-1-roberto.sassu@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.154]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mutable files can be created before the HMAC key is unsealed, for example
the dracut state and the systemd journal. Next accesses to those files will
be denied if the new appraisal mode enforce-evm is selected
(INTEGRITY_UNKNOWN returned by EVM is considered as an error).

This patch solves this problem by initializing EVM at early boot with a
randomly generated key. This key is used to calculate and verify the HMAC
for new files in a tmpfs filesystem, until the persistent key is loaded.

The new xattr type EVM_XATTR_HMAC_RND_KEY has been introduced to determine
which key should be used to verify the HMAC. This type is used for new
files and file updates (unless security.evm exists with a different type),
until the persistent key is loaded. Afterwards, existing HMACs calculated
with the random key are replaced with HMACs calculated with the persistent
key.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++-
 security/integrity/evm/evm.h                  | 10 +++-
 security/integrity/evm/evm_crypto.c           | 57 ++++++++++++++++---
 security/integrity/evm/evm_main.c             | 41 ++++++++++---
 security/integrity/integrity.h                |  1 +
 5 files changed, 96 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 138f6664b2e2..fe5cde58c11b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1239,9 +1239,11 @@
 			has equivalent usage. See its documentation for details.
 
 	evm=		[EVM]
-			Format: { "fix" }
-			Permit 'security.evm' to be updated regardless of
-			current integrity status.
+			Format: { "fix" | "random" }
+			Specify "fix" to permit 'security.evm' to be updated
+			regardless of current integrity status. Specify "random"
+			to initialize EVM with a random key to be used for new
+			files until the persistent HMAC key is loaded.
 
 	failslab=
 	fail_page_alloc=
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index c3f437f5db10..0ca4490b7e40 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -24,9 +24,11 @@
 #define EVM_INIT_HMAC	0x0001
 #define EVM_INIT_X509	0x0002
 #define EVM_ALLOW_METADATA_WRITES	0x0004
+#define EVM_INIT_HMAC_RND_KEY	0x0008
 #define EVM_SETUP_COMPLETE 0x80000000 /* userland has signaled key load */
 
-#define EVM_KEY_MASK (EVM_INIT_HMAC | EVM_INIT_X509)
+#define EVM_PERSISTENT_KEY_MASK (EVM_INIT_HMAC | EVM_INIT_X509)
+#define EVM_KEY_MASK (EVM_INIT_HMAC | EVM_INIT_X509 | EVM_INIT_HMAC_RND_KEY)
 #define EVM_INIT_MASK (EVM_INIT_HMAC | EVM_INIT_X509 | EVM_SETUP_COMPLETE | \
 		       EVM_ALLOW_METADATA_WRITES)
 
@@ -53,19 +55,21 @@ struct evm_digest {
 } __packed;
 
 int evm_init_key(void);
+void evm_set_random_key(void);
 int evm_update_evmxattr(struct dentry *dentry,
 			const char *req_xattr_name,
 			const char *req_xattr_value,
 			size_t req_xattr_value_len);
 int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 		  const char *req_xattr_value,
-		  size_t req_xattr_value_len, struct evm_digest *data);
+		  size_t req_xattr_value_len, char type,
+		  struct evm_digest *data);
 int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
 		  const char *req_xattr_value,
 		  size_t req_xattr_value_len, char type,
 		  struct evm_digest *data);
 int evm_init_hmac(struct inode *inode, const struct xattr *xattr,
-		  char *hmac_val);
+		  struct evm_ima_xattr_data *evm_xattr);
 int evm_init_secfs(void);
 
 #endif
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 82a38e801ee4..51a02200b057 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -19,6 +19,7 @@
 #include <linux/crypto.h>
 #include <linux/xattr.h>
 #include <linux/evm.h>
+#include <linux/random.h>
 #include <keys/encrypted-type.h>
 #include <crypto/hash.h>
 #include <crypto/hash_info.h>
@@ -30,6 +31,7 @@ static unsigned char evmkey[MAX_KEY_SIZE];
 static const int evmkey_len = MAX_KEY_SIZE;
 
 struct crypto_shash *hmac_tfm;
+struct crypto_shash *hmac_rnd_tfm;
 static struct crypto_shash *evm_tfm[HASH_ALGO__LAST];
 
 static DEFINE_MUTEX(mutex);
@@ -62,8 +64,10 @@ int evm_set_key(void *key, size_t keylen)
 	rc = -EINVAL;
 	if (keylen > MAX_KEY_SIZE)
 		goto inval;
+	memset(evmkey, 0, sizeof(evmkey));
 	memcpy(evmkey, key, keylen);
 	evm_initialized |= EVM_INIT_HMAC;
+	evm_initialized &= ~EVM_INIT_HMAC_RND_KEY;
 	pr_info("key initialized\n");
 	return 0;
 inval:
@@ -74,6 +78,12 @@ int evm_set_key(void *key, size_t keylen)
 }
 EXPORT_SYMBOL_GPL(evm_set_key);
 
+void evm_set_random_key(void)
+{
+	get_random_bytes(evmkey, sizeof(evmkey));
+	evm_initialized |= EVM_INIT_HMAC_RND_KEY;
+}
+
 static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 {
 	long rc;
@@ -88,6 +98,9 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 		}
 		tfm = &hmac_tfm;
 		algo = evm_hmac;
+	} else if (type == EVM_XATTR_HMAC_RND_KEY) {
+		tfm = &hmac_rnd_tfm;
+		algo = evm_hmac;
 	} else {
 		if (hash_algo >= HASH_ALGO__LAST)
 			return ERR_PTR(-EINVAL);
@@ -108,7 +121,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 			mutex_unlock(&mutex);
 			return ERR_PTR(rc);
 		}
-		if (type == EVM_XATTR_HMAC) {
+		if (type == EVM_XATTR_HMAC || EVM_XATTR_HMAC_RND_KEY) {
 			rc = crypto_shash_setkey(*tfm, evmkey, evmkey_len);
 			if (rc) {
 				crypto_free_shash(*tfm);
@@ -255,10 +268,10 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 
 int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 		  const char *req_xattr_value, size_t req_xattr_value_len,
-		  struct evm_digest *data)
+		  char type, struct evm_digest *data)
 {
 	return evm_calc_hmac_or_hash(dentry, req_xattr_name, req_xattr_value,
-				    req_xattr_value_len, EVM_XATTR_HMAC, data);
+				    req_xattr_value_len, type, data);
 }
 
 int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
@@ -296,6 +309,29 @@ static int evm_is_immutable(struct dentry *dentry, struct inode *inode)
 	return rc;
 }
 
+static enum evm_ima_xattr_type evm_get_default_type(struct dentry *dentry)
+{
+	enum evm_ima_xattr_type evm_default_type = EVM_XATTR_HMAC;
+	struct evm_ima_xattr_data xattr_data;
+	int rc;
+
+	if (evm_initialized & EVM_INIT_HMAC_RND_KEY)
+		evm_default_type = EVM_XATTR_HMAC_RND_KEY;
+	else
+		goto out;
+
+	rc = vfs_getxattr(dentry, XATTR_NAME_EVM, (char *)&xattr_data,
+			  sizeof(xattr_data));
+
+	if (rc == sizeof(xattr_data))
+		evm_default_type = xattr_data.type;
+out:
+	if (evm_default_type != EVM_XATTR_HMAC_RND_KEY &&
+	    !(evm_initialized & EVM_INIT_HMAC))
+		return IMA_XATTR_LAST;
+
+	return evm_default_type;
+}
 
 /*
  * Calculate the hmac and update security.evm xattr
@@ -306,6 +342,7 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 			const char *xattr_value, size_t xattr_value_len)
 {
 	struct inode *inode = d_backing_inode(dentry);
+	enum evm_ima_xattr_type evm_default_type;
 	struct evm_digest data;
 	int rc = 0;
 
@@ -319,11 +356,15 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 	if (rc)
 		return -EPERM;
 
+	evm_default_type = evm_get_default_type(dentry);
+	if (evm_default_type == IMA_XATTR_LAST)
+		return -ENOKEY;
+
 	data.hdr.algo = HASH_ALGO_SHA1;
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
-			   xattr_value_len, &data);
+			   xattr_value_len, evm_default_type, &data);
 	if (rc == 0) {
-		data.hdr.xattr.sha1.type = EVM_XATTR_HMAC;
+		data.hdr.xattr.sha1.type = evm_default_type;
 		rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_EVM,
 					   &data.hdr.xattr.data[1],
 					   SHA1_DIGEST_SIZE + 1, 0);
@@ -334,18 +375,18 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 }
 
 int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
-		  char *hmac_val)
+		  struct evm_ima_xattr_data *evm_xattr)
 {
 	struct shash_desc *desc;
 
-	desc = init_desc(EVM_XATTR_HMAC, HASH_ALGO_SHA1);
+	desc = init_desc(evm_xattr->type, HASH_ALGO_SHA1);
 	if (IS_ERR(desc)) {
 		pr_info("init_desc failed\n");
 		return PTR_ERR(desc);
 	}
 
 	crypto_shash_update(desc, lsm_xattr->value, lsm_xattr->value_len);
-	hmac_add_misc(desc, inode, EVM_XATTR_HMAC, hmac_val);
+	hmac_add_misc(desc, inode, evm_xattr->type, evm_xattr->digest);
 	kfree(desc);
 	return 0;
 }
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index b6d9f14bc234..faa4a02a3139 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -59,14 +59,16 @@ static struct xattr_list evm_config_default_xattrnames[] = {
 
 LIST_HEAD(evm_config_xattrnames);
 
-static int evm_fixmode;
-static int __init evm_set_fixmode(char *str)
+static int evm_fixmode, evm_random_key;
+static int __init evm_setup(char *str)
 {
 	if (strncmp(str, "fix", 3) == 0)
 		evm_fixmode = 1;
+	if (strncmp(str, "random", 6) == 0)
+		evm_random_key = 1;
 	return 0;
 }
-__setup("evm=", evm_set_fixmode);
+__setup("evm=", evm_setup);
 
 static void __init evm_init_config(void)
 {
@@ -92,6 +94,11 @@ static bool evm_key_loaded(void)
 	return (bool)(evm_initialized & EVM_KEY_MASK);
 }
 
+static bool evm_persistent_key_loaded(void)
+{
+	return (bool)(evm_initialized & EVM_PERSISTENT_KEY_MASK);
+}
+
 static int evm_find_protected_xattrs(struct dentry *dentry)
 {
 	struct inode *inode = d_backing_inode(dentry);
@@ -152,7 +159,9 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 				GFP_NOFS);
 	if (rc <= 0) {
 		evm_status = INTEGRITY_FAIL;
-		if (rc == -ENODATA) {
+		if (!evm_persistent_key_loaded()) {
+			evm_status = INTEGRITY_UNKNOWN;
+		} else if (rc == -ENODATA) {
 			rc = evm_find_protected_xattrs(dentry);
 			if (rc > 0)
 				evm_status = INTEGRITY_NOLABEL;
@@ -164,11 +173,18 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		goto out;
 	}
 
+	if (xattr_data->type != EVM_XATTR_HMAC_RND_KEY &&
+	    !evm_persistent_key_loaded()) {
+		evm_status = INTEGRITY_UNKNOWN;
+		goto out;
+	}
+
 	xattr_len = rc;
 
 	/* check value type */
 	switch (xattr_data->type) {
 	case EVM_XATTR_HMAC:
+	case EVM_XATTR_HMAC_RND_KEY:
 		if (xattr_len != sizeof(struct evm_ima_xattr_data)) {
 			evm_status = INTEGRITY_FAIL;
 			goto out;
@@ -176,7 +192,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 
 		digest.hdr.algo = HASH_ALGO_SHA1;
 		rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
-				   xattr_value_len, &digest);
+				   xattr_value_len, xattr_data->type, &digest);
 		if (rc)
 			break;
 		rc = crypto_memneq(xattr_data->digest, digest.digest,
@@ -523,18 +539,26 @@ int evm_inode_init_security(struct inode *inode,
 				 const struct xattr *lsm_xattr,
 				 struct xattr *evm_xattr)
 {
+	enum evm_ima_xattr_type evm_default_type = EVM_XATTR_HMAC;
 	struct evm_ima_xattr_data *xattr_data;
 	int rc;
 
 	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
 		return 0;
 
+	if (!evm_persistent_key_loaded()) {
+		if (inode->i_sb->s_magic != TMPFS_MAGIC)
+			return 0;
+
+		evm_default_type = EVM_XATTR_HMAC_RND_KEY;
+	}
+
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
 	if (!xattr_data)
 		return -ENOMEM;
 
-	xattr_data->type = EVM_XATTR_HMAC;
-	rc = evm_init_hmac(inode, lsm_xattr, xattr_data->digest);
+	xattr_data->type = evm_default_type;
+	rc = evm_init_hmac(inode, lsm_xattr, xattr_data);
 	if (rc < 0)
 		goto out;
 
@@ -584,6 +608,9 @@ static int __init init_evm(void)
 		}
 	}
 
+	if (!error && evm_random_key)
+		evm_set_random_key();
+
 	return error;
 }
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 7de59f44cba3..a037d10db46f 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -74,6 +74,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	EVM_XATTR_HMAC_RND_KEY,
 	IMA_XATTR_LAST
 };
 
-- 
2.17.1

