Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D3925DF75
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgIDQMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 12:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgIDQMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 12:12:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B5B92074D;
        Fri,  4 Sep 2020 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599235965;
        bh=la3TyS7vVTZN42KHMdToaoK3PJRSu01m7MbVO+OuZFM=;
        h=Subject:To:From:Date:From;
        b=KwBoSmwiGUSXB6g8cUqmuFMbueQk3eI9k3i5u3cuVBhbv+CRkx7ZsCjaTV7mq5tom
         E56kq7B7e42J/Z6UGqODDZwa3zHzARCCt/2/cbZe2u8WpxqNp3Mt8txxOEWnavF9dS
         H6Zr5kmffpJNWIDRk3RY2wfFga9pLLIAosgqApfw=
Subject: patch "debugfs: Fix module state check condition" added to driver-core-linus
To:     vdronov@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 18:13:06 +0200
Message-ID: <1599235986247174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    debugfs: Fix module state check condition

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e3b9fc7eec55e6fdc8beeed18f2ed207086341e2 Mon Sep 17 00:00:00 2001
From: Vladis Dronov <vdronov@redhat.com>
Date: Tue, 11 Aug 2020 17:01:29 +0200
Subject: debugfs: Fix module state check condition

The '#ifdef MODULE' check in the original commit does not work as intended.
The code under the check is not built at all if CONFIG_DEBUG_FS=y. Fix this
by using a correct check.

Fixes: 275678e7a9be ("debugfs: Check module state before warning in {full/open}_proxy_open()")
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200811150129.53343-1-vdronov@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index b167d2d02148..a768a09430c3 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -177,7 +177,7 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 		goto out;
 
 	if (!fops_get(real_fops)) {
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 		if (real_fops->owner &&
 		    real_fops->owner->state == MODULE_STATE_GOING)
 			goto out;
@@ -312,7 +312,7 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 		goto out;
 
 	if (!fops_get(real_fops)) {
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 		if (real_fops->owner &&
 		    real_fops->owner->state == MODULE_STATE_GOING)
 			goto out;
-- 
2.28.0


