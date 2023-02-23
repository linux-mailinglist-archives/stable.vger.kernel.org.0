Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3EB6A0CC0
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjBWPU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjBWPUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:20:55 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA26570A4;
        Thu, 23 Feb 2023 07:20:53 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id k37so6227386wms.0;
        Thu, 23 Feb 2023 07:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQXcSwFHRHYpPydn18S6kG44NwIMqJyC0OdDshq2YbM=;
        b=ICoa1k7KT5HKbsSdLswwJKVQcL2mOLSpthKOGVJ80ul9LSknrCR+/hW85uC8ljC+rl
         Izo7WUJ7ELpLprBIzbTG1OfPRMpSZarZGo6QHGQaBtiSKy5pNAyy+O/qAO7ymQrrdP9E
         dfzHn3ib6UqRAdA9QqrkB9V7ZVycWGGvq7hvig8HPqDHGz1+CapOrgZKPvQhUkhlhZKm
         hgcJcQ2cCSMo5Tsaf1d9D1cxeRFHHL94KP5EkvOmIT7rZgQLhSHsqaIRuIrKHtdLitiC
         S5PDVObLXjDgQ352DsF/uhxXiNYISFUxi1GiFCHpH4yq816gvWV3WIL9U+dbY/z8PLy6
         pP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQXcSwFHRHYpPydn18S6kG44NwIMqJyC0OdDshq2YbM=;
        b=K+mHIUqVeYBITJ+Y+qKKzkBZBOM+rovHIRlglo0qLInr7fHLdgBRFug5qe3kdYWAKk
         58Mje2Pbr1DgQDx+5fq2m91MfWCTyoDdWZweWsPFUlRMk/NWUFnu8Ng3c1e+sSaLT/Or
         bYT0Ap0w7LUvoI2cOJbTjixvtIhP91orVP8XPHNyhZVnvbwGX8VkCQJGjYv8ach+SbsX
         IuJUFo6ty5TmbF2+ZU2WlFPmAUzeA1cP22nOXxsoR+E4jL+8nEiERYhvsrMMEy6OGKxH
         Z1mHmoky7aqv3f+wD8FSZ1MXnGHKj2zoNnZHXbSxdsaac3y0kKAW+3PSc0SW6SWY3AuA
         Fwdg==
X-Gm-Message-State: AO0yUKU4QdMt8VHEbVoVY2j3cvzQr1kjnUiP1DJUfucBuLTZBXMQgU8E
        qcuo4oM1wscQDeUmt5/tFzU=
X-Google-Smtp-Source: AK7set89s1NSLC4Iiiqal5e8SwdCTxYRei7OBnhkE+pmmBmu4I8Kp6bF/DJXxa/WIGGIEntyj61YZA==
X-Received: by 2002:a05:600c:44c5:b0:3dc:eaef:c1bb with SMTP id f5-20020a05600c44c500b003dceaefc1bbmr9752524wmo.35.1677165651964;
        Thu, 23 Feb 2023 07:20:51 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6289000000b002c56af32e8csm9372590wru.35.2023.02.23.07.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 07:20:51 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.1 1/5] attr: add in_group_or_capable()
Date:   Thu, 23 Feb 2023 17:20:40 +0200
Message-Id: <20230223152044.1064909-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230223152044.1064909-1-amir73il@gmail.com>
References: <20230223152044.1064909-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 11c2a8700cdcabf9b639b7204a1e38e2a0b6798e upstream.

In setattr_{copy,prepare}() we need to perform the same permission
checks to determine whether we need to drop the setgid bit or not.
Instead of open-coding it twice add a simple helper the encapsulates the
logic. We will reuse this helpers to make dropping the setgid bit during
write operations more consistent in a follow up patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/attr.c     | 10 +++++-----
 fs/inode.c    | 28 ++++++++++++++++++++++++----
 fs/internal.h |  2 ++
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 1552a5f23d6b..b1162fca84a2 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,8 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
@@ -140,8 +142,7 @@ int setattr_prepare(struct user_namespace *mnt_userns, struct dentry *dentry,
 			vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
 
 		/* Also check the setgid bit! */
-		if (!vfsgid_in_group_p(vfsgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, vfsgid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -251,9 +252,8 @@ void setattr_copy(struct user_namespace *mnt_userns, struct inode *inode,
 		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
-		vfsgid_t vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
-		if (!vfsgid_in_group_p(vfsgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode,
+					 i_gid_into_vfsgid(mnt_userns, inode)))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
diff --git a/fs/inode.c b/fs/inode.c
index b608528efd3a..55299b710c45 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2487,6 +2487,28 @@ struct timespec64 current_time(struct inode *inode)
 }
 EXPORT_SYMBOL(current_time);
 
+/**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @mnt_userns: user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ * @vfsgid:	the new/current vfsgid of @inode
+ *
+ * Check wether @vfsgid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, vfsgid_t vfsgid)
+{
+	if (vfsgid_in_group_p(vfsgid))
+		return true;
+	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
 /**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @mnt_userns: User namespace of the mount the inode was created from
@@ -2508,11 +2530,9 @@ umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
-		return mode;
-	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
+	if (in_group_or_capable(mnt_userns, dir,
+				i_gid_into_vfsgid(mnt_userns, dir)))
 		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/fs/internal.h b/fs/internal.h
index 6f0386b34fae..1de39bbc9ddd 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -151,6 +151,8 @@ extern int vfs_open(const struct path *, struct file *);
  */
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, vfsgid_t vfsgid);
 
 /*
  * fs-writeback.c
-- 
2.34.1

