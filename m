Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C901065AD
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfKVGZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:25:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfKVFu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E834620726;
        Fri, 22 Nov 2019 05:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401857;
        bh=7DS8nQvITiDoPvFXUkkqn4Bs2erk92HkQ7idQB7DNKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVzen5CMgELAgivuF50Dd0DugidYIwJDvntPJuh3SLat4nMpFh4f7PVogQEKtI5f1
         J850y1nFXhE5VN9knTYOfappAgxkS6wy9GTr3nVTaTqFFHcbgogERHpZkSPLFPzDSP
         Icrhe1mCIm6YBxQ9j64iwRQTqXGY6a9UlLr96LNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 094/219] pinctrl: sh-pfc: r8a77990: Fix MOD_SEL0 SEL_I2C1 field width
Date:   Fri, 22 Nov 2019 00:47:06 -0500
Message-Id: <20191122054911.1750-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 755a5b805fa7ff22e2934d67501efd92109f41ea ]

The SEL_I2C1 (MOD_SEL0[21:20]) field in Module Select Register 0 has a
width of 2 bits, i.e. it allows programming one out of 4 different
configurations.
However, the MOD_SEL0_21_20 macro contains 8 values instead of 4,
overflowing into the subsequent fields in the register, and thus breaking
the configuration of the latter.

Fix this by dropping the bogus last 4 values, including the non-existent
SEL_I2C1_4 configuration.

Fixes: 6d4036a1e3b3ac0f ("pinctrl: sh-pfc: Initial R8A77990 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a77990.c b/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
index b81c807ac54d5..d2fcf7f7b9668 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
@@ -395,7 +395,7 @@ FM(IP12_31_28)	IP12_31_28	FM(IP13_31_28)	IP13_31_28	FM(IP14_31_28)	IP14_31_28	FM
 #define MOD_SEL0_24		FM(SEL_HSCIF0_0)		FM(SEL_HSCIF0_1)
 #define MOD_SEL0_23		FM(SEL_HSCIF1_0)		FM(SEL_HSCIF1_1)
 #define MOD_SEL0_22		FM(SEL_HSCIF2_0)		FM(SEL_HSCIF2_1)
-#define MOD_SEL0_21_20		FM(SEL_I2C1_0)			FM(SEL_I2C1_1)			FM(SEL_I2C1_2)			FM(SEL_I2C1_3)		FM(SEL_I2C1_4)		F_(0, 0)	F_(0, 0)	F_(0, 0)
+#define MOD_SEL0_21_20		FM(SEL_I2C1_0)			FM(SEL_I2C1_1)			FM(SEL_I2C1_2)			FM(SEL_I2C1_3)
 #define MOD_SEL0_19_18_17	FM(SEL_I2C2_0)			FM(SEL_I2C2_1)			FM(SEL_I2C2_2)			FM(SEL_I2C2_3)		FM(SEL_I2C2_4)		F_(0, 0)	F_(0, 0)	F_(0, 0)
 #define MOD_SEL0_16		FM(SEL_NDFC_0)			FM(SEL_NDFC_1)
 #define MOD_SEL0_15		FM(SEL_PWM0_0)			FM(SEL_PWM0_1)
-- 
2.20.1

