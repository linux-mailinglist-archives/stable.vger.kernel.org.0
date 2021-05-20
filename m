Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD37E38A6B2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhETK3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236113AbhETK2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B408061C2F;
        Thu, 20 May 2021 09:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504255;
        bh=bLWm8hy44V8UpnLnkmIfeoX9moIiwg7OlwNSNKDjnRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS4vbZUg4ps5wNGCdveoGe4mQU2+RuEWYmWbr/uHSRxgZaQsoqGuOgV7BiSFaYr1u
         SmJKTg8o7FZKvbkgpjbh0iA+EArODkDMxd5Bp13i2GUd5NykxKOloeIsKAQv2HP8Xu
         CqlMnvgdcCzJ7bJedbit+YyjSXoKUQpzCbU8HCbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 161/323] USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()
Date:   Thu, 20 May 2021 11:20:53 +0200
Message-Id: <20210520092125.623965079@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index e8a5fdaee37d..204f7acf89a4 100644
--- a/drivers/usb/gadget/udc/snps_udc_plat.c
+++ b/drivers/usb/gadget/udc/snps_udc_plat.c
@@ -122,8 +122,8 @@ static int udc_plat_probe(struct platform_device *pdev)
 
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



