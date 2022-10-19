Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14AE603C76
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiJSIrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiJSIqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:46:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5216AE56;
        Wed, 19 Oct 2022 01:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C596F61800;
        Wed, 19 Oct 2022 08:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53F2C433D6;
        Wed, 19 Oct 2022 08:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168871;
        bh=UzWcRCSCGAHYUtnLJmb+NhEh2plIKFuHU5nHeprqRTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOmNk8VKHdGSdLDriZPyth2B5hN7k2PTWrxcvIEQts0ZnekKrtYegRaGAFZbgWp7b
         PjBJth/i90MthZLvlgyqfUWzL+wwwfQsRwdgO5cmTb3URMNw51eo5otUlCAozXvTIh
         PPp8v51hspq/ngqbMIZItc6b8417YGiycxyCAvuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yang Guo <guoyang2@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH 6.0 082/862] clocksource/drivers/arm_arch_timer: Fix CNTPCT_LO and CNTVCT_LO value
Date:   Wed, 19 Oct 2022 10:22:49 +0200
Message-Id: <20221019083253.559428691@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Guo <guoyang2@huawei.com>

commit af246cc6d0ed11318223606128bb0b09866c4c08 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/arm_arch_timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


