Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABCE51A7E5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353713AbiEDRFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348684AbiEDRDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:03:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65004D9C0;
        Wed,  4 May 2022 09:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40A65B82552;
        Wed,  4 May 2022 16:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C5EC385A5;
        Wed,  4 May 2022 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683153;
        bh=syvbfAMOEbim3F1NblPad85qNNOn39u3qZiZAyUDIdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrDHOrKmhNfcs6GQ3jbAyzJP8ptitBYYkgEdfwlcjbuz6VwmLQ1juMnOGQx9FUt7y
         7gMfyRYivN9z222k/grnACitmuxLhO2w7TsmeELcxHARg75d2kBn0FUQas4ls1jyES
         fmE/nYXCVoN7ka3vj6M/VTDWkaw0VlFZDKwHJ0QY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Lin <henryl@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 010/177] xhci: stop polling roothubs after shutdown
Date:   Wed,  4 May 2022 18:43:23 +0200
Message-Id: <20220504153054.499542356@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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


