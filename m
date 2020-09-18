Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4924C26F013
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgIRCkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgIRCLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA43208DB;
        Fri, 18 Sep 2020 02:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395094;
        bh=ygklLE7x3pSrEqwH+meJspWhHuinLS6HI8oRrCRgor0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1pUlPyWUJlUPM7rzD/8zAQlukNXF27rXjAArSG+kuI4c+lK1shkC7ysbaqGJpnNg
         G34VhpA8mM2jIEp31gS2p2jSGVBn9GOaL4UETC1vkyzRqX2J1hJOlghDhIRO7ox+bF
         xuO7nzDTw1USH+Yqeuil3Q9kGAf6kyLuJXA2GGLE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Chen <chenyu56@huawei.com>,
        John Stultz <john.stultz@linaro.org>, Li Jun <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 175/206] usb: dwc3: Increase timeout for CmdAct cleared by device controller
Date:   Thu, 17 Sep 2020 22:07:31 -0400
Message-Id: <20200918020802.2065198-175-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Chen <chenyu56@huawei.com>

[ Upstream commit 1c0e69ae1b9f9004fd72978612ae3463791edc56 ]

If the SS PHY is in P3, there is no pipe_clk, HW may use suspend_clk
for function, as suspend_clk is slow so EP command need more time to
complete, e.g, imx8M suspend_clk is 32K, set ep configuration will
take about 380us per below trace time stamp(44.286278 - 44.285897
= 0.000381):

configfs_acm.sh-822   [000] d..1    44.285896: dwc3_writel: addr
000000006d59aae1 value 00000401
configfs_acm.sh-822   [000] d..1    44.285897: dwc3_readl: addr
000000006d59aae1 value 00000401
... ...
configfs_acm.sh-822   [000] d..1    44.286278: dwc3_readl: addr
000000006d59aae1 value 00000001
configfs_acm.sh-822   [000] d..1    44.286279: dwc3_gadget_ep_cmd:
ep0out: cmd 'Set Endpoint Configuration' [401] params 00001000
00000500 00000000 --> status: Successful

This was originally found on Hisilicon Kirin Soc that need more time
for the device controller to clear the CmdAct of DEPCMD.

Signed-off-by: Yu Chen <chenyu56@huawei.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7bf2573dd459e..37cc3fd7c3cad 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -270,7 +270,7 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned cmd,
 {
 	const struct usb_endpoint_descriptor *desc = dep->endpoint.desc;
 	struct dwc3		*dwc = dep->dwc;
-	u32			timeout = 1000;
+	u32			timeout = 5000;
 	u32			saved_config = 0;
 	u32			reg;
 
-- 
2.25.1

