Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389295F3F8D
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 11:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiJDJ3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 05:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJDJ1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 05:27:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A04138;
        Tue,  4 Oct 2022 02:27:10 -0700 (PDT)
Date:   Tue, 04 Oct 2022 09:27:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664875627;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hDk/cIXklCsgbZlgH72/a8e3sdQyIG1XRO+Qx2Hma2U=;
        b=IRrD9AL/6Jh1Z759f7sknrPc95WYkANU+P8xJrnm73EIQ7SRDc6bbcwjnSk8DDCQrHby+e
        ZpwBJK5mumfo2CZIp+bJQeaRhUrsdDPeoDfpxgoMd1v+LpZnCslrjRp6V5FwLsIwATJyA2
        A8ba5tS1K8A5O+RktdWTB/gvpopLjkoYH1qhtTsY80VXZNpQeRS8aCQmKu93JYH/fhkyyZ
        fkuPT2QlpeVRqew6kCXOvm9bMdqPcInDhn+CVQoYu00dYOr79DjgYr0PI+43p8w644ZPHC
        YQHywE9Hd6GwHPYX82JBWwcnjqnwFzr25DejDpmlZJijkMGxnuAomkeJIj1K5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664875627;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hDk/cIXklCsgbZlgH72/a8e3sdQyIG1XRO+Qx2Hma2U=;
        b=Pk4ODwz54jXlqQ27h/qgjIk07FoHJl2LVz7EYmPcwckjckovdScrLe06QKjxTd76KKKD+S
        3jzSvxG/mTwIUHAw==
From:   "tip-bot2 for Yang Guo" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/core] clocksource/drivers/arm_arch_timer: Fix CNTPCT_LO
 and CNTVCT_LO value
Cc:     stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yang Guo <guoyang2@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220927033221.49589-1-zhangshaokun@hisilicon.com>
References: <20220927033221.49589-1-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Message-ID: <166487562575.401.15454181207950068300.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/core branch of tip:

Commit-ID:     af246cc6d0ed11318223606128bb0b09866c4c08
Gitweb:        https://git.kernel.org/tip/af246cc6d0ed11318223606128bb0b09866c4c08
Author:        Yang Guo <guoyang2@huawei.com>
AuthorDate:    Tue, 27 Sep 2022 11:32:21 +08:00
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Tue, 27 Sep 2022 11:30:53 +02:00

clocksource/drivers/arm_arch_timer: Fix CNTPCT_LO and CNTVCT_LO value

CNTPCT_LO and CNTVCT_LO are defined by mistake in commit '8b82c4f883a7',
so fix them according to the Arm ARM DDI 0487I.a, Table I2-4
"CNTBaseN memory map" as follows:

Offset    Register      Type Description
0x000     CNTPCT[31:0]  RO   Physical Count register.
0x004     CNTPCT[63:32] RO
0x008     CNTVCT[31:0]  RO   Virtual Count register.
0x00C     CNTVCT[63:32] RO

Fixes: 8b82c4f883a7 ("clocksource/drivers/arm_arch_timer: Move MMIO timer programming over to CVAL")
Cc: stable@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Yang Guo <guoyang2@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Link: https://lore.kernel.org/r/20220927033221.49589-1-zhangshaokun@hisilicon.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/arm_arch_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index ff935ef..a7ff775 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -44,8 +44,8 @@
 #define CNTACR_RWVT	BIT(4)
 #define CNTACR_RWPT	BIT(5)
 
-#define CNTVCT_LO	0x00
-#define CNTPCT_LO	0x08
+#define CNTPCT_LO	0x00
+#define CNTVCT_LO	0x08
 #define CNTFRQ		0x10
 #define CNTP_CVAL_LO	0x20
 #define CNTP_CTL	0x2c
