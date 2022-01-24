Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC171499669
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349371AbiAXVDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:03:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50102 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443556AbiAXU5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:57:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25FF9611C8;
        Mon, 24 Jan 2022 20:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A2BC340E5;
        Mon, 24 Jan 2022 20:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057837;
        bh=4V4cxWlmyZvF0156r5z/jnCjIkSbiX6J5fCpOPi18WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jchcq3oREjjcK/wq+xfV5Jua6WNcX5BeKZNtOmU6E0cFS6S07LY6dqeDgpHfsPbBb
         HrHCiWq8vha9+HiaYlbKAgynaEyQwuRqKiydr51zb/q/CGgBGK9KaqGFWh4iXYKMU3
         coGnbLTgwjbeLUZoqBVwO/YWCrEBlBKARWZKQdOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0096/1039] drm/vc4: hdmi: Set a default HSM rate
Date:   Mon, 24 Jan 2022 19:31:25 +0100
Message-Id: <20220124184128.387367217@linuxfoundation.org>
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

[ Upstream commit 3e85b81591609bb794bb00cd619b20965b5b38cd ]

When the firmware doesn't setup the HSM rate (such as when booting
without an HDMI cable plugged in), its rate is 0 and thus any register
access results in a CPU stall, even though HSM is enabled.

Let's enforce a minimum rate at boot to avoid this issue.

Fixes: 4f6e3d66ac52 ("drm/vc4: Add runtime PM support to the HDMI encoder driver")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210922125419.4125779-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index b284623e28634..33f61e2f7e6d1 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -94,6 +94,7 @@
 # define VC4_HD_M_SW_RST			BIT(2)
 # define VC4_HD_M_ENABLE			BIT(0)
 
+#define HSM_MIN_CLOCK_FREQ	120000000
 #define CEC_CLOCK_FREQ 40000
 
 #define HDMI_14_MAX_TMDS_CLK   (340 * 1000 * 1000)
@@ -2162,6 +2163,19 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 			vc4_hdmi->disable_4kp60 = true;
 	}
 
+	/*
+	 * If we boot without any cable connected to the HDMI connector,
+	 * the firmware will skip the HSM initialization and leave it
+	 * with a rate of 0, resulting in a bus lockup when we're
+	 * accessing the registers even if it's enabled.
+	 *
+	 * Let's put a sensible default at runtime_resume so that we
+	 * don't end up in this situation.
+	 */
+	ret = clk_set_min_rate(vc4_hdmi->hsm_clock, HSM_MIN_CLOCK_FREQ);
+	if (ret)
+		goto err_put_ddc;
+
 	if (vc4_hdmi->variant->reset)
 		vc4_hdmi->variant->reset(vc4_hdmi);
 
-- 
2.34.1



