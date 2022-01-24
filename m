Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB15B497D65
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 11:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiAXKuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 05:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiAXKuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 05:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39744C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 02:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34AC6612E5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E372AC340E1;
        Mon, 24 Jan 2022 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643021415;
        bh=mZSvZg+lAgVCMnURbbQf7SawHM1srUmoQ7y7eaKwk9I=;
        h=Subject:To:Cc:From:Date:From;
        b=gVognKfPqBY4vqR+vKiC+pVTuNDWSr14wpijOpnAkWoAtgSisn73mTxVA5VF9UIZa
         oscc3Llfwoj/omysRa1d1CKMP0HNFxfJvIQ7H8Pk7HrO6mvze/+MTU15XQCVnZOeJ8
         gX5Wn68eXx5AqvCemKVAZWqIR+s/v6IPxEa4dG7I=
Subject: FAILED: patch "[PATCH] drm/vc4: hdmi: Make sure the device is powered with CEC" failed to apply to 4.19-stable tree
To:     maxime@cerno.tech, dave.stevenson@raspberrypi.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 11:49:59 +0100
Message-ID: <1643021399119166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 Mon Sep 17 00:00:00 2001
From: Maxime Ripard <maxime@cerno.tech>
Date: Thu, 19 Aug 2021 15:59:30 +0200
Subject: [PATCH] drm/vc4: hdmi: Make sure the device is powered with CEC

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

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 1f13e0f00089..8cc84395f4cb 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1741,8 +1741,14 @@ static int vc4_hdmi_cec_enable(struct cec_adapter *adap)
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
@@ -1785,6 +1791,8 @@ static int vc4_hdmi_cec_disable(struct cec_adapter *adap)
 	HDMI_WRITE(HDMI_CEC_CNTRL_5, HDMI_READ(HDMI_CEC_CNTRL_5) |
 		   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
 
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
+
 	return 0;
 }
 

