Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A99466C9F1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbjAPQ57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbjAPQ5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:57:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785272C660
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:40:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F1A61077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27850C433EF;
        Mon, 16 Jan 2023 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887226;
        bh=n8Nq0Ty86m0viJpELb5xHmcQRan2ATAjFnHhYodzI3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=al38mY58gHivkq3Z6dJcQNXknJ1Q6Wlr75SMlcbVLJrRRQpzfufAl0QVNv0B5asPQ
         eM9Ep1nOQqNYurHPZ2zwpA5zUqDpZ0tB4Hc38x1QojZEsIo2IOmjCpKhYyghecMhfI
         87GVg9e/W+PYreXlZHDeVE2TAdVh66iTC++2f2Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Doug Brown <doug@schmorgal.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/521] ARM: mmp: fix timer_read delay
Date:   Mon, 16 Jan 2023 16:45:03 +0100
Message-Id: <20230116154849.122535032@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Brown <doug@schmorgal.com>

[ Upstream commit e348b4014c31041e13ff370669ba3348c4d385e3 ]

timer_read() was using an empty 100-iteration loop to wait for the
TMR_CVWR register to capture the latest timer counter value. The delay
wasn't long enough. This resulted in CPU idle time being extremely
underreported on PXA168 with CONFIG_NO_HZ_IDLE=y.

Switch to the approach used in the vendor kernel, which implements the
capture delay by reading TMR_CVWR a few times instead.

Fixes: 49cbe78637eb ("[ARM] pxa: add base support for Marvell's PXA168 processor line")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20221204005117.53452-3-doug@schmorgal.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mmp/time.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 96ad1db0b04b..edd280e75546 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -52,18 +52,21 @@
 static void __iomem *mmp_timer_base = TIMERS_VIRT_BASE;
 
 /*
- * FIXME: the timer needs some delay to stablize the counter capture
+ * Read the timer through the CVWR register. Delay is required after requesting
+ * a read. The CR register cannot be directly read due to metastability issues
+ * documented in the PXA168 software manual.
  */
 static inline uint32_t timer_read(void)
 {
-	int delay = 100;
+	uint32_t val;
+	int delay = 3;
 
 	__raw_writel(1, mmp_timer_base + TMR_CVWR(1));
 
 	while (delay--)
-		cpu_relax();
+		val = __raw_readl(mmp_timer_base + TMR_CVWR(1));
 
-	return __raw_readl(mmp_timer_base + TMR_CVWR(1));
+	return val;
 }
 
 static u64 notrace mmp_read_sched_clock(void)
-- 
2.35.1



