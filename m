Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D998362170
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbfGHPQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbfGHPQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA05F2166E;
        Mon,  8 Jul 2019 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598975;
        bh=aYAo/xr3vWfROcvFgtq0lwGDp0XPObai2tK1AZ7l1R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOSdp4wLFTRs6ii4fwhq+If4r++4X5HJXq11vS4X9bxvYiRUOJstp1FewhojZhWF1
         D66H5Qpj5DgToiCBsGNvysZstwjTEdVFQUaoQaahP1kBKQRGaExH+c+xpEMba44L+T
         42u8uayXgOFYw2d9ZnCZGb4UWGPyJ+MevUpFkABY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>
Subject: [PATCH 4.4 37/73] ovl: modify ovl_permission() to do checks on two inodes
Date:   Mon,  8 Jul 2019 17:12:47 +0200
Message-Id: <20190708150523.283666939@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/inode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
 #include <linux/xattr.h>
 #include "overlayfs.h"
 
@@ -91,6 +92,7 @@ int ovl_permission(struct inode *inode,
 	struct ovl_entry *oe;
 	struct dentry *alias = NULL;
 	struct inode *realinode;
+	const struct cred *old_cred;
 	struct dentry *realdentry;
 	bool is_upper;
 	int err;
@@ -143,7 +145,18 @@ int ovl_permission(struct inode *inode,
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


