Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4315C0225
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIUPsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiIUPrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:47:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FA091D13;
        Wed, 21 Sep 2022 08:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6608FB82714;
        Wed, 21 Sep 2022 15:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB644C433D6;
        Wed, 21 Sep 2022 15:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775246;
        bh=ROmjALs2aLv+mU6hjgmn6dS843ULyMub8FPpmP4DHrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSo/R639pqZVTsW+VBiAf702QNd8qOPx69MeadDxnaGfpdxKRJKobXNuhewY+ebz0
         WOBzHzY3XOBPyRGRvxU0r62QQHgZrxKzNEKT4/LlC58C/CF8jdcttxjAnhaqafyfdq
         1UXHWGWf5PecRReHlSSsfI+jB4a210T3D2924ZnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Sujaritha Sundaresan <sujaritha.sundaresan@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 28/38] drm/i915/gt: Fix perf limit reasons bit positions
Date:   Wed, 21 Sep 2022 17:46:12 +0200
Message-Id: <20220921153647.157448691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit d654f60898d56ffda461ef4ffd7bbe15159feb8d upstream.

Perf limit reasons bit positions were off by one.

Fixes: fa68bff7cf27 ("drm/i915/gt: Add sysfs throttle frequency interfaces")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Acked-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Sujaritha Sundaresan <sujaritha.sundaresan@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220908155821.1662110-1-ashutosh.dixit@intel.com
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit 60017f34fc334d1bb25476b0b0996b4073e76c90)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_reg.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1849,14 +1849,14 @@
 
 #define GT0_PERF_LIMIT_REASONS		_MMIO(0x1381a8)
 #define   GT0_PERF_LIMIT_REASONS_MASK	0xde3
-#define   PROCHOT_MASK			REG_BIT(1)
-#define   THERMAL_LIMIT_MASK		REG_BIT(2)
-#define   RATL_MASK			REG_BIT(6)
-#define   VR_THERMALERT_MASK		REG_BIT(7)
-#define   VR_TDC_MASK			REG_BIT(8)
-#define   POWER_LIMIT_4_MASK		REG_BIT(9)
-#define   POWER_LIMIT_1_MASK		REG_BIT(11)
-#define   POWER_LIMIT_2_MASK		REG_BIT(12)
+#define   PROCHOT_MASK			REG_BIT(0)
+#define   THERMAL_LIMIT_MASK		REG_BIT(1)
+#define   RATL_MASK			REG_BIT(5)
+#define   VR_THERMALERT_MASK		REG_BIT(6)
+#define   VR_TDC_MASK			REG_BIT(7)
+#define   POWER_LIMIT_4_MASK		REG_BIT(8)
+#define   POWER_LIMIT_1_MASK		REG_BIT(10)
+#define   POWER_LIMIT_2_MASK		REG_BIT(11)
 
 #define CHV_CLK_CTL1			_MMIO(0x101100)
 #define VLV_CLK_CTL2			_MMIO(0x101104)


