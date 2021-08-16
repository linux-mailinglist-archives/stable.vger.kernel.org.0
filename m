Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8274A3ED524
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbhHPNIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237673AbhHPNHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:07:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E30AF611C4;
        Mon, 16 Aug 2021 13:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119183;
        bh=VEUPOZXTtpy8l9wAIKpGWklm6YXw3/irO2n+X6ElW6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7YIcmbbnaO58hiVCB6ot551vkxI8Vqw0MuWZmpNgrBR8b20JU5JeZLV3KQHynBcc
         B3HMQjqXqWXsJ03WO3KImqNav5vGdfy2aSSs2XMRbsRmJrIkfmp9PTI1T3ABy2Ulcr
         u1XiMozszCQcqdpiT27P9354kEPg7+LPttNPV68c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Zhiyong Tao <zhiyong.tao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/96] pinctrl: mediatek: Fix fallback behavior for bias_set_combo
Date:   Mon, 16 Aug 2021 15:01:34 +0200
Message-Id: <20210816125435.740928622@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 798a315fc359aa6dbe48e09d802aa59b7e158ffc ]

Some pin doesn't support PUPD register, if it fails and fallbacks with
bias_set_combo case, it will call mtk_pinconf_bias_set_pupd_r1_r0() to
modify the PUPD pin again.

Since the general bias set are either PU/PD or PULLSEL/PULLEN, try
bias_set or bias_set_rev1 for the other fallback case. If the pin
doesn't support neither PU/PD nor PULLSEL/PULLEN, it will return
-ENOTSUPP.

Fixes: 81bd1579b43e ("pinctrl: mediatek: Fix fallback call path")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Zhiyong Tao <zhiyong.tao@mediatek.com>
Link: https://lore.kernel.org/r/20210701080955.2660294-1-hsinyi@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 7815426e7aea..10002b8497fe 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -926,12 +926,10 @@ int mtk_pinconf_adv_pull_set(struct mtk_pinctrl *hw,
 			err = hw->soc->bias_set(hw, desc, pullup);
 			if (err)
 				return err;
-		} else if (hw->soc->bias_set_combo) {
-			err = hw->soc->bias_set_combo(hw, desc, pullup, arg);
-			if (err)
-				return err;
 		} else {
-			return -ENOTSUPP;
+			err = mtk_pinconf_bias_set_rev1(hw, desc, pullup);
+			if (err)
+				err = mtk_pinconf_bias_set(hw, desc, pullup);
 		}
 	}
 
-- 
2.30.2



