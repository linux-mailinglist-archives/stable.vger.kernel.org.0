Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7E715C766
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBMQKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728006AbgBMPWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:38 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29DB024690;
        Thu, 13 Feb 2020 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607357;
        bh=QVTMlH3x/XufSgrUByrIR90YJd9Pgm7gaU+w7qCgZC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJoQotKvfQuPIru/1LGxRiePF+8SPdCRNiTZ66i5vQgmanw/z6/Lld3M6dwvtEzpM
         03L/V9HF4uvCfm/W2A+9ChUyc1dU3DVLok5SgI8Gn5D/WdLgorDjPCLtCacWlOLx1v
         6qAgAK2uGqsdg4nWOfu965LkcYo2Da9EKmXv6WgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Subject: [PATCH 4.4 24/91] Revert "ovl: modify ovl_permission() to do checks on two inodes"
Date:   Thu, 13 Feb 2020 07:19:41 -0800
Message-Id: <20200213151830.964687032@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>

This reverts commit b24be4acd17a8963a29b2a92e1d80b9ddf759c95 which is commit
c0ca3d70e8d3cf81e2255a217f7ca402f5ed0862 upstream.

Commit b24be4acd17a ("ovl: modify ovl_permission() to do checks on two
inodes") (stable kernel  id) breaks r/w access in overlayfs when setting
ACL to files, in 4.4 stable kernel. There is an available reproducer in
[1].

To reproduce the issue :
$./make-overlay.sh
$./test.sh
st_mode is 100644
open failed: -1
cat: /tmp/overlay/animal: Permission denied <---- Breaks access
-rw-r--r-- 1 jo jo 0 Oct 11 09:57 /tmp/overlay/animal

There are two options to fix this; (a) backport commit ce31513a9114
("ovl: copyattr after setting POSIX ACL") to 4.4 or (b) revert offending
commit b24be4acd17a ("ovl: modify ovl_permission() to do checks on two
inodes"). Following option (a) entails high risk of regression since
commit ce31513a9114 ("ovl: copyattr after setting POSIX ACL") has many
dependencies on other commits that need to be backported too (~18
commits).

This patch proceeds with reverting commit b24be4acd17a ("ovl: modify
ovl_permission() to do checks on two inodes").  The reverted commit is
associated with CVE-2018-16597, however the test-script provided in [3]
shows that 4.4 kernel is  NOT affected by this cve and therefore it's
safe to revert it.

The offending commit was introduced upstream in v4.8-rc1. At this point
had nothing to do with any CVE.  It was related with CVE-2018-16597 as
it was the fix for bug [2]. Later on it was backported to stable 4.4.

The test-script [3] tests whether 4.4 kernel is affected by
CVE-2018-16597. It tests the reproducer found in [2] plus a few more
cases. The correct output of the script is failure with "Permission
denied" when a normal user tries to overwrite root owned files.  For
more details please refer to [4].

[1] https://gist.github.com/thomas-holmes/711bcdb28e2b8e6d1c39c1d99d292af7
[2] https://bugzilla.suse.com/show_bug.cgi?id=1106512#c0
[3] https://launchpadlibrarian.net/459694705/test_overlay_permission.sh
[4] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1851243

Signed-off-by: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/inode.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -9,7 +9,6 @@
 
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/cred.h>
 #include <linux/xattr.h>
 #include "overlayfs.h"
 
@@ -92,7 +91,6 @@ int ovl_permission(struct inode *inode,
 	struct ovl_entry *oe;
 	struct dentry *alias = NULL;
 	struct inode *realinode;
-	const struct cred *old_cred;
 	struct dentry *realdentry;
 	bool is_upper;
 	int err;
@@ -145,18 +143,7 @@ int ovl_permission(struct inode *inode,
 			goto out_dput;
 	}
 
-	/*
-	 * Check overlay inode with the creds of task and underlying inode
-	 * with creds of mounter
-	 */
-	err = generic_permission(inode, mask);
-	if (err)
-		goto out_dput;
-
-	old_cred = ovl_override_creds(inode->i_sb);
 	err = __inode_permission(realinode, mask);
-	revert_creds(old_cred);
-
 out_dput:
 	dput(alias);
 	return err;


