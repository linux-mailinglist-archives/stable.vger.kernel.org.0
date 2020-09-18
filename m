Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3FC26F23E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgIRC5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgIRCGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68CFA239D0;
        Fri, 18 Sep 2020 02:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394792;
        bh=6uzXXWI0y9hLLOPB61lhgPChBKZfo1sriuNCfxOGg8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZILd6uGvqDSnCUffAjVLlgJtVqXYeXGFZgJ2f1lHbMSLxQZ1AM/u5GivZNeU+n4n
         57sHNHFQDYAu84UV0Mn68hNgdLed9CpmIwV5MhFtGiNF7Kc6rpchIoA1E3DrWPZ2sE
         GJJaI9yvvDUQhz2uceuzn4h/xlMvVe8mEnwhQA7M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 262/330] USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()
Date:   Thu, 17 Sep 2020 22:00:02 -0400
Message-Id: <20200918020110.2063155-262-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit c856b4b0fdb5044bca4c0acf9a66f3b5cc01a37a ]

If the function platform_get_irq() failed, the negative value
returned will not be detected here. So fix error handling in
mv_ehci_probe(). And when get irq failed, the function
platform_get_irq() logs an error message, so remove redundant
message here.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20200508114305.15740-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-mv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index 66ec1fdf9fe7d..15b2e8910e9b7 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -157,9 +157,8 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	hcd->regs = ehci_mv->op_regs;
 
 	hcd->irq = platform_get_irq(pdev, 0);
-	if (!hcd->irq) {
-		dev_err(&pdev->dev, "Cannot get irq.");
-		retval = -ENODEV;
+	if (hcd->irq < 0) {
+		retval = hcd->irq;
 		goto err_disable_clk;
 	}
 
-- 
2.25.1

