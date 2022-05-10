Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FC45217D0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbiEJN2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243089AbiEJNZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154812311CF;
        Tue, 10 May 2022 06:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8810615F8;
        Tue, 10 May 2022 13:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33B4C385A6;
        Tue, 10 May 2022 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188729;
        bh=syvbfAMOEbim3F1NblPad85qNNOn39u3qZiZAyUDIdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbm1qwslSwzwmAKHzPzEqJIdnQiLKZoogYMFMDvXvnSbESWBbtbD0+7myImmzdKjT
         DPvyHgGflhd6rMJdbcW+wSSvBCeYZl34bO5H5FWicape+Z/o/KJ3vEhAArT5993LIn
         y/qpfqM7amBvEhIN+Ou3nayofgHx4ENZ6j8pSFTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Lin <henryl@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 08/88] xhci: stop polling roothubs after shutdown
Date:   Tue, 10 May 2022 15:06:53 +0200
Message-Id: <20220510130733.986683627@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Lin <henryl@nvidia.com>

commit dc92944a014cd6a6f6c94299aaa36164dd2c238a upstream.

While rebooting, XHCI controller and its bus device will be shut down
in order by .shutdown callback. Stopping roothubs polling in
xhci_shutdown() can prevent XHCI driver from accessing port status
after its bus device shutdown.

Take PCIe XHCI controller as example, if XHCI driver doesn't stop roothubs
polling, XHCI driver may access PCIe BAR register for port status after
parent PCIe root port driver is shutdown and cause PCIe bus error.

[check shared hcd exist before stopping its roothub polling -Mathias]

Cc: stable@vger.kernel.org
Signed-off-by: Henry Lin <henryl@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220408134823.2527272-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -778,6 +778,17 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
 
+	/* Don't poll the roothubs after shutdown. */
+	xhci_dbg(xhci, "%s: stopping usb%d port polling.\n",
+			__func__, hcd->self.busnum);
+	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+	del_timer_sync(&hcd->rh_timer);
+
+	if (xhci->shared_hcd) {
+		clear_bit(HCD_FLAG_POLL_RH, &xhci->shared_hcd->flags);
+		del_timer_sync(&xhci->shared_hcd->rh_timer);
+	}
+
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
 	/* Workaround for spurious wakeups at shutdown with HSW */


