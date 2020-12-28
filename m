Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05052E682E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441959AbgL1Qcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgL1NEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B782208B6;
        Mon, 28 Dec 2020 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160602;
        bh=Jt5ah7W6jt8vYVVXZz8JhEpNRQ0h7d7odSb+gh5XBgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBMfd215wwgqQb4Cgql6pSzRixZ+/94jbaGNmZ7ehU74iFRivppIwPVmD9d1I8617
         M8kikKtYT4uY9tFpyagETWyeTGnF5XYr9TluYQiDajWe/OeZ+SZtUKlHaZAH666M3N
         NA87wMmyq6gAUT8OMWrxQOwsqjIFyUzYBjiQ+ujI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 106/175] usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe
Date:   Mon, 28 Dec 2020 13:49:19 +0100
Message-Id: <20201228124858.388195843@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit d6ff32478d7e95d6ca199b5c852710d6964d5811 ]

The pm_runtime_enable will decrement the power disable depth. Imbalance
depth will resulted in enabling runtime PM of device fails later.  Thus
a pairing decrement must be needed on the error handling path to keep it
balanced.

Fixes: 6c984b066d84b ("ARM: OMAP: USBHOST: Replace usbhs core driver APIs by Runtime pm APIs")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201123145719.1455849-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-omap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 94ea9fff13e6d..9227a9ddac609 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -237,6 +237,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 
 err_pm_runtime:
 	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 
 err_phy:
 	for (i = 0; i < omap->nports; i++) {
-- 
2.27.0



