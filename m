Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF74AAAF0
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380956AbiBESeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:34:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380931AbiBESeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:34:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BAE56119E;
        Sat,  5 Feb 2022 18:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8C5C340E8;
        Sat,  5 Feb 2022 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644086047;
        bh=SJEmG7sBtALjZ5vYUbaI3CkNzUfq5p/ZKIHm/YIO0ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW0ONNvFXUY5GlKIJZvzJ4VrqnN5fRvxwfvqAMNvmxVv1HyVDX9lXBfxGfwsbmzyi
         QeW/aDT77Z3q44e/2AhwVfr6Ud2Rq5SVlLHfqknsD1Aelz1y8bl3Aow9prXbvorK0N
         oQkOxNb6Zv1/3IFMy1uGw15DJjv7Zim/Hl46DE48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.98
Date:   Sat,  5 Feb 2022 19:33:56 +0100
Message-Id: <1644086035217144@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1644086035165161@kroah.com>
References: <1644086035165161@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9f328bfcaf97..10827bec74d8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 97
+SUBLEVEL = 98
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 8eac7dc637b0..5d5c4e9a8621 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1399,21 +1399,15 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	struct vc4_hdmi *vc4_hdmi = cec_get_drvdata(adap);
 	/* clock period in microseconds */
 	const u32 usecs = 1000000 / CEC_CLOCK_FREQ;
-	u32 val;
-	int ret;
-
-	if (enable) {
-		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
-		if (ret)
-			return ret;
+	u32 val = HDMI_READ(HDMI_CEC_CNTRL_5);
 
-		val = HDMI_READ(HDMI_CEC_CNTRL_5);
-		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
-			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
-			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
-		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
-			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
+	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
+		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
+		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
+	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
+	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
 
+	if (enable) {
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val);
@@ -1439,10 +1433,7 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
-
-		pm_runtime_put(&vc4_hdmi->pdev->dev);
 	}
-
 	return 0;
 }
 
