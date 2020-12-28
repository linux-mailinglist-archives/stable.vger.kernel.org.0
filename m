Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C242E3AF5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391946AbgL1Nnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404405AbgL1Nno (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DAA621D94;
        Mon, 28 Dec 2020 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163008;
        bh=PC5/RpDZfIvt+bcLuIFw1MvS8/iDa+IkvDQlQSaFfWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCYcevWEX9EmASCkOiZRbq0H9z2IdVTMzhOlaogt6ygUeEYXAKMdazQYKF6eJo+6P
         Hwa2wIeL6/eWoQMRW72ROLN0tsMCxg6WZyUnL2huiQf4fCRM76cq+E3CPAx2PZv1YO
         da4Aq69ToCQt+Qxjxc1KJolp7e+QyFi2IZno88gM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/453] selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling
Date:   Mon, 28 Dec 2020 13:45:43 +0100
Message-Id: <20201228124942.363945272@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit 200ea5a2292dc444a818b096ae6a32ba3caa51b9 ]

A previous fix, commit 83370b31a915 ("selinux: fix error initialization
in inode_doinit_with_dentry()"), changed how failures were handled
before a SELinux policy was loaded.  Unfortunately that patch was
potentially problematic for two reasons: it set the isec->initialized
state without holding a lock, and it didn't set the inode's SELinux
label to the "default" for the particular filesystem.  The later can
be a problem if/when a later attempt to revalidate the inode fails
and SELinux reverts to the existing inode label.

This patch should restore the default inode labeling that existed
before the original fix, without affecting the LABEL_INVALID marking
such that revalidation will still be attempted in the future.

Fixes: 83370b31a915 ("selinux: fix error initialization in inode_doinit_with_dentry()")
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 76f7eb5690c8e..717a398ef4d05 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1499,13 +1499,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			isec->initialized = LABEL_INVALID;
-			/*
-			 * There is nothing useful to jump to the "out"
-			 * label, except a needless spin lock/unlock
-			 * cycle.
-			 */
-			return 0;
+			goto out_invalid;
 		}
 
 		rc = inode_doinit_use_xattr(inode, dentry, sbsec->def_sid,
@@ -1559,15 +1553,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit() with a dentry, before these inodes
 			 * could be used again by userspace.
 			 */
-			if (!dentry) {
-				isec->initialized = LABEL_INVALID;
-				/*
-				 * There is nothing useful to jump to the "out"
-				 * label, except a needless spin lock/unlock
-				 * cycle.
-				 */
-				return 0;
-			}
+			if (!dentry)
+				goto out_invalid;
 			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			if (rc) {
@@ -1592,11 +1579,10 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 out:
 	spin_lock(&isec->lock);
 	if (isec->initialized == LABEL_PENDING) {
-		if (!sid || rc) {
+		if (rc) {
 			isec->initialized = LABEL_INVALID;
 			goto out_unlock;
 		}
-
 		isec->initialized = LABEL_INITIALIZED;
 		isec->sid = sid;
 	}
@@ -1604,6 +1590,15 @@ out:
 out_unlock:
 	spin_unlock(&isec->lock);
 	return rc;
+
+out_invalid:
+	spin_lock(&isec->lock);
+	if (isec->initialized == LABEL_PENDING) {
+		isec->initialized = LABEL_INVALID;
+		isec->sid = sid;
+	}
+	spin_unlock(&isec->lock);
+	return 0;
 }
 
 /* Convert a Linux signal to an access vector. */
-- 
2.27.0



