Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA0E4C749C
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbiB1Rpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbiB1RnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094F19A4E5;
        Mon, 28 Feb 2022 09:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1414B61375;
        Mon, 28 Feb 2022 17:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F12C340E7;
        Mon, 28 Feb 2022 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069715;
        bh=KpiCJSOCMTZiDWqLlKadY57iMfFkeIoGxU63WBrxqjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMWxNYJlj5Z+NOjQ7RPc9XhatS7IzX7Tm5PN8AN12D1rXfIyZIyUEpI8WBpnC+hMA
         YNZUziD6/sBq0Yeov+1phCtZn9TFRpuRV8DMD5/bbW7tEkfulY3aBAaP82feSWFUTl
         rS9DOf/jWxmUMn+9WjAj8TwWswg/JEX/9VnijVlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5.10 67/80] usb: dwc3: gadget: Let the interrupt handler disable bottom halves.
Date:   Mon, 28 Feb 2022 18:24:48 +0100
Message-Id: <20220228172319.855409031@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 84918a89d6efaff075de570b55642b6f4ceeac6d upstream.

The interrupt service routine registered for the gadget is a primary
handler which mask the interrupt source and a threaded handler which
handles the source of the interrupt. Since the threaded handler is
voluntary threaded, the IRQ-core does not disable bottom halves before
invoke the handler like it does for the forced-threaded handler.

Due to changes in networking it became visible that a network gadget's
completions handler may schedule a softirq which remains unprocessed.
The gadget's completion handler is usually invoked either in hard-IRQ or
soft-IRQ context. In this context it is enough to just raise the softirq
because the softirq itself will be handled once that context is left.
In the case of the voluntary threaded handler, there is nothing that
will process pending softirqs. Which means it remain queued until
another random interrupt (on this CPU) fires and handles it on its exit
path or another thread locks and unlocks a lock with the bh suffix.
Worst case is that the CPU goes idle and the NOHZ complains about
unhandled softirqs.

Disable bottom halves before acquiring the lock (and disabling
interrupts) and enable them after dropping the lock. This ensures that
any pending softirqs will handled right away.

Link: https://lkml.kernel.org/r/c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com
Fixes: e5f68b4a3e7b0 ("Revert "usb: dwc3: gadget: remove unnecessary _irqsave()"")
Cc: stable <stable@kernel.org>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/Yg/YPejVQH3KkRVd@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3775,9 +3775,11 @@ static irqreturn_t dwc3_thread_interrupt
 	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
 
+	local_bh_disable();
 	spin_lock_irqsave(&dwc->lock, flags);
 	ret = dwc3_process_event_buf(evt);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	local_bh_enable();
 
 	return ret;
 }


