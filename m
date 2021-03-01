Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190A4328BF9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240543AbhCASnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:43:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240353AbhCASit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:38:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F6F16510E;
        Mon,  1 Mar 2021 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618913;
        bh=29peClinjeSOXWIDssJv6bqRyMkgcWu5UhMsZ9ZDo2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEOtiP6RweHUg8Fmb+j1MvL9M2qWhIRKlWgGbS2NBspjk6x8YPhU+ENQqnqPaSIwP
         SJgRjbcUrLzWohYz5jShs4uP48Tq5GToZvg+VweceJzZ4kfiRFx/n/+nJ8QjBP8wLx
         FXWJmmY3SR3wDqXSWMPsT3/b60pmgblLxPf1NhWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/663] drm/vc4: hdmi: Compute the CEC clock divider from the clock rate
Date:   Mon,  1 Mar 2021 17:08:01 +0100
Message-Id: <20210301161153.339781630@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 163a3ef681e5e9d5df558e855d86ccd4708d6200 ]

The CEC clock divider needs to output a frequency of 40kHz from the HSM
rate on the BCM2835. The driver used to have a fixed frequency for it,
but that changed for the BCM2711 and we now need to compute it
dynamically to maintain the proper rate.

Fixes: cd4cb49dc5bb ("drm/vc4: hdmi: Adjust HSM clock rate depending on pixel rate")
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111142309.193441-7-maxime@cerno.tech
(cherry picked from commit f1ceb9d10043683b89e5e5e5848fb4e855295762)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 879c1fe0565de..08b3f9c87e6ec 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1468,6 +1468,7 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 {
 	struct cec_connector_info conn_info;
 	struct platform_device *pdev = vc4_hdmi->pdev;
+	u16 clk_cnt;
 	u32 value;
 	int ret;
 
@@ -1493,8 +1494,9 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	 * divider: the hsm_clock rate and this divider setting will
 	 * give a 40 kHz CEC clock.
 	 */
+	clk_cnt = clk_get_rate(vc4_hdmi->hsm_clock) / CEC_CLOCK_FREQ;
 	value |= VC4_HDMI_CEC_ADDR_MASK |
-		 (4091 << VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT);
+		 (clk_cnt << VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT);
 	HDMI_WRITE(HDMI_CEC_CNTRL_1, value);
 	ret = devm_request_threaded_irq(&pdev->dev, platform_get_irq(pdev, 0),
 					vc4_cec_irq_handler,
-- 
2.27.0



