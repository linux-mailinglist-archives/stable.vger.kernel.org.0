Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DE44ABB37
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384278AbiBGL1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381829AbiBGLRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:17:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0324C0401EF;
        Mon,  7 Feb 2022 03:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 811E561314;
        Mon,  7 Feb 2022 11:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAA0C004E1;
        Mon,  7 Feb 2022 11:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232636;
        bh=LbP2stevJ2DD4xdfntJs2VzQvlAFG9SAkJXK7TpnxRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpHpam27kPUtK/kvWa+YmVUm6ETfj5XklZUJXP+9S9CY0SyW8WUNirgQSSUaJCZys
         V0Z8c6Q/XVjNT5dLhJrP+tX33ulKITZg0Ul49i2i6jWhdi7ZJlXVbdHbXU5b+Vlc2O
         MIU2lrcE6ZGazzmozEdhDa++u8dhQvdHpoz5dvMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yannick Vignon <yannick.vignon@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 75/86] net: stmmac: ensure PTP time register reads are consistent
Date:   Mon,  7 Feb 2022 12:06:38 +0100
Message-Id: <20220207103800.132479846@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yannick Vignon <yannick.vignon@nxp.com>

commit 80d4609008e6d696a279e39ae7458c916fcd44c1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -159,15 +159,20 @@ static int adjust_systime(void __iomem *
 
 static void get_systime(void __iomem *ioaddr, u64 *systime)
 {
-	u64 ns;
+	u64 ns, sec0, sec1;
 
-	/* Get the TSSS value */
-	ns = readl(ioaddr + PTP_STNSR);
-	/* Get the TSS and convert sec time value to nanosecond */
-	ns += readl(ioaddr + PTP_STSR) * 1000000000ULL;
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
 
 const struct stmmac_hwtimestamp stmmac_ptp = {


