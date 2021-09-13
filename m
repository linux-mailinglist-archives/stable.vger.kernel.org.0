Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E8E40922A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344078AbhIMOIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242662AbhIMOGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E49661A6C;
        Mon, 13 Sep 2021 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540411;
        bh=x73VeGWG/wCftAU+sqyya83+jbHEp6i30b7fFTCFvcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0OtNno9Gl/X+igHIbLJgR5L31Q2hIZWVwyyHOscW1elU29XNWBY2kuzmJSoRzTmT
         DKVsRthIWca5bhAvJ6xoCQbnpM68sqnKumiWiGt41NmGqHIi41U4f+xdmk3DZlOUZ6
         hlBMtwLAdSDwtA5m+sL1OIqMO8ii2eQSR8TGASJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 182/300] usb: gadget: udc: s3c2410: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:03 +0200
Message-Id: <20210913131115.541383083@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit ecff88e819e31081d41cd05bb199b9bd10e13e90 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding an original
error code. Stop calling request_irq() with the invalid IRQ #s.

Fixes: 188db4435ac6 ("usb: gadget: s3c: use platform resources")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/bd69b22c-b484-5a1f-c798-78d4b78405f2@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/s3c2410_udc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/udc/s3c2410_udc.c
index b154b62abefa..82c4f3fb2dae 100644
--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -1784,6 +1784,10 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	s3c2410_udc_reinit(udc);
 
 	irq_usbd = platform_get_irq(pdev, 0);
+	if (irq_usbd < 0) {
+		retval = irq_usbd;
+		goto err_udc_clk;
+	}
 
 	/* irq setup after old hardware state is cleaned up */
 	retval = request_irq(irq_usbd, s3c2410_udc_irq,
-- 
2.30.2



