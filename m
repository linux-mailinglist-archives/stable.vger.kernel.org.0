Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A1E5662ED
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 08:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiGEGCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 02:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiGEGC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 02:02:29 -0400
Received: from out199-6.us.a.mail.aliyun.com (out199-6.us.a.mail.aliyun.com [47.90.199.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BB6BCA5
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 23:02:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VIQiBhI_1657000942;
Received: from localhost.localdomain(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0VIQiBhI_1657000942)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 14:02:23 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Wen Yang <simon.wy@alibaba-inc.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.9] x86/mm/cpa: Unconditionally avoid WBINDV when we can
Date:   Tue,  5 Jul 2022 14:02:09 +0800
Message-Id: <20220705060209.22806-3-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220705060209.22806-1-wenyang@linux.alibaba.com>
References: <20220705060209.22806-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <simon.wy@alibaba-inc.com>

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
Cc: <stable@vger.kernel.org> # 4.9.x: d2479a3: x86/pti: Fix boot problems from Global-bit setting
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 arch/x86/mm/pageattr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a586faeab0e5..e1b5b603eb48 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -215,13 +215,12 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 			    int in_flags, struct page **pages)
 {
 	unsigned int i, level;
-	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
 
 	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
 
-	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
+	flush_tlb_all();
 
-	if (!cache || do_wbinvd)
+	if (!cache)
 		return;
 
 	/*
-- 
2.19.1.6.gb485710b

