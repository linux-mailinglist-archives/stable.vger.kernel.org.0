Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B4265D776
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbjADPo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239574AbjADPoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:44:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF80A34751
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:44:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71FFCB816B7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCA1C433D2;
        Wed,  4 Jan 2023 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672847062;
        bh=cEsuAOOP0ycV6N3BCVYQIpXnaa8OqJ+J8bo5KMPM6W8=;
        h=Subject:To:Cc:From:Date:From;
        b=0SxyVBP+cA+UM50CsgoKbFdUsvlkFi4dJ2fNF7WES8CVTLEdRMk/3gbO9NWZxhtmA
         GI+X2m95nPp6CNS6C+3GW8ptynvjuDU03iajRIZEQa1Jo5Ibm+v7+7ffEiz2+CS1lZ
         crTo/4w7isbymw9iBzG7xLxgjzJof/sUNrRXGtvc=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index" failed to apply to 6.1-stable tree
To:     jani.nikula@intel.com, rodrigo.vivi@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:44:19 +0100
Message-ID: <1672847059102181@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6217e9f05a74 ("drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index")
963bbdb32b47 ("drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence")
8cee664d3eb6 ("drm/i915: use proper helper for register updates")
e58c2cac2c21 ("drm/i915/display: Use intel_uncore alias if defined")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6217e9f05a74df48c77ee68993d587cdfdb1feb7 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Tue, 20 Dec 2022 16:01:05 +0200
Subject: [PATCH] drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Due to copy-paste fail, MIPI_BKLT_EN_1 would always use PPS index 1,
never 0. Fix the sloppiest commit in recent memory.

Fixes: 963bbdb32b47 ("drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221220140105.313333-1-jani.nikula@intel.com
(cherry picked from commit a561933c571798868b5fa42198427a7e6df56c09)
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index 41f025f089d9..2cbc1292ab38 100644
--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -430,7 +430,7 @@ static void icl_native_gpio_set_value(struct drm_i915_private *dev_priv,
 		break;
 	case MIPI_BKLT_EN_1:
 	case MIPI_BKLT_EN_2:
-		index = gpio == MIPI_AVDD_EN_1 ? 0 : 1;
+		index = gpio == MIPI_BKLT_EN_1 ? 0 : 1;
 
 		intel_de_rmw(dev_priv, PP_CONTROL(index), EDP_BLC_ENABLE,
 			     value ? EDP_BLC_ENABLE : 0);

