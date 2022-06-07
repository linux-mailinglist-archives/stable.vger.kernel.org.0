Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971B253FAD5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiFGKJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiFGKJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:09:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17B97E1C2;
        Tue,  7 Jun 2022 03:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C802B81ED8;
        Tue,  7 Jun 2022 10:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48430C34119;
        Tue,  7 Jun 2022 10:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654596546;
        bh=xaJ3XEVmM6xTga7+v67FnseXxdXUgT36op+OI2WndPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ0nrtIX9XMJyc1HZUJ9MkWIktv1umLVymLhDNAKzC4nWFkjIE3B+ciVl2PXYp3tY
         sIqdslVUtGOC5jxjefZBuCN7nHTw/ejEIZ8cp9FonkJSfLHrzFQv2EOBQmTxiRhKr3
         7EvHjy95PZCe4ftvnQ9LQUu06HCeGz9h7yBwazC7dHsbKZvUAqDXcl96wNhfUeSlGh
         YTGJ0e2fkFathfAgtffN1xbOsr00XKIyvG5saYABqwVFXZWp7oMMvg20qH7oAvS2ND
         TxJkzuXQvQACHSqPpNQu7OLGsHocHS2JYndnI8oE7ZAiiqwH6ar5tbniXF4/+QIfyB
         XIQOuoh56RE0Q==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.15.y 1/2] fs: add two trivial lookup helpers
Date:   Tue,  7 Jun 2022 12:08:38 +0200
Message-Id: <20220607100840.1686673-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <165451869522688@kroah.com>
References: 
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5734; h=from:subject; bh=xaJ3XEVmM6xTga7+v67FnseXxdXUgT36op+OI2WndPE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTNV15Q8vfH1XJpsb1+Ao0K+fY/lvQv6rnkovx9+u/AFWpf ZleIdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkuR7D/xgxfl2zFKv5S8+sP9K6hn /Zv38NTQyX0hQfbY9R++kxU5OR4RhPxuHtnLlCq3nNtYpK35TWx9cktCXY7Lw1o3u67GF9JgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to the addition of lookup_one() add a version of
lookup_one_unlocked() and lookup_one_positive_unlocked() that take
idmapped mounts into account. This is required to port overlay to
support idmapped base layers.

Cc: <linux-fsdevel@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/namei.c            | 70 ++++++++++++++++++++++++++++++++++++-------
 include/linux/namei.h |  6 ++++
 2 files changed, 66 insertions(+), 10 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8882a70dc119..2ea15d043412 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2718,7 +2718,8 @@ struct dentry *lookup_one(struct user_namespace *mnt_userns, const char *name,
 EXPORT_SYMBOL(lookup_one);
 
 /**
- * lookup_one_len_unlocked - filesystem helper to lookup single pathname component
+ * lookup_one_unlocked - filesystem helper to lookup single pathname component
+ * @mnt_userns:	idmapping of the mount the lookup is performed from
  * @name:	pathname component to lookup
  * @base:	base directory to lookup from
  * @len:	maximum length @len should be interpreted to
@@ -2729,14 +2730,15 @@ EXPORT_SYMBOL(lookup_one);
  * Unlike lookup_one_len, it should be called without the parent
  * i_mutex held, and will take the i_mutex itself if necessary.
  */
-struct dentry *lookup_one_len_unlocked(const char *name,
-				       struct dentry *base, int len)
+struct dentry *lookup_one_unlocked(struct user_namespace *mnt_userns,
+				   const char *name, struct dentry *base,
+				   int len)
 {
 	struct qstr this;
 	int err;
 	struct dentry *ret;
 
-	err = lookup_one_common(&init_user_ns, name, base, len, &this);
+	err = lookup_one_common(mnt_userns, name, base, len, &this);
 	if (err)
 		return ERR_PTR(err);
 
@@ -2745,6 +2747,59 @@ struct dentry *lookup_one_len_unlocked(const char *name,
 		ret = lookup_slow(&this, base, 0);
 	return ret;
 }
+EXPORT_SYMBOL(lookup_one_unlocked);
+
+/**
+ * lookup_one_positive_unlocked - filesystem helper to lookup single
+ *				  pathname component
+ * @mnt_userns:	idmapping of the mount the lookup is performed from
+ * @name:	pathname component to lookup
+ * @base:	base directory to lookup from
+ * @len:	maximum length @len should be interpreted to
+ *
+ * This helper will yield ERR_PTR(-ENOENT) on negatives. The helper returns
+ * known positive or ERR_PTR(). This is what most of the users want.
+ *
+ * Note that pinned negative with unlocked parent _can_ become positive at any
+ * time, so callers of lookup_one_unlocked() need to be very careful; pinned
+ * positives have >d_inode stable, so this one avoids such problems.
+ *
+ * Note that this routine is purely a helper for filesystem usage and should
+ * not be called by generic code.
+ *
+ * The helper should be called without i_mutex held.
+ */
+struct dentry *lookup_one_positive_unlocked(struct user_namespace *mnt_userns,
+					    const char *name,
+					    struct dentry *base, int len)
+{
+	struct dentry *ret = lookup_one_unlocked(mnt_userns, name, base, len);
+
+	if (!IS_ERR(ret) && d_flags_negative(smp_load_acquire(&ret->d_flags))) {
+		dput(ret);
+		ret = ERR_PTR(-ENOENT);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(lookup_one_positive_unlocked);
+
+/**
+ * lookup_one_len_unlocked - filesystem helper to lookup single pathname component
+ * @name:	pathname component to lookup
+ * @base:	base directory to lookup from
+ * @len:	maximum length @len should be interpreted to
+ *
+ * Note that this routine is purely a helper for filesystem usage and should
+ * not be called by generic code.
+ *
+ * Unlike lookup_one_len, it should be called without the parent
+ * i_mutex held, and will take the i_mutex itself if necessary.
+ */
+struct dentry *lookup_one_len_unlocked(const char *name,
+				       struct dentry *base, int len)
+{
+	return lookup_one_unlocked(&init_user_ns, name, base, len);
+}
 EXPORT_SYMBOL(lookup_one_len_unlocked);
 
 /*
@@ -2758,12 +2813,7 @@ EXPORT_SYMBOL(lookup_one_len_unlocked);
 struct dentry *lookup_positive_unlocked(const char *name,
 				       struct dentry *base, int len)
 {
-	struct dentry *ret = lookup_one_len_unlocked(name, base, len);
-	if (!IS_ERR(ret) && d_flags_negative(smp_load_acquire(&ret->d_flags))) {
-		dput(ret);
-		ret = ERR_PTR(-ENOENT);
-	}
-	return ret;
+	return lookup_one_positive_unlocked(&init_user_ns, name, base, len);
 }
 EXPORT_SYMBOL(lookup_positive_unlocked);
 
diff --git a/include/linux/namei.h b/include/linux/namei.h
index e89329bb3134..caeb08a98536 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -69,6 +69,12 @@ extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_len_unlocked(const char *, struct dentry *, int);
 extern struct dentry *lookup_positive_unlocked(const char *, struct dentry *, int);
 struct dentry *lookup_one(struct user_namespace *, const char *, struct dentry *, int);
+struct dentry *lookup_one_unlocked(struct user_namespace *mnt_userns,
+				   const char *name, struct dentry *base,
+				   int len);
+struct dentry *lookup_one_positive_unlocked(struct user_namespace *mnt_userns,
+					    const char *name,
+					    struct dentry *base, int len);
 
 extern int follow_down_one(struct path *);
 extern int follow_down(struct path *);

base-commit: 207ca688162d4d77129981a8b4352114b97a52b5
-- 
2.34.1

