Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96ABC49A9DC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323751AbiAYD3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376395AbiAXVFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82A4C06809C;
        Mon, 24 Jan 2022 12:05:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 857DC6091B;
        Mon, 24 Jan 2022 20:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE61C340E5;
        Mon, 24 Jan 2022 20:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054746;
        bh=rKSH15DjDk60dPicvYM3uCvRq8hCaBfQaC1tF+7WONQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcdH/lcNyJNdIE8XQ6ioBildZlFLTtrimq7fp3eVVPrTvyC55DNfBnMskbNZLfl52
         neGBoMh1SpzFRE/CZuTXiwLp9SEzKtFWVpf3Yv6rfB3sS11/CKnjEI6lAPUahmLob+
         r4CWsZX9Xsl/1bg1UqW8Ah8Yw/1kiWshaqf5+GDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.10 489/563] drm/vc4: hdmi: Make sure the device is powered with CEC
Date:   Mon, 24 Jan 2022 19:44:14 +0100
Message-Id: <20220124184041.353523380@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 upstream.

Similarly to what we encountered with the detect hook with DRM, nothing
actually prevents any of the CEC callback from being run while the HDMI
output is disabled.

However, this is an issue since any register access to the controller
when it's powered down will result in a silent hang.

Let's make sure we run the runtime_pm hooks when the CEC adapter is
opened and closed by the userspace to avoid that issue.

Fixes: 15b4511a4af6 ("drm/vc4: add HDMI CEC support")
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210819135931.895976-6-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1399,8 +1399,14 @@ static int vc4_hdmi_cec_adap_enable(stru
 	struct vc4_hdmi *vc4_hdmi = cec_get_drvdata(adap);
 	/* clock period in microseconds */
 	const u32 usecs = 1000000 / CEC_CLOCK_FREQ;
-	u32 val = HDMI_READ(HDMI_CEC_CNTRL_5);
+	u32 val;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+	if (ret)
+		return ret;
 
+	val = HDMI_READ(HDMI_CEC_CNTRL_5);
 	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
 		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
 		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
@@ -1525,6 +1531,8 @@ static int vc4_hdmi_cec_init(struct vc4_
 	if (ret < 0)
 		goto err_delete_cec_adap;
 
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
+
 	return 0;
 
 err_delete_cec_adap:


