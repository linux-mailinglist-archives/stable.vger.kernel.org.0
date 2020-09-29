Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2C27CC48
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbgI2Me6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgI2LVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:21:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF21A23A50;
        Tue, 29 Sep 2020 11:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378364;
        bh=FKSyQy8IhMrfV3uwxwj3FPEYU6o9g3jlh069ZrX5a10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI9sBERoWROxA98y4PE0r98Amq1gJ3wpgXIgBfKbMZ8phNbM9g6cyQHN80EN6gv1M
         M6H0KeePDJC3pbvAt2/O2wPd1GIvl+14+VXOajQKBm0yDQ2SuLu517Jiv2gWQzkORw
         eaqMUfL++KHY25U8Uz/W8Sx9e0MawGc7wGnS8xVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Chen <chenyu56@huawei.com>,
        John Stultz <john.stultz@linaro.org>, Li Jun <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 125/166] usb: dwc3: Increase timeout for CmdAct cleared by device controller
Date:   Tue, 29 Sep 2020 13:00:37 +0200
Message-Id: <20200929105941.439256515@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4149d751719e3..4a42368734644 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -276,7 +276,7 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned cmd,
 {
 	const struct usb_endpoint_descriptor *desc = dep->endpoint.desc;
 	struct dwc3		*dwc = dep->dwc;
-	u32			timeout = 1000;
+	u32			timeout = 5000;
 	u32			saved_config = 0;
 	u32			reg;
 
-- 
2.25.1



