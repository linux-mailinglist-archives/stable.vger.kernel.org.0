Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE0A409229
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344067AbhIMOIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245219AbhIMOGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:06:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2F2461A79;
        Mon, 13 Sep 2021 13:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540414;
        bh=jtgoBIX27zlNb/u9W6fYZxseeXTsFRaB5+H2GQJiUMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpJRl8O1dgvFzeagVWAsd+zYroCE7Fcpy0Yy8/gblzcNBWTITaUR9AnKJyPtfW9lG
         qeNBUPyHrPfva2mcToIrTbSOmaR9oWVQZnH8wk0bnMgHuVRkLqFoKvaHY4graX+yVH
         wZDNBa1ifPINdhtrTp+YcRr/SIdRrnjluLJ0oBSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 183/300] usb: misc: brcmstb-usb-pinmap: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:04 +0200
Message-Id: <20210913131115.573225139@linuxfoundation.org>
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

[ Upstream commit 711087f342914e831269438ff42cf59bb0142c71 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding an original
error code.  Stop calling devm_request_irq() with the invalid IRQ #s.

Fixes: 517c4c44b323 ("usb: Add driver to allow any GPIO to be used for 7211 USB signals")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/806d0b1a-365b-93d9-3fc1-922105ca5e61@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/brcmstb-usb-pinmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/misc/brcmstb-usb-pinmap.c b/drivers/usb/misc/brcmstb-usb-pinmap.c
index 336653091e3b..2b2019c19cde 100644
--- a/drivers/usb/misc/brcmstb-usb-pinmap.c
+++ b/drivers/usb/misc/brcmstb-usb-pinmap.c
@@ -293,6 +293,8 @@ static int __init brcmstb_usb_pinmap_probe(struct platform_device *pdev)
 
 		/* Enable interrupt for out pins */
 		irq = platform_get_irq(pdev, 0);
+		if (irq < 0)
+			return irq;
 		err = devm_request_irq(&pdev->dev, irq,
 				       brcmstb_usb_pinmap_ovr_isr,
 				       IRQF_TRIGGER_RISING,
-- 
2.30.2



