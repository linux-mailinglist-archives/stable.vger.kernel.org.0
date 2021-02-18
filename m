Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A0431EDE9
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBRSDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:03:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhBRP0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 10:26:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 985F561494;
        Thu, 18 Feb 2021 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613661924;
        bh=KYQQT/h7NAr4W5QdUloljaFErRZGK/qj8Y+UcYIqp+E=;
        h=Subject:To:From:Date:From;
        b=VGMbrqeVFQ6mcebgKP5Fz1rytgwcxhfJW5PI2bMnjUK6p4W/a4Hsptryn945tC5q7
         bYDC02ncF2rGdYdGeiyWa+aFwwaO3Z01S+YvnD8JqrvC+xfw2lrH615Z5NYwwdk2eV
         fk6RXTSXX7BaRto5zG63dE6A0Z6TW+S/4lfqEJJE=
Subject: patch "debugfs: do not attempt to create a new file before the filesystem is" added to driver-core-next
To:     gregkh@linuxfoundation.org, maz@kernel.org, michael@walle.cc,
        rafael@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Feb 2021 16:25:12 +0100
Message-ID: <1613661912106224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    debugfs: do not attempt to create a new file before the filesystem is

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 56348560d495d2501e87db559a61de717cd3ab02 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 18 Feb 2021 11:08:18 +0100
Subject: debugfs: do not attempt to create a new file before the filesystem is
 initalized

Some subsystems want to add debugfs files at early boot, way before
debugfs is initialized.  This seems to work somehow as the vfs layer
will not allow it to happen, but let's be explicit and test to ensure we
are properly up and running before allowing files to be created.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Reported-by: Michael Walle <michael@walle.cc>
Reported-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210218100818.3622317-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index bbeb563cbe78..86c7f0489620 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -318,6 +318,9 @@ static struct dentry *start_creating(const char *name, struct dentry *parent)
 	if (!(debugfs_allow & DEBUGFS_ALLOW_API))
 		return ERR_PTR(-EPERM);
 
+	if (!debugfs_initialized())
+		return ERR_PTR(-ENOENT);
+
 	pr_debug("creating file '%s'\n", name);
 
 	if (IS_ERR(parent))
-- 
2.30.1


