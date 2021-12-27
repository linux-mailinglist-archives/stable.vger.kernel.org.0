Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55C7480381
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhL0TDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:03:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40756 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhL0TDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:03:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C985AB810BA;
        Mon, 27 Dec 2021 19:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4389EC36AE7;
        Mon, 27 Dec 2021 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631810;
        bh=WY7/IBQQ7PCl+D+qAmJBhE5XKqIk0FCvNlIT9/7d9Q8=;
        h=From:To:Cc:Subject:Date:From;
        b=J8ngXBKahixF83dT0V7W8ipBzgGEeJq1b4oLb5mMznhSNIN3eNAE9cDvz4dD6JeL6
         wUMRktxHO1It/46XEeSqPxxVoqaQdvdkWjbYR0crKXvDyL5LUPM2sLxAv0l0z/Ev5p
         JMERrwTyG6dtGVmL26T5n1oEj32qgGyteu2oiZPTdoKoLD9RqmUFhjzrtDRDuv2Jxr
         nwO8Zk+KzR3l3gVsg8LkHd8P9RdcsPn8eSLPuZSSv4SnI0NgrNY03VsSEi1vMpwazK
         owAqZvrT4hBo3O5xBWQpjnjTt4iZujWubLrMvreaQMtkjsnD+Csjpw/m/gdvHEAXyM
         cnKvL/JYMTYBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>,
        Zhiyong Tao <zhiyong.tao@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, sean.wang@kernel.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 01/26] pinctrl: mediatek: fix global-out-of-bounds issue
Date:   Mon, 27 Dec 2021 14:03:02 -0500
Message-Id: <20211227190327.1042326-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>

[ Upstream commit 2d5446da5acecf9c67db1c9d55ae2c3e5de01f8d ]

When eint virtual eint number is greater than gpio number,
it maybe produce 'desc[eint_n]' size globle-out-of-bounds issue.

Signed-off-by: Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>
Signed-off-by: Zhiyong Tao <zhiyong.tao@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20211110071900.4490-2-zhiyong.tao@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 45ebdeba985ae..12163d3c4bcb0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -285,8 +285,12 @@ static int mtk_xt_get_gpio_n(void *data, unsigned long eint_n,
 	desc = (const struct mtk_pin_desc *)hw->soc->pins;
 	*gpio_chip = &hw->chip;
 
-	/* Be greedy to guess first gpio_n is equal to eint_n */
-	if (desc[eint_n].eint.eint_n == eint_n)
+	/*
+	 * Be greedy to guess first gpio_n is equal to eint_n.
+	 * Only eint virtual eint number is greater than gpio number.
+	 */
+	if (hw->soc->npins > eint_n &&
+	    desc[eint_n].eint.eint_n == eint_n)
 		*gpio_n = eint_n;
 	else
 		*gpio_n = mtk_xt_find_eint_num(hw, eint_n);
-- 
2.34.1

