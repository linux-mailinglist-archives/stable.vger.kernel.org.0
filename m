Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01D7420E29
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhJDNWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236322AbhJDNUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 256D6613D5;
        Mon,  4 Oct 2021 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352923;
        bh=/Jmw2NIfSbfqBRDWlcm8mKANeosTuX2qFq+wE7Ji8sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNPbsP/2v1b1fRrQc1xL3WmH8WS8HFZNVX2h73KW7t7HN45OL4vUaK6aPNiFzZeX3
         BulH3k7nG2ekqIEiC2ncI8yV9MFBzYwCtlGza+9cJ7NkKJZkn3uh722twkYAu3jwgv
         zvhMpRVKOjltG6Nuer8NunbnCHgUHnGQNwBSTxF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/93] usb: cdns3: fix race condition before setting doorbell
Date:   Mon,  4 Oct 2021 14:52:03 +0200
Message-Id: <20211004125034.762835814@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit b69ec50b3e55c4b2a85c8bc46763eaf330605847 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 9d38f864cb68..e11162294413 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1101,6 +1101,19 @@ static int cdns3_ep_run_stream_transfer(struct cdns3_endpoint *priv_ep,
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
@@ -1352,6 +1365,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		/*clearing TRBERR and EP_STS_DESCMIS before seting DRDY*/
 		writel(EP_STS_TRBERR | EP_STS_DESCMIS, &priv_dev->regs->ep_sts);
 		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+		cdns3_rearm_drdy_if_needed(priv_ep);
 		trace_cdns3_doorbell_epx(priv_ep->name,
 					 readl(&priv_dev->regs->ep_traddr));
 	}
-- 
2.33.0



