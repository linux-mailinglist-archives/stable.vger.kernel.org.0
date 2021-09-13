Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D840922C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbhIMOIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343710AbhIMOGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:06:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B78AF61A6F;
        Mon, 13 Sep 2021 13:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540405;
        bh=xWzOSUC3nB4FNyqD6n8KAzMIGWPa7Q6zrHX4Mng4a14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIBPSuI0fjT+GSfv1/FHgc7s3fFDpwCJd25tvQKYsWpqobz/HiU5KXF2n0iDowQf2
         QkI1PHj2zyG0ymObIRCYdszJK5DQ5a+so0CRYCJTNNhXuOeCKD2JzANhm1rbNYpMD1
         0m3NmfPNyElvtbU9bRzpDgyGBU4PmcbP7fpz2yw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 179/300] usb: dwc3: meson-g12a: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:00 +0200
Message-Id: <20210913131115.445726570@linuxfoundation.org>
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

[ Upstream commit baa2986bda3f7b2386607587a4185e3dff8f98df ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_threaded_irq()
(which takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code. Stop calling devm_request_threaded_irq() with the
invalid IRQ #s.

Fixes: f90db10779ad ("usb: dwc3: meson-g12a: Add support for IRQ based OTG switching")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/96106462-5538-0b2f-f2ab-ee56e4853912@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index ffe301d6ea35..d0f9b7c296b0 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -598,6 +598,8 @@ static int dwc3_meson_g12a_otg_init(struct platform_device *pdev,
 				   USB_R5_ID_DIG_IRQ, 0);
 
 		irq = platform_get_irq(pdev, 0);
+		if (irq < 0)
+			return irq;
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						dwc3_meson_g12a_irq_thread,
 						IRQF_ONESHOT, pdev->name, priv);
-- 
2.30.2



