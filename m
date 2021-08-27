Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420E63F9568
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 09:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244488AbhH0HuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 03:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244489AbhH0HuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 03:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7141B60F92;
        Fri, 27 Aug 2021 07:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630050553;
        bh=JV+TXXI6JdR6mSTcz97m+0giSdzwiDz6DFtHGvS9sr4=;
        h=Subject:To:From:Date:From;
        b=plbCpSoMQU/pAjkbUviQorjOWRTkXzQnnqKEX1jOlIsI2cl+ycofCZ6ZNjT1lDYWA
         vRBGvFIOkYB3L7PK7p+PZcAhY9g23dXdJbkE2S965fHmpQHVFQK4H8n97mV4UmMnq5
         jUSwZebNlpFotJx0nNY0ZuoPqMGOsk2AzwpbQA5M=
Subject: patch "xhci: fix even more unsafe memory usage in xhci tracing" added to usb-next
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Aug 2021 09:40:58 +0200
Message-ID: <1630050058122235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: fix even more unsafe memory usage in xhci tracing

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 4843b4b5ec64b875a5e334f280508f1f75e7d3e4 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 20 Aug 2021 15:34:59 +0300
Subject: xhci: fix even more unsafe memory usage in xhci tracing

Removes static char buffer usage in the following decode functions:
	xhci_decode_ctrl_ctx()
	xhci_decode_slot_context()
	xhci_decode_usbsts()
	xhci_decode_doorbell()
	xhci_decode_ep_context()

Caller must provide a buffer to use.
In tracing use __get_str() as recommended to pass buffer.

Minor changes are needed in other xhci code as these functions are also
used elsewhere

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210820123503.2605901-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-debugfs.c |  8 ++++++--
 drivers/usb/host/xhci-ring.c    |  3 ++-
 drivers/usb/host/xhci-trace.h   | 18 +++++++++++-------
 drivers/usb/host/xhci.h         | 21 ++++++++-------------
 4 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index 85c12f56b17c..dc832ddf7033 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -261,11 +261,13 @@ static int xhci_slot_context_show(struct seq_file *s, void *unused)
 	struct xhci_slot_ctx	*slot_ctx;
 	struct xhci_slot_priv	*priv = s->private;
 	struct xhci_virt_device	*dev = priv->dev;
+	char			str[XHCI_MSG_MAX];
 
 	xhci = hcd_to_xhci(bus_to_hcd(dev->udev->bus));
 	slot_ctx = xhci_get_slot_ctx(xhci, dev->out_ctx);
 	seq_printf(s, "%pad: %s\n", &dev->out_ctx->dma,
-		   xhci_decode_slot_context(le32_to_cpu(slot_ctx->dev_info),
+		   xhci_decode_slot_context(str,
+					    le32_to_cpu(slot_ctx->dev_info),
 					    le32_to_cpu(slot_ctx->dev_info2),
 					    le32_to_cpu(slot_ctx->tt_info),
 					    le32_to_cpu(slot_ctx->dev_state)));
@@ -281,6 +283,7 @@ static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 	struct xhci_ep_ctx	*ep_ctx;
 	struct xhci_slot_priv	*priv = s->private;
 	struct xhci_virt_device	*dev = priv->dev;
+	char			str[XHCI_MSG_MAX];
 
 	xhci = hcd_to_xhci(bus_to_hcd(dev->udev->bus));
 
@@ -288,7 +291,8 @@ static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 		ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
 		dma = dev->out_ctx->dma + (ep_index + 1) * CTX_SIZE(xhci->hcc_params);
 		seq_printf(s, "%pad: %s\n", &dma,
-			   xhci_decode_ep_context(le32_to_cpu(ep_ctx->ep_info),
+			   xhci_decode_ep_context(str,
+						  le32_to_cpu(ep_ctx->ep_info),
 						  le32_to_cpu(ep_ctx->ep_info2),
 						  le64_to_cpu(ep_ctx->deq),
 						  le32_to_cpu(ep_ctx->tx_info)));
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8fea44bbc266..d0faa67a689d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1212,6 +1212,7 @@ void xhci_stop_endpoint_command_watchdog(struct timer_list *t)
 	struct xhci_hcd *xhci = ep->xhci;
 	unsigned long flags;
 	u32 usbsts;
+	char str[XHCI_MSG_MAX];
 
 	spin_lock_irqsave(&xhci->lock, flags);
 
@@ -1225,7 +1226,7 @@ void xhci_stop_endpoint_command_watchdog(struct timer_list *t)
 	usbsts = readl(&xhci->op_regs->status);
 
 	xhci_warn(xhci, "xHCI host not responding to stop endpoint command.\n");
-	xhci_warn(xhci, "USBSTS:%s\n", xhci_decode_usbsts(usbsts));
+	xhci_warn(xhci, "USBSTS:%s\n", xhci_decode_usbsts(str, usbsts));
 
 	ep->ep_state &= ~EP_STOP_CMD_PENDING;
 
diff --git a/drivers/usb/host/xhci-trace.h b/drivers/usb/host/xhci-trace.h
index 5e1c50cb7016..a5da02077297 100644
--- a/drivers/usb/host/xhci-trace.h
+++ b/drivers/usb/host/xhci-trace.h
@@ -322,6 +322,7 @@ DECLARE_EVENT_CLASS(xhci_log_ep_ctx,
 		__field(u32, info2)
 		__field(u64, deq)
 		__field(u32, tx_info)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->info = le32_to_cpu(ctx->ep_info);
@@ -329,8 +330,8 @@ DECLARE_EVENT_CLASS(xhci_log_ep_ctx,
 		__entry->deq = le64_to_cpu(ctx->deq);
 		__entry->tx_info = le32_to_cpu(ctx->tx_info);
 	),
-	TP_printk("%s", xhci_decode_ep_context(__entry->info,
-		__entry->info2, __entry->deq, __entry->tx_info)
+	TP_printk("%s", xhci_decode_ep_context(__get_str(str),
+		__entry->info, __entry->info2, __entry->deq, __entry->tx_info)
 	)
 );
 
@@ -367,6 +368,7 @@ DECLARE_EVENT_CLASS(xhci_log_slot_ctx,
 		__field(u32, info2)
 		__field(u32, tt_info)
 		__field(u32, state)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->info = le32_to_cpu(ctx->dev_info);
@@ -374,9 +376,9 @@ DECLARE_EVENT_CLASS(xhci_log_slot_ctx,
 		__entry->tt_info = le64_to_cpu(ctx->tt_info);
 		__entry->state = le32_to_cpu(ctx->dev_state);
 	),
-	TP_printk("%s", xhci_decode_slot_context(__entry->info,
-			__entry->info2, __entry->tt_info,
-			__entry->state)
+	TP_printk("%s", xhci_decode_slot_context(__get_str(str),
+			__entry->info, __entry->info2,
+			__entry->tt_info, __entry->state)
 	)
 );
 
@@ -431,12 +433,13 @@ DECLARE_EVENT_CLASS(xhci_log_ctrl_ctx,
 	TP_STRUCT__entry(
 		__field(u32, drop)
 		__field(u32, add)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->drop = le32_to_cpu(ctrl_ctx->drop_flags);
 		__entry->add = le32_to_cpu(ctrl_ctx->add_flags);
 	),
-	TP_printk("%s", xhci_decode_ctrl_ctx(__entry->drop, __entry->add)
+	TP_printk("%s", xhci_decode_ctrl_ctx(__get_str(str), __entry->drop, __entry->add)
 	)
 );
 
@@ -555,13 +558,14 @@ DECLARE_EVENT_CLASS(xhci_log_doorbell,
 	TP_STRUCT__entry(
 		__field(u32, slot)
 		__field(u32, doorbell)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->slot = slot;
 		__entry->doorbell = doorbell;
 	),
 	TP_printk("Ring doorbell for %s",
-		xhci_decode_doorbell(__entry->slot, __entry->doorbell)
+		  xhci_decode_doorbell(__get_str(str), __entry->slot, __entry->doorbell)
 	)
 );
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 99ae9994f5eb..dca6181c33fd 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2460,10 +2460,9 @@ static inline const char *xhci_decode_trb(char *str, size_t size,
 	return str;
 }
 
-static inline const char *xhci_decode_ctrl_ctx(unsigned long drop,
-					       unsigned long add)
+static inline const char *xhci_decode_ctrl_ctx(char *str,
+		unsigned long drop, unsigned long add)
 {
-	static char	str[1024];
 	unsigned int	bit;
 	int		ret = 0;
 
@@ -2489,10 +2488,9 @@ static inline const char *xhci_decode_ctrl_ctx(unsigned long drop,
 	return str;
 }
 
-static inline const char *xhci_decode_slot_context(u32 info, u32 info2,
-		u32 tt_info, u32 state)
+static inline const char *xhci_decode_slot_context(char *str,
+		u32 info, u32 info2, u32 tt_info, u32 state)
 {
-	static char str[1024];
 	u32 speed;
 	u32 hub;
 	u32 mtt;
@@ -2621,9 +2619,8 @@ static inline const char *xhci_decode_portsc(char *str, u32 portsc)
 	return str;
 }
 
-static inline const char *xhci_decode_usbsts(u32 usbsts)
+static inline const char *xhci_decode_usbsts(char *str, u32 usbsts)
 {
-	static char str[256];
 	int ret = 0;
 
 	if (usbsts == ~(u32)0)
@@ -2650,9 +2647,8 @@ static inline const char *xhci_decode_usbsts(u32 usbsts)
 	return str;
 }
 
-static inline const char *xhci_decode_doorbell(u32 slot, u32 doorbell)
+static inline const char *xhci_decode_doorbell(char *str, u32 slot, u32 doorbell)
 {
-	static char str[256];
 	u8 ep;
 	u16 stream;
 	int ret;
@@ -2719,10 +2715,9 @@ static inline const char *xhci_ep_type_string(u8 type)
 	}
 }
 
-static inline const char *xhci_decode_ep_context(u32 info, u32 info2, u64 deq,
-		u32 tx_info)
+static inline const char *xhci_decode_ep_context(char *str, u32 info,
+		u32 info2, u64 deq, u32 tx_info)
 {
-	static char str[1024];
 	int ret;
 
 	u32 esit;
-- 
2.32.0


