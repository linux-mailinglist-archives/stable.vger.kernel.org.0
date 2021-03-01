Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C57328BC7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbhCASiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239876AbhCASeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:34:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4836060200;
        Mon,  1 Mar 2021 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620778;
        bh=Re+qalLPlqw9GmM+XvYZxgiSgrFuLrMIUItUAZvQM24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8y1UjsFO9bDnN5V3iUZkwqSJn6NvS3xTsVOXBQ7SwPDk0K76ccddq89ZgvNkM0L9
         zZp3giJqU6CfoHzmfh3akpd1fEgN3nJKYbHPry5+BwXOlpAM3KrBdrNu00DtY4bx6U
         pGugATworlrKA9DV7scxav0ens2EZfG81keU7/08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 277/775] drm/vc4: hdmi: Compute the CEC clock divider from the clock rate
Date:   Mon,  1 Mar 2021 17:07:25 +0100
Message-Id: <20210301161215.318473079@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index a9a6552bdae93..eff9014750e2d 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1467,6 +1467,7 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 {
 	struct cec_connector_info conn_info;
 	struct platform_device *pdev = vc4_hdmi->pdev;
+	u16 clk_cnt;
 	u32 value;
 	int ret;
 
@@ -1492,8 +1493,9 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
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



