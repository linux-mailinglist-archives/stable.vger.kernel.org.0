Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB2499563
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392623AbiAXUvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47080 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390927AbiAXUqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96893B80FA1;
        Mon, 24 Jan 2022 20:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC97EC340E5;
        Mon, 24 Jan 2022 20:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057198;
        bh=BItfNGfUUbAV/nLpEBTDpo2VvhTunofOvRGfFxsF9mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLFVmRq3ZfcbmSJ8to4Dof/WNKa3XIE7lRN5Xw46n4mS3S018n3EjdWrjOHaeH8kF
         2kGCj4GE8xVKolMOglbve1sUdkiz9er3aP33859RD/+i3Wrx0xDVXUCbXIkU/kfPhN
         l3WEDk6ufCYHH2DVNcNWKx1N4KRH4h/O3NHaCxMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.15 734/846] drm/vc4: hdmi: Make sure the device is powered with CEC
Date:   Mon, 24 Jan 2022 19:44:11 +0100
Message-Id: <20220124184126.318677950@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -1735,8 +1735,14 @@ static int vc4_hdmi_cec_adap_enable(stru
 	struct vc4_hdmi *vc4_hdmi = cec_get_drvdata(adap);
 	/* clock period in microseconds */
 	const u32 usecs = 1000000 / CEC_CLOCK_FREQ;
-	u32 val = HDMI_READ(HDMI_CEC_CNTRL_5);
+	u32 val;
+	int ret;
 
+	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+	if (ret)
+		return ret;
+
+	val = HDMI_READ(HDMI_CEC_CNTRL_5);
 	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
 		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
 		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
@@ -1882,6 +1888,8 @@ static int vc4_hdmi_cec_init(struct vc4_
 	if (ret < 0)
 		goto err_remove_handlers;
 
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
+
 	return 0;
 
 err_remove_handlers:


