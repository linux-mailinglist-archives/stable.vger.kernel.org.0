Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32C769CE2D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjBTN5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjBTN47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:56:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524781EFCB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FEA160EA0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEBFC433EF;
        Mon, 20 Feb 2023 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901385;
        bh=EdLLzfipr8enHf/NYK4avEko70jsQeKRumPFACQ1QbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8IhEkR+Qzm029G0xTxBkReATeb6V/xgiY5+Z+RMwS/Zv7Qtml7eOnKb0QTfF/hlX
         e86Oi2EdRKzJQJgLc3xilAmoA3g4/n5c99BYbL46yRFmF4BqXmiuO3r2xHE12oSvHD
         EugAu7GDV6NZrVy+sRzYN3AuUHbG5LHonBbV8kCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Harrison <John.C.Harrison@Intel.com>,
        Raviteja Goud Talla <ravitejax.goud.talla@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/57] drm/i915/gen11: Moving WAs to icl_gt_workarounds_init()
Date:   Mon, 20 Feb 2023 14:36:55 +0100
Message-Id: <20230220133551.019919308@linuxfoundation.org>
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

From: Raviteja Goud Talla <ravitejax.goud.talla@intel.com>

[ Upstream commit 67b858dd89932086ae0ee2d0ce4dd070a2c88bb3 ]

Bspec page says "Reset: BUS", Accordingly moving w/a's:
Wa_1407352427,Wa_1406680159 to proper function icl_gt_workarounds_init()
Which will resolve guc enabling error

v2:
  - Previous patch rev2 was created by email client which caused the
    Build failure, This v2 is to resolve the previous broken series

Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Raviteja Goud Talla <ravitejax.goud.talla@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211203145603.4006937-1-ravitejax.goud.talla@intel.com
Stable-dep-of: d5a1224aa68c ("drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 4a3bde7c9f217..5c92789504d01 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1212,6 +1212,15 @@ icl_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		    GAMT_CHKN_BIT_REG,
 		    GAMT_CHKN_DISABLE_L3_COH_PIPE);
 
+	/* Wa_1407352427:icl,ehl */
+	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
+		    PSDUNIT_CLKGATE_DIS);
+
+	/* Wa_1406680159:icl,ehl */
+	wa_write_or(wal,
+		    SUBSLICE_UNIT_LEVEL_CLKGATE,
+		    GWUNIT_CLKGATE_DIS);
+
 	/* Wa_1607087056:icl,ehl,jsl */
 	if (IS_ICELAKE(i915) ||
 	    IS_EHL_REVID(i915, EHL_REVID_A0, EHL_REVID_A0)) {
@@ -1823,15 +1832,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
 			    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
 
-		/* Wa_1407352427:icl,ehl */
-		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
-			    PSDUNIT_CLKGATE_DIS);
-
-		/* Wa_1406680159:icl,ehl */
-		wa_write_or(wal,
-			    SUBSLICE_UNIT_LEVEL_CLKGATE,
-			    GWUNIT_CLKGATE_DIS);
-
 		/*
 		 * Wa_1408767742:icl[a2..forever],ehl[all]
 		 * Wa_1605460711:icl[a0..c0]
-- 
2.39.0



