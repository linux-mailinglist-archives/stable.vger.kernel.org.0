Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4F11B4DF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbfLKPWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbfLKPWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE43C208C3;
        Wed, 11 Dec 2019 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077763;
        bh=mAf0WnQYeLV7ICC6KqevtF7PXWLFmXkLFXBJEdViVAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qldft/SXKn4MhWme+jV+Yr2OFSDLJE3AoLt7QAYPgkD1/1t+LWpvhUOL6HyRa0FIq
         rspJxqB53ydY933VL02tQqkvH+H7gSi0lXa88bti8yv4MnCeEnYP3cGbgjqRpuEN5B
         XnGMGG4jvLEYRZ7nB+4aRP55YP1qIO0YuUXt3m1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianxin Pan <jianxin.pan@amlogic.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/243] clk: meson: meson8b: fix the offset of vid_pll_dcos N value
Date:   Wed, 11 Dec 2019 16:05:24 +0100
Message-Id: <20191211150350.098521030@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 376d8c45bd6ac79f02ecf9ca1606dc5d1b271bc0 ]

Unlike the other PLLs on Meson8b the N value "vid_pll_dco" (a better
name would be hdmi_pll_dco or - as the datasheet calls it - HPLL) is
located at HHI_VID_PLL_CNTL[14:10] instead of [13:9].
This results in an incorrect calculation of the rate of this PLL because
the value seen by the kernel is double the actual N (divider) value.
Update the offset of the N value to fix the calculation of the PLL rate.

Fixes: 28b9fcd016126e ("clk: meson8b: Add support for Meson8b clocks")
Reported-by: Jianxin Pan <jianxin.pan@amlogic.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lkml.kernel.org/r/20181202214220.7715-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/meson8b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/meson/meson8b.c b/drivers/clk/meson/meson8b.c
index 9d79ff857d83e..e90af556ff90f 100644
--- a/drivers/clk/meson/meson8b.c
+++ b/drivers/clk/meson/meson8b.c
@@ -144,7 +144,7 @@ static struct clk_regmap meson8b_vid_pll = {
 		},
 		.n = {
 			.reg_off = HHI_VID_PLL_CNTL,
-			.shift   = 9,
+			.shift   = 10,
 			.width   = 5,
 		},
 		.od = {
-- 
2.20.1



