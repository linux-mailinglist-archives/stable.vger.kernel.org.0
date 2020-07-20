Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEFE2271AD
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgGTVov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgGTVhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B33722BEF;
        Mon, 20 Jul 2020 21:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281064;
        bh=8howY8j9fNGGWqKTj9zlyAhmGqYzekyWtWpnYVgsxus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tekFt1xDH52FxaIjUigh3LTF3VcCKYDo3XFcdoba5al6N8gFanLg83e+wKSMbQTcs
         zznfQxDAtF43zCopA3rJbm9TWqMP6mb7pORlplqbqKfnrsFDGIt3uNEFFrBPikEiLd
         sIiqqaBk0J4VS67pAkrd6YnJ8cicpXZnPkkOa09c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>, kbuild test robot <lkp@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 23/40] usb: cdns3: ep0: fix some endian issues
Date:   Mon, 20 Jul 2020 17:36:58 -0400
Message-Id: <20200720213715.406997-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 9f81d45c79271def8a9b90447b04b9c6323291f9 ]

It is found by sparse.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/ep0.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index da4c5eb03d7ee..666cebd9c5f29 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -37,18 +37,18 @@ static void cdns3_ep0_run_transfer(struct cdns3_device *priv_dev,
 	struct cdns3_usb_regs __iomem *regs = priv_dev->regs;
 	struct cdns3_endpoint *priv_ep = priv_dev->eps[0];
 
-	priv_ep->trb_pool[0].buffer = TRB_BUFFER(dma_addr);
-	priv_ep->trb_pool[0].length = TRB_LEN(length);
+	priv_ep->trb_pool[0].buffer = cpu_to_le32(TRB_BUFFER(dma_addr));
+	priv_ep->trb_pool[0].length = cpu_to_le32(TRB_LEN(length));
 
 	if (zlp) {
-		priv_ep->trb_pool[0].control = TRB_CYCLE | TRB_TYPE(TRB_NORMAL);
-		priv_ep->trb_pool[1].buffer = TRB_BUFFER(dma_addr);
-		priv_ep->trb_pool[1].length = TRB_LEN(0);
-		priv_ep->trb_pool[1].control = TRB_CYCLE | TRB_IOC |
-		    TRB_TYPE(TRB_NORMAL);
+		priv_ep->trb_pool[0].control = cpu_to_le32(TRB_CYCLE | TRB_TYPE(TRB_NORMAL));
+		priv_ep->trb_pool[1].buffer = cpu_to_le32(TRB_BUFFER(dma_addr));
+		priv_ep->trb_pool[1].length = cpu_to_le32(TRB_LEN(0));
+		priv_ep->trb_pool[1].control = cpu_to_le32(TRB_CYCLE | TRB_IOC |
+		    TRB_TYPE(TRB_NORMAL));
 	} else {
-		priv_ep->trb_pool[0].control = TRB_CYCLE | TRB_IOC |
-		    TRB_TYPE(TRB_NORMAL);
+		priv_ep->trb_pool[0].control = cpu_to_le32(TRB_CYCLE | TRB_IOC |
+		    TRB_TYPE(TRB_NORMAL));
 		priv_ep->trb_pool[1].control = 0;
 	}
 
@@ -264,11 +264,11 @@ static int cdns3_req_ep0_get_status(struct cdns3_device *priv_dev,
 	case USB_RECIP_INTERFACE:
 		return cdns3_ep0_delegate_req(priv_dev, ctrl);
 	case USB_RECIP_ENDPOINT:
-		index = cdns3_ep_addr_to_index(ctrl->wIndex);
+		index = cdns3_ep_addr_to_index(le16_to_cpu(ctrl->wIndex));
 		priv_ep = priv_dev->eps[index];
 
 		/* check if endpoint is stalled or stall is pending */
-		cdns3_select_ep(priv_dev, ctrl->wIndex);
+		cdns3_select_ep(priv_dev, le16_to_cpu(ctrl->wIndex));
 		if (EP_STS_STALL(readl(&priv_dev->regs->ep_sts)) ||
 		    (priv_ep->flags & EP_STALL_PENDING))
 			usb_status =  BIT(USB_ENDPOINT_HALT);
@@ -388,10 +388,10 @@ static int cdns3_ep0_feature_handle_endpoint(struct cdns3_device *priv_dev,
 	if (!(ctrl->wIndex & ~USB_DIR_IN))
 		return 0;
 
-	index = cdns3_ep_addr_to_index(ctrl->wIndex);
+	index = cdns3_ep_addr_to_index(le16_to_cpu(ctrl->wIndex));
 	priv_ep = priv_dev->eps[index];
 
-	cdns3_select_ep(priv_dev, ctrl->wIndex);
+	cdns3_select_ep(priv_dev, le16_to_cpu(ctrl->wIndex));
 
 	if (set)
 		__cdns3_gadget_ep_set_halt(priv_ep);
@@ -452,7 +452,7 @@ static int cdns3_req_ep0_set_sel(struct cdns3_device *priv_dev,
 	if (priv_dev->gadget.state < USB_STATE_ADDRESS)
 		return -EINVAL;
 
-	if (ctrl_req->wLength != 6) {
+	if (le16_to_cpu(ctrl_req->wLength) != 6) {
 		dev_err(priv_dev->dev, "Set SEL should be 6 bytes, got %d\n",
 			ctrl_req->wLength);
 		return -EINVAL;
@@ -476,7 +476,7 @@ static int cdns3_req_ep0_set_isoch_delay(struct cdns3_device *priv_dev,
 	if (ctrl_req->wIndex || ctrl_req->wLength)
 		return -EINVAL;
 
-	priv_dev->isoch_delay = ctrl_req->wValue;
+	priv_dev->isoch_delay = le16_to_cpu(ctrl_req->wValue);
 
 	return 0;
 }
-- 
2.25.1

