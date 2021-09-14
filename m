Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7480C40A961
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhINIgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhINIgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ADDA6103B;
        Tue, 14 Sep 2021 08:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631608527;
        bh=VKoxazqJ7VkIIS84Ejl9WQgak3vgYCSWlvVU6s08tE8=;
        h=Subject:To:From:Date:From;
        b=ZCRV8xv8C2Ow66KrAhcR0FbJXFewKTn4/ko95Zb9BKgxHqwiuzCVq7xlY2fNM1OfQ
         66gZQSzoL1kzRzgDmk2VBm+NiF9uMmI1DLK8lqcga3ZSg++Z0rMkY9jbOPhUh5wDXJ
         THFfsnQgK5gnPZaCL4UvVfgpUZccKyY/JbmTttTk=
Subject: patch "usb: cdns3: fix race condition before setting doorbell" added to usb-linus
To:     pawell@cadence.com, a-govindraju@ti.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:35:19 +0200
Message-ID: <163160851915022@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: fix race condition before setting doorbell

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b69ec50b3e55c4b2a85c8bc46763eaf330605847 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 7 Sep 2021 08:26:19 +0200
Subject: usb: cdns3: fix race condition before setting doorbell

For DEV_VER_V3 version there exist race condition between clearing
ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
Setting EP_CMD_DRDY will be ignored by controller when
EP_STS_TRBERR is set. So, between these two instructions we have
a small time gap in which the EP_STSS_TRBERR can be set. In such case
the transfer will not start after setting doorbell.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org> # 5.12.x
Tested-by: Aswath Govindraju <a-govindraju@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210907062619.34622-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 5d8c982019af..1f3b4a142212 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1100,6 +1100,19 @@ static int cdns3_ep_run_stream_transfer(struct cdns3_endpoint *priv_ep,
 	return 0;
 }
 
+static void cdns3_rearm_drdy_if_needed(struct cdns3_endpoint *priv_ep)
+{
+	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
+
+	if (priv_dev->dev_ver < DEV_VER_V3)
+		return;
+
+	if (readl(&priv_dev->regs->ep_sts) & EP_STS_TRBERR) {
+		writel(EP_STS_TRBERR, &priv_dev->regs->ep_sts);
+		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+	}
+}
+
 /**
  * cdns3_ep_run_transfer - start transfer on no-default endpoint hardware
  * @priv_ep: endpoint object
@@ -1351,6 +1364,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		/*clearing TRBERR and EP_STS_DESCMIS before seting DRDY*/
 		writel(EP_STS_TRBERR | EP_STS_DESCMIS, &priv_dev->regs->ep_sts);
 		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+		cdns3_rearm_drdy_if_needed(priv_ep);
 		trace_cdns3_doorbell_epx(priv_ep->name,
 					 readl(&priv_dev->regs->ep_traddr));
 	}
-- 
2.33.0


