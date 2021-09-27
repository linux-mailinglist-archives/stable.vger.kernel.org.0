Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94189419BCE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhI0RWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237081AbhI0RUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58701611F0;
        Mon, 27 Sep 2021 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762803;
        bh=69Uxtxgyff81kJqEEoa933+6XTWO0/G3EDLXaWooPU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lJoiimZn/l/ILQOBm8NREmOVTitjWEUlximdDrHC4rzzZ6GAe0bh4hmP3BI70z/9
         5XGfMXkPVBrtFNkGUUchhzdDR4Brdn/UwO5m1JSxGdKAsGNu4wIK9KNUefIwxeuTxw
         eH07eTOT5BUBiZz8QOzIigJmzfbo11ozfIMHqcgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.14 024/162] usb: cdns3: fix race condition before setting doorbell
Date:   Mon, 27 Sep 2021 19:01:10 +0200
Message-Id: <20210927170234.300838423@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit b69ec50b3e55c4b2a85c8bc46763eaf330605847 upstream.

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
 drivers/usb/cdns3/cdns3-gadget.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1100,6 +1100,19 @@ static int cdns3_ep_run_stream_transfer(
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
@@ -1351,6 +1364,7 @@ static int cdns3_ep_run_transfer(struct
 		/*clearing TRBERR and EP_STS_DESCMIS before seting DRDY*/
 		writel(EP_STS_TRBERR | EP_STS_DESCMIS, &priv_dev->regs->ep_sts);
 		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+		cdns3_rearm_drdy_if_needed(priv_ep);
 		trace_cdns3_doorbell_epx(priv_ep->name,
 					 readl(&priv_dev->regs->ep_traddr));
 	}


