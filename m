Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFA04F01DF
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354926AbiDBNDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354907AbiDBNDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:03:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF497140A4
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 06:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96886B80885
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C41C340EE;
        Sat,  2 Apr 2022 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648904477;
        bh=FobrzUVpRaLLiOX7fJ43MUXv/7z2h1kGZfVOQBwBZiM=;
        h=Subject:To:Cc:From:Date:From;
        b=MrMn/lNvPwbtud02fhG0HT9CR7wtEQH0otMZHh6AW5KoFgoP319RtPl3cf0SxLkNL
         /xDpHUlhcYviVtkSPWCfRmtw6NslcCFh3mRTTdI8GuA8RwnW1OQ4Bho01iho/BdIEt
         rFXmehlI8/1erPWAMSgQBilwflHheHPwNd2XCL9o=
Subject: FAILED: patch "[PATCH] drm/i915/display/adlp: Implement new step in the TC voltage" failed to apply to 5.17-stable tree
To:     jose.souza@intel.com, Clinton.A.Taylor@intel.com,
        clinton.a.taylor@intel.com, imre.deak@intel.com,
        jani.nikula@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 15:01:15 +0200
Message-ID: <1648904475148227@kroah.com>
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5ff59dddacd4738edcbd01847d9df7682348cf86 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Date: Thu, 13 Jan 2022 09:48:26 -0800
Subject: [PATCH] drm/i915/display/adlp: Implement new step in the TC voltage
 swing prog sequence
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

TC voltage swing programming sequence was updated with a new step.

BSpec: 54956
Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Clint Taylor <clinton.a.taylor@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220113174826.50272-1-jose.souza@intel.com

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 6ee0f77b7927..4e93eac926a5 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -1300,6 +1300,28 @@ static void tgl_dkl_phy_set_signal_levels(struct intel_encoder *encoder,
 
 		intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
 			     DKL_TX_DP20BITMODE, 0);
+
+		if (IS_ALDERLAKE_P(dev_priv)) {
+			u32 val;
+
+			if (intel_crtc_has_type(crtc_state, INTEL_OUTPUT_HDMI)) {
+				if (ln == 0) {
+					val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(0);
+					val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(2);
+				} else {
+					val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(3);
+					val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(3);
+				}
+			} else {
+				val = DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(0);
+				val |= DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(0);
+			}
+
+			intel_de_rmw(dev_priv, DKL_TX_DPCNTL2(tc_port),
+				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK |
+				     DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK,
+				     val);
+		}
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b3a05ed86734..4424807c8dec 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -9968,8 +9968,12 @@ enum skl_power_gate {
 						     _DKL_PHY2_BASE) + \
 						     _DKL_TX_DPCNTL1)
 
-#define _DKL_TX_DPCNTL2				0x2C8
-#define  DKL_TX_DP20BITMODE				(1 << 2)
+#define _DKL_TX_DPCNTL2					0x2C8
+#define  DKL_TX_DP20BITMODE				REG_BIT(2)
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK	REG_GENMASK(4, 3)
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1(val)	REG_FIELD_PREP(DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX1_MASK, (val))
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK	REG_GENMASK(6, 5)
+#define  DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2(val)	REG_FIELD_PREP(DKL_TX_DPCNTL2_CFG_LOADGENSELECT_TX2_MASK, (val))
 #define DKL_TX_DPCNTL2(tc_port) _MMIO(_PORT(tc_port, \
 						     _DKL_PHY1_BASE, \
 						     _DKL_PHY2_BASE) + \

