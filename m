Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8D57643F
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiGOPQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGOPQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:16:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23D3326EC;
        Fri, 15 Jul 2022 08:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657898176; x=1689434176;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WRHSubit+Lk19ufdasQNizHHZwCF18420UwzZxf6a8w=;
  b=LE4/cLSbfI0y/0abW/EijQzbYytTUCLQzkcUe/qBf5RcHTOF+ecmwKjc
   emD7hTXDHOwlgXbRubGih5EUw/NyVYa61xX0VxiB/+hwhGtEmC7etNiW1
   yDRQkCedpMRvsQgX0riLKuYAZB8p/vn7Dfc1FJkfebw/05S/O2IU9535K
   LEwq4b4rk5ia4on2eSmtHrvMgVjJnpXQMrKo4o32CxNPiDDiN3KYB0h9I
   nO4n8Jp54PdpJQsaiHCTzU6zNUqp/kQO3R80LV661HqQok/e3xMmV9V6H
   00IX4cI+KJIYNMItWRAoKRSG52kUcn2LO+nbLLejxHjislMpKSQDI5T6b
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286955082"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="286955082"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 08:16:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="723109285"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 15 Jul 2022 08:16:13 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26FFGBwn012966;
        Fri, 15 Jul 2022 16:16:11 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH] x86/olpc: fix 'logical not is only applied to the left hand side'
Date:   Fri, 15 Jul 2022 17:15:36 +0200
Message-Id: <20220715151536.67401-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bitops compile-time optimization series revealed one more
problem in olpc-xo1-sci.c:send_ebook_state(), resulted in GCC
warnings:

arch/x86/platform/olpc/olpc-xo1-sci.c: In function 'send_ebook_state':
arch/x86/platform/olpc/olpc-xo1-sci.c:83:63: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
   83 |         if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
      |                                                               ^~
arch/x86/platform/olpc/olpc-xo1-sci.c:83:13: note: add parentheses around left hand side expression to silence this warning

Despite this code working as intended, this redundant double
negation of boolean value, together with comparing to `char`
with no explicit conversion to bool, makes compilers think
the author made some unintentional logical mistakes here.
Make it the other way around and negate the char instead
to silence the warnings.

Fixes: d2aa37411b8e ("x86/olpc/xo1/sci: Produce wakeup events for buttons and switches")
Cc: stable@vger.kernel.org # 3.5+
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-and-tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 arch/x86/platform/olpc/olpc-xo1-sci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index f03a6883dcc6..89f25af4b3c3 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -80,7 +80,7 @@ static void send_ebook_state(void)
 		return;
 	}
 
-	if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
+	if (test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == !!state)
 		return; /* Nothing new to report. */
 
 	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);
-- 
2.36.1

