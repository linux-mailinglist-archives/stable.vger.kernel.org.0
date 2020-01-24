Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D49147F6B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732412AbgAXLCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387928AbgAXLCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:02:05 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C7F32075D;
        Fri, 24 Jan 2020 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863725;
        bh=Z9zyaKEYsqnFvREbUmhGZ9Y95eR5DwryFtQWe4UXLrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFsw6NHcl2TLA2cq/4D9Lpz24O3WnCOHXrson5crrqpF5SozVTTlL69T8Tl56vapL
         YRqaDpThab2aKa9p6Iq5HDmH2mY1s5yayvj9fG8SCTNlfsXmv07Q7pkZUGnBX2tGZl
         nmNnF3sOnnWC5BToT1Guvk2/PXS25vC3/yhBiuS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/639] drm/sun4i: hdmi: Fix double flag assignation
Date:   Fri, 24 Jan 2020 10:23:48 +0100
Message-Id: <20200124093054.673742546@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit 1e0ff648940e603cab6c52cf3723017d30d78f30 ]

The is_double flag is a boolean currently assigned to the value of the d
variable, that is either 1 or 2. It means that this is_double variable is
always set to true, even though the initial intent was to have it set to
true when d is 2.

Fix this.

Fixes: 9c5681011a0c ("drm/sun4i: Add HDMI support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Reviewed-by: Giulio Benetti <giulio.benetti@micronovasrl.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181021163446.29135-2-maxime.ripard@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c
index 3ecffa52c8146..a74adec6c5dcd 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c
@@ -52,7 +52,7 @@ static unsigned long sun4i_tmds_calc_divider(unsigned long rate,
 			    (rate - tmp_rate) < (rate - best_rate)) {
 				best_rate = tmp_rate;
 				best_m = m;
-				is_double = d;
+				is_double = (d == 2) ? true : false;
 			}
 		}
 	}
-- 
2.20.1



