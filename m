Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262EE5A470
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfF1SqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:46:02 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:48204 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfF1SqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:46:02 -0400
Received: from [4.30.142.84] (helo=[127.0.1.1])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hgvsl-000T1c-MM; Fri, 28 Jun 2019 14:45:59 -0400
Subject: [4.4.y PATCH 1/4] ovl: modify ovl_permission() to do checks on two
 inodes
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com, srivatsa@csail.mit.edu
Date:   Fri, 28 Jun 2019 11:45:58 -0700
Message-ID: <156174754838.35226.13171581960350534112.stgit@srivatsa-ubuntu>
In-Reply-To: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
References: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

commit c0ca3d70e8d3cf81e2255a217f7ca402f5ed0862 upstream.

Right now ovl_permission() calls __inode_permission(realinode), to do
permission checks on real inode and no checks are done on overlay inode.

Modify it to do checks both on overlay inode as well as underlying inode.
Checks on overlay inode will be done with the creds of calling task while
checks on underlying inode will be done with the creds of mounter.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ Srivatsa: 4.4.y backport:
  - Skipped the hunk modifying non-existent function ovl_get_acl()
  - Adjusted the error path
  - Included linux/cred.h to get prototype for revert_creds() ]
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
---

 fs/overlayfs/inode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 985a4cd..9aff817 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
 #include <linux/xattr.h>
 #include "overlayfs.h"
 
@@ -91,6 +92,7 @@ int ovl_permission(struct inode *inode, int mask)
 	struct ovl_entry *oe;
 	struct dentry *alias = NULL;
 	struct inode *realinode;
+	const struct cred *old_cred;
 	struct dentry *realdentry;
 	bool is_upper;
 	int err;
@@ -143,7 +145,18 @@ int ovl_permission(struct inode *inode, int mask)
 			goto out_dput;
 	}
 
+	/*
+	 * Check overlay inode with the creds of task and underlying inode
+	 * with creds of mounter
+	 */
+	err = generic_permission(inode, mask);
+	if (err)
+		goto out_dput;
+
+	old_cred = ovl_override_creds(inode->i_sb);
 	err = __inode_permission(realinode, mask);
+	revert_creds(old_cred);
+
 out_dput:
 	dput(alias);
 	return err;

