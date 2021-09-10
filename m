Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0413B406C40
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhIJMi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234348AbhIJMgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE009611CB;
        Fri, 10 Sep 2021 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277325;
        bh=tOD87EJ/Ew3INAK8d2jffoA3s6Y9JcYm0Gn1ZgRPKT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGNRC2zhUppmP1bSrwTfkz45CZEvPnt8UHLDZI9WRT3e+nu7RMWUGyauqGstNhgk7
         hEzfpg5a6Hf+shl5XXgi7yNUnD/0pt64lGKLeMj+x7cUfn1hScH5qdl+5PFY/l0vLj
         Cm6zv1igHlJ85Sa8QEnwQDhaS4H2niogfKdXbu6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 35/37] xhci: fix unsafe memory usage in xhci tracing
Date:   Fri, 10 Sep 2021 14:30:38 +0200
Message-Id: <20210910122918.313227744@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit cbf286e8ef8337308c259ff5b9ce2e74d403be5a upstream.

Removes static char buffer usage in the following decode functions:
	xhci_decode_trb()
	xhci_decode_ptortsc()

Caller must provide a buffer to use.
In tracing use __get_str() as recommended to pass buffer.

Minor chanes are needed in xhci debugfs code as these functions are also
used there. Changes include moving XHCI_MSG_MAX definititon from
xhci-trace.h to xhci.h

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210820123503.2605901-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-debugfs.c |    6 +++-
 drivers/usb/host/xhci-trace.h   |    8 +++---
 drivers/usb/host/xhci.h         |   52 +++++++++++++++++++++-------------------
 3 files changed, 36 insertions(+), 30 deletions(-)

--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -197,12 +197,13 @@ static void xhci_ring_dump_segment(struc
 	int			i;
 	dma_addr_t		dma;
 	union xhci_trb		*trb;
+	char			str[XHCI_MSG_MAX];
 
 	for (i = 0; i < TRBS_PER_SEGMENT; i++) {
 		trb = &seg->trbs[i];
 		dma = seg->dma + i * sizeof(*trb);
 		seq_printf(s, "%pad: %s\n", &dma,
-			   xhci_decode_trb(le32_to_cpu(trb->generic.field[0]),
+			   xhci_decode_trb(str, XHCI_MSG_MAX, le32_to_cpu(trb->generic.field[0]),
 					   le32_to_cpu(trb->generic.field[1]),
 					   le32_to_cpu(trb->generic.field[2]),
 					   le32_to_cpu(trb->generic.field[3])));
@@ -340,9 +341,10 @@ static int xhci_portsc_show(struct seq_f
 {
 	struct xhci_port	*port = s->private;
 	u32			portsc;
+	char			str[XHCI_MSG_MAX];
 
 	portsc = readl(port->addr);
-	seq_printf(s, "%s\n", xhci_decode_portsc(portsc));
+	seq_printf(s, "%s\n", xhci_decode_portsc(str, portsc));
 
 	return 0;
 }
--- a/drivers/usb/host/xhci-trace.h
+++ b/drivers/usb/host/xhci-trace.h
@@ -25,8 +25,6 @@
 #include "xhci.h"
 #include "xhci-dbgcap.h"
 
-#define XHCI_MSG_MAX	500
-
 DECLARE_EVENT_CLASS(xhci_log_msg,
 	TP_PROTO(struct va_format *vaf),
 	TP_ARGS(vaf),
@@ -122,6 +120,7 @@ DECLARE_EVENT_CLASS(xhci_log_trb,
 		__field(u32, field1)
 		__field(u32, field2)
 		__field(u32, field3)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->type = ring->type;
@@ -131,7 +130,7 @@ DECLARE_EVENT_CLASS(xhci_log_trb,
 		__entry->field3 = le32_to_cpu(trb->field[3]);
 	),
 	TP_printk("%s: %s", xhci_ring_type_string(__entry->type),
-			xhci_decode_trb(__entry->field0, __entry->field1,
+		  xhci_decode_trb(__get_str(str), XHCI_MSG_MAX, __entry->field0, __entry->field1,
 					__entry->field2, __entry->field3)
 	)
 );
@@ -523,6 +522,7 @@ DECLARE_EVENT_CLASS(xhci_log_portsc,
 		    TP_STRUCT__entry(
 				     __field(u32, portnum)
 				     __field(u32, portsc)
+				     __dynamic_array(char, str, XHCI_MSG_MAX)
 				     ),
 		    TP_fast_assign(
 				   __entry->portnum = portnum;
@@ -530,7 +530,7 @@ DECLARE_EVENT_CLASS(xhci_log_portsc,
 				   ),
 		    TP_printk("port-%d: %s",
 			      __entry->portnum,
-			      xhci_decode_portsc(__entry->portsc)
+			      xhci_decode_portsc(__get_str(str), __entry->portsc)
 			      )
 );
 
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -22,6 +22,9 @@
 #include	"xhci-ext-caps.h"
 #include "pci-quirks.h"
 
+/* max buffer size for trace and debug messages */
+#define XHCI_MSG_MAX		500
+
 /* xHCI PCI Configuration Registers */
 #define XHCI_SBRN_OFFSET	(0x60)
 
@@ -2217,15 +2220,14 @@ static inline char *xhci_slot_state_stri
 	}
 }
 
-static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
-		u32 field3)
+static inline const char *xhci_decode_trb(char *str, size_t size,
+					  u32 field0, u32 field1, u32 field2, u32 field3)
 {
-	static char str[256];
 	int type = TRB_FIELD_TO_TYPE(field3);
 
 	switch (type) {
 	case TRB_LINK:
-		sprintf(str,
+		snprintf(str, size,
 			"LINK %08x%08x intr %d type '%s' flags %c:%c:%c:%c",
 			field1, field0, GET_INTR_TARGET(field2),
 			xhci_trb_type_string(type),
@@ -2242,7 +2244,7 @@ static inline const char *xhci_decode_tr
 	case TRB_HC_EVENT:
 	case TRB_DEV_NOTE:
 	case TRB_MFINDEX_WRAP:
-		sprintf(str,
+		snprintf(str, size,
 			"TRB %08x%08x status '%s' len %d slot %d ep %d type '%s' flags %c:%c",
 			field1, field0,
 			xhci_trb_comp_code_string(GET_COMP_CODE(field2)),
@@ -2255,7 +2257,8 @@ static inline const char *xhci_decode_tr
 
 		break;
 	case TRB_SETUP:
-		sprintf(str, "bRequestType %02x bRequest %02x wValue %02x%02x wIndex %02x%02x wLength %d length %d TD size %d intr %d type '%s' flags %c:%c:%c",
+		snprintf(str, size,
+			"bRequestType %02x bRequest %02x wValue %02x%02x wIndex %02x%02x wLength %d length %d TD size %d intr %d type '%s' flags %c:%c:%c",
 				field0 & 0xff,
 				(field0 & 0xff00) >> 8,
 				(field0 & 0xff000000) >> 24,
@@ -2272,7 +2275,8 @@ static inline const char *xhci_decode_tr
 				field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_DATA:
-		sprintf(str, "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c",
+		snprintf(str, size,
+			 "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c",
 				field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 				GET_INTR_TARGET(field2),
 				xhci_trb_type_string(type),
@@ -2285,7 +2289,8 @@ static inline const char *xhci_decode_tr
 				field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_STATUS:
-		sprintf(str, "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c",
+		snprintf(str, size,
+			 "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c",
 				field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 				GET_INTR_TARGET(field2),
 				xhci_trb_type_string(type),
@@ -2298,7 +2303,7 @@ static inline const char *xhci_decode_tr
 	case TRB_ISOC:
 	case TRB_EVENT_DATA:
 	case TRB_TR_NOOP:
-		sprintf(str,
+		snprintf(str, size,
 			"Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c:%c",
 			field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 			GET_INTR_TARGET(field2),
@@ -2315,21 +2320,21 @@ static inline const char *xhci_decode_tr
 
 	case TRB_CMD_NOOP:
 	case TRB_ENABLE_SLOT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: flags %c",
 			xhci_trb_type_string(type),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_DISABLE_SLOT:
 	case TRB_NEG_BANDWIDTH:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: slot %d flags %c",
 			xhci_trb_type_string(type),
 			TRB_TO_SLOT_ID(field3),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_ADDR_DEV:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2338,7 +2343,7 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_CONFIG_EP:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2347,7 +2352,7 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_EVAL_CONTEXT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2355,7 +2360,7 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_RESET_EP:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d ep %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2376,7 +2381,7 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_SET_DEQ:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: deq %08x%08x stream %d slot %d ep %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2387,14 +2392,14 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_RESET_DEV:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: slot %d flags %c",
 			xhci_trb_type_string(type),
 			TRB_TO_SLOT_ID(field3),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_FORCE_EVENT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: event %08x%08x vf intr %d vf id %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2403,14 +2408,14 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_SET_LT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: belt %d flags %c",
 			xhci_trb_type_string(type),
 			TRB_TO_BELT(field3),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_GET_BW:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d speed %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2419,7 +2424,7 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_FORCE_HEADER:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: info %08x%08x%08x pkt type %d roothub port %d flags %c",
 			xhci_trb_type_string(type),
 			field2, field1, field0 & 0xffffffe0,
@@ -2428,7 +2433,7 @@ static inline const char *xhci_decode_tr
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	default:
-		sprintf(str,
+		snprintf(str, size,
 			"type '%s' -> raw %08x %08x %08x %08x",
 			xhci_trb_type_string(type),
 			field0, field1, field2, field3);
@@ -2553,9 +2558,8 @@ static inline const char *xhci_portsc_li
 	return "Unknown";
 }
 
-static inline const char *xhci_decode_portsc(u32 portsc)
+static inline const char *xhci_decode_portsc(char *str, u32 portsc)
 {
-	static char str[256];
 	int ret;
 
 	ret = sprintf(str, "%s %s %s Link:%s PortSpeed:%d ",


