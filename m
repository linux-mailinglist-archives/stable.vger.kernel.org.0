Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC4317C135
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 16:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCFPGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 10:06:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:49424 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgCFPGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 10:06:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 07:06:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,522,1574150400"; 
   d="scan'208";a="234831840"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 06 Mar 2020 07:06:36 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/2] xhci: Do not open code __print_symbolic() in xhci trace events
Date:   Fri,  6 Mar 2020 17:08:57 +0200
Message-Id: <20200306150858.21904-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306150858.21904-1-mathias.nyman@linux.intel.com>
References: <20200306150858.21904-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

libtraceevent (used by perf and trace-cmd) failed to parse the
xhci_urb_dequeue trace event. This is because the user space trace
event format parsing is not a full C compiler. It can handle some basic
logic, but is not meant to be able to handle everything C can do.

In cases where a trace event field needs to be converted from a number
to a string, there's the __print_symbolic() macro that should be used:

 See samples/trace_events/trace-events-sample.h

Some xhci trace events open coded the __print_symbolic() causing the
user spaces tools to fail to parse it. This has to be replaced with
__print_symbolic() instead.

CC: stable@vger.kernel.org
Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206531
Fixes: 5abdc2e6e12ff ("usb: host: xhci: add urb_enqueue/dequeue/giveback tracers")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-trace.h | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/xhci-trace.h b/drivers/usb/host/xhci-trace.h
index 56eb867803a6..b19582b2a72c 100644
--- a/drivers/usb/host/xhci-trace.h
+++ b/drivers/usb/host/xhci-trace.h
@@ -289,23 +289,12 @@ DECLARE_EVENT_CLASS(xhci_log_urb,
 	),
 	TP_printk("ep%d%s-%s: urb %p pipe %u slot %d length %d/%d sgs %d/%d stream %d flags %08x",
 			__entry->epnum, __entry->dir_in ? "in" : "out",
-			({ char *s;
-			switch (__entry->type) {
-			case USB_ENDPOINT_XFER_INT:
-				s = "intr";
-				break;
-			case USB_ENDPOINT_XFER_CONTROL:
-				s = "control";
-				break;
-			case USB_ENDPOINT_XFER_BULK:
-				s = "bulk";
-				break;
-			case USB_ENDPOINT_XFER_ISOC:
-				s = "isoc";
-				break;
-			default:
-				s = "UNKNOWN";
-			} s; }), __entry->urb, __entry->pipe, __entry->slot_id,
+			__print_symbolic(__entry->type,
+				   { USB_ENDPOINT_XFER_INT,	"intr" },
+				   { USB_ENDPOINT_XFER_CONTROL,	"control" },
+				   { USB_ENDPOINT_XFER_BULK,	"bulk" },
+				   { USB_ENDPOINT_XFER_ISOC,	"isoc" }),
+			__entry->urb, __entry->pipe, __entry->slot_id,
 			__entry->actual, __entry->length, __entry->num_mapped_sgs,
 			__entry->num_sgs, __entry->stream, __entry->flags
 		)
-- 
2.17.1

