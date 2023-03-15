Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E386BB1F8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjCOMbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbjCOMbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B648EA1B;
        Wed, 15 Mar 2023 05:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0660161D51;
        Wed, 15 Mar 2023 12:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14591C433EF;
        Wed, 15 Mar 2023 12:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883452;
        bh=C6PME5ZEYwwvmyaJxyfORMvu3RAVgCFo6s6wziQGxe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtUvRTQ9QRVJ/6PJ34D0Si53H0NFpw3IOG72o3/k9NORJC8pwgSi80XYPcEB6dbw7
         SavPavTXr7vJqXMyQ9fW/KScSfhdkLKWUNCT1oJt/9XEGuTWT94qOgIu8UaUkIu8Nt
         0l1rZ20FfkVBoSzyX+yj6j4uiiYzVdnEEJsdIamQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Seth Forshee <seth.forshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 142/145] fs: hold writers when changing mounts idmapping
Date:   Wed, 15 Mar 2023 13:13:28 +0100
Message-Id: <20230315115743.595251147@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit e1bbcd277a53e08d619ffeec56c5c9287f2bf42f upstream.

Hold writers when changing a mount's idmapping to make it more robust.

The vfs layer takes care to retrieve the idmapping of a mount once
ensuring that the idmapping used for vfs permission checking is
identical to the idmapping passed down to the filesystem.

For ioctl codepaths the filesystem itself is responsible for taking the
idmapping into account if they need to. While all filesystems with
FS_ALLOW_IDMAP raised take the same precautions as the vfs we should
enforce it explicitly by making sure there are no active writers on the
relevant mount while changing the idmapping.

This is similar to turning a mount ro with the difference that in
contrast to turning a mount ro changing the idmapping can only ever be
done once while a mount can transition between ro and rw as much as it
wants.

This is a minor user-visible change. But it is extremely unlikely to
matter. The caller must've created a detached mount via OPEN_TREE_CLONE
and then handed that O_PATH fd to another process or thread which then
must've gotten a writable fd for that mount and started creating files
in there while the caller is still changing mount properties. While not
impossible it will be an extremely rare corner-case and should in
general be considered a bug in the application. Consider making a mount
MOUNT_ATTR_NOEXEC or MOUNT_ATTR_NODEV while allowing someone else to
perform lookups or exec'ing in parallel by handing them a copy of the
OPEN_TREE_CLONE fd or another fd beneath that mount.

Link: https://lore.kernel.org/r/20220510095840.152264-1-brauner@kernel.org
Cc: Seth Forshee <seth.forshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3968,6 +3968,23 @@ static int can_idmap_mount(const struct
 	return 0;
 }
 
+/**
+ * mnt_allow_writers() - check whether the attribute change allows writers
+ * @kattr: the new mount attributes
+ * @mnt: the mount to which @kattr will be applied
+ *
+ * Check whether thew new mount attributes in @kattr allow concurrent writers.
+ *
+ * Return: true if writers need to be held, false if not
+ */
+static inline bool mnt_allow_writers(const struct mount_kattr *kattr,
+				     const struct mount *mnt)
+{
+	return (!(kattr->attr_set & MNT_READONLY) ||
+		(mnt->mnt.mnt_flags & MNT_READONLY)) &&
+	       !kattr->mnt_userns;
+}
+
 static struct mount *mount_setattr_prepare(struct mount_kattr *kattr,
 					   struct mount *mnt, int *err)
 {
@@ -3998,8 +4015,7 @@ static struct mount *mount_setattr_prepa
 
 		last = m;
 
-		if ((kattr->attr_set & MNT_READONLY) &&
-		    !(m->mnt.mnt_flags & MNT_READONLY)) {
+		if (!mnt_allow_writers(kattr, m)) {
 			*err = mnt_hold_writers(m);
 			if (*err)
 				goto out;
@@ -4050,13 +4066,8 @@ static void mount_setattr_commit(struct
 			WRITE_ONCE(m->mnt.mnt_flags, flags);
 		}
 
-		/*
-		 * We either set MNT_READONLY above so make it visible
-		 * before ~MNT_WRITE_HOLD or we failed to recursively
-		 * apply mount options.
-		 */
-		if ((kattr->attr_set & MNT_READONLY) &&
-		    (m->mnt.mnt_flags & MNT_WRITE_HOLD))
+		/* If we had to hold writers unblock them. */
+		if (m->mnt.mnt_flags & MNT_WRITE_HOLD)
 			mnt_unhold_writers(m);
 
 		if (!err && kattr->propagation)


