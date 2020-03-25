Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2AB191FCD
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 04:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCYDgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 23:36:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33853 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYDgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 23:36:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so508545pgn.1;
        Tue, 24 Mar 2020 20:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=TQggyO2aG3/J9tyHE64TxT0PFq58WGQfqt36Azet3yg=;
        b=o5gis7qDgBKjJXhzvsX0VrxVPS54IUHWnCsEg5GCyHBh0ZIDrpjhcGP7HSYfIsoxys
         5i57ygCgcyzJLMGA1/P+mBLC2TDTKajIeq/ILHv8sWXLP5dFmFUS3wuC/HXApmBUohlr
         TtrWI8QJoSpvp0ftMXLbZ/EYWGNWtWkkBG4MEKTzIyk+EkLMVC3EFSOF7tq4Yc3GfnCq
         DtJ93dGFP8D9C3t6wNwwaY0OgeVAIBFXHkHooHctkYyfgSwXFqn44ImvwkeJ9cPYBzD2
         yqEHA2pgfGX5vEKgtUTd2DMrm5jL6b53ZLS8BaAWB2Nm9fq1qUC6pnxD2qtgA7udPvoy
         7H1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=TQggyO2aG3/J9tyHE64TxT0PFq58WGQfqt36Azet3yg=;
        b=GnqgSczbspq6SqZo4wFz3aquBbAPOgoF3xXuYOJoBcO4rJFGsrmK1wh+Lb7e7gnzKe
         /601a7dRCeVYdecD2Ni2kSoNFNUd3LMpSg5+1uppe41t2dfcNYZUyVxCCP3mQLGaySB/
         LOv3606Vmjx3RdqmgdwXYZHrGraN2Us27c6ruONj0LzQEpl2tmrFPkNXmAiYP1/D6WQh
         noiyF60dLp6+VA2G01o3BGtDgGd32rOOwuuMQJvWEPwAdSVg7rP9gY+O20hYTzFw7gwt
         yk4GGaQeYd/TD3dIP0HiE5IDKrSsiT7FkKbHKgNrl55O0BM4549fcva7fQ5+oslLjWhO
         TsHw==
X-Gm-Message-State: ANhLgQ04anus8RqZsJoozJmOCnf0V+L6BYy+gsO1Rno8F2OdIr4E6lag
        6djlmmUI+TqxaEUQC2GaQUgECVVC3pLk2iqN
X-Google-Smtp-Source: ADFU+vt0SEbslAUeIkMwoV0mKo8ZnPoNWtTbu+NRgu+LhYETVXY5iJlHeTYAFtJKYbzXAVOHILpl0A==
X-Received: by 2002:a63:450b:: with SMTP id s11mr1041641pga.45.1585107410462;
        Tue, 24 Mar 2020 20:36:50 -0700 (PDT)
Received: from software.domain.org ([104.207.149.93])
        by smtp.gmail.com with ESMTPSA id 144sm17405416pfx.184.2020.03.24.20.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 24 Mar 2020 20:36:49 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org,
        Pei Huang <huangpei@loongson.cn>
Subject: [PATCH] MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3
Date:   Wed, 25 Mar 2020 11:44:54 +0800
Message-Id: <1585107894-8803-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LDDIR/LDPTE is Loongson-3's acceleration for Page Table Walking. If BD
(Base Directory, the 4th page directory) is not enabled, then GDOffset
is biased by BadVAddr[63:62]. So, if GDOffset (aka. BadVAddr[47:36] for
Loongson-3) is big enough, "0b11(BadVAddr[63:62])|BadVAddr[47:36]|...."
can far beyond pg_swapper_dir. This means the pg_swapper_dir may NOT be
accessed by LDDIR correctly, so fix it by set PWDirExt in CP0_PWCtl.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pei Huang <huangpei@loongson.cn>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/mm/tlbex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 344e6e9..da407cd 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1480,6 +1480,7 @@ static void build_r4000_tlb_refill_handler(void)
 
 static void setup_pw(void)
 {
+	unsigned int pwctl;
 	unsigned long pgd_i, pgd_w;
 #ifndef __PAGETABLE_PMD_FOLDED
 	unsigned long pmd_i, pmd_w;
@@ -1506,6 +1507,7 @@ static void setup_pw(void)
 
 	pte_i = ilog2(_PAGE_GLOBAL);
 	pte_w = 0;
+	pwctl = 1 << 30; /* Set PWDirExt */
 
 #ifndef __PAGETABLE_PMD_FOLDED
 	write_c0_pwfield(pgd_i << 24 | pmd_i << 12 | pt_i << 6 | pte_i);
@@ -1516,8 +1518,9 @@ static void setup_pw(void)
 #endif
 
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
-	write_c0_pwctl(1 << 6 | psn);
+	pwctl |= (1 << 6 | psn);
 #endif
+	write_c0_pwctl(pwctl);
 	write_c0_kpgd((long)swapper_pg_dir);
 	kscratch_used_mask |= (1 << 7); /* KScratch6 is used for KPGD */
 }
-- 
2.7.0

