Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1A127C812
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgI2L6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgI2Llw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD64206F7;
        Tue, 29 Sep 2020 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379712;
        bh=6uzXXWI0y9hLLOPB61lhgPChBKZfo1sriuNCfxOGg8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWGBZ6uzdOly10QWtuCC08JPR8bmqxSM4Swb7TDX5PlrNZvJUTHc/DNnAeUQgZgr7
         +Cg2EfVHRTPEL8IdU86knwSnOl0teDiUk1+2eZeBmNZ/K97Zb8nu1eB9w9ioVYf7VR
         YVSKjBEzS27lxjxp/WtDpuM+Vp2nPtqLU3GSq1hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 255/388] USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()
Date:   Tue, 29 Sep 2020 12:59:46 +0200
Message-Id: <20200929110022.817735527@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



