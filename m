Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B955073E
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfFXKFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729820AbfFXKEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:53 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4CA205ED;
        Mon, 24 Jun 2019 10:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370692;
        bh=FetlrdchN7oAWuBliIG6imsOL7E0QglN4LHd39Hgjh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ey6Odkwl2iJ/gDB34Aqm1REMfKElahG8LpB8L5PNzAVsb9TARKm/kAIjaq5ZWzt+Y
         Idh1vvCi0qew1hAu7X4E6k3sgIIDQVJl7gvXvMx8WUuxkJl7FKj362Axn0/0gk355k
         Nnie/9vZH/N9B4P02atZwbvAvaXC4vuon09gX+3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/90] drm/arm/hdlcd: Allow a bit of clock tolerance
Date:   Mon, 24 Jun 2019 17:56:47 +0800
Message-Id: <20190624092317.858285737@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1c810739097fdeb31b393b67a0a1e3d7ffdd9f63 ]

On the Arm Juno platform, the HDLCD pixel clock is constrained to 250KHz
resolution in order to avoid the tiny System Control Processor spending
aeons trying to calculate exact PLL coefficients. This means that modes
like my oddball 1600x1200 with 130.89MHz clock get rejected since the
rate cannot be matched exactly. In practice, though, this mode works
quite happily with the clock at 131MHz, so let's relax the check to
allow a little bit of slop.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/hdlcd_crtc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/hdlcd_crtc.c b/drivers/gpu/drm/arm/hdlcd_crtc.c
index d5c1a0b1f01a..e69d996eabad 100644
--- a/drivers/gpu/drm/arm/hdlcd_crtc.c
+++ b/drivers/gpu/drm/arm/hdlcd_crtc.c
@@ -193,7 +193,8 @@ static enum drm_mode_status hdlcd_crtc_mode_valid(struct drm_crtc *crtc,
 	long rate, clk_rate = mode->clock * 1000;
 
 	rate = clk_round_rate(hdlcd->clk, clk_rate);
-	if (rate != clk_rate) {
+	/* 0.1% seems a close enough tolerance for the TDA19988 on Juno */
+	if (abs(rate - clk_rate) * 1000 > clk_rate) {
 		/* clock required by mode not supported by hardware */
 		return MODE_NOCLOCK;
 	}
-- 
2.20.1



