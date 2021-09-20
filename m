Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC987411AA8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhITQux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244343AbhITQuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A9936127A;
        Mon, 20 Sep 2021 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156519;
        bh=BEdHrqnaRumpSH1/KUdNA/axJLqGlsErWO+bLDxSrxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RveQDywjkYIhOYflohE+WaJKJjAOKOnZ1wvnSMrqMvLn/HE/DUPSw/IGM/tlmckNb
         vOwFhzdIDSoOS670YAWnjjJmPp0x/kOkf0qysMiMN/U933jlV88j8F65npddJg9BUE
         cT512TcRPAt2nu6nDAOcdLXXbpgDq9yu86x1ujPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 055/133] usb: phy: tahvo: add IRQ check
Date:   Mon, 20 Sep 2021 18:42:13 +0200
Message-Id: <20210920163914.447595907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 0d45a1373e669880b8beaecc8765f44cb0241e47 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to request_threaded_irq() (which
takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding an
original error code.  Stop calling request_threaded_irq() with the invalid
IRQ #s.

Fixes: 9ba96ae5074c ("usb: omap1: Tahvo USB transceiver driver")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/8280d6a4-8e9a-7cfe-1aa9-db586dc9afdf@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-tahvo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index 335a1ef35224..ec86eedd789b 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -404,7 +404,9 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, tu);
 
-	tu->irq = platform_get_irq(pdev, 0);
+	tu->irq = ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
 	ret = request_threaded_irq(tu->irq, NULL, tahvo_usb_vbus_interrupt,
 				   IRQF_ONESHOT,
 				   "tahvo-vbus", tu);
-- 
2.30.2



