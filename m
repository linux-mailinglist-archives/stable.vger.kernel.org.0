Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A1C1218A4
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfLPR5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:57:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfLPR51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:57:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38958206B7;
        Mon, 16 Dec 2019 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519046;
        bh=eKqDTAxFyxA/lXvzU1Qr7q6anvv1C64wcHPO3SspZ5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVKlVKrWlQBdAEiL8WtxfCQ9qdACq8hj/U5+g/BydiMsyPeTW50g/uf2Hhc+0LlsN
         KXTkwZAoqBil4L5x78W63IF3odyC+HndJH9eY+olCqrUUGMDklMasqJpuKWBaFrpmA
         uvlniWagZDPcKncdht0F355VrayjaOI4XBKZu0QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Billauer <eli.billauer@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 172/267] xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behaviour.
Date:   Mon, 16 Dec 2019 18:48:18 +0100
Message-Id: <20191216174911.925916147@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 7ff11162808cc2ec66353fc012c58bb449c892c3 upstream.

xhci driver claims it needs XHCI_TRUST_TX_LENGTH quirk for both
Broadcom/Cavium and a Renesas xHC controllers.

The quirk was inteded for handling false "success" complete event for
transfers that had data left untransferred.
These transfers should complete with "short packet" events instead.

In these two new cases the false "success" completion is reported
after a "short packet" if the TD consists of several TRBs.
xHCI specs 4.10.1.1.2 say remaining TRBs should report "short packet"
as well after the first short packet in a TD, but this issue seems so
common it doesn't make sense to add the quirk for all vendors.

Turn these events into short packets automatically instead.

This gets rid of the  "The WARN Successful completion on short TX for
slot 1 ep 1: needs XHCI_TRUST_TX_LENGTH quirk" warning in many cases.

Cc: <stable@vger.kernel.org>
Reported-by: Eli Billauer <eli.billauer@gmail.com>
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Eli Billauer <eli.billauer@gmail.com>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2398,7 +2398,8 @@ static int handle_tx_event(struct xhci_h
 	case COMP_SUCCESS:
 		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
-		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
+		if (xhci->quirks & XHCI_TRUST_TX_LENGTH ||
+		    ep_ring->last_td_was_short)
 			trb_comp_code = COMP_SHORT_PACKET;
 		else
 			xhci_warn_ratelimited(xhci,


