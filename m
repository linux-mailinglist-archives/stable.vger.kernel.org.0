Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0AFA624F4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390065AbfGHPrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbfGHPTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:19:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 156C92166E;
        Mon,  8 Jul 2019 15:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599146;
        bh=ZqmW10D35p/x6y7IAQNUyGnMQXsoa6AxexrI/IJgfog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST7H5e4QF73WPKdFEVbmMxSgznbri/gdtWgzhyw3IgUoTO9boI+u4gO4TQ3WVi6Sx
         y1JyE84aEmEtyK6W41qQ+SImqYmkuF0lMf/Ezq9qSjmXt0okvLPIQD7YMDu3+yO6PH
         I9m6tLVt2drOI/58WpuxEqarIdQvBacihawDQfio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 020/102] drm/arm/hdlcd: Allow a bit of clock tolerance
Date:   Mon,  8 Jul 2019 17:12:13 +0200
Message-Id: <20190708150527.236742908@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
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
index 28341b32067f..84dea276175b 100644
--- a/drivers/gpu/drm/arm/hdlcd_crtc.c
+++ b/drivers/gpu/drm/arm/hdlcd_crtc.c
@@ -170,7 +170,8 @@ static int hdlcd_crtc_atomic_check(struct drm_crtc *crtc,
 	long rate, clk_rate = mode->clock * 1000;
 
 	rate = clk_round_rate(hdlcd->clk, clk_rate);
-	if (rate != clk_rate) {
+	/* 0.1% seems a close enough tolerance for the TDA19988 on Juno */
+	if (abs(rate - clk_rate) * 1000 > clk_rate) {
 		/* clock required by mode not supported by hardware */
 		return -EINVAL;
 	}
-- 
2.20.1



