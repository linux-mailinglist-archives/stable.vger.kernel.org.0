Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACBE346133
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 15:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhCWOQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 10:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232216AbhCWOPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 10:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8E1761585;
        Tue, 23 Mar 2021 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616508941;
        bh=9eFtHqKZETCn0kriGpEnQ3tA/WE0Z0us6GCMXRMQEjM=;
        h=Subject:To:From:Date:From;
        b=VpKqM5cPNReH54d71ceW5VEtaO1fviQCaBEgC/yEgUqYzc0lh7KToXgIPVnSOtxQg
         LiFIqkn10ahtFPdNB2uFX4a49uYfEvYRcY/AAx/dUyr8kvt4JLyQ7k+DpMLy3xlrW+
         QwevARdDyQovLn5MU621rf2dqfLycERYVqeZD3tI=
Subject: patch "mei: allow map and unmap of client dma buffer only for disconnected" added to char-misc-linus
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 15:15:30 +0100
Message-ID: <1616508930185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: allow map and unmap of client dma buffer only for disconnected

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ce068bc7da473e39b64d130101e178406023df0c Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Thu, 18 Mar 2021 07:59:59 +0200
Subject: mei: allow map and unmap of client dma buffer only for disconnected
 client

Allow map and unmap of the client dma buffer only when the client is not
connected. The functions return -EPROTO if the client is already connected.
This is to fix the race when traffic may start or stop when buffer
is not available.

Cc: <stable@vger.kernel.org> #v5.11+
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20210318055959.305627-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/client.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 4378a9b25848..2cc370adb238 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -2286,8 +2286,8 @@ int mei_cl_dma_alloc_and_map(struct mei_cl *cl, const struct file *fp,
 	if (buffer_id == 0)
 		return -EINVAL;
 
-	if (!mei_cl_is_connected(cl))
-		return -ENODEV;
+	if (mei_cl_is_connected(cl))
+		return -EPROTO;
 
 	if (cl->dma_mapped)
 		return -EPROTO;
@@ -2327,9 +2327,7 @@ int mei_cl_dma_alloc_and_map(struct mei_cl *cl, const struct file *fp,
 
 	mutex_unlock(&dev->device_lock);
 	wait_event_timeout(cl->wait,
-			   cl->dma_mapped ||
-			   cl->status ||
-			   !mei_cl_is_connected(cl),
+			   cl->dma_mapped || cl->status,
 			   mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 
@@ -2376,8 +2374,9 @@ int mei_cl_dma_unmap(struct mei_cl *cl, const struct file *fp)
 		return -EOPNOTSUPP;
 	}
 
-	if (!mei_cl_is_connected(cl))
-		return -ENODEV;
+	/* do not allow unmap for connected client */
+	if (mei_cl_is_connected(cl))
+		return -EPROTO;
 
 	if (!cl->dma_mapped)
 		return -EPROTO;
@@ -2405,9 +2404,7 @@ int mei_cl_dma_unmap(struct mei_cl *cl, const struct file *fp)
 
 	mutex_unlock(&dev->device_lock);
 	wait_event_timeout(cl->wait,
-			   !cl->dma_mapped ||
-			   cl->status ||
-			   !mei_cl_is_connected(cl),
+			   !cl->dma_mapped || cl->status,
 			   mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 
-- 
2.31.0


