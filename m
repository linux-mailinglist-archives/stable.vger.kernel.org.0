Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4FF409232
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344489AbhIMOJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343995AbhIMOHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDDC361A70;
        Mon, 13 Sep 2021 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540416;
        bh=pjnJCroe+DxkfKrNgNYoolpkciWNle+1P5sU88pqt/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhlsrmOvU5rhsNKOQ56k5mQuEkh9kJKSmF7MLCNDaIApnx1ZnlUmjHNlbANAd2X1N
         Q/JWB9bAvYCYPhRSpBYKXJ4kTqviJNC3muIvJYEpOSPot56bd7UPjrNfiOMKsBnGQx
         b3ZbsOsDZ3syXtSQJN3tRe9R1rfOWUvSfAkbWIQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 184/300] usb: phy: fsl-usb: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:05 +0200
Message-Id: <20210913131115.609657153@linuxfoundation.org>
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

[ Upstream commit ecc2f30dbb25969908115c81ec23650ed982b004 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding an original
error code. Stop calling request_irq() with the invalid IRQ #s.

Fixes: 0807c500a1a6 ("USB: add Freescale USB OTG Transceiver driver")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/b0a86089-8b8b-122e-fd6d-73e8c2304964@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-fsl-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index f34c9437a182..972704262b02 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -873,6 +873,8 @@ int usb_otg_start(struct platform_device *pdev)
 
 	/* request irq */
 	p_otg->irq = platform_get_irq(pdev, 0);
+	if (p_otg->irq < 0)
+		return p_otg->irq;
 	status = request_irq(p_otg->irq, fsl_otg_isr,
 				IRQF_SHARED, driver_name, p_otg);
 	if (status) {
-- 
2.30.2



