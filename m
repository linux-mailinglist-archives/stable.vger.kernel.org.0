Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B638A17F0CA
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 07:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCJG7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 02:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgCJG7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 02:59:42 -0400
Received: from localhost.localdomain (unknown [180.171.74.255])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E20A2467C;
        Tue, 10 Mar 2020 06:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583823582;
        bh=cmbgetZfb6P+3CdH0q8rIWefP0yljF8X4Bt3d4dAjCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2P5OD7b8gjsTNi5sZjdMR0Ih/opDfViJrh9b5F0LfuOCUFdpD6rJfplp88aClsjt
         X/YQUWfu1/V7M+BJG+9GrGJSS+YwzUK3/ByR1brMlprTAPGxtyDZdcvkMwapBTjjuO
         LzZBspAmactf8uA/OzwcDtvyBjoG+m23J59mYAb4=
From:   Peter Chen <peter.chen@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] usb: chipidea: udc: fix sleeping function called from invalid context
Date:   Tue, 10 Mar 2020 14:59:26 +0800
Message-Id: <20200310065926.17746-2-peter.chen@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310065926.17746-1-peter.chen@kernel.org>
References: <20200310065926.17746-1-peter.chen@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

The code calls pm_runtime_get_sync with irq disabled, it causes below
warning:

BUG: sleeping function called from invalid context at
wer/runtime.c:1075
in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid:
er/u8:1
CPU: 1 PID: 37 Comm: kworker/u8:1 Not tainted
20200304-00181-gbebfd2a5be98 #1588
Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
Workqueue: ci_otg ci_otg_work
[<c010e8bd>] (unwind_backtrace) from [<c010a315>]
1/0x14)
[<c010a315>] (show_stack) from [<c0987d29>]
5/0x94)
[<c0987d29>] (dump_stack) from [<c013e77f>]
+0xeb/0x118)
[<c013e77f>] (___might_sleep) from [<c052fa1d>]
esume+0x75/0x78)
[<c052fa1d>] (__pm_runtime_resume) from [<c0627a33>]
0x23/0x74)
[<c0627a33>] (ci_udc_pullup) from [<c062fb93>]
nect+0x2b/0xcc)
[<c062fb93>] (usb_gadget_connect) from [<c062769d>]
_connect+0x59/0x104)
[<c062769d>] (ci_hdrc_gadget_connect) from [<c062778b>]
ssion+0x43/0x48)
[<c062778b>] (ci_udc_vbus_session) from [<c062f997>]
s_connect+0x17/0x9c)
[<c062f997>] (usb_gadget_vbus_connect) from [<c062634d>]
bd/0x128)
[<c062634d>] (ci_otg_work) from [<c0134719>]
rk+0x149/0x404)
[<c0134719>] (process_one_work) from [<c0134acb>]
0xf7/0x3bc)
[<c0134acb>] (worker_thread) from [<c0139433>]
x118)
[<c0139433>] (kthread) from [<c01010bd>]
(ret_from_fork+0x11/0x34)

Tested-by: Dmitry Osipenko <digetx@gmail.com>
Cc: <stable@vger.kernel.org> #v5.5
Fixes: 72dc8df7920f ("usb: chipidea: udc: protect usb interrupt enable")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/chipidea/udc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index ffaf46f5d062..1fa587ec52fc 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1539,9 +1539,11 @@ static void ci_hdrc_gadget_connect(struct usb_gadget *_gadget, int is_active)
 		if (ci->driver) {
 			hw_device_state(ci, ci->ep0out->qh.dma);
 			usb_gadget_set_state(_gadget, USB_STATE_POWERED);
+			spin_unlock_irqrestore(&ci->lock, flags);
 			usb_udc_vbus_handler(_gadget, true);
+		} else {
+			spin_unlock_irqrestore(&ci->lock, flags);
 		}
-		spin_unlock_irqrestore(&ci->lock, flags);
 	} else {
 		usb_udc_vbus_handler(_gadget, false);
 		if (ci->driver)
-- 
2.17.1

