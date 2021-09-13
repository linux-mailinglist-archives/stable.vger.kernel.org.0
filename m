Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AD40924E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245064AbhIMOKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344158AbhIMOIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D0961283;
        Mon, 13 Sep 2021 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540457;
        bh=d9tOvY4GPK1jKWMaBSPHaYQUFYgLGzNJbCmnl5KHBLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKGTPzNlgHxxJQdbl8EfZpKyUT8xqmM2Q9tEZI9dtEWpcneX8xHj5xL0rodtmZ1/A
         e8AzlMiGNUyIG5duEWk5ln8f/hipVU6TEy9LmpLmFDldmn/RqJfSyTe7w/wAzkO1Y3
         p/N5CFyMRnPbDPeU/pO3/DVNJjXJdIEVpNL7GFEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 194/300] usb: phy: tahvo: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:15 +0200
Message-Id: <20210913131115.933994984@linuxfoundation.org>
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
index baebb1f5a973..a3e043e3e4aa 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -393,7 +393,9 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 
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



