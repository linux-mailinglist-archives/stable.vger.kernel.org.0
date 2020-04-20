Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE341B0A8E
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgDTMsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgDTMsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8915B20736;
        Mon, 20 Apr 2020 12:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386931;
        bh=D+r3/ZPsZAPbTUAkTAu0VfQ1jRA/yMEXedkNJkr1pvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmFKcZ7tHU0Nrx5bY/Tui2XZ9EPD/DEQea0gNZdPFLHaGLqRE9ICD1wFB70qjrGK8
         Hov/1uB7ADLTYnDqlx9LtvcwipQTaU9/AiEBqvgP/nRzOfHVMXLiOQWkMvyhQBs6+/
         VBn2zNKdaWsGC+t/773LSPVjcDfp8TGccERdzCIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/40] usb: dwc3: gadget: dont enable interrupt when disabling endpoint
Date:   Mon, 20 Apr 2020 14:39:35 +0200
Message-Id: <20200420121501.489818182@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c5353b225df9b2d0cf881873eef6f680e43c9aa2 ]

Since we're disabling the endpoint anyway, we don't worry about
getting endpoint command completion interrupt.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7b8b463676ad6..019aee3a79568 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -688,12 +688,13 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 	return 0;
 }
 
-static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force);
+static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
+		bool interrupt);
 static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
 {
 	struct dwc3_request		*req;
 
-	dwc3_stop_active_transfer(dep, true);
+	dwc3_stop_active_transfer(dep, true, false);
 
 	/* - giveback all requests to gadget driver */
 	while (!list_empty(&dep->started_list)) {
@@ -1416,7 +1417,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		}
 		if (r == req) {
 			/* wait until it is processed */
-			dwc3_stop_active_transfer(dep, true);
+			dwc3_stop_active_transfer(dep, true, true);
 
 			if (!r->trb)
 				goto out0;
@@ -2366,7 +2367,7 @@ static void dwc3_gadget_endpoint_transfer_in_progress(struct dwc3_ep *dep,
 	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
 	if (stop) {
-		dwc3_stop_active_transfer(dep, true);
+		dwc3_stop_active_transfer(dep, true, true);
 		dep->flags = DWC3_EP_ENABLED;
 	}
 
@@ -2488,7 +2489,8 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
 	}
 }
 
-static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force)
+static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
+	bool interrupt)
 {
 	struct dwc3 *dwc = dep->dwc;
 	struct dwc3_gadget_ep_cmd_params params;
@@ -2532,7 +2534,7 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force)
 
 	cmd = DWC3_DEPCMD_ENDTRANSFER;
 	cmd |= force ? DWC3_DEPCMD_HIPRI_FORCERM : 0;
-	cmd |= DWC3_DEPCMD_CMDIOC;
+	cmd |= interrupt ? DWC3_DEPCMD_CMDIOC : 0;
 	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
 	memset(&params, 0, sizeof(params));
 	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-- 
2.20.1



