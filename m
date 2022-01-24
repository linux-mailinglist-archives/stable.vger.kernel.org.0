Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E15499663
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355210AbiAXVDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:03:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49848 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443443AbiAXU46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:56:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D748D60B03;
        Mon, 24 Jan 2022 20:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8774C340E5;
        Mon, 24 Jan 2022 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057816;
        bh=e4BpGwdT8izfHTQPZn1Ny6wEvrlLCnwgZUVm5AB7R5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugAdMgexZTUNmSKUvataG+vr+3PS14HBp4AdKRH8VLr3FVUuGoalUfu6bNwIQ7r2i
         JV9S2famDY4u29QcLDGfa1IQrdWPXCkitW8nmv+nBgTjOINT0LPCJVWKZJRoO8HT4C
         IWLHUt7NZvYqAo+d+XSiizvVDvlJCZ+ExnibPlvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.16 0056/1039] mei: hbm: fix client dma reply status
Date:   Mon, 24 Jan 2022 19:30:45 +0100
Message-Id: <20220124184127.033162199@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 6b0b80ac103b2a40c72a47c301745fd1f4ef4697 upstream.

Don't blindly copy status value received from the firmware
into internal client status field,
It may be positive and ERR_PTR(ret) will translate it
into an invalid address and the caller will crash.

Put the error code into the client status on failure.

Fixes: 369aea845951 ("mei: implement client dma setup.")
Cc: <stable@vger.kernel.org> # v5.11+
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: : Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20211228082047.378115-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hbm.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -672,10 +672,14 @@ static void mei_hbm_cl_dma_map_res(struc
 	if (!cl)
 		return;
 
-	dev_dbg(dev->dev, "cl dma map result = %d\n", res->status);
-	cl->status = res->status;
-	if (!cl->status)
+	if (res->status) {
+		dev_err(dev->dev, "cl dma map failed %d\n", res->status);
+		cl->status = -EFAULT;
+	} else {
+		dev_dbg(dev->dev, "cl dma map succeeded\n");
 		cl->dma_mapped = 1;
+		cl->status = 0;
+	}
 	wake_up(&cl->wait);
 }
 
@@ -698,10 +702,14 @@ static void mei_hbm_cl_dma_unmap_res(str
 	if (!cl)
 		return;
 
-	dev_dbg(dev->dev, "cl dma unmap result = %d\n", res->status);
-	cl->status = res->status;
-	if (!cl->status)
+	if (res->status) {
+		dev_err(dev->dev, "cl dma unmap failed %d\n", res->status);
+		cl->status = -EFAULT;
+	} else {
+		dev_dbg(dev->dev, "cl dma unmap succeeded\n");
 		cl->dma_mapped = 0;
+		cl->status = 0;
+	}
 	wake_up(&cl->wait);
 }
 


