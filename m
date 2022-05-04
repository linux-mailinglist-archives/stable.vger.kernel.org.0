Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B0551A696
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353855AbiEDQ4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353948AbiEDQyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FD349904;
        Wed,  4 May 2022 09:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34748617A5;
        Wed,  4 May 2022 16:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81362C385A5;
        Wed,  4 May 2022 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682983;
        bh=k1rHxpQm2S8mpKlnDFvQd5CLu7baZrkGv8q8lii6SQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0m1vj5hbi5ViNYOBR4qnc8uX8AykAsu2mn7g8kU1OrlteXFObaEcoWrO2cWoykF7e
         cpvIE5LBRRFhXaumOedZ3mLefNq08nWSJDL3ByKss2PP/df8Ieas5vW8HbQP8uK2KB
         7rX84UWg4kZke2tZRQ3B24Z5ZyadrFsmofFG8t4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 012/129] xhci: increase usb U3 -> U0 link resume timeout from 100ms to 500ms
Date:   Wed,  4 May 2022 18:43:24 +0200
Message-Id: <20220504153022.295406273@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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
@@ -1348,7 +1348,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 				}
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
-								 msecs_to_jiffies(100)))
+								 msecs_to_jiffies(500)))
 					xhci_dbg(xhci, "missing U0 port change event for port %d-%d\n",
 						 hcd->self.busnum, wIndex + 1);
 				spin_lock_irqsave(&xhci->lock, flags);


