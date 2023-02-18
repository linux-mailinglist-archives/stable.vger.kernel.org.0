Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AC669B993
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBRLGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBRLGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:06:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAFA1A4B1
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:06:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E51AB8229B
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BA1C433D2;
        Sat, 18 Feb 2023 11:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676718392;
        bh=komzbNo6mSBRl3265I72MD68ZRQOQCVSDMY+DWZUyq4=;
        h=Subject:To:Cc:From:Date:From;
        b=vGm1t9feUlcSv5MMtjHkXNC1jvgiMxyVG94mayliy7RIp1OW/U8AJXN7FQhReFaK7
         vwjElf/p1Efx/EHSbL6COKi6JIz+MNntBYt2PDoAzXXapBcMs3hMaPuPHKvoPARns0
         zlUFIaiA3HM0xgLdGzuqOUiwarLND5xTfmqU786E=
Subject: FAILED: patch "[PATCH] drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT" failed to apply to 5.15-stable tree
To:     matthew.d.roper@intel.com, gustavo.sousa@intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:06:30 +0100
Message-ID: <167671839021235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d5a1224aa68c ("drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list")
67b858dd8993 ("drm/i915/gen11: Moving WAs to icl_gt_workarounds_init()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d5a1224aa68c8b124a4c5c390186e571815ed390 Mon Sep 17 00:00:00 2001
From: Matt Roper <matthew.d.roper@intel.com>
Date: Wed, 1 Feb 2023 14:28:29 -0800
Subject: [PATCH] drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT
 list

The UNSLICE_UNIT_LEVEL_CLKGATE register programmed by this workaround
has 'BUS' style reset, indicating that it does not lose its value on
engine resets.  Furthermore, this register is part of the GT forcewake
domain rather than the RENDER domain, so it should not be impacted by
RCS engine resets.  As such, we should implement this on the GT
workaround list rather than an engine list.

Bspec: 19219
Fixes: 3551ff928744 ("drm/i915/gen11: Moving WAs to rcs_engine_wa_init()")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230201222831.608281-2-matthew.d.roper@intel.com
(cherry picked from commit 5f21dc07b52eb54a908e66f5d6e05a87bcb5b049)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 949c19339015..a0740308555d 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1355,6 +1355,13 @@ icl_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 		    GAMT_CHKN_BIT_REG,
 		    GAMT_CHKN_DISABLE_L3_COH_PIPE);
 
+	/*
+	 * Wa_1408615072:icl,ehl  (vsunit)
+	 * Wa_1407596294:icl,ehl  (hsunit)
+	 */
+	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
+		    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
+
 	/* Wa_1407352427:icl,ehl */
 	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
 		    PSDUNIT_CLKGATE_DIS);
@@ -2539,13 +2546,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_masked_en(wal, GEN9_CSFE_CHICKEN1_RCS,
 			     GEN11_ENABLE_32_PLANE_MODE);
 
-		/*
-		 * Wa_1408615072:icl,ehl  (vsunit)
-		 * Wa_1407596294:icl,ehl  (hsunit)
-		 */
-		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
-			    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
-
 		/*
 		 * Wa_1408767742:icl[a2..forever],ehl[all]
 		 * Wa_1605460711:icl[a0..c0]

