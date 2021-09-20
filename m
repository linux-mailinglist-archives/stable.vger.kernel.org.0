Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FC3411BB1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245548AbhITRBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344784AbhITQ7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BFC6135A;
        Mon, 20 Sep 2021 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156748;
        bh=zatE2GZab1SjxDk+v63GhnraWQW1H2qJWrJ07zY+gY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXNvrnze9xA+tThOCUfaW5xvpJSmVbLuGWmkYtRJgd+G2S651C8cI1YKrVPNj7EcF
         q+zcz7NdpW9680OympA67eVvqxpJgb/o9B0/ueZGQXkeuoduu9NBAhKpZRS9h25iRi
         XNMkHYBzNuKPLJ+7zPEh0Kqe6yN6zR3CPYQOj4kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 066/175] usb: phy: fsl-usb: add IRQ check
Date:   Mon, 20 Sep 2021 18:41:55 +0200
Message-Id: <20210920163920.220302446@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index 85d031ce85c1..63798de8b5ae 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -891,6 +891,8 @@ int usb_otg_start(struct platform_device *pdev)
 
 	/* request irq */
 	p_otg->irq = platform_get_irq(pdev, 0);
+	if (p_otg->irq < 0)
+		return p_otg->irq;
 	status = request_irq(p_otg->irq, fsl_otg_isr,
 				IRQF_SHARED, driver_name, p_otg);
 	if (status) {
-- 
2.30.2



