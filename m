Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F01499228
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347766AbiAXURj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41064 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348467AbiAXUOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:14:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07BE5611CD;
        Mon, 24 Jan 2022 20:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D757FC340E5;
        Mon, 24 Jan 2022 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055246;
        bh=7qanzDnN7eNEgxgtzBO5i6iPcUJCL9BcsN+rhJvQ00E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3wI++9eCl/abWo7CVH6jBRa7S5uMT09JAmRIEVbFr4+k0PcPi19iRx5SHDskcz4J
         GzjPs8avoQLUHTrdjwCbVxHmbJwCHqR4Bt8Dq5A3vg8JWAziltLtl+K66IKT55D4il
         ZZhlDavMz+4sv5y01ORLHqysGcmvkgi5zk+J1oYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/846] drm/vc4: hdmi: Set a default HSM rate
Date:   Mon, 24 Jan 2022 19:33:26 +0100
Message-Id: <20220124184104.060739850@linuxfoundation.org>
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
index ed8a4b7f8b6e2..623a4699bd212 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -94,6 +94,7 @@
 # define VC4_HD_M_SW_RST			BIT(2)
 # define VC4_HD_M_ENABLE			BIT(0)
 
+#define HSM_MIN_CLOCK_FREQ	120000000
 #define CEC_CLOCK_FREQ 40000
 
 #define HDMI_14_MAX_TMDS_CLK   (340 * 1000 * 1000)
@@ -2161,6 +2162,19 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
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



