Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C205255AB
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 21:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiELTXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 15:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352238AbiELTXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 15:23:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11A56D4F1
        for <stable@vger.kernel.org>; Thu, 12 May 2022 12:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652383392; x=1683919392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=miXhrNsIPH7MVMZP+KGm8Yejsvd+J8yPZ2x4pbcdxVc=;
  b=np46+UQuVjhbF+4myx8ATGk10ZaEPClf+sk9eljk89/5rtV8LJR4nOpc
   uD87MDj1oGlumsTrjl6xEB/D+yabO4btxqVTwJ9FVs1tiIJn7BpAiw9UB
   EzYwD2pmwnjkwbwiEZgjcNQeIw4MHiGSoSiQlxBPnlYDQLxo/xXfRXRZQ
   nWWDbWlN+cSfGdHmCLuuZWWGrpSA031wOT4GBEOjuPHbyPsFIYIpCWJqp
   k+pH1hPHJFzxsFQz6JvLX2T0rxZJzM+7TkY/IfuRFbA0odaVCwi8pWl+5
   Var4r9eCRxJfKB0FtQtVvzJaZnkM7wEkfZb7iqEY/c3agQ0WKlX1Bdj8W
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="356545873"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="356545873"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 12:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="542924506"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2022 12:23:10 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 24CJN7RV028699;
        Thu, 12 May 2022 20:23:07 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     linux-drivers-review@eclists.intel.com
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/6] ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
Date:   Thu, 12 May 2022 21:21:53 +0200
Message-Id: <20220512192158.3723647-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220512192158.3723647-1-alexandr.lobakin@intel.com>
References: <20220512192158.3723647-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

test_bit(), as any other bitmap op, takes `unsigned long *` as a
second argument (pointer to the actual bitmap), as any bitmap
itself is an array of unsigned longs. However, the ia64_get_irr()
code passes a ref to `u64` as a second argument.
This works with the ia64 bitops implementation due to that they
have `void *` as the second argument and then cast it later on.
This works with the bitmap API itself due to that `unsigned long`
has the same size on ia64 as `u64` (`unsigned long long`), but
from the compiler PoV those two are different.
Define @irr as `unsigned long` to fix that. That implies no
functional changes. Has been hidden for 16 years!

Fixes: a58786917ce2 ("[IA64] avoid broken SAL_CACHE_FLUSH implementations")
Cc: stable@vger.kernel.org # 2.6.16+
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 arch/ia64/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 7cbce290f4e5..757c2f6d8d4b 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -538,7 +538,7 @@ ia64_get_irr(unsigned int vector)
 {
 	unsigned int reg = vector / 64;
 	unsigned int bit = vector % 64;
-	u64 irr;
+	unsigned long irr;
 
 	switch (reg) {
 	case 0: irr = ia64_getreg(_IA64_REG_CR_IRR0); break;
-- 
2.35.3

