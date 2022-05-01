Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E714516506
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 17:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbiEAPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 11:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbiEAPzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 11:55:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A31BC81
        for <stable@vger.kernel.org>; Sun,  1 May 2022 08:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B74CB80B4C
        for <stable@vger.kernel.org>; Sun,  1 May 2022 15:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E02BC385A9;
        Sun,  1 May 2022 15:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651420330;
        bh=2/UcZ+huaDwnMggkHP6PBC5OZUaMz5CLJy71IsqDq38=;
        h=Subject:To:Cc:From:Date:From;
        b=B1679hkaZlaUVYxKuk6PHtPq/anlSauVxhvoCC4j4J1Wa/cyad25h9atofSA17YxO
         gXnLuTgN9sLJ5QfVLGFqAm+p7EYSNnj5XYoEwtQJWGPB/l0xZ2cji0rMTV9Z/W/4Ey
         iDh9pbr6A1oCV0LqV55Wa5Vl0hm1uKzJI5LfpiJ8=
Subject: FAILED: patch "[PATCH] xhci: increase usb U3 -> U0 link resume timeout from 100ms to" failed to apply to 5.4-stable tree
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 17:52:04 +0200
Message-ID: <165142032415585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 33597f0c48be0836854d43c577e35c8f8a765a7d Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 8 Apr 2022 16:48:23 +0300
Subject: [PATCH] xhci: increase usb U3 -> U0 link resume timeout from 100ms to
 500ms

The first U3 wake signal by the host may be lost if the USB 3 connection is
tunneled over USB4, with a runtime suspended USB4 host, and firmware
implemented connection manager.

Specs state the host must wait 100ms (tU3WakeupRetryDelay) before
resending a U3 wake signal if device doesn't respond, leading to U3 -> U0
link transition times around 270ms in the tunneled case.

Fixes: 0200b9f790b0 ("xhci: Wait until link state trainsits to U0 after setting USB_SS_PORT_LS_U0")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220408134823.2527272-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1e7dc130c39a..f65f1ba2b592 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1434,7 +1434,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				}
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
-								 msecs_to_jiffies(100)))
+								 msecs_to_jiffies(500)))
 					xhci_dbg(xhci, "missing U0 port change event for port %d-%d\n",
 						 hcd->self.busnum, wIndex + 1);
 				spin_lock_irqsave(&xhci->lock, flags);

