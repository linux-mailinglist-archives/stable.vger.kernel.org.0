Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FD531EDE6
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBRSDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232127AbhBRPY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 10:24:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D19064E6F;
        Thu, 18 Feb 2021 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613661848;
        bh=ITex1z9nEFvHBIK8prhsEXW7QNpPvDGW+0boJmlsSP0=;
        h=Subject:To:From:Date:From;
        b=I3ZvFEAjSj00cDKmD8rfOeM1PjpPp2DPGGyAdng0LImBX1ItScv8bm4OMxMS/GLlp
         ZIJj5f1XD4a/peBQ3+Co/iOseiRHb4ExaAdbzw9p2OrSXvfCQqxgxlN9Yz+C76Np4P
         WtC8qAnzvoacfQ0Ezs8oN6RWweYrGBTq5624KoZA=
Subject: patch "debugfs: be more robust at handling improper input in" added to driver-core-testing
To:     gregkh@linuxfoundation.org, maz@kernel.org, michael@walle.cc,
        rafael@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Feb 2021 16:24:05 +0100
Message-ID: <161366184510152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    debugfs: be more robust at handling improper input in

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the driver-core-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From bc6de804d36b3709d54fa22bd128cbac91c11526 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 18 Feb 2021 11:08:17 +0100
Subject: debugfs: be more robust at handling improper input in
 debugfs_lookup()

debugfs_lookup() doesn't like it if it is passed an illegal name
pointer, or if the filesystem isn't even initialized yet.  If either of
these happen, it will crash the system, so fix it up by properly testing
for valid input and that we are up and running before trying to find a
file in the filesystem.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210218100818.3622317-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 2fcf66473436..bbeb563cbe78 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -297,7 +297,7 @@ struct dentry *debugfs_lookup(const char *name, struct dentry *parent)
 {
 	struct dentry *dentry;
 
-	if (IS_ERR(parent))
+	if (!debugfs_initialized() || IS_ERR_OR_NULL(name) || IS_ERR(parent))
 		return NULL;
 
 	if (!parent)
-- 
2.30.1


