Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD131425A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhBHVya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:54:30 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:57250 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235345AbhBHVyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 16:54:21 -0500
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D7AE1C0096;
        Mon,  8 Feb 2021 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1612821198; bh=ozkQo3B++EYfECFvGM89waDABpZFRTmfbTdPMBiW3AU=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=eKxsEwCJ4no0dPV9cCQZkctnqjg3l/E9CRBKgW/PjtMPQKDjcr7LCaeHtPCh22bqk
         VLLNn1bVATtgZKB2I24MuhPAT1nw4WnVPv+YQVlagLMFhyaYG+EkoN9jzgFzX05K2D
         kVPiTrdQM2ySmw+H+aMgjXLSHFqJUQtE+qxp/XNPNg3VY4xAoKuh/Fk31Xo7HRAOql
         kfg7gP/Oa6pPfuZpp1Ln75RGuj4kTC2vKOo+edFEpFHdmGODZRcpX07dGZ3oqPbs40
         lKBHwsKkCFQ6wQAJQvoI3wc4dcnlUGHI8oVvylrMc//5vh9MIF1yujeKULJMZ+IPUg
         LGr3x990CRDWA==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 533B0A007C;
        Mon,  8 Feb 2021 21:53:17 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Mon, 08 Feb 2021 13:53:16 -0800
Date:   Mon, 08 Feb 2021 13:53:16 -0800
Message-Id: <1263b563dedc4ab8b0fb854fba06ce4bc56bd495.1612820995.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1612820995.git.Thinh.Nguyen@synopsys.com>
References: <cover.1612820995.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 2/2] usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dep->interval captures the number of frames/microframes per interval
from bInterval. Fullspeed interrupt endpoint bInterval is the number of
frames per interval and not 2^(bInterval - 1). So fix it here. This
change is only for debugging purpose and should not affect the interrupt
endpoint operation.

Cc: <stable@vger.kernel.org>
Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index d0f8d3ec855f..aebcf8ec0716 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -615,8 +615,13 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		if (dwc->gadget->speed == USB_SPEED_FULL)
 			bInterval_m1 = 0;
 
+		if (usb_endpoint_type(desc) == USB_ENDPOINT_XFER_INT &&
+		    dwc->gadget->speed == USB_SPEED_FULL)
+			dep->interval = desc->bInterval;
+		else
+			dep->interval = 1 << (desc->bInterval - 1);
+
 		params.param1 |= DWC3_DEPCFG_BINTERVAL_M1(bInterval_m1);
-		dep->interval = 1 << (desc->bInterval - 1);
 	}
 
 	return dwc3_send_gadget_ep_cmd(dep, DWC3_DEPCMD_SETEPCONFIG, &params);
-- 
2.28.0

