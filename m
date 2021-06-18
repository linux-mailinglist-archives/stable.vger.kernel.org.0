Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7E03ACFA8
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 18:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhFRQFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 12:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbhFRQFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 12:05:48 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69CAC06175F;
        Fri, 18 Jun 2021 09:03:38 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:03:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624032217;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xkhf3ArxO/MMuD3CvKKkwuOLJ4diQ6Ra3JwkcNSrZb4=;
        b=wKVKN6q+Wy7rdpUY3sT57RZKeXPN+m2CtKQolk0wEhvYwh1GAG3+PRy3E1XmwVZZpCdMTT
        wJLsSM+bphuezQzBnL/UIdQRkabTxx6U0zOPDqaq5/ViwxhZo+Jqw0QzGCr7YH1XTueepU
        GqqWdEGfC+CG3KM7+dFJe5oKeAx7t4FmRtPEh6UsiXKKeBSjhKnelg8yT/9hhTvhITuIok
        3LSgSrRLDQp8Krg6d9R3HWmTojkEluSor4oOuvCwykFtQIeVvzVoAsOHkz06hscdARuS8y
        c2BoS9RNwUItT4V7fPztxLWu+AX4asJDeOTbeATmMRu/VdP0gMM6ZNOYjcfx/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624032217;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xkhf3ArxO/MMuD3CvKKkwuOLJ4diQ6Ra3JwkcNSrZb4=;
        b=x0Jm3pq5iES06DeZ/CWyc7YAnajftNFWj7aQUu9my53BXmvi45EEB8msbm07aWUrr+kabD
        DM9laK86czYzAuCw==
From:   "tip-bot2 for Samuel Holland" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/core] clocksource/arm_arch_timer: Improve Allwinner A64
 timer workaround
Cc:     stable@vger.kernel.org,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210515021439.55316-1-samuel@sholland.org>
References: <20210515021439.55316-1-samuel@sholland.org>
MIME-Version: 1.0
Message-ID: <162403221683.19906.5221093456161398601.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/core branch of tip:

Commit-ID:     8b33dfe0ba1c84c1aab2456590b38195837f1e6e
Gitweb:        https://git.kernel.org/tip/8b33dfe0ba1c84c1aab2456590b38195837f1e6e
Author:        Samuel Holland <samuel@sholland.org>
AuthorDate:    Fri, 14 May 2021 21:14:39 -05:00
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Wed, 16 Jun 2021 17:33:04 +02:00

clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround

Bad counter reads are experienced sometimes when bit 10 or greater rolls
over. Originally, testing showed that at least 10 lower bits would be
set to the same value during these bad reads. However, some users still
reported time skips.

Wider testing revealed that on some chips, occasionally only the lowest
9 bits would read as the anomalous value. During these reads (which
still happen only when bit 10), bit 9 would read as the correct value.

Reduce the mask by one bit to cover these cases as well.

Cc: stable@vger.kernel.org
Fixes: c950ca8c35ee ("clocksource/drivers/arch_timer: Workaround for Allwinner A64 timer instability")
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210515021439.55316-1-samuel@sholland.org
---
 drivers/clocksource/arm_arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 89a9e05..be6d741 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -364,7 +364,7 @@ static u64 notrace arm64_858921_read_cntvct_el0(void)
 	do {								\
 		_val = read_sysreg(reg);				\
 		_retries--;						\
-	} while (((_val + 1) & GENMASK(9, 0)) <= 1 && _retries);	\
+	} while (((_val + 1) & GENMASK(8, 0)) <= 1 && _retries);	\
 									\
 	WARN_ON_ONCE(!_retries);					\
 	_val;								\
