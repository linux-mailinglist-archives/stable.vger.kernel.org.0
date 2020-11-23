Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645AB2C06D4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbgKWMet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbgKWMes (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5046720857;
        Mon, 23 Nov 2020 12:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134887;
        bh=oWESSb/KESHk/7RZ6Qu/BgrRa8Q1K148M9X3dlhSkyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGgh0OvYgN0DjDR8MSF25tVFei7NHRGp5qQyrf0WFni+5KPLB4vEprFNFOzojqBeT
         9RCHzKYZg5EbMhvp6GSGsib6p3XbXzSIuVegW7osXtwKm0/o0MyVpy64xDjJCrQyQG
         0ZcyOHe3E9hMljDQnieD7bxgPvvNNnAA8I4e4MN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <thesven73@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 009/158] lan743x: prevent entire kernel HANG on open, for some platforms
Date:   Mon, 23 Nov 2020 13:20:37 +0100
Message-Id: <20201123121820.388363311@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 796a2665ca3e91ebaba7222f76fd9a035714e2d8 ]

On arm imx6, when opening the chip's netdev, the whole Linux
kernel intermittently hangs/freezes.

This is caused by a bug in the driver code which tests if pcie
interrupts are working correctly, using the software interrupt:

1. open: enable the software interrupt
2. open: tell the chip to assert the software interrupt
3. open: wait for flag
4. ISR: acknowledge s/w interrupt, set flag
5. open: notice flag, disable the s/w interrupt, continue

Unfortunately the ISR only acknowledges the s/w interrupt, but
does not disable it. This will re-trigger the ISR in a tight
loop.

On some (lucky) platforms, open proceeds to disable the s/w
interrupt even while the ISR is 'spinning'. On arm imx6,
the spinning ISR does not allow open to proceed, resulting
in a hung Linux kernel.

Fix minimally by disabling the s/w interrupt in the ISR, which
will prevent it from spinning. This won't break anything because
the s/w interrupt is used as a one-shot interrupt.

Note that this is a minimal fix, overlooking many possible
cleanups, e.g.:
- lan743x_intr_software_isr() is completely redundant and reads
  INT_STS twice for no apparent reason
- disabling the s/w interrupt in lan743x_intr_test_isr() is now
  redundant, but harmless
- waiting on software_isr_flag can be converted from a sleeping
  poll loop to wait_event_timeout()

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # arm imx6 lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Link: https://lore.kernel.org/r/20201112204741.12375-1-TheSven73@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -145,7 +145,8 @@ static void lan743x_intr_software_isr(vo
 
 	int_sts = lan743x_csr_read(adapter, INT_STS);
 	if (int_sts & INT_BIT_SW_GP_) {
-		lan743x_csr_write(adapter, INT_STS, INT_BIT_SW_GP_);
+		/* disable the interrupt to prevent repeated re-triggering */
+		lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_SW_GP_);
 		intr->software_isr_flag = 1;
 	}
 }


