Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5F6411F4F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348604AbhITRkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348446AbhITRic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C4CD61B42;
        Mon, 20 Sep 2021 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157637;
        bh=s21Gqzn3SpMIJqHSOPjkIuGzU0rms9xC53o8jFzRMfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2cHEn1vU4uxhZv96C0h3smjsgTBoyui1D3eWcv0e/0wS3Pw+FrQhyID9Sh+vBUJ5
         OhEbJursQM8GiJwB7Nszdqwfo5JXVSV8O6p/zrfeTkoIY+fs88aTODTkUQmqby6yj3
         /oO0oYxLXbsVoyQjsUSdoQGlIwKsI0AUyOAJNSvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/293] usb: phy: twl6030: add IRQ checks
Date:   Mon, 20 Sep 2021 18:40:45 +0200
Message-Id: <20210920163936.103586686@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 0881e22c06e66af0b64773c91c8868ead3d01aa1 ]

The driver neglects to check the result of platform_get_irq()'s calls and
blithely passes the negative error codes to request_threaded_irq() (which
takes *unsigned* IRQ #), causing them both to fail with -EINVAL, overriding
an original error code.  Stop calling request_threaded_irq() with the
invalid IRQ #s.

Fixes: c33fad0c3748 ("usb: otg: Adding twl6030-usb transceiver driver for OMAP4430")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/9507f50b-50f1-6dc4-f57c-3ed4e53a1c25@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index dade34d70419..859af6113b45 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -342,6 +342,11 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 	twl->irq2		= platform_get_irq(pdev, 1);
 	twl->linkstat		= MUSB_UNKNOWN;
 
+	if (twl->irq1 < 0)
+		return twl->irq1;
+	if (twl->irq2 < 0)
+		return twl->irq2;
+
 	twl->comparator.set_vbus	= twl6030_set_vbus;
 	twl->comparator.start_srp	= twl6030_start_srp;
 
-- 
2.30.2



