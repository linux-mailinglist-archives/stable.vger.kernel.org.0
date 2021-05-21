Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D93838C57D
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 13:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhEULOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 07:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhEULOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 07:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA60E613CC;
        Fri, 21 May 2021 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621595610;
        bh=tVJKLUUWLmpTliwEPxW4z5hSZ3Un+OgMh+H8JiK4GxU=;
        h=Subject:To:From:Date:From;
        b=pVXLXzNR/b7OA1UyBMazfe6w2lsjCMgvLN6mqE5y5vdNEw2Y+YXgQKknFWCACvKHV
         ZG9MCpV3oOXaCrKfHgNhDdpweApv1Hw29adHQB4eLzVRGBetm4uRJ/Jl5x6KdRd8p+
         CKat/vkKbMqwHuoomF/0AlGTrAL8S2aKjiVwrPXU=
Subject: patch "debugfs: fix security_locked_down() call for SELinux" added to driver-core-linus
To:     omosnace@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 13:13:27 +0200
Message-ID: <162159560726173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    debugfs: fix security_locked_down() call for SELinux

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5881fa8dc2de9697a89451f6518e8b3a796c09c6 Mon Sep 17 00:00:00 2001
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Fri, 7 May 2021 14:53:04 +0200
Subject: debugfs: fix security_locked_down() call for SELinux

When (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) is zero, then
the SELinux implementation of the locked_down hook might report a denial
even though the operation would actually be allowed.

To fix this, make sure that security_locked_down() is called only when
the return value will be taken into account (i.e. when changing one of
the problematic attributes).

Note: this was introduced by commit 5496197f9b08 ("debugfs: Restrict
debugfs when the kernel is locked down"), but it didn't matter at that
time, as the SELinux support came in later.

Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Link: https://lore.kernel.org/r/20210507125304.144394-1-omosnace@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 1d252164d97b..8129a430d789 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -45,10 +45,13 @@ static unsigned int debugfs_allow __ro_after_init = DEFAULT_DEBUGFS_ALLOW_BITS;
 static int debugfs_setattr(struct user_namespace *mnt_userns,
 			   struct dentry *dentry, struct iattr *ia)
 {
-	int ret = security_locked_down(LOCKDOWN_DEBUGFS);
+	int ret;
 
-	if (ret && (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)))
-		return ret;
+	if (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) {
+		ret = security_locked_down(LOCKDOWN_DEBUGFS);
+		if (ret)
+			return ret;
+	}
 	return simple_setattr(&init_user_ns, dentry, ia);
 }
 
-- 
2.31.1


