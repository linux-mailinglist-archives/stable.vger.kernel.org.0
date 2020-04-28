Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D43D1BC841
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgD1Saw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbgD1Saw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:30:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED49B21707;
        Tue, 28 Apr 2020 18:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098651;
        bh=c9H+qpd47HYJ1J9D3GTa+VjseQBJ8oDJHKlKlFAPWDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkfjG4u5g2o0b78LFZqtMGA19/Rrz9GmEbnp+/gCB7fScdHolGynslPkJa5MWoAlU
         YDxtr4PP7WDTzI/cdnPSmA2Io4XDjSIaFoKkYjnIF727IW7GfIzDsxiHkOFBRPXsi2
         SwVeWYQiMTDMlwe6WRUQbSTAnT9aOVYBEi3Z7URQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>
Subject: [PATCH 5.6 092/167] USB: early: Handle AMDs spec-compliant identifiers, too
Date:   Tue, 28 Apr 2020 20:24:28 +0200
Message-Id: <20200428182236.615243960@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 7dbdb53d72a51cea9b921d9dbba54be00752212a upstream.

This fixes a bug that causes the USB3 early console to freeze after
printing a single line on AMD machines because it can't parse the
Transfer TRB properly.

The spec at
https://www.intel.com/content/dam/www/public/us/en/documents/technical-specifications/extensible-host-controler-interface-usb-xhci.pdf
says in section "4.5.1 Device Context Index" that the Context Index,
also known as Endpoint ID according to
section "1.6 Terms and Abbreviations", is normally computed as
`DCI = (Endpoint Number * 2) + Direction`, which matches the current
definitions of XDBC_EPID_OUT and XDBC_EPID_IN.

However, the numbering in a Debug Capability Context data structure is
supposed to be different:
Section "7.6.3.2 Endpoint Contexts and Transfer Rings" explains that a
Debug Capability Context data structure has the endpoints mapped to indices
0 and 1.

Change XDBC_EPID_OUT/XDBC_EPID_IN to the spec-compliant values, add
XDBC_EPID_OUT_INTEL/XDBC_EPID_IN_INTEL with Intel's incorrect values, and
let xdbc_handle_tx_event() handle both.

I have verified that with this patch applied, the USB3 early console works
on both an Intel and an AMD machine.

Fixes: aeb9dd1de98c ("usb/early: Add driver for xhci debug capability")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20200401074619.8024-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/early/xhci-dbc.c |    8 ++++----
 drivers/usb/early/xhci-dbc.h |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/usb/early/xhci-dbc.c
+++ b/drivers/usb/early/xhci-dbc.c
@@ -728,19 +728,19 @@ static void xdbc_handle_tx_event(struct
 	case COMP_USB_TRANSACTION_ERROR:
 	case COMP_STALL_ERROR:
 	default:
-		if (ep_id == XDBC_EPID_OUT)
+		if (ep_id == XDBC_EPID_OUT || ep_id == XDBC_EPID_OUT_INTEL)
 			xdbc.flags |= XDBC_FLAGS_OUT_STALL;
-		if (ep_id == XDBC_EPID_IN)
+		if (ep_id == XDBC_EPID_IN || ep_id == XDBC_EPID_IN_INTEL)
 			xdbc.flags |= XDBC_FLAGS_IN_STALL;
 
 		xdbc_trace("endpoint %d stalled\n", ep_id);
 		break;
 	}
 
-	if (ep_id == XDBC_EPID_IN) {
+	if (ep_id == XDBC_EPID_IN || ep_id == XDBC_EPID_IN_INTEL) {
 		xdbc.flags &= ~XDBC_FLAGS_IN_PROCESS;
 		xdbc_bulk_transfer(NULL, XDBC_MAX_PACKET, true);
-	} else if (ep_id == XDBC_EPID_OUT) {
+	} else if (ep_id == XDBC_EPID_OUT || ep_id == XDBC_EPID_OUT_INTEL) {
 		xdbc.flags &= ~XDBC_FLAGS_OUT_PROCESS;
 	} else {
 		xdbc_trace("invalid endpoint id %d\n", ep_id);
--- a/drivers/usb/early/xhci-dbc.h
+++ b/drivers/usb/early/xhci-dbc.h
@@ -120,8 +120,22 @@ struct xdbc_ring {
 	u32			cycle_state;
 };
 
-#define XDBC_EPID_OUT		2
-#define XDBC_EPID_IN		3
+/*
+ * These are the "Endpoint ID" (also known as "Context Index") values for the
+ * OUT Transfer Ring and the IN Transfer Ring of a Debug Capability Context data
+ * structure.
+ * According to the "eXtensible Host Controller Interface for Universal Serial
+ * Bus (xHCI)" specification, section "7.6.3.2 Endpoint Contexts and Transfer
+ * Rings", these should be 0 and 1, and those are the values AMD machines give
+ * you; but Intel machines seem to use the formula from section "4.5.1 Device
+ * Context Index", which is supposed to be used for the Device Context only.
+ * Luckily the values from Intel don't overlap with those from AMD, so we can
+ * just test for both.
+ */
+#define XDBC_EPID_OUT		0
+#define XDBC_EPID_IN		1
+#define XDBC_EPID_OUT_INTEL	2
+#define XDBC_EPID_IN_INTEL	3
 
 struct xdbc_state {
 	u16			vendor;


