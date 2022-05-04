Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA051A5EF
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353637AbiEDQvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353462AbiEDQvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4AB2E9D6;
        Wed,  4 May 2022 09:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 594076174B;
        Wed,  4 May 2022 16:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974ECC385AA;
        Wed,  4 May 2022 16:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682894;
        bh=9Jff2lxUeZilP+MjFMOWPR5n/EWcyo3sWxDxd33gFDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoPGxIMXD6+bWqX08Yibr3klubdfYqIbL7Ztuac9WD7I83/U6G9SUnylDnufVdUkD
         LSWVOgJMrtklCyhOm0AmzZJdCYJ2IqwN32Kf1flEyrHIfxBYo38e9PveuZ09jVxXCb
         /P/aRsnOR3IgRnXBuxxoYTc//+m3g3HH639XooPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 13/84] xhci: increase usb U3 -> U0 link resume timeout from 100ms to 500ms
Date:   Wed,  4 May 2022 18:43:54 +0200
Message-Id: <20220504152928.757491781@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 33597f0c48be0836854d43c577e35c8f8a765a7d upstream.

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
---
 drivers/usb/host/xhci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1343,7 +1343,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 				}
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
-								 msecs_to_jiffies(100)))
+								 msecs_to_jiffies(500)))
 					xhci_dbg(xhci, "missing U0 port change event for port %d\n",
 						 wIndex);
 				spin_lock_irqsave(&xhci->lock, flags);


