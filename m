Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF2B54FB8D
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383505AbiFQQwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 12:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382895AbiFQQve (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 12:51:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAABA52E60;
        Fri, 17 Jun 2022 09:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655484621; x=1687020621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7oB2+/tAQ0YbLfBu8lpkzq06X+Z13qiz2lNUmx1L1VE=;
  b=TSc2d8GQV5H5A3qjvuXlqso0m/bu/LaAu76xOdYLGOvEF86EFOGorLwg
   E+aVC+t+YI3YGo5JOzfpKDkuIgVu7TT54eQR3DKikv47DnAPtMTCpiyxC
   z1aFBeN7HZ3bwGdDmzTu+5HeTAX3/tSZMNLZdaGeDeUQ2oW5ASHcn+++b
   9bl+4oie4/CADKBht9H7UUsqtdXN1dkodmzP2KkQ3UmSBaYsStyFiAQIc
   a7gm82zkCg+CIMcWTrC5prBICeOT9eQwSMPwqrfkMOxa6Z3B3snEu2a97
   biczHl0Gq78U9czr6SsrmplqlFiYttN+sJ+2IX5RhhgWUs8yD6ucJXIEC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="365834503"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="365834503"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 07:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="763274799"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2022 07:40:40 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25HEeXl3024161;
        Fri, 17 Jun 2022 15:40:38 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>, Yury Norov <yury.norov@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matt Turner <mattst88@gmail.com>,
        Brian Cain <bcain@quicinc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Marco Elver <elver@google.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-alpha@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH v3 1/7] ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
Date:   Fri, 17 Jun 2022 16:40:25 +0200
Message-Id: <20220617144031.2549432-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617144031.2549432-1-alexandr.lobakin@intel.com>
References: <20220617144031.2549432-1-alexandr.lobakin@intel.com>
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
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
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
2.36.1

