Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F6119B242
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388322AbgDAQmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389098AbgDAQmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:42:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D28D32063A;
        Wed,  1 Apr 2020 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759340;
        bh=BrD0Wz+N8Jr3H8OgAyOyvPdUQvi6rQhn4MI94zk6Jik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8kj4pvDZFxrDNYvj1lLEJ/Mi1nMwU491j2c5hsXDd1CipxoXBWgXIYASjm3l4Mf2
         5gMxbAZe0hCg8cwVu/wtsEDHHbdrIFePE7PTZenXnLN/KegLppGkRCgxqtyoO/Oc7z
         0pTlI/icCK8P31RtDlFc67L5pfZXpmvkdwPuJao4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 034/148] xhci: Do not open code __print_symbolic() in xhci trace events
Date:   Wed,  1 Apr 2020 18:17:06 +0200
Message-Id: <20200401161555.930656316@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 045706bff837ee89c13f1ace173db71922c1c40b upstream.

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
Link: https://lore.kernel.org/r/20200306150858.21904-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-trace.h |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/drivers/usb/host/xhci-trace.h
+++ b/drivers/usb/host/xhci-trace.h
@@ -276,23 +276,12 @@ DECLARE_EVENT_CLASS(xhci_log_urb,
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


