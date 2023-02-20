Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDB869CE34
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjBTN5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjBTN5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:57:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801031E9D0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62DF560EA1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71010C433D2;
        Mon, 20 Feb 2023 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901392;
        bh=GqKcTgJxgu3baZPW6wFl+pbBvEwfQfrTF6fLPb0V6HE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDqeBJcky2hTRo+kz4gX6CjAYURcI6MzkEPDbadpgHc15mJaohezsctWVnC1qZBhe
         ehPPDovVkpITbXsbEk5hMX8z2grV7b3lDzoX4wTB3YUqsSQ8PDWeG7u8GJ3ua1g2bz
         wIaQLCVmP8nyFwwO8M2izru6LNvTdhguzqsv8/oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Roper <matthew.d.roper@intel.com>,
        Gustavo Sousa <gustavo.sousa@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/57] drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list
Date:   Mon, 20 Feb 2023 14:36:56 +0100
Message-Id: <20230220133551.048848396@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit d5a1224aa68c8b124a4c5c390186e571815ed390 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 5c92789504d01..ae5cf2b55e159 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1212,6 +1212,13 @@ icl_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
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
@@ -1825,13 +1832,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
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
-- 
2.39.0



