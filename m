Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1F040925F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343977AbhIMOLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244029AbhIMOJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC10A613D1;
        Mon, 13 Sep 2021 13:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540472;
        bh=dD3fqUeojFwl4DrUD/xsbfGqy5wqRmYiptQoXo5SqX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXAW3+9pxZqOvlPNXlVkQotE0glLDjFY+j8AnTLbMZk7AKP9LWYuqvCpKsMYYsmsi
         zluJC7NNFJ4NAu9nFlapmnTTnNLRuT6vZ03ZE6BBKxvb8+pRbOlJPGwnP+56+ADAhm
         Bh1090forbxLSyAalc5Zjyf4r+AhjIdiiNRa8kUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 208/300] usb: gadget: mv_u3d: request_irq() after initializing UDC
Date:   Mon, 13 Sep 2021 15:14:29 +0200
Message-Id: <20210913131116.394844439@linuxfoundation.org>
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

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit 2af0c5ffadaf9d13eca28409d4238b4e672942d3 ]

If IRQ occurs between calling  request_irq() and  mv_u3d_eps_init(),
then null pointer dereference occurs since u3d->eps[] wasn't
initialized yet but used in mv_u3d_nuke().

The patch puts registration of the interrupt handler after
initializing of neccesery data.

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: 90fccb529d24 ("usb: gadget: Gadget directory cleanup - group UDC drivers")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Link: https://lore.kernel.org/r/20210818141247.4794-1-lutovinova@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/mv_u3d_core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/udc/mv_u3d_core.c b/drivers/usb/gadget/udc/mv_u3d_core.c
index 5486f5a70868..0db97fecf99e 100644
--- a/drivers/usb/gadget/udc/mv_u3d_core.c
+++ b/drivers/usb/gadget/udc/mv_u3d_core.c
@@ -1921,14 +1921,6 @@ static int mv_u3d_probe(struct platform_device *dev)
 		goto err_get_irq;
 	}
 	u3d->irq = r->start;
-	if (request_irq(u3d->irq, mv_u3d_irq,
-		IRQF_SHARED, driver_name, u3d)) {
-		u3d->irq = 0;
-		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
-			u3d->irq);
-		retval = -ENODEV;
-		goto err_request_irq;
-	}
 
 	/* initialize gadget structure */
 	u3d->gadget.ops = &mv_u3d_ops;	/* usb_gadget_ops */
@@ -1941,6 +1933,15 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 	mv_u3d_eps_init(u3d);
 
+	if (request_irq(u3d->irq, mv_u3d_irq,
+		IRQF_SHARED, driver_name, u3d)) {
+		u3d->irq = 0;
+		dev_err(&dev->dev, "Request irq %d for u3d failed\n",
+			u3d->irq);
+		retval = -ENODEV;
+		goto err_request_irq;
+	}
+
 	/* external vbus detection */
 	if (u3d->vbus) {
 		u3d->clock_gating = 1;
@@ -1964,8 +1965,8 @@ static int mv_u3d_probe(struct platform_device *dev)
 
 err_unregister:
 	free_irq(u3d->irq, u3d);
-err_request_irq:
 err_get_irq:
+err_request_irq:
 	kfree(u3d->status_req);
 err_alloc_status_req:
 	kfree(u3d->eps);
-- 
2.30.2



