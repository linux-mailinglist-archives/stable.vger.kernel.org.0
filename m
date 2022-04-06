Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF494F6B27
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiDFUUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiDFUUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCAD91ACF;
        Wed,  6 Apr 2022 11:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB76561CAF;
        Wed,  6 Apr 2022 18:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9972C385A3;
        Wed,  6 Apr 2022 18:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269629;
        bh=U3Or1bcDh4RmwtjDk+VMAFzvah/CEKtaKgXoyBwRsoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8sT3VrAqYHZq1633bz0n3bFc6Tn3ri/PRtQqE+/S/aNSoVKGZHeFGxXPmiJTivcr
         w2OWHFbMUoN/QrOPxDyE5A9G13VMsB04TM8m6Z47pl/x5NAxwnkNRg8LcJKWOZmQd7
         wrvq6PK0CToUMV2ixTSfk2W7YabcPSwF9o+7oiYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Tianhong <dingtianhong@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 12/43] clocksource/drivers/arm_arch_timer: Remove fsl-a008585 parameter
Date:   Wed,  6 Apr 2022 20:26:21 +0200
Message-Id: <20220406182437.041802301@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ding Tianhong <dingtianhong@huawei.com>

commit 5444ea6a7f46276876e94ecf8d44615af1ef22f7 upstream.

Having a command line option to flip the errata handling for a
particular erratum is a little bit unusual, and it's vastly superior to
pass this in the DT. By common consensus, it's best to kill off the
command line parameter.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
[Mark: split patch, reword commit message]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt  |    9 ---------
 drivers/clocksource/arm_arch_timer.c |   14 --------------
 2 files changed, 23 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -751,15 +751,6 @@ bytes respectively. Such letter suffixes
 			loops can be debugged more effectively on production
 			systems.
 
-	clocksource.arm_arch_timer.fsl-a008585=
-			[ARM64]
-			Format: <bool>
-			Enable/disable the workaround of Freescale/NXP
-			erratum A-008585.  This can be useful for KVM
-			guests, if the guest device tree doesn't show the
-			erratum.  If unspecified, the workaround is
-			enabled based on the device tree.
-
 	clearcpuid=BITNUM [X86]
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -101,20 +101,6 @@ EXPORT_SYMBOL_GPL(arch_timer_read_ool_en
 
 static int fsl_a008585_enable = -1;
 
-static int __init early_fsl_a008585_cfg(char *buf)
-{
-	int ret;
-	bool val;
-
-	ret = strtobool(buf, &val);
-	if (ret)
-		return ret;
-
-	fsl_a008585_enable = val;
-	return 0;
-}
-early_param("clocksource.arm_arch_timer.fsl-a008585", early_fsl_a008585_cfg);
-
 u32 __fsl_a008585_read_cntp_tval_el0(void)
 {
 	return __fsl_a008585_read_reg(cntp_tval_el0);


