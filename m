Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4A2E4288
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407730AbgL1N75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407722AbgL1N74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4F5C20799;
        Mon, 28 Dec 2020 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163981;
        bh=aJ/QwsVof6xNW9nvjSnTD8jIkYqKc1rROQ8iu2vpGfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDTSCnAaquF9cOZ9l24E+ag/a5NGWPBCUDlbqgtMEpQ0Bm2hmB3LAPGlGACFWVFhl
         Dmsq+D9x+Osrk/GyrI0gGV0hK0bgPy75K7ViViTtMPnWqFfqJJKAchgWaDD4VauSyX
         jPr0UM151kbPdAY2GrE5n2uxgnrQ+D+RVtgugERA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyue Ren <rentianyue@kylinos.cn>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/717] selinux: fix error initialization in inode_doinit_with_dentry()
Date:   Mon, 28 Dec 2020 13:40:17 +0100
Message-Id: <20201228125021.905697213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyue Ren <rentianyue@kylinos.cn>

[ Upstream commit 83370b31a915493231e5b9addc72e4bef69f8d31 ]

Mark the inode security label as invalid if we cannot find
a dentry so that we will retry later rather than marking it
initialized with the unlabeled SID.

Fixes: 9287aed2ad1f ("selinux: Convert isec->lock into a spinlock")
Signed-off-by: Tianyue Ren <rentianyue@kylinos.cn>
[PM: minor comment tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6b1826fc3658e..158fc47d8620d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1451,7 +1451,13 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit with a dentry, before these inodes could
 			 * be used again by userspace.
 			 */
-			goto out;
+			isec->initialized = LABEL_INVALID;
+			/*
+			 * There is nothing useful to jump to the "out"
+			 * label, except a needless spin lock/unlock
+			 * cycle.
+			 */
+			return 0;
 		}
 
 		rc = inode_doinit_use_xattr(inode, dentry, sbsec->def_sid,
@@ -1507,8 +1513,15 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			 * inode_doinit() with a dentry, before these inodes
 			 * could be used again by userspace.
 			 */
-			if (!dentry)
-				goto out;
+			if (!dentry) {
+				isec->initialized = LABEL_INVALID;
+				/*
+				 * There is nothing useful to jump to the "out"
+				 * label, except a needless spin lock/unlock
+				 * cycle.
+				 */
+				return 0;
+			}
 			rc = selinux_genfs_get_sid(dentry, sclass,
 						   sbsec->flags, &sid);
 			if (rc) {
-- 
2.27.0



