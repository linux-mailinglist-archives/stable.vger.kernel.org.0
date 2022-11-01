Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A401B6148C4
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiKAL3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiKAL2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7436C2652;
        Tue,  1 Nov 2022 04:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D214F615DD;
        Tue,  1 Nov 2022 11:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226E6C433B5;
        Tue,  1 Nov 2022 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302105;
        bh=7r1QOHV06h+9wzOcTmWBQcgWcXag41HhBfVH04SzsOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doCpQkVEkrCtyIEp6fXWy5cc8w+s4OPCSdGLPiwU9wNq8/mJ8KVFyRlueJwsAVsRO
         5cNz7UkqW+Vxu6wTM6sVqITv9DbwBLBjXjKw1eZ6uwDwyfcykxaHs5GxP1taNJXyd+
         Ohp0YDJIpBZL1g1FrFTcHm6Aab0IPW5jEpwt5OWCC/+D7XGGuFnbEcxKOr4ZlgNLq3
         jt3GZ+jtGzbDvni3FujWG9P1sw/+jIAQ3kmSrSOf9jGqqJPJbrbMQTLZr9K84T+ga3
         fxZH0RNfGkb1OQn3/1ORuKUBXX5t7nHSbo/qrWx8NLcz/vx24t2Pc+uH4EkRxdVMvd
         iF+bUxlcjw+RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 20/34] drm/vc4: hdmi: Check the HSM rate at runtime_resume
Date:   Tue,  1 Nov 2022 07:27:12 -0400
Message-Id: <20221101112726.799368-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 4190e8bbcbc77a9c36724681801cedc5229e7fc2 ]

If our HSM clock has not been properly initialized, any register access
will silently lock up the system.

Let's check that this can't happen by adding a check for the rate before
any register access, and error out otherwise.

Link: https://lore.kernel.org/dri-devel/20220922145448.w3xfywkn5ecak2et@pengutronix.de/
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220929-rpi-pi3-unplugged-fixes-v1-2-cd22e962296c@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 1e5f68704d7d..3d8fc32b4d08 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2869,12 +2869,28 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 	unsigned long __maybe_unused flags;
 	u32 __maybe_unused value;
+	unsigned long rate;
 	int ret;
 
 	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
 	if (ret)
 		return ret;
 
+	/*
+	 * Whenever the RaspberryPi boots without an HDMI monitor
+	 * plugged in, the firmware won't have initialized the HSM clock
+	 * rate and it will be reported as 0.
+	 *
+	 * If we try to access a register of the controller in such a
+	 * case, it will lead to a silent CPU stall. Let's make sure we
+	 * prevent such a case.
+	 */
+	rate = clk_get_rate(vc4_hdmi->hsm_clock);
+	if (!rate) {
+		ret = -EINVAL;
+		goto err_disable_clk;
+	}
+
 	if (vc4_hdmi->variant->reset)
 		vc4_hdmi->variant->reset(vc4_hdmi);
 
@@ -2896,6 +2912,10 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 #endif
 
 	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(vc4_hdmi->hsm_clock);
+	return ret;
 }
 
 static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
-- 
2.35.1

