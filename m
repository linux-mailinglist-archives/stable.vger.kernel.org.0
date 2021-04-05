Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ADE353CE2
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhDEI5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhDEI5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE6661394;
        Mon,  5 Apr 2021 08:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613024;
        bh=A4Ev3rsh+10sLAdNk5zWl9n9T5YWpez7mU5IgvbvWRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjqPMvsw/IHhnCDqBmhAPleyfnOqqsV52dERUy8h8kP8l4xd6QXnKOY8TrTQIvJor
         C7bp6307SAA0L24zu91+rxKQ/m3H54EueJmHy95NjtocUn102c1cBAbV21moYwwH0I
         G5MhgJbD1nZIX3V6xS1FI5ap7fKuC6PzR37yFAUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianqun Xu <jay.xu@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Wang Panzhenzhuan <randy.wang@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.9 24/35] pinctrl: rockchip: fix restore error in resume
Date:   Mon,  5 Apr 2021 10:53:59 +0200
Message-Id: <20210405085019.641171953@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Panzhenzhuan <randy.wang@rock-chips.com>

commit c971af25cda94afe71617790826a86253e88eab0 upstream.

The restore in resume should match to suspend which only set for RK3288
SoCs pinctrl.

Fixes: 8dca933127024 ("pinctrl: rockchip: save and restore gpio6_c6 pinmux in suspend/resume")
Reviewed-by: Jianqun Xu <jay.xu@rock-chips.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Wang Panzhenzhuan <randy.wang@rock-chips.com>
Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
Link: https://lore.kernel.org/r/20210223100725.269240-1-jay.xu@rock-chips.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-rockchip.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2367,12 +2367,15 @@ static int __maybe_unused rockchip_pinct
 static int __maybe_unused rockchip_pinctrl_resume(struct device *dev)
 {
 	struct rockchip_pinctrl *info = dev_get_drvdata(dev);
-	int ret = regmap_write(info->regmap_base, RK3288_GRF_GPIO6C_IOMUX,
-			       rk3288_grf_gpio6c_iomux |
-			       GPIO6C6_SEL_WRITE_ENABLE);
+	int ret;
 
-	if (ret)
-		return ret;
+	if (info->ctrl->type == RK3288) {
+		ret = regmap_write(info->regmap_base, RK3288_GRF_GPIO6C_IOMUX,
+				   rk3288_grf_gpio6c_iomux |
+				   GPIO6C6_SEL_WRITE_ENABLE);
+		if (ret)
+			return ret;
+	}
 
 	return pinctrl_force_default(info->pctl_dev);
 }


