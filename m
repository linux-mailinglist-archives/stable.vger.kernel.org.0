Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713C24A96A0
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357387AbiBDJ1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53830 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357513AbiBDJ0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:26:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C471B836F7;
        Fri,  4 Feb 2022 09:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B39C004E1;
        Fri,  4 Feb 2022 09:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966761;
        bh=y7kUMDzkk7KxDwnhmT+pG870mIhhFOi4y36sO8vIdTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fA6yhIOE4XU0GBiC3yO4/FVpcZsmIv5BthZ8/6UY/h2lFce210QtP/cXMy6LDF6tX
         WKB5TuIYPBdaWEdtKlodDzK3pus0a+BVw0fQDaCW1rdBBC6yLa0Jj2mzV+D8TSAI9J
         /vaOuZ7MG1Zgi49Segvcgg0BzkKaWs/1i3+Az6Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.16 05/43] drm/vc4: hdmi: Make sure the device is powered with CEC
Date:   Fri,  4 Feb 2022 10:22:12 +0100
Message-Id: <20220204091917.363327130@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

Commit 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 upstream.

The original commit depended on a rework commit (724fc856c09e ("drm/vc4:
hdmi: Split the CEC disable / enable functions in two")) that
(rightfully) didn't reach stable.

However, probably because the context changed, when the patch was
applied to stable the pm_runtime_put called got moved to the end of the
vc4_hdmi_cec_adap_enable function (that would have become
vc4_hdmi_cec_disable with the rework) to vc4_hdmi_cec_init.

This means that at probe time, we now drop our reference to the clocks
and power domains and thus end up with a CPU hang when the CPU tries to
access registers.

The call to pm_runtime_resume_and_get() is also problematic since the
.adap_enable CEC hook is called both to enable and to disable the
controller. That means that we'll now call pm_runtime_resume_and_get()
at disable time as well, messing with the reference counting.

The behaviour we should have though would be to have
pm_runtime_resume_and_get() called when the CEC controller is enabled,
and pm_runtime_put when it's disabled.

We need to move things around a bit to behave that way, but it aligns
stable with upstream.

Cc: <stable@vger.kernel.org> # 5.10.x
Cc: <stable@vger.kernel.org> # 5.15.x
Cc: <stable@vger.kernel.org> # 5.16.x
Reported-by: Michael Stapelberg <michael+drm@stapelberg.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1739,18 +1739,18 @@ static int vc4_hdmi_cec_adap_enable(stru
 	u32 val;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
-	if (ret)
-		return ret;
+	if (enable) {
+		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+		if (ret)
+			return ret;
 
-	val = HDMI_READ(HDMI_CEC_CNTRL_5);
-	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
-		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
-		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
-	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
-	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
+		val = HDMI_READ(HDMI_CEC_CNTRL_5);
+		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
+			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
+			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
+		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
+			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
 
-	if (enable) {
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val);
@@ -1778,7 +1778,10 @@ static int vc4_hdmi_cec_adap_enable(stru
 			HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
+
+		pm_runtime_put(&vc4_hdmi->pdev->dev);
 	}
+
 	return 0;
 }
 
@@ -1889,8 +1892,6 @@ static int vc4_hdmi_cec_init(struct vc4_
 	if (ret < 0)
 		goto err_remove_handlers;
 
-	pm_runtime_put(&vc4_hdmi->pdev->dev);
-
 	return 0;
 
 err_remove_handlers:


