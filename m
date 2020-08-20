Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA4524BE4A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgHTNXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgHTJeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ACFF22BF5;
        Thu, 20 Aug 2020 09:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916010;
        bh=cFSsyY+N9kTR0Cd7a0UjjTB3fTM2An8IueZiXLqrQhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzmsXp4V+oqsi2JxURJPUnqRVKacd8JAX3eMEp4VMT5E7WU9MT+vCkHzB0uPkXqIl
         /go66YuWSnbz4PMLU94eRoPjjdgyoZhCVU6ScCrnOsN0+tpoXPre192X1MHVdu8HnE
         mSWa6C2xqs7Eq6WrhU48GDM5z4H5U6YWiQPDigd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 212/232] mfd: dln2: Run event handler loop under spinlock
Date:   Thu, 20 Aug 2020 11:21:03 +0200
Message-Id: <20200820091623.075137583@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3d858942250820b9adc35f963a257481d6d4c81d ]

The event handler loop must be run with interrupts disabled.
Otherwise we will have a warning:

[ 1970.785649] irq 31 handler lineevent_irq_handler+0x0/0x20 enabled interrupts
[ 1970.792739] WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:159 __handle_irq_event_percpu+0x162/0x170
[ 1970.860732] RIP: 0010:__handle_irq_event_percpu+0x162/0x170
...
[ 1970.946994] Call Trace:
[ 1970.949446]  <IRQ>
[ 1970.951471]  handle_irq_event_percpu+0x2c/0x80
[ 1970.955921]  handle_irq_event+0x23/0x43
[ 1970.959766]  handle_simple_irq+0x57/0x70
[ 1970.963695]  generic_handle_irq+0x42/0x50
[ 1970.967717]  dln2_rx+0xc1/0x210 [dln2]
[ 1970.971479]  ? usb_hcd_unmap_urb_for_dma+0xa6/0x1c0
[ 1970.976362]  __usb_hcd_giveback_urb+0x77/0xe0
[ 1970.980727]  usb_giveback_urb_bh+0x8e/0xe0
[ 1970.984837]  tasklet_action_common.isra.0+0x4a/0xe0
...

Recently xHCI driver switched to tasklets in the commit 36dc01657b49
("usb: host: xhci: Support running urb giveback in tasklet context").

The handle_irq_event_* functions are expected to be called with interrupts
disabled and they rightfully complain here because we run in tasklet context
with interrupts enabled.

Use a event spinlock to protect event handler from being interrupted.

Note, that there are only two users of this GPIO and ADC drivers and both of
them are using generic_handle_irq() which makes above happen.

Fixes: 338a12814297 ("mfd: Add support for Diolan DLN-2 devices")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/dln2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 39276fa626d2b..83e676a096dc1 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -287,7 +287,11 @@ static void dln2_rx(struct urb *urb)
 	len = urb->actual_length - sizeof(struct dln2_header);
 
 	if (handle == DLN2_HANDLE_EVENT) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&dln2->event_cb_lock, flags);
 		dln2_run_event_callbacks(dln2, id, echo, data, len);
+		spin_unlock_irqrestore(&dln2->event_cb_lock, flags);
 	} else {
 		/* URB will be re-submitted in _dln2_transfer (free_rx_slot) */
 		if (dln2_transfer_complete(dln2, urb, handle, echo))
-- 
2.25.1



