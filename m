Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF68E411BAD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345095AbhITRB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344651AbhITQ70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:59:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2BB861268;
        Mon, 20 Sep 2021 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156746;
        bh=RfbUyVdgSWGh8UzBjgpM78qUWJju/apyLKq6voc5Q9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMSrJfe68nDvjyqMd6oO1CtDlY1XZppXpLwfGz1xvnobq5aAYgI2sYllNjM3HiBb9
         ME8dGiEqBZhSfNkXrRVg7B+RcwVlkd5M8ftyWOha4wSlM5lD8iqQh9+m8RWOzrY2Go
         aMpjS87xw8g7Scg8OpXEFdT0iE6g0o93PQAJvuKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/175] usb: gadget: udc: at91: add IRQ check
Date:   Mon, 20 Sep 2021 18:41:54 +0200
Message-Id: <20210920163920.179409326@linuxfoundation.org>
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

[ Upstream commit 50855c31573b02963f0aa2aacfd4ea41c31ae0e0 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_irq() (which takes
*unsigned* IRQ #), causing it to fail with -EINVAL, overriding an original
error code. Stop calling devm_request_irq() with the invalid IRQ #s.

Fixes: 8b2e76687b39 ("USB: AT91 UDC updates, mostly power management")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Acked-by: Felipe Balbi <balbi@kernel.org>
Link: https://lore.kernel.org/r/6654a224-739a-1a80-12f0-76d920f87b6c@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/at91_udc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index 8bc78418d40e..cd92cda03d71 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1895,7 +1895,9 @@ static int at91udc_probe(struct platform_device *pdev)
 	clk_disable(udc->iclk);
 
 	/* request UDC and maybe VBUS irqs */
-	udc->udp_irq = platform_get_irq(pdev, 0);
+	udc->udp_irq = retval = platform_get_irq(pdev, 0);
+	if (retval < 0)
+		goto err_unprepare_iclk;
 	retval = devm_request_irq(dev, udc->udp_irq, at91_udc_irq, 0,
 				  driver_name, udc);
 	if (retval) {
-- 
2.30.2



