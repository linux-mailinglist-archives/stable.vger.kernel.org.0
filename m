Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C53A49A4E0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2372043AbiAYAK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363973AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AEAC05A1BD;
        Mon, 24 Jan 2022 13:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 341E9B811FC;
        Mon, 24 Jan 2022 21:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E84DC340E4;
        Mon, 24 Jan 2022 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060419;
        bh=qGKPlBKi4dvM3k6D9aqxyYUFmALZfLKHSo5w9/UB2ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtCtCjlcvT0yNpTx5xw06rGH3Hd4i9Uy/fxpOkf9pKM5DGz164fHf9OI+5q54Xh6y
         AusBuoCyrigJ2doGul4Z5DOgBh33BPB1dmsDzKLbYMhlwYokghAur4ZIlt8sO3omRQ
         sOITUmPxddMwiuv9ZDFAPh48CjX0rXHuwrkDl7Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.16 0908/1039] drm/vc4: hdmi: Make sure the device is powered with CEC
Date:   Mon, 24 Jan 2022 19:44:57 +0100
Message-Id: <20220124184155.818941043@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -1736,8 +1736,14 @@ static int vc4_hdmi_cec_adap_enable(stru
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
@@ -1883,6 +1889,8 @@ static int vc4_hdmi_cec_init(struct vc4_
 	if (ret < 0)
 		goto err_remove_handlers;
 
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
+
 	return 0;
 
 err_remove_handlers:


