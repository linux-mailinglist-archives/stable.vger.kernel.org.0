Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B771F4FCB33
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbiDLBDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345969AbiDLA6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:58:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616D4340D4;
        Mon, 11 Apr 2022 17:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9876B815C8;
        Tue, 12 Apr 2022 00:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31717C385A3;
        Tue, 12 Apr 2022 00:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724705;
        bh=ubE5cBK1u0KST/FYIMyU80MCab6kYD84Od29l4/064s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NB/ksB1mMt9rh7UsX7Y5RK/9MhWqddSoceg4cEumsGYcQX52vFy4i3cFQShapUGFB
         6lvbvPHrNeaeeK8bmZE4sFhyq43Ly0ngbqmXfxRekcQgGJX1s0cFljbRL4Ex3rTW/s
         w+nakeOdR3yPJRnTNporYsta7Ae8hSVOa0Q9kSBz7+vE5G0WyLeuTqmkFQJbJsb+bg
         Y6A1B6XZ/UevrULzCuC6VprRwpbX8EDkb4UEVYsjObB+TMQ4WLKVxVZBCdexlSvvdi
         LqqltOy93QEo3M+rFcLy4MX/oUZ9I+QtgB9+dhobNBC4o3etviGmo3sisI7jLsocUI
         DImdtct5XZrng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Frank Li <Frank.li@nxp.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 21/21] perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant
Date:   Mon, 11 Apr 2022 20:50:40 -0400
Message-Id: <20220412005042.351105-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005042.351105-1-sashal@kernel.org>
References: <20220412005042.351105-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit d02b4dd84e1a90f7f1444d027c0289bf355b0d5a ]

Fix:

  In file included from <command-line>:0:0:
  In function ‘ddr_perf_counter_enable’,
      inlined from ‘ddr_perf_irq_handler’ at drivers/perf/fsl_imx8_ddr_perf.c:651:2:
  ././include/linux/compiler_types.h:352:38: error: call to ‘__compiletime_assert_729’ \
	declared with attribute error: FIELD_PREP: mask is not constant
    _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
...

See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
details as to why it triggers with older gccs only.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Frank Li <Frank.li@nxp.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220405151517.29753-10-bp@alien8.de
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 726ed8f59868..912a220a9db9 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -29,7 +29,7 @@
 #define CNTL_OVER_MASK		0xFFFFFFFE
 
 #define CNTL_CSV_SHIFT		24
-#define CNTL_CSV_MASK		(0xFF << CNTL_CSV_SHIFT)
+#define CNTL_CSV_MASK		(0xFFU << CNTL_CSV_SHIFT)
 
 #define EVENT_CYCLES_ID		0
 #define EVENT_CYCLES_COUNTER	0
-- 
2.35.1

