Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2016153E311
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiFFHoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiFFHoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:44:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F394172E1A
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA52611B4
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1E2C385A9;
        Mon,  6 Jun 2022 07:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501458;
        bh=IdYBdQYd+sJIbmdmlaWBLboJNx6MgAr7vTJJuU5tgtY=;
        h=Subject:To:Cc:From:Date:From;
        b=Hcv148i2dAX6kuxVh5mrWkB/OuDVumvbkD4MnOlcpfvm3fPzZV2V3CfYH8NaihU40
         nnITpUfanxSINJdUngB6/aYJKBfOE5+ZL2raRxAZvCIyhYhGJcIvfwo+G4KWRtZQyE
         5L+1KsRGJGJoC+D0zmqIe2q4J7zpglHQ0Cs1zoKY=
Subject: FAILED: patch "[PATCH] xhci: Set HCD flag to defer primary roothub registration" failed to apply to 5.4-stable tree
To:     kishon@ti.com, chris.chiu@canonical.com,
        gregkh@linuxfoundation.org, mathias.nyman@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:44:15 +0200
Message-ID: <16545014551357@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b7a4f9b5d0e4b6dd937678c546c0b322dd1a4054 Mon Sep 17 00:00:00 2001
From: Kishon Vijay Abraham I <kishon@ti.com>
Date: Tue, 10 May 2022 14:46:30 +0530
Subject: [PATCH] xhci: Set HCD flag to defer primary roothub registration

Set "HCD_FLAG_DEFER_RH_REGISTER" to hcd->flags in xhci_run() to defer
registering primary roothub in usb_add_hcd() if xhci has two roothubs.
This will make sure both primary roothub and secondary roothub will be
registered along with the second HCD.
This is required for cold plugged USB devices to be detected in certain
PCIe USB cards (like Inateck USB card connected to AM64 EVM or J7200 EVM).

This patch has been added and reverted earier as it triggered a race
in usb device enumeration.
That race is now fixed in 5.16-rc3, and in stable back to 5.4
commit 6cca13de26ee ("usb: hub: Fix locking issues with address0_mutex")
commit 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0
race")

[minor rebase change, and commit message update -Mathias]

CC: stable@vger.kernel.org # 5.4+
Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Tested-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20220510091630.16564-3-kishon@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 25b87e99b4dd..2be38d9de8df 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -696,6 +696,8 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
+
 	xhci_create_dbc_dev(xhci);
 
 	xhci_debugfs_init(xhci);

