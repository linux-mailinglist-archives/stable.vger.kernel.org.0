Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBEF565A4B
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbiGDPpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 11:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiGDPpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 11:45:21 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A21B10EA
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 08:45:18 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VIO699M_1656949511;
Received: from localhost.localdomain(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0VIO699M_1656949511)
          by smtp.aliyun-inc.com;
          Mon, 04 Jul 2022 23:45:12 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
Date:   Mon,  4 Jul 2022 23:45:08 +0800
Message-Id: <20220704154508.13317-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit ddd07b750382adc2b78fdfbec47af8a6e0d8ef37 upstream.

CAT has happened, WBINDV is bad (even before CAT blowing away the
entire cache on a multi-core platform wasn't nice), try not to use it
ever.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Cc: Bin Yang <bin.yang@intel.com>
Cc: Mark Gross <mark.gross@intel.com>
Link: https://lkml.kernel.org/r/20180919085947.933674526@infradead.org
Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 arch/x86/mm/pageattr.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 101f3ad0d6ad..ab87da7a6043 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -239,26 +239,12 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 			    int in_flags, struct page **pages)
 {
 	unsigned int i, level;
-#ifdef CONFIG_PREEMPT
-	/*
-	 * Avoid wbinvd() because it causes latencies on all CPUs,
-	 * regardless of any CPU isolation that may be in effect.
-	 *
-	 * This should be extended for CAT enabled systems independent of
-	 * PREEMPT because wbinvd() does not respect the CAT partitions and
-	 * this is exposed to unpriviledged users through the graphics
-	 * subsystem.
-	 */
-	unsigned long do_wbinvd = 0;
-#else
-	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
-#endif
 
 	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
 
-	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
+	flush_tlb_all();
 
-	if (!cache || do_wbinvd)
+	if (!cache)
 		return;
 
 	/*
-- 
2.19.1.6.gb485710b

