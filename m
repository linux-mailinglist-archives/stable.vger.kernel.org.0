Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F2D497344
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbiAWQx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbiAWQx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:53:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABB0C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 08:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2CB60FA3
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E179C340E2;
        Sun, 23 Jan 2022 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956808;
        bh=tfu09xlCVB1JyP18cj9DlCQwz7tt8SpeHN2J6BtF8sI=;
        h=Subject:To:Cc:From:Date:From;
        b=TrjiYCeytp9saKk4B6EPyHJ0uhVQnxZ8kD4BpqozfbecCW6tpqb1hC7nG+Ir4R2Ud
         Dl5m1kp2g+Y0l+i0WLJ+mv7Rno2qvniFqyeZvAlat2oSjvWFvj4PKyOMJdWdgoVbDb
         ICeLKqgrSRHP1QKPYb/dsuuJfw9/XOvwzi5HMvzg=
Subject: FAILED: patch "[PATCH] drm/i915/display/adlp: Implement new step in the TC voltage" failed to apply to 5.16-stable tree
To:     jose.souza@intel.com, Clinton.A.Taylor@intel.com,
        clinton.a.taylor@intel.com, imre.deak@intel.com,
        jani.nikula@linux.intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:53:25 +0100
Message-ID: <16429568053411@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e26602be4869c74dd8a0f66f718b8a0ce120edb4 Mon Sep 17 00:00:00 2001
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
(cherry picked from commit 5ff59dddacd4738edcbd01847d9df7682348cf86)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 9c9d574f0b8c..cab505277595 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -1298,6 +1298,28 @@ static void tgl_dkl_phy_set_signal_levels(struct intel_encoder *encoder,
 
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
index 4c28dadf8d69..971d601fe751 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -11166,8 +11166,12 @@ enum skl_power_gate {
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

