Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9BA2E656F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390950AbgL1Nb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390948AbgL1Nb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6EB22582;
        Mon, 28 Dec 2020 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162301;
        bh=Y6Ayr8WtJZPMpItiKT91BoUhaxMLEnpZO1OIGCZvovI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2gBEtuR3SQuk/zwXU/D18nQRLYvSAnF/D0fAA05VogvQYfkujwm99zIBgpp2QRiW
         gKuyCdZZ8bjjAuN1L519p9/mlEKASMt+GgI2x0ffMLEpIOQ5wWK/wT8ijhsTrmC9GH
         wAVeondmn9o7kuYUvS3o/Pb6pI05EsFzcwQWFwL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/346] usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe
Date:   Mon, 28 Dec 2020 13:48:55 +0100
Message-Id: <20201228124930.220787211@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 7d20296cbe9f9..d31c425d61675 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -222,6 +222,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 
 err_pm_runtime:
 	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 
 err_phy:
 	for (i = 0; i < omap->nports; i++) {
-- 
2.27.0



