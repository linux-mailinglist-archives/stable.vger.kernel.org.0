Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFE7551A7C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244949AbiFTNGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244450AbiFTNFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:05:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABB519C24;
        Mon, 20 Jun 2022 06:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10DD4B811A6;
        Mon, 20 Jun 2022 13:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CE9C3411B;
        Mon, 20 Jun 2022 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730011;
        bh=WaG1nHyRp9gM42Yl11WvQkmWsXZ9kxeW+GdjIh4gZQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neck4NhXlgyFTZVyO1V8lKwrP4EVn6Zu3igtZNX+fkO38djIZIRYvK42qYL8yGZmV
         02leBcLKj0NW6UAVyLQSNm+mAFDx3Lke8+kDGHhprnFminAPl16XUL53JU0MphfHC1
         ynrG+MU9PtXMthTV7JfMwHtusnhmojboK4IQ1gqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.18 125/141] fs: account for group membership
Date:   Mon, 20 Jun 2022 14:51:03 +0200
Message-Id: <20220620124733.247984907@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 168f912893407a5acb798a4a58613b5f1f98c717 upstream.

When calling setattr_prepare() to determine the validity of the
attributes the ia_{g,u}id fields contain the value that will be written
to inode->i_{g,u}id. This is exactly the same for idmapped and
non-idmapped mounts and allows callers to pass in the values they want
to see written to inode->i_{g,u}id.

When group ownership is changed a caller whose fsuid owns the inode can
change the group of the inode to any group they are a member of. When
searching through the caller's groups we need to use the gid mapped
according to the idmapped mount otherwise we will fail to change
ownership for unprivileged users.

Consider a caller running with fsuid and fsgid 1000 using an idmapped
mount that maps id 65534 to 1000 and 65535 to 1001. Consequently, a file
owned by 65534:65535 in the filesystem will be owned by 1000:1001 in the
idmapped mount.

The caller now requests the gid of the file to be changed to 1000 going
through the idmapped mount. In the vfs we will immediately map the
requested gid to the value that will need to be written to inode->i_gid
and place it in attr->ia_gid. Since this idmapped mount maps 65534 to
1000 we place 65534 in attr->ia_gid.

When we check whether the caller is allowed to change group ownership we
first validate that their fsuid matches the inode's uid. The
inode->i_uid is 65534 which is mapped to uid 1000 in the idmapped mount.
Since the caller's fsuid is 1000 we pass the check.

We now check whether the caller is allowed to change inode->i_gid to the
requested gid by calling in_group_p(). This will compare the passed in
gid to the caller's fsgid and search the caller's additional groups.

Since we're dealing with an idmapped mount we need to pass in the gid
mapped according to the idmapped mount. This is akin to checking whether
a caller is privileged over the future group the inode is owned by. And
that needs to take the idmapped mount into account. Note, all helpers
are nops without idmapped mounts.

New regression test sent to xfstests.

Link: https://github.com/lxc/lxd/issues/10537
Link: https://lore.kernel.org/r/20220613111517.2186646-1-brauner@kernel.org
Fixes: 2f221d6f7b88 ("attr: handle idmapped mounts")
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org # 5.15+
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -61,9 +61,15 @@ static bool chgrp_ok(struct user_namespa
 		     const struct inode *inode, kgid_t gid)
 {
 	kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
-	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode)) &&
-	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
-		return true;
+	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode))) {
+		kgid_t mapped_gid;
+
+		if (gid_eq(gid, inode->i_gid))
+			return true;
+		mapped_gid = mapped_kgid_fs(mnt_userns, i_user_ns(inode), gid);
+		if (in_group_p(mapped_gid))
+			return true;
+	}
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;
 	if (gid_eq(kgid, INVALID_GID) &&
@@ -123,12 +129,20 @@ int setattr_prepare(struct user_namespac
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
+		kgid_t mapped_gid;
+
 		if (!inode_owner_or_capable(mnt_userns, inode))
 			return -EPERM;
+
+		if (ia_valid & ATTR_GID)
+			mapped_gid = mapped_kgid_fs(mnt_userns,
+						i_user_ns(inode), attr->ia_gid);
+		else
+			mapped_gid = i_gid_into_mnt(mnt_userns, inode);
+
 		/* Also check the setgid bit! */
-               if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-                                i_gid_into_mnt(mnt_userns, inode)) &&
-                    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_p(mapped_gid) &&
+		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 


