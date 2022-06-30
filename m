Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB3561D15
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbiF3OLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236860AbiF3OKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:10:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D791973915;
        Thu, 30 Jun 2022 06:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F43B82AF5;
        Thu, 30 Jun 2022 13:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E905C34115;
        Thu, 30 Jun 2022 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597328;
        bh=8gSpTM0M2+5AiSnd+UDb4VINeI9nE6g3nHJOluh2suY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5b4c904YUJwxIFdSjrASpeQevkhE7WXiOC78LN3a2Pufg1w/s/75lHT62WQxpZx8
         DAQ5lx+qLi63ovNuQf15NxFTfO9peM3IaOU1PI01/GKl6q5/8szHJAhHxKSTf+X3M2
         okobm9fnw/zCNg5Lj4jC445TCkyDKmd14qG8pdEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 18/28] fs: use low-level mapping helpers
Date:   Thu, 30 Jun 2022 15:47:14 +0200
Message-Id: <20220630133233.464470992@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 4472071331549e911a5abad41aea6e3be855a1a4 upstream.

In a few places the vfs needs to interact with bare k{g,u}ids directly
instead of struct inode. These are just a few. In previous patches we
introduced low-level mapping helpers that are able to support
filesystems mounted an idmapping. This patch simply converts the places
to use these new helpers.

Link: https://lore.kernel.org/r/20211123114227.3124056-7-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-7-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-7-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smbacl.c    |   18 ++----------------
 fs/ksmbd/smbacl.h    |    4 ++--
 fs/open.c            |    4 ++--
 fs/posix_acl.c       |   16 ++++++++++------
 security/commoncap.c |   13 ++++++++-----
 5 files changed, 24 insertions(+), 31 deletions(-)

--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -275,14 +275,7 @@ static int sid_to_id(struct user_namespa
 		uid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		/*
-		 * Translate raw sid into kuid in the server's user
-		 * namespace.
-		 */
-		uid = make_kuid(&init_user_ns, id);
-
-		/* If this is an idmapped mount, apply the idmapping. */
-		uid = kuid_from_mnt(user_ns, uid);
+		uid = mapped_kuid_user(user_ns, &init_user_ns, KUIDT_INIT(id));
 		if (uid_valid(uid)) {
 			fattr->cf_uid = uid;
 			rc = 0;
@@ -292,14 +285,7 @@ static int sid_to_id(struct user_namespa
 		gid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		/*
-		 * Translate raw sid into kgid in the server's user
-		 * namespace.
-		 */
-		gid = make_kgid(&init_user_ns, id);
-
-		/* If this is an idmapped mount, apply the idmapping. */
-		gid = kgid_from_mnt(user_ns, gid);
+		gid = mapped_kgid_user(user_ns, &init_user_ns, KGIDT_INIT(id));
 		if (gid_valid(gid)) {
 			fattr->cf_gid = gid;
 			rc = 0;
--- a/fs/ksmbd/smbacl.h
+++ b/fs/ksmbd/smbacl.h
@@ -217,7 +217,7 @@ static inline uid_t posix_acl_uid_transl
 	kuid_t kuid;
 
 	/* If this is an idmapped mount, apply the idmapping. */
-	kuid = kuid_into_mnt(mnt_userns, pace->e_uid);
+	kuid = mapped_kuid_fs(mnt_userns, &init_user_ns, pace->e_uid);
 
 	/* Translate the kuid into a userspace id ksmbd would see. */
 	return from_kuid(&init_user_ns, kuid);
@@ -229,7 +229,7 @@ static inline gid_t posix_acl_gid_transl
 	kgid_t kgid;
 
 	/* If this is an idmapped mount, apply the idmapping. */
-	kgid = kgid_into_mnt(mnt_userns, pace->e_gid);
+	kgid = mapped_kgid_fs(mnt_userns, &init_user_ns, pace->e_gid);
 
 	/* Translate the kgid into a userspace id ksmbd would see. */
 	return from_kgid(&init_user_ns, kgid);
--- a/fs/open.c
+++ b/fs/open.c
@@ -653,8 +653,8 @@ int chown_common(const struct path *path
 	gid = make_kgid(current_user_ns(), group);
 
 	mnt_userns = mnt_user_ns(path->mnt);
-	uid = kuid_from_mnt(mnt_userns, uid);
-	gid = kgid_from_mnt(mnt_userns, gid);
+	uid = mapped_kuid_user(mnt_userns, &init_user_ns, uid);
+	gid = mapped_kgid_user(mnt_userns, &init_user_ns, gid);
 
 retry_deleg:
 	newattrs.ia_valid =  ATTR_CTIME;
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -376,7 +376,9 @@ posix_acl_permission(struct user_namespa
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-				uid = kuid_into_mnt(mnt_userns, pa->e_uid);
+				uid = mapped_kuid_fs(mnt_userns,
+						      &init_user_ns,
+						      pa->e_uid);
 				if (uid_eq(uid, current_fsuid()))
                                         goto mask;
 				break;
@@ -389,7 +391,9 @@ posix_acl_permission(struct user_namespa
                                 }
 				break;
                         case ACL_GROUP:
-				gid = kgid_into_mnt(mnt_userns, pa->e_gid);
+				gid = mapped_kgid_fs(mnt_userns,
+						      &init_user_ns,
+						      pa->e_gid);
 				if (in_group_p(gid)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
@@ -736,17 +740,17 @@ static void posix_acl_fix_xattr_userns(
 		case ACL_USER:
 			uid = make_kuid(from, le32_to_cpu(entry->e_id));
 			if (from_user)
-				uid = kuid_from_mnt(mnt_userns, uid);
+				uid = mapped_kuid_user(mnt_userns, &init_user_ns, uid);
 			else
-				uid = kuid_into_mnt(mnt_userns, uid);
+				uid = mapped_kuid_fs(mnt_userns, &init_user_ns, uid);
 			entry->e_id = cpu_to_le32(from_kuid(to, uid));
 			break;
 		case ACL_GROUP:
 			gid = make_kgid(from, le32_to_cpu(entry->e_id));
 			if (from_user)
-				gid = kgid_from_mnt(mnt_userns, gid);
+				gid = mapped_kgid_user(mnt_userns, &init_user_ns, gid);
 			else
-				gid = kgid_into_mnt(mnt_userns, gid);
+				gid = mapped_kgid_fs(mnt_userns, &init_user_ns, gid);
 			entry->e_id = cpu_to_le32(from_kgid(to, gid));
 			break;
 		default:
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -419,7 +419,7 @@ int cap_inode_getsecurity(struct user_na
 	kroot = make_kuid(fs_ns, root);
 
 	/* If this is an idmapped mount shift the kuid. */
-	kroot = kuid_into_mnt(mnt_userns, kroot);
+	kroot = mapped_kuid_fs(mnt_userns, &init_user_ns, kroot);
 
 	/* If the root kuid maps to a valid uid in current ns, then return
 	 * this as a nscap. */
@@ -489,6 +489,7 @@ out_free:
  * @size:	size of @ivalue
  * @task_ns:	user namespace of the caller
  * @mnt_userns:	user namespace of the mount the inode was found from
+ * @fs_userns:	user namespace of the filesystem
  *
  * If the inode has been found through an idmapped mount the user namespace of
  * the vfsmount must be passed through @mnt_userns. This function will then
@@ -498,7 +499,8 @@ out_free:
  */
 static kuid_t rootid_from_xattr(const void *value, size_t size,
 				struct user_namespace *task_ns,
-				struct user_namespace *mnt_userns)
+				struct user_namespace *mnt_userns,
+				struct user_namespace *fs_userns)
 {
 	const struct vfs_ns_cap_data *nscap = value;
 	kuid_t rootkid;
@@ -508,7 +510,7 @@ static kuid_t rootid_from_xattr(const vo
 		rootid = le32_to_cpu(nscap->rootid);
 
 	rootkid = make_kuid(task_ns, rootid);
-	return kuid_from_mnt(mnt_userns, rootkid);
+	return mapped_kuid_user(mnt_userns, fs_userns, rootkid);
 }
 
 static bool validheader(size_t size, const struct vfs_cap_data *cap)
@@ -559,7 +561,8 @@ int cap_convert_nscap(struct user_namesp
 			/* user is privileged, just write the v2 */
 			return size;
 
-	rootid = rootid_from_xattr(*ivalue, size, task_ns, mnt_userns);
+	rootid = rootid_from_xattr(*ivalue, size, task_ns, mnt_userns,
+				   &init_user_ns);
 	if (!uid_valid(rootid))
 		return -EINVAL;
 
@@ -700,7 +703,7 @@ int get_vfs_caps_from_disk(struct user_n
 	/* Limit the caps to the mounter of the filesystem
 	 * or the more limited uid specified in the xattr.
 	 */
-	rootkuid = kuid_into_mnt(mnt_userns, rootkuid);
+	rootkuid = mapped_kuid_fs(mnt_userns, &init_user_ns, rootkuid);
 	if (!rootid_owns_currentns(rootkuid))
 		return -ENODATA;
 


