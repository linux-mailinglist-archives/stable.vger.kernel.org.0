Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF531FE483
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgFRCSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbgFRBTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4C521D94;
        Thu, 18 Jun 2020 01:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443173;
        bh=PAz4pLAm9XEI1zL/Wk3wIS4gF+KjCk6zdfZrFFmni5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmDicJiaOVPEeaE9SeBPrHIw3HNemeH7crHTX22y8t0UhVoNjrHgMDYZtK5wMKwaA
         Icc7FWBxd/kepUY1JIAIXR4ZDerI4KzQif+gwwVPhbrWi8Wr02QE5AbYPYiVXoGMB/
         mlTFczn3eSS4OiLFy8tTYE4ySYOLbd/bfYTwR2Yk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 137/266] pinctrl: rockchip: fix memleak in rockchip_dt_node_to_map
Date:   Wed, 17 Jun 2020 21:14:22 -0400
Message-Id: <20200618011631.604574-137-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit d7faa8ffb6be57bf8233a4b5a636d76b83c51ce7 ]

In function rockchip_dt_node_to_map, a new_map variable is
allocated by:

new_map = devm_kcalloc(pctldev->dev, map_num, sizeof(*new_map),
		       GFP_KERNEL);

This uses devres and attaches new_map to the pinctrl driver.
This cause a leak since new_map is not released when the probed
driver is removed. Fix it by using kcalloc to allocate new_map
and free it in `rockchip_dt_free_map`

Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20200506100903.15420-1-dafna.hirschfeld@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index dc0bbf198cbc..1bd8840e11a6 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -506,8 +506,8 @@ static int rockchip_dt_node_to_map(struct pinctrl_dev *pctldev,
 	}
 
 	map_num += grp->npins;
-	new_map = devm_kcalloc(pctldev->dev, map_num, sizeof(*new_map),
-								GFP_KERNEL);
+
+	new_map = kcalloc(map_num, sizeof(*new_map), GFP_KERNEL);
 	if (!new_map)
 		return -ENOMEM;
 
@@ -517,7 +517,7 @@ static int rockchip_dt_node_to_map(struct pinctrl_dev *pctldev,
 	/* create mux map */
 	parent = of_get_parent(np);
 	if (!parent) {
-		devm_kfree(pctldev->dev, new_map);
+		kfree(new_map);
 		return -EINVAL;
 	}
 	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
@@ -544,6 +544,7 @@ static int rockchip_dt_node_to_map(struct pinctrl_dev *pctldev,
 static void rockchip_dt_free_map(struct pinctrl_dev *pctldev,
 				    struct pinctrl_map *map, unsigned num_maps)
 {
+	kfree(map);
 }
 
 static const struct pinctrl_ops rockchip_pctrl_ops = {
-- 
2.25.1

