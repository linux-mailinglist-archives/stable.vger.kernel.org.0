Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0733E8157
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhHJR6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237041AbhHJR4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 963006137F;
        Tue, 10 Aug 2021 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617515;
        bh=2Y3Qp3G5mENTpc2REOidP74dQvh1947DMC9bw/PxA+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tybUmUyaB85XAo3unIMfRFJxZcfQhompnWqniOyViSVTbfRHM2xj71+W4ZcMJkYh1
         il3koR5J0/Xw1bYi5zw0UdXXA7z2CVIEzbBfCrAKpx2Uz6vvayMZ8tBfn3+ymxlwF/
         RImSZUkej/EShK4l426XUnvwpq0QrRdWrRcWzj2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 5.13 091/175] usb: gadget: remove leaked entry from udc driver list
Date:   Tue, 10 Aug 2021 19:29:59 +0200
Message-Id: <20210810173003.945438751@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

commit fa4a8dcfd51b911f101ebc461dfe22230b74dd64 upstream.

The usb_add_gadget_udc will add a new gadget to the udc class
driver list. Not calling usb_del_gadget_udc in error branch
will result in residual gadget entry in the udc driver list.
We fix it by calling usb_del_gadget_udc to clean it when error
return.

Fixes: 48ba02b2e2b1 ("usb: gadget: add udc driver for max3420")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20210727073142.84666-1-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/max3420_udc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/max3420_udc.c
+++ b/drivers/usb/gadget/udc/max3420_udc.c
@@ -1260,12 +1260,14 @@ static int max3420_probe(struct spi_devi
 	err = devm_request_irq(&spi->dev, irq, max3420_irq_handler, 0,
 			       "max3420", udc);
 	if (err < 0)
-		return err;
+		goto del_gadget;
 
 	udc->thread_task = kthread_create(max3420_thread, udc,
 					  "max3420-thread");
-	if (IS_ERR(udc->thread_task))
-		return PTR_ERR(udc->thread_task);
+	if (IS_ERR(udc->thread_task)) {
+		err = PTR_ERR(udc->thread_task);
+		goto del_gadget;
+	}
 
 	irq = of_irq_get_byname(spi->dev.of_node, "vbus");
 	if (irq <= 0) { /* no vbus irq implies self-powered design */
@@ -1285,10 +1287,14 @@ static int max3420_probe(struct spi_devi
 		err = devm_request_irq(&spi->dev, irq,
 				       max3420_vbus_handler, 0, "vbus", udc);
 		if (err < 0)
-			return err;
+			goto del_gadget;
 	}
 
 	return 0;
+
+del_gadget:
+	usb_del_gadget_udc(&udc->gadget);
+	return err;
 }
 
 static int max3420_remove(struct spi_device *spi)


