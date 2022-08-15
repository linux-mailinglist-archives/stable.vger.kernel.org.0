Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49AF594989
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiHOXLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353068AbiHOXKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:10:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A805379A55;
        Mon, 15 Aug 2022 13:00:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275E2B80EA8;
        Mon, 15 Aug 2022 20:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F22EC433C1;
        Mon, 15 Aug 2022 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593601;
        bh=StjgcR6nA87Jhlh+ZwYMvS8/tCMtuZEn7F+G7iUqQg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RujZWniObrL4LjPtnXPjATjxxJsxRZtPMyYZlf0qslmBjIqS1gC144qEt7uFXmRuX
         oe/4hCFkllsHD24gN5A/0Oxzkj1S6kTRlb0SD7xS1BiIjk4FB3GGn8+bS8mIi73f7w
         +M5eVlw3rvXOH7ClYxyI4g68xo64SX94GexlMUqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        kernel test robot <lkp@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 5.18 0974/1095] x86/olpc: fix logical not is only applied to the left hand side
Date:   Mon, 15 Aug 2022 20:06:13 +0200
Message-Id: <20220815180509.382223212@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
@@ -80,7 +80,7 @@ static void send_ebook_state(void)
 		return;
 	}
 
-	if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
+	if (test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == !!state)
 		return; /* Nothing new to report. */
 
 	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);


