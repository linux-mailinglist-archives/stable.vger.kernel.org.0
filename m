Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B991C6E033
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfGSD5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbfGSD5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0566A21852;
        Fri, 19 Jul 2019 03:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508630;
        bh=n4tzgIJGYk/RW0+7lrFTK5XGxFRsx5zPbIlfOt2bBmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIqahlJH1vg7HGfq9TGHiOdBxjSey8lsN+MJ+znsfO95csp6NsjLVbU9xwTLdGL1q
         yVRYLWYGlFLwhNRHrLqAVWbdlNrRzLnrqmqk0vDbyBH36dEnn/YxP8v6jKrSvCtJtZ
         MFtyz/nuy/x1DLZX90eIB33FpxT+gVteneC3xTMs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-gpio@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 012/171] pinctrl: rockchip: fix leaked of_node references
Date:   Thu, 18 Jul 2019 23:54:03 -0400
Message-Id: <20190719035643.14300-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 3c89c70634bb0b6f48512de873e7a45c7e1fbaa5 ]

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/pinctrl/pinctrl-rockchip.c:3221:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 3196, but without a corresponding object release within this function.
./drivers/pinctrl/pinctrl-rockchip.c:3223:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 3196, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-gpio@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 807a3263d849..62a622159006 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -3204,6 +3204,7 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank,
 						    base,
 						    &rockchip_regmap_config);
 		}
+		of_node_put(node);
 	}
 
 	bank->irq = irq_of_parse_and_map(bank->of_node, 0);
-- 
2.20.1

