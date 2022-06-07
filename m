Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C195542718
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343547AbiFHCQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 22:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444862AbiFHCLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 22:11:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3DE25A818;
        Tue,  7 Jun 2022 12:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04F4D6077B;
        Tue,  7 Jun 2022 19:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C548C385A2;
        Tue,  7 Jun 2022 19:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629882;
        bh=SOVgZGmxox99chUL0j/dLJdoiw+f0+Ci7SsA5C0yofA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIKEqwJ9JY35nTCOAossBxhSiCDoORh09P8h7/Omfe2LvJRX8wKOKghtMS6/h7sm4
         Kk7kKAYF5v0p2S1K5Ee/yvVmiRUl2F3efG8CwGdqlw7p0evLqQoV/nSp1DFBSP9qX8
         Dwq1VtFSGXmvyAOmGG7aaoPjDfcyzp0ANQIsNOJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.18 810/879] irqchip/armada-370-xp: Do not touch Performance Counter Overflow on A375, A38x, A39x
Date:   Tue,  7 Jun 2022 19:05:28 +0200
Message-Id: <20220607165026.369091113@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit a3d66a76348daf559873f19afc912a2a7c2ccdaf upstream.

Register ARMADA_370_XP_INT_FABRIC_MASK_OFFS is Armada 370 and XP specific
and on new Armada platforms it has different meaning. It does not configure
Performance Counter Overflow interrupt masking. So do not touch this
register on non-A370/XP platforms (A375, A38x and A39x).

Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 28da06dfd9e4 ("irqchip: armada-370-xp: Enable the PMU interrupts")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220425113706.29310-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-armada-370-xp.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -308,7 +308,16 @@ static inline int armada_370_xp_msi_init
 
 static void armada_xp_mpic_perf_init(void)
 {
-	unsigned long cpuid = cpu_logical_map(smp_processor_id());
+	unsigned long cpuid;
+
+	/*
+	 * This Performance Counter Overflow interrupt is specific for
+	 * Armada 370 and XP. It is not available on Armada 375, 38x and 39x.
+	 */
+	if (!of_machine_is_compatible("marvell,armada-370-xp"))
+		return;
+
+	cpuid = cpu_logical_map(smp_processor_id());
 
 	/* Enable Performance Counter Overflow interrupts */
 	writel(ARMADA_370_XP_INT_CAUSE_PERF(cpuid),


