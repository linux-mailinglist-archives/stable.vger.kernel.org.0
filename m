Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6516E4C72A5
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiB1R2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiB1R1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDFE887B5;
        Mon, 28 Feb 2022 09:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6962361358;
        Mon, 28 Feb 2022 17:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBCEC340F1;
        Mon, 28 Feb 2022 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069206;
        bh=r2zGWISR8ADy/uMfenbo6oa4HWz6gRQAjuTFHjo4Oaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WThdPCDUqkb1Gp+1Hbr7za3ue6aA2m9h5NDYDkGVxy4cII7ani/eeaneG78M/pJn6
         G7eX+s7PzyGQApUL0Cb5PQRXz1BiXtxIuHpr6GkhRu4Amri/WPSIL5NXYx3r0l2x3u
         jx7MzDyTKfhgSLV5mC5SfOAbY2VI0CFDux+2xvy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4.9 24/29] usb: dwc3: gadget: Let the interrupt handler disable bottom halves.
Date:   Mon, 28 Feb 2022 18:23:51 +0100
Message-Id: <20220228172144.199942293@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
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
@@ -2904,9 +2904,11 @@ static irqreturn_t dwc3_thread_interrupt
 	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
 
+	local_bh_disable();
 	spin_lock_irqsave(&dwc->lock, flags);
 	ret = dwc3_process_event_buf(evt);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	local_bh_enable();
 
 	return ret;
 }


