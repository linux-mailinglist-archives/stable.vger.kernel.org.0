Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C81505173
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbiDRMex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbiDRMdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1431F26AE8;
        Mon, 18 Apr 2022 05:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C793B80ED1;
        Mon, 18 Apr 2022 12:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890CAC385A7;
        Mon, 18 Apr 2022 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284674;
        bh=0w5fkYWRq9t9bwKn/65Gjp/8xhsgA6n0+Ym3YnpIS4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCaJDJDxcx/0llfwk1UEpDzrWxxeX058mpXVz6M87fOGPKmvTz9jamBq1dEhGrJL9
         Yig9OhL2F5Zr5WJJa1lza9pIqx9et67/2uVHk71xNAH1u5jCv1JAeE632fOYenuSIO
         fVW4IMjEdrvnaTU3IVkvL+G18u39h5/4ipa36lkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Frank Li <Frank.li@nxp.com>, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 174/219] perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant
Date:   Mon, 18 Apr 2022 14:12:23 +0200
Message-Id: <20220418121211.748966891@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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



