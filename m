Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A148593AA8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344371AbiHOTkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343991AbiHOTiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:38:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A993ED72;
        Mon, 15 Aug 2022 11:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2579F611DB;
        Mon, 15 Aug 2022 18:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AB4C433C1;
        Mon, 15 Aug 2022 18:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589192;
        bh=DQqfjIPCusGfeXhHiEnPPDYHHL0EQoPeHiJRj6wvgJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPXasR58sE+90u2/LePNj/asSGZhDi0had+c5Qg0HK/CyPQm/eErq6YAgBzB7/9S+
         C4c0tIiM+MtUbl/lHWBchxRO2ErSOm475ciUg+n4R5yNnyo6ghnjN3grjJCDiKfMi6
         n9lGXrziD6PC4HdURmaKGQTslyIaqOvsuvaKNFDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 642/779] s390/smp: cleanup control register update routines
Date:   Mon, 15 Aug 2022 20:04:46 +0200
Message-Id: <20220815180404.804207438@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 9097fc793f74ef9c677f8c4aed0c24f6f07f0133 ]

Get rid of duplicate code and redundant data.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ctl_reg.h | 16 ++++++++++-----
 arch/s390/kernel/smp.c          | 36 +++++++++++----------------------
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/s390/include/asm/ctl_reg.h b/arch/s390/include/asm/ctl_reg.h
index 04dc65f8901d..80b93c06a2bb 100644
--- a/arch/s390/include/asm/ctl_reg.h
+++ b/arch/s390/include/asm/ctl_reg.h
@@ -72,8 +72,17 @@ static __always_inline void __ctl_clear_bit(unsigned int cr, unsigned int bit)
 	__ctl_load(reg, cr, cr);
 }
 
-void smp_ctl_set_bit(int cr, int bit);
-void smp_ctl_clear_bit(int cr, int bit);
+void smp_ctl_set_clear_bit(int cr, int bit, bool set);
+
+static inline void ctl_set_bit(int cr, int bit)
+{
+	smp_ctl_set_clear_bit(cr, bit, true);
+}
+
+static inline void ctl_clear_bit(int cr, int bit)
+{
+	smp_ctl_set_clear_bit(cr, bit, false);
+}
 
 union ctlreg0 {
 	unsigned long val;
@@ -128,8 +137,5 @@ union ctlreg15 {
 	};
 };
 
-#define ctl_set_bit(cr, bit) smp_ctl_set_bit(cr, bit)
-#define ctl_clear_bit(cr, bit) smp_ctl_clear_bit(cr, bit)
-
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_CTL_REG_H */
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 982b72ca677c..7bbcb5b8d3f6 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -579,39 +579,27 @@ static void smp_ctl_bit_callback(void *info)
 }
 
 static DEFINE_SPINLOCK(ctl_lock);
-static unsigned long ctlreg;
 
-/*
- * Set a bit in a control register of all cpus
- */
-void smp_ctl_set_bit(int cr, int bit)
+void smp_ctl_set_clear_bit(int cr, int bit, bool set)
 {
-	struct ec_creg_mask_parms parms = { 1UL << bit, -1UL, cr };
-
-	spin_lock(&ctl_lock);
-	memcpy_absolute(&ctlreg, &S390_lowcore.cregs_save_area[cr], sizeof(ctlreg));
-	__set_bit(bit, &ctlreg);
-	memcpy_absolute(&S390_lowcore.cregs_save_area[cr], &ctlreg, sizeof(ctlreg));
-	spin_unlock(&ctl_lock);
-	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
-}
-EXPORT_SYMBOL(smp_ctl_set_bit);
-
-/*
- * Clear a bit in a control register of all cpus
- */
-void smp_ctl_clear_bit(int cr, int bit)
-{
-	struct ec_creg_mask_parms parms = { 0, ~(1UL << bit), cr };
+	struct ec_creg_mask_parms parms = { .cr = cr, };
+	u64 ctlreg;
 
+	if (set) {
+		parms.orval = 1UL << bit;
+		parms.andval = -1UL;
+	} else {
+		parms.orval = 0;
+		parms.andval = ~(1UL << bit);
+	}
 	spin_lock(&ctl_lock);
 	memcpy_absolute(&ctlreg, &S390_lowcore.cregs_save_area[cr], sizeof(ctlreg));
-	__clear_bit(bit, &ctlreg);
+	ctlreg = (ctlreg & parms.andval) | parms.orval;
 	memcpy_absolute(&S390_lowcore.cregs_save_area[cr], &ctlreg, sizeof(ctlreg));
 	spin_unlock(&ctl_lock);
 	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
-EXPORT_SYMBOL(smp_ctl_clear_bit);
+EXPORT_SYMBOL(smp_ctl_set_clear_bit);
 
 #ifdef CONFIG_CRASH_DUMP
 
-- 
2.35.1



