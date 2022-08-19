Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D513B59A3CE
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353279AbiHSQmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353730AbiHSQkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C945124F7A;
        Fri, 19 Aug 2022 09:09:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA7E9614DA;
        Fri, 19 Aug 2022 16:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DB6C433C1;
        Fri, 19 Aug 2022 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925313;
        bh=OdsdjjtAm2+QWCcdhVZzboUF4nGAiGDh8SnobGJMTGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ma4M2pjYQJzS7YYpzHGA4GnFHmc5jrl+SpIqCgYd8vgcGWKr2+g2lbFIMI3dQhvck
         VIKZd6FHF6xLtxX7Dd/dLGSVHzyBMQE7q/hINi/SAJYZBzR1m3A88XpPZihQeYhuU/
         8gohyHZ+5AFb6CqWw4VGUfWTxByNkhesD/QSUZG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 452/545] drm/i915/dg1: Update DMC_DEBUG3 register
Date:   Fri, 19 Aug 2022 17:43:42 +0200
Message-Id: <20220819153849.636088991@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Chuansheng Liu <chuansheng.liu@intel.com>

[ Upstream commit b60668cb4c57a7cc451de781ae49f5e9cc375eaf ]

Current DMC_DEBUG3(_MMIO(0x101090)) address is for TGL,
it is wrong for DG1. Just like commit 5bcc95ca382e
("drm/i915/dg1: Update DMC_DEBUG register"), correct
this issue for DG1 platform to avoid wrong register
being read.

BSpec: 49788

v2: fix "not wrong" typo. (Jani)

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220211002933.84240-1-chuansheng.liu@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_debugfs.c | 4 ++--
 drivers/gpu/drm/i915/i915_reg.h                      | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_debugfs.c b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
index 0bf31f9a8af5..e6780fcc5006 100644
--- a/drivers/gpu/drm/i915/display/intel_display_debugfs.c
+++ b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
@@ -526,8 +526,8 @@ static int i915_dmc_info(struct seq_file *m, void *unused)
 		 * reg for DC3CO debugging and validation,
 		 * but TGL DMC f/w is using DMC_DEBUG3 reg for DC3CO counter.
 		 */
-		seq_printf(m, "DC3CO count: %d\n",
-			   intel_de_read(dev_priv, DMC_DEBUG3));
+		seq_printf(m, "DC3CO count: %d\n", intel_de_read(dev_priv, IS_DGFX(dev_priv) ?
+					DG1_DMC_DEBUG3 : TGL_DMC_DEBUG3));
 	} else {
 		dc5_reg = IS_BROXTON(dev_priv) ? BXT_CSR_DC3_DC5_COUNT :
 						 SKL_CSR_DC3_DC5_COUNT;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index f1ab26307db6..04157d8ced32 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7546,7 +7546,8 @@ enum {
 #define TGL_DMC_DEBUG_DC5_COUNT	_MMIO(0x101084)
 #define TGL_DMC_DEBUG_DC6_COUNT	_MMIO(0x101088)
 
-#define DMC_DEBUG3		_MMIO(0x101090)
+#define TGL_DMC_DEBUG3		_MMIO(0x101090)
+#define DG1_DMC_DEBUG3		_MMIO(0x13415c)
 
 /* Display Internal Timeout Register */
 #define RM_TIMEOUT		_MMIO(0x42060)
-- 
2.35.1



