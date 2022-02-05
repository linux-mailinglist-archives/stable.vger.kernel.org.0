Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95F44AAAEC
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380929AbiBESeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbiBESeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:34:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6DEC061348;
        Sat,  5 Feb 2022 10:34:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF2926119E;
        Sat,  5 Feb 2022 18:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B68C340E8;
        Sat,  5 Feb 2022 18:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644086039;
        bh=ab935xd8+Elw+NfzFHxe6p6i1Cpe23NlVb7gpAfUQ1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6shGF56jjYwsjlWiPRmn0nAYi2ki4kIBqOTnRKbOurOO2MqyZ8Kg8K1Oj+3bMeJf
         OYEvkkWgPZM/lArTrJVF/a0lCafrv69wWfihMTmBtGq/welVdMkFRFCA1TPbD3mhw0
         JckpyZgaoSUGvDPERkmQQLCko5JmDex9AWwpA6Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.21
Date:   Sat,  5 Feb 2022 19:33:50 +0100
Message-Id: <1644086029126106@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164408602952101@kroah.com>
References: <164408602952101@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3643400c15d8..b4770cdda9b6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 20
+SUBLEVEL = 21
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 2d532c0fe819..e880bdd8dcfd 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1735,21 +1735,15 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
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
@@ -1777,10 +1771,7 @@ static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
 			HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
 		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
 			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
-
-		pm_runtime_put(&vc4_hdmi->pdev->dev);
 	}
-
 	return 0;
 }
 
