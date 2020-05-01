Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87151C16B0
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgEANv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731032AbgEANiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:38:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8E92173E;
        Fri,  1 May 2020 13:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340284;
        bh=XcghBDSwiZLVwlHGU2MXLCquDLWZS7gj+r5HQZeJ6rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs1LManOGtHWyLySVOt92ix/Kha3LGOAlINoIQLStk36PEH2IHnSfel1L068lxHG3
         jz2/VJ0XTJVdt3cDJ7HkYvIgp8OkQuG9bila8Lto78mJb1wK3O3C876w/TUY9BtKm0
         6zAbsVLhvmOosTZluN58ip3e/y/+E7xRs/CHPZ8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 08/83] usb: gadget: udc: atmel: Fix vbus disconnect handling
Date:   Fri,  1 May 2020 15:22:47 +0200
Message-Id: <20200501131525.999344083@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

commit 12b94da411f9c6d950beb067d913024fd5617a61 upstream.

A DMA transfer can be in progress while vbus is lost due to a cable
disconnect. For endpoints that use DMA, this condition can lead to
peripheral hang. The patch ensures that endpoints are disabled before
the clocks are stopped to prevent this issue.

Fixes: a64ef71ddc13 ("usb: gadget: atmel_usba_udc: condition clocks to vbus state")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/atmel_usba_udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -1950,10 +1950,10 @@ static irqreturn_t usba_vbus_irq_thread(
 			usba_start(udc);
 		} else {
 			udc->suspended = false;
-			usba_stop(udc);
-
 			if (udc->driver->disconnect)
 				udc->driver->disconnect(&udc->gadget);
+
+			usba_stop(udc);
 		}
 		udc->vbus_prev = vbus;
 	}


