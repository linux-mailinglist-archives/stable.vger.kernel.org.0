Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA495410E5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355492AbiFGTaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356503AbiFGT1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8501A0047;
        Tue,  7 Jun 2022 11:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 623286194C;
        Tue,  7 Jun 2022 18:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72130C385A2;
        Tue,  7 Jun 2022 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625399;
        bh=szR72GWSqH7x+phHBBmxy1siDxqYSsbp9og3m7l+Jsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYlKeoym6dbP9CKFPmQOFI71vZDqO2wr5QbKYm/7rtAtGEwO7Gwvw8X3U3oA6uhxc
         i8UXoiukF8Ka2O1jAFlLJrcmISj2qy2w/pO5dakTr64Frx+WURw/XHjRcPIXq8ah+4
         ov346OGR6TbsANfJPvvrRZFP6oWck42cUSewlVcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 662/667] fs: add two trivial lookup helpers
Date:   Tue,  7 Jun 2022 19:05:27 +0200
Message-Id: <20220607164954.498288205@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christian Brauner <brauner@kernel.org>

commit 00675017e0aeba5305665c52ded4ddce6a4c0231 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c            |   70 ++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/namei.h |    6 ++++
 2 files changed, 66 insertions(+), 10 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2718,7 +2718,8 @@ struct dentry *lookup_one(struct user_na
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
 
@@ -2745,6 +2747,59 @@ struct dentry *lookup_one_len_unlocked(c
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
 
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -69,6 +69,12 @@ extern struct dentry *lookup_one_len(con
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


