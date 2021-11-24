Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7B45BC32
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244012AbhKXM0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243532AbhKXMUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A82F61178;
        Wed, 24 Nov 2021 12:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755964;
        bh=cV9s8bhwDz06r7QY5q6CoQiU534N/xpik56JGkrc/zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfeWWa7fVbR38QmGu4ryx6CbiQgSNREeMSgoV9EX/Rz4PlCeRmdy/4fTbfAsKFIyq
         p+Pz2WxkxqtrTAp/x8BhZiPtA46NKs7t1iE/Jf2iUCg7ghFglK0R9IKFuNag++cbfL
         7VIDmj0IH64nibstJaurbqdkf4qIUvjj82njaGsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/207] ath9k: Fix potential interrupt storm on queue reset
Date:   Wed, 24 Nov 2021 12:56:04 +0100
Message-Id: <20211124115707.084356071@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

[ Upstream commit 4925642d541278575ad1948c5924d71ffd57ef14 ]

In tests with two Lima boards from 8devices (QCA4531 based) on OpenWrt
19.07 we could force a silent restart of a device with no serial
output when we were sending a high amount of UDP traffic (iperf3 at 80
MBit/s in both directions from external hosts, saturating the wifi and
causing a load of about 4.5 to 6) and were then triggering an
ath9k_queue_reset().

Further debugging showed that the restart was caused by the ath79
watchdog. With disabled watchdog we could observe that the device was
constantly going into ath_isr() interrupt handler and was returning
early after the ATH_OP_HW_RESET flag test, without clearing any
interrupts. Even though ath9k_queue_reset() calls
ath9k_hw_kill_interrupts().

With JTAG we could observe the following race condition:

1) ath9k_queue_reset()
   ...
   -> ath9k_hw_kill_interrupts()
   -> set_bit(ATH_OP_HW_RESET, &common->op_flags);
   ...
   <- returns

      2) ath9k_tasklet()
         ...
         -> ath9k_hw_resume_interrupts()
         ...
         <- returns

                 3) loops around:
                    ...
                    handle_int()
                    -> ath_isr()
                       ...
                       -> if (test_bit(ATH_OP_HW_RESET,
                                       &common->op_flags))
                            return IRQ_HANDLED;

                    x) ath_reset_internal():
                       => never reached <=

And in ath_isr() we would typically see the following interrupts /
interrupt causes:

* status: 0x00111030 or 0x00110030
* async_cause: 2 (AR_INTR_MAC_IPQ)
* sync_cause: 0

So the ath9k_tasklet() reenables the ath9k interrupts
through ath9k_hw_resume_interrupts() which ath9k_queue_reset() had just
disabled. And ath_isr() then keeps firing because it returns IRQ_HANDLED
without actually clearing the interrupt.

To fix this IRQ storm also clear/disable the interrupts again when we
are in reset state.

Cc: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Linus Lüssing <linus.luessing@c0d3.blue>
Fixes: 872b5d814f99 ("ath9k: do not access hardware on IRQs during reset")
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210914192515.9273-3-linus.luessing@c0d3.blue
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7776f4a8630e4..ca0877f0e6392 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -528,8 +528,10 @@ irqreturn_t ath_isr(int irq, void *dev)
 	ath9k_debug_sync_cause(sc, sync_cause);
 	status &= ah->imask;	/* discard unasked-for bits */
 
-	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags)) {
+		ath9k_hw_kill_interrupts(sc->sc_ah);
 		return IRQ_HANDLED;
+	}
 
 	/*
 	 * If there are no status bits set, then this interrupt was not
-- 
2.33.0



