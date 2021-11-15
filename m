Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177D1452456
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351206AbhKPBh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243084AbhKOSum (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED19561A79;
        Mon, 15 Nov 2021 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999764;
        bh=jgLdDGouZ2eimi3+zStfs/pgADp0MD7OZS0wWYSD2oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il9f9dRFl0FHtg5h9c5C03oSpgFxQ3PJH+xX9pSxT1KF39WQEhmPyS14wdI8Kq8pM
         IYybHmAqN0ekvPOglCDL9E8doSTwiKXZZKfGaQ1ov3VDoZKfWGV2b91G76OscunV5J
         0T4Kml3sl0/yzm+uDVbeQCKeAsKN2j79CDQgFSug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, THOBY Simon <Simon.THOBY@viveris.fr>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 415/849] IMA: block writes of the security.ima xattr with unsupported algorithms
Date:   Mon, 15 Nov 2021 17:58:18 +0100
Message-Id: <20211115165434.295735118@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: THOBY Simon <Simon.THOBY@viveris.fr>

[ Upstream commit 50f742dd91474e7f4954bf88d094eede59783883 ]

By default, writes to the extended attributes security.ima will be
allowed even if the hash algorithm used for the xattr is not compiled
in the kernel (which does not make sense because the kernel would not
be able to appraise that file as it lacks support for validating the
hash).

Prevent and audit writes to the security.ima xattr if the hash algorithm
used in the new value is not available in the current kernel.

Signed-off-by: THOBY Simon <Simon.THOBY@viveris.fr>
Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima.h          |  2 +-
 security/integrity/ima/ima_appraise.c | 49 +++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index f0e448ed1f9fb..40fe3a571f898 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -319,7 +319,7 @@ int ima_must_appraise(struct user_namespace *mnt_userns, struct inode *inode,
 void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
 enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
 					   enum ima_hooks func);
-enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
+enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
 				 int xattr_len);
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value);
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index ef9dcfce45d45..530514df1c9a5 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -171,7 +171,7 @@ static void ima_cache_flags(struct integrity_iint_cache *iint,
 	}
 }
 
-enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
+enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
 				 int xattr_len)
 {
 	struct signature_v2_hdr *sig;
@@ -575,6 +575,47 @@ static void ima_reset_appraise_flags(struct inode *inode, int digsig)
 		clear_bit(IMA_DIGSIG, &iint->atomic_flags);
 }
 
+/**
+ * validate_hash_algo() - Block setxattr with unsupported hash algorithms
+ * @dentry: object of the setxattr()
+ * @xattr_value: userland supplied xattr value
+ * @xattr_value_len: length of xattr_value
+ *
+ * The xattr value is mapped to its hash algorithm, and this algorithm
+ * must be built in the kernel for the setxattr to be allowed.
+ *
+ * Emit an audit message when the algorithm is invalid.
+ *
+ * Return: 0 on success, else an error.
+ */
+static int validate_hash_algo(struct dentry *dentry,
+			      const struct evm_ima_xattr_data *xattr_value,
+			      size_t xattr_value_len)
+{
+	char *path = NULL, *pathbuf = NULL;
+	enum hash_algo xattr_hash_algo;
+
+	xattr_hash_algo = ima_get_hash_algo(xattr_value, xattr_value_len);
+
+	if (likely(xattr_hash_algo == ima_hash_algo ||
+		   crypto_has_alg(hash_algo_name[xattr_hash_algo], 0, 0)))
+		return 0;
+
+	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!pathbuf)
+		return -EACCES;
+
+	path = dentry_path(dentry, pathbuf, PATH_MAX);
+
+	integrity_audit_msg(AUDIT_INTEGRITY_DATA, d_inode(dentry), path,
+			    "set_data", "unavailable-hash-algorithm",
+			    -EACCES, 0);
+
+	kfree(pathbuf);
+
+	return -EACCES;
+}
+
 int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len)
 {
@@ -592,9 +633,11 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		digsig = (xvalue->type == EVM_XATTR_PORTABLE_DIGSIG);
 	}
 	if (result == 1 || evm_revalidate_status(xattr_name)) {
+		result = validate_hash_algo(dentry, xvalue, xattr_value_len);
+		if (result)
+			return result;
+
 		ima_reset_appraise_flags(d_backing_inode(dentry), digsig);
-		if (result == 1)
-			result = 0;
 	}
 	return result;
 }
-- 
2.33.0



