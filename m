Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271652A513F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgKCUir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729996AbgKCUin (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A20C12224E;
        Tue,  3 Nov 2020 20:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435923;
        bh=T02o5Udkax2eoFN+Of/S+ktQnyMeM0oJ6VzAt25IZz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AAhVIu29fZzo25CRMj0cgK1XETH85DtzLkaLfBotos0r1cTKizErm0V0Lhu18+7s
         A4jjIUopcCvD6NZ8zXwU3m6RmjFs0Qoo3dw1ASyLwfW2f9Tb9/JclijwWQ28PeFzGb
         6Fe9DYtNmWN+t12dRq1Kl/t14e6a437J4vKW/mwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Thierry Reding <treding@nvidia.com>,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 041/391] usb: host: ehci-tegra: Fix error handling in tegra_ehci_probe()
Date:   Tue,  3 Nov 2020 21:31:32 +0100
Message-Id: <20201103203350.410726708@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 32d174d2d5eb318c34ff36771adefabdf227c186 ]

If the function platform_get_irq() failed, the negative value
returned will not be detected here. So fix error handling in
tegra_ehci_probe().

Fixes: 79ad3b5add4a ("usb: host: Add EHCI driver for NVIDIA Tegra SoCs")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20201026090657.49988-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index e077b2ca53c51..869d9c4de5fcd 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -479,8 +479,8 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	u_phy->otg->host = hcd_to_bus(hcd);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
-		err = -ENODEV;
+	if (irq < 0) {
+		err = irq;
 		goto cleanup_phy;
 	}
 
-- 
2.27.0



