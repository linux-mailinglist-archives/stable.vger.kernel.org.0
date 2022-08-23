Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B2759DE6F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbiHWLie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242125AbiHWLhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:37:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE94C992A;
        Tue, 23 Aug 2022 02:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6225161330;
        Tue, 23 Aug 2022 09:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E27C433D7;
        Tue, 23 Aug 2022 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246889;
        bh=mGkh9x3LB0kpL5XkmS7qHndStB4OsfpUDJQhVibN7SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lG7poJproGqvf8ig+bF+WnCK8/0CDi9R/6ub81hc7/9mP8HXbblvUuCwUO8CejGSs
         3QiutQ1UTMIe3zfTIQNIO2Jr0+ohk+6GDYoqYudxxyT4yPi9XxaOx5ljV5uuGl5DG7
         q5GYq8nNl1QOiCFg4KLtF7sXkb/cmeL94oV+TP14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        kernel test robot <lkp@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 5.4 252/389] x86/olpc: fix logical not is only applied to the left hand side
Date:   Tue, 23 Aug 2022 10:25:30 +0200
Message-Id: <20220823080126.119312764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Alexander Lobakin <alexandr.lobakin@intel.com>

commit 3a2ba42cbd0b669ce3837ba400905f93dd06c79f upstream.

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
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/olpc/olpc-xo1-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -81,7 +81,7 @@ static void send_ebook_state(void)
 		return;
 	}
 
-	if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
+	if (test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == !!state)
 		return; /* Nothing new to report. */
 
 	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);


