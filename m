Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB64FCAB9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiDLAzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245722AbiDLAyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:54:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2751B20BD7;
        Mon, 11 Apr 2022 17:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 073B76184B;
        Tue, 12 Apr 2022 00:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25844C385A3;
        Tue, 12 Apr 2022 00:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724543;
        bh=0w5fkYWRq9t9bwKn/65Gjp/8xhsgA6n0+Ym3YnpIS4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tH+jA/JxqYBkfthGjOeGB2T21nVZNF23W5Id+bFuSviUrEdTT9kbhQjvzZ9cDic9v
         tbriKq11uJCq9vqpH/ZnSTh9dKE0SC9c+r6Uj4xDcj5Mxewd7sy/lrEWaKpzu3PNRU
         2Hw/MprrXyHO25md64eUlWBeeFbQYwFNJAx/gbOcwxRDhbIkVUVTfF2uvSFZ5jFKgx
         dcS1t22QPjLVF+lXb7NkwhD4L0Z5vowczDOZZu5gzGWcn1lWaLMMKcg2hpWmWJSOiv
         drGGzLkcLRop0hqYMCJsMf1VgluWOwpI2wHJmX+lCm29sF6OPyaZguC51Q3PJK1gz1
         hMODTwuhY0VFw==
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
Subject: [PATCH AUTOSEL 5.15 41/41] perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant
Date:   Mon, 11 Apr 2022 20:46:53 -0400
Message-Id: <20220412004656.350101-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
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
index 94ebc1ecace7..b1b2a55de77f 100644
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

