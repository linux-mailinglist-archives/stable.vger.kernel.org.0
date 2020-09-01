Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08DB2596F0
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgIAQIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbgIAPjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:39:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D0120866;
        Tue,  1 Sep 2020 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974739;
        bh=VKgDTcJEVJkXNweGm1k2v0p1QcJy2uODm4rk7Clru80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWM+bxp3rinqYchMiOOw74VGSdkCnB+jvyD+ORpRCsVEoPmjiWch7HFZHb3SsVxfJ
         PO8b6xmoTZZYjRXiY2kqeAHJ1Kd1yFnMX0LkC66AUY68q6VM4QOXjA0DJ4H87AIDSo
         DhKkr2h6VuZoZ0wnWv/91gRnKiw//8SjqACG0tbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Sean Wang <sean.wang@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 075/255] pinctrl: mediatek: fix build for tristate changes
Date:   Tue,  1 Sep 2020 17:08:51 +0200
Message-Id: <20200901151004.326270183@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 047cd9a6bd8a2a73e8d92eb97a1b50c7bcd59279 ]

Export mtk_is_virt_gpio() for the case when
CONFIG_PINCTRL_MTK=y
CONFIG_PINCTRL_MTK_V2=y
CONFIG_PINCTRL_MTK_MOORE=y
CONFIG_PINCTRL_MTK_PARIS=m

to fix this build error:

ERROR: modpost: "mtk_is_virt_gpio" [drivers/pinctrl/mediatek/pinctrl-paris.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Sean Wang <sean.wang@kernel.org>
Cc: linux-mediatek@lists.infradead.org
Link: https://lore.kernel.org/r/d15827a3-d0c8-e231-9f61-8507b3d7be3a@infradead.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index c53e2c391e32b..2f3dfb56c3fa4 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -264,6 +264,7 @@ bool mtk_is_virt_gpio(struct mtk_pinctrl *hw, unsigned int gpio_n)
 
 	return virt_gpio;
 }
+EXPORT_SYMBOL_GPL(mtk_is_virt_gpio);
 
 static int mtk_xt_get_gpio_n(void *data, unsigned long eint_n,
 			     unsigned int *gpio_n,
-- 
2.25.1



