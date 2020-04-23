Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB421B67A4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgDWXIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:08:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51050 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728679AbgDWXHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:07:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvm-0004y2-88; Fri, 24 Apr 2020 00:06:54 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvj-00E73O-LD; Fri, 24 Apr 2020 00:06:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>
Date:   Fri, 24 Apr 2020 00:07:44 +0100
Message-ID: <lsq.1587683028.637600042@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 237/245] [media] media-devnode: just return 0 instead
 of using a var
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 8b37c6455fc8f43e0e95db2847284e618db6a4f8 upstream.

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/media-devnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -192,7 +192,6 @@ static int media_open(struct inode *inod
 static int media_release(struct inode *inode, struct file *filp)
 {
 	struct media_devnode *mdev = media_devnode_data(filp);
-	int ret = 0;
 
 	if (mdev->fops->release)
 		mdev->fops->release(filp);
@@ -201,7 +200,7 @@ static int media_release(struct inode *i
 	   return value is ignored. */
 	put_device(&mdev->dev);
 	filp->private_data = NULL;
-	return ret;
+	return 0;
 }
 
 static const struct file_operations media_devnode_fops = {

