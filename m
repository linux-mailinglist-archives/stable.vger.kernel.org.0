Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8E344C7CB
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhKJSze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:55:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233871AbhKJSxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:53:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B98B061872;
        Wed, 10 Nov 2021 18:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570115;
        bh=fT0Zs5Hif2VMstUm9hcb/4Z70zoKqekD4qV6fjd2SHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/mWkiH8fwN3/PFhvPQvbyegfz24jbzQLCjfpSnZuq5hTG9w1qSyJRhnB21AVuv0S
         bec72VMN97mnixQt8I7iElVQm9pIVzoSiweGzINE+wlDFhM2/wf7thd0jvrDvCamRB
         2aUNt2iXlZOL4rtak2lfiL2TFucg1YM9ume3k6Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Ren <rentao.bupt@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Neal Liu <neal_liu@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>
Subject: [PATCH 5.10 03/21] usb: ehci: handshake CMD_RUN instead of STS_HALT
Date:   Wed, 10 Nov 2021 19:43:49 +0100
Message-Id: <20211110182003.072897019@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Liu <neal_liu@aspeedtech.com>

commit 7f2d73788d9067fd4f677ac5f60ffd25945af7af upstream.

For Aspeed, HCHalted status depends on not only Run/Stop but also
ASS/PSS status.
Handshake CMD_RUN on startup instead.

Tested-by: Tao Ren <rentao.bupt@gmail.com>
Reviewed-by: Tao Ren <rentao.bupt@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Link: https://lore.kernel.org/r/20210910073619.26095-1-neal_liu@aspeedtech.com
Cc: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-hcd.c      |   11 ++++++++++-
 drivers/usb/host/ehci-platform.c |    6 ++++++
 drivers/usb/host/ehci.h          |    1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -634,7 +634,16 @@ static int ehci_run (struct usb_hcd *hcd
 	/* Wait until HC become operational */
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
 	msleep(5);
-	rc = ehci_handshake(ehci, &ehci->regs->status, STS_HALT, 0, 100 * 1000);
+
+	/* For Aspeed, STS_HALT also depends on ASS/PSS status.
+	 * Check CMD_RUN instead.
+	 */
+	if (ehci->is_aspeed)
+		rc = ehci_handshake(ehci, &ehci->regs->command, CMD_RUN,
+				    1, 100 * 1000);
+	else
+		rc = ehci_handshake(ehci, &ehci->regs->status, STS_HALT,
+				    0, 100 * 1000);
 
 	up_write(&ehci_cf_port_reset_rwsem);
 
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -294,6 +294,12 @@ static int ehci_platform_probe(struct pl
 					  "has-transaction-translator"))
 			hcd->has_tt = 1;
 
+		if (of_device_is_compatible(dev->dev.of_node,
+					    "aspeed,ast2500-ehci") ||
+		    of_device_is_compatible(dev->dev.of_node,
+					    "aspeed,ast2600-ehci"))
+			ehci->is_aspeed = 1;
+
 		if (soc_device_match(quirk_poll_match))
 			priv->quirk_poll = true;
 
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -218,6 +218,7 @@ struct ehci_hcd {			/* one per controlle
 	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
 	unsigned		need_oc_pp_cycle:1; /* MPC834X port power */
 	unsigned		imx28_write_fix:1; /* For Freescale i.MX28 */
+	unsigned		is_aspeed:1;
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)


