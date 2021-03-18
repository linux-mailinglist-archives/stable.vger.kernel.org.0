Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E4733FF29
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 07:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCRGAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 02:00:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:32755 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229454AbhCRGAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 02:00:11 -0400
IronPort-SDR: BSxKdS/sAntxzgpgiWZMjuY7uCVaPm3G799KXhcoqW0kGJbZakuvWNXyNWAU15lXrTb4bR2NkY
 WzXIthAH2L2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="274664966"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="274664966"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 23:00:10 -0700
IronPort-SDR: R4xHaaQ9RLYh3b1dz6IdmtQ7dCjPC/HYsfZndAyNyx2+GkohRHH59zNy6tXvQO/LZ3LFiNBd2U
 Y+8NL/7IvQOQ==
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="412942689"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 23:00:08 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, stable@vger.kernel.org
Subject: [char-misc-next] mei: allow map and unmap of client dma buffer only for disconnected client
Date:   Thu, 18 Mar 2021 07:59:59 +0200
Message-Id: <20210318055959.305627-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow map and unmap of the client dma buffer only when the client is not
connected. The functions return -EPROTO if the client is already connected.
This is to fix the race when traffic may start or stop when buffer
is not available.

Cc: <stable@vger.kernel.org> #v5.11+
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
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
2.26.3

