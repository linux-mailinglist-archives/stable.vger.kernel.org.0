Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AE32E38C0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbgL1NOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732509AbgL1NOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B0CC2076D;
        Mon, 28 Dec 2020 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161259;
        bh=hr/RIXSi7ckCRx6TPnC5jjk7QCnko/RVz4FSAX8Fj0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnOzaTOxY7IP8o3t/Fowu8JOSzchiLR82xdltas5XFdtahOmbbIbesCxmROr0GMf1
         iWehTTzc7wibgXR2+PV74YKp/78don2a47L5PsIfRpXIbbwQEPrBDUVDTmhvFP0lCT
         qYei5do7YGiGCbsMSTvyqYq1jaKwz+pxofCIMSLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 138/242] clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI
Date:   Mon, 28 Dec 2020 13:49:03 +0100
Message-Id: <20201228124911.500120023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keqian Zhu <zhukeqian1@huawei.com>

[ Upstream commit 8b7770b877d187bfdae1eaf587bd2b792479a31c ]

ARM virtual counter supports event stream, it can only trigger an event
when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 changes,
so the actual period of event stream is 2^(cntkctl_evnti + 1). For example,
when the trigger bit is 0, then virtual counter trigger an event for every
two cycles.

While we're at it, rework the way we compute the trigger bit position
by making it more obvious that when bits [n:n-1] are both set (with n
being the most significant bit), we pick bit (n + 1).

Fixes: 037f637767a8 ("drivers: clocksource: add support for ARM architected timer event stream")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201204073126.6920-3-zhukeqian1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 14e2419063e93..2c5913057b87b 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -744,15 +744,24 @@ static void arch_timer_evtstrm_enable(int divider)
 
 static void arch_timer_configure_evtstream(void)
 {
-	int evt_stream_div, pos;
+	int evt_stream_div, lsb;
+
+	/*
+	 * As the event stream can at most be generated at half the frequency
+	 * of the counter, use half the frequency when computing the divider.
+	 */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
+
+	/*
+	 * Find the closest power of two to the divisor. If the adjacent bit
+	 * of lsb (last set bit, starts from 0) is set, then we use (lsb + 1).
+	 */
+	lsb = fls(evt_stream_div) - 1;
+	if (lsb > 0 && (evt_stream_div & BIT(lsb - 1)))
+		lsb++;
 
-	/* Find the closest power of two to the divisor */
-	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
-	pos = fls(evt_stream_div);
-	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
-		pos--;
 	/* enable event stream */
-	arch_timer_evtstrm_enable(min(pos, 15));
+	arch_timer_evtstrm_enable(max(0, min(lsb, 15)));
 }
 
 static void arch_counter_set_user_access(void)
-- 
2.27.0



