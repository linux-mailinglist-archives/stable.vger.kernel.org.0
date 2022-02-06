Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5534AAF38
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbiBFMqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:46:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D5C06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:46:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8609B80E06
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0C5C340E9;
        Sun,  6 Feb 2022 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151558;
        bh=4Tqu/mOyu057UfwMtMJNYnZc8FL8oYQNl9m+IaPC+H8=;
        h=Subject:To:Cc:From:Date:From;
        b=TrSQE+azx5A3CRJ6sFPlrOS/hk0xx7v5I+Uy+4M6/ZCNYFuLmJ9C/65W+sAormgW+
         cIyAGeXX0SANEGUyi2ssD40pv22kiiUdO925Rwuy9iN425B+HCax0yfpP+VZnK9gHe
         v5w/fxgeAU1p3HRVY8c6QVd2YT1pNt2P95OcGOQE=
Subject: FAILED: patch "[PATCH] net: stmmac: ensure PTP time register reads are consistent" failed to apply to 4.9-stable tree
To:     yannick.vignon@nxp.com, kuba@kernel.org, rmk+kernel@armlinux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:45:55 +0100
Message-ID: <1644151555236209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 80d4609008e6d696a279e39ae7458c916fcd44c1 Mon Sep 17 00:00:00 2001
From: Yannick Vignon <yannick.vignon@nxp.com>
Date: Thu, 3 Feb 2022 17:00:25 +0100
Subject: [PATCH] net: stmmac: ensure PTP time register reads are consistent

Even if protected from preemption and interrupts, a small time window
remains when the 2 register reads could return inconsistent values,
each time the "seconds" register changes. This could lead to an about
1-second error in the reported time.

Add logic to ensure the "seconds" and "nanoseconds" values are consistent.

Fixes: 92ba6888510c ("stmmac: add the support for PTP hw clock driver")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20220203160025.750632-1-yannick.vignon@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 074e2cdfb0fa..a7ec9f4d46ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -145,15 +145,20 @@ static int adjust_systime(void __iomem *ioaddr, u32 sec, u32 nsec,
 
 static void get_systime(void __iomem *ioaddr, u64 *systime)
 {
-	u64 ns;
-
-	/* Get the TSSS value */
-	ns = readl(ioaddr + PTP_STNSR);
-	/* Get the TSS and convert sec time value to nanosecond */
-	ns += readl(ioaddr + PTP_STSR) * 1000000000ULL;
+	u64 ns, sec0, sec1;
+
+	/* Get the TSS value */
+	sec1 = readl_relaxed(ioaddr + PTP_STSR);
+	do {
+		sec0 = sec1;
+		/* Get the TSSS value */
+		ns = readl_relaxed(ioaddr + PTP_STNSR);
+		/* Get the TSS value */
+		sec1 = readl_relaxed(ioaddr + PTP_STSR);
+	} while (sec0 != sec1);
 
 	if (systime)
-		*systime = ns;
+		*systime = ns + (sec1 * 1000000000ULL);
 }
 
 static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)

