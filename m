Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36737353E82
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhDEJGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238720AbhDEJGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:06:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF797613A3;
        Mon,  5 Apr 2021 09:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613557;
        bh=wn/9FINT1L9GJVH4RmwjtlSZL1DRmq/bpG9Dx7yKUVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3E+ljqHHsUocmtsHls9ywXSAHAjxw1MmZNp5cTEVUT/kGhdo64tdC8oEgYelIsE/
         iKZg6PkBsUWu/5EU/Z7UFo9jU/Y/Yoxs0QE3+WVpmioYjFZ36rzVgVHVtFNw9j25ZB
         CudP0p3hm3umfFIDwc85k375sS0/Ii2nZ/bFzAY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianqun Xu <jay.xu@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Wang Panzhenzhuan <randy.wang@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 56/74] pinctrl: rockchip: fix restore error in resume
Date:   Mon,  5 Apr 2021 10:54:20 +0200
Message-Id: <20210405085026.551514381@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
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
@@ -3386,12 +3386,15 @@ static int __maybe_unused rockchip_pinct
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


