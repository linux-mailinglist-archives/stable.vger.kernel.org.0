Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB8038A3A5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhETJz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234462AbhETJwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:52:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AF3D61622;
        Thu, 20 May 2021 09:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503378;
        bh=Cv6LI9wlQSoSUVWhBCyuz4fJ+z81h80e01Lbp8ns4cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EelB0movQf8W2dJzDpOSEDdx7o7oSomCbDNNQ3uu8bZtYcMaNr81cGMw3QY3H5jr1
         YBLUI6lTnmXD2NkzzHrlmDU4CpBobgGiIMi00DnKf2ciWmcivSv5QPwdJNZ8QTzal+
         hcIIsv9ECx0fNpji8CJDEribpFu0KZ20gUHmo5yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/425] USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()
Date:   Thu, 20 May 2021 11:19:24 +0200
Message-Id: <20210520092137.828611977@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 2e3d055bf27d70204cae349335a62a4f9b7c165a ]

IS_ERR() and PTR_ERR() use wrong pointer, it should be
udc->virt_addr, fix it.

Fixes: 1b9f35adb0ff ("usb: gadget: udc: Add Synopsys UDC Platform driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210330130159.1051979-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/snps_udc_plat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/snps_udc_plat.c b/drivers/usb/gadget/udc/snps_udc_plat.c
index 32f1d3e90c26..99805d60a7ab 100644
--- a/drivers/usb/gadget/udc/snps_udc_plat.c
+++ b/drivers/usb/gadget/udc/snps_udc_plat.c
@@ -114,8 +114,8 @@ static int udc_plat_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	udc->virt_addr = devm_ioremap_resource(dev, res);
-	if (IS_ERR(udc->regs))
-		return PTR_ERR(udc->regs);
+	if (IS_ERR(udc->virt_addr))
+		return PTR_ERR(udc->virt_addr);
 
 	/* udc csr registers base */
 	udc->csr = udc->virt_addr + UDC_CSR_ADDR;
-- 
2.30.2



