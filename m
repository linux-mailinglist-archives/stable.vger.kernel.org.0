Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E9E6DCCC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389076AbfGSENM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389065AbfGSENL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:13:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29ADE21851;
        Fri, 19 Jul 2019 04:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509591;
        bh=TqdL7f/PqMNcy5u2uewEklBWw4dH4clfQc1IDLslypA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzTAYCmBMU80aoKb9MXfe+/YYvLPAJEq2pBRMmMx8XQI3UCNReRYRjDD9dkEQgPKZ
         PZLRYAFXfbnUrtbvZnJe3QorRYlbWDOfNwFKxmVSJLL4iQUvyK0+WziFaPcNdfeo6v
         YNZR9O5Z3Z6TnlGYyjAxJ12lKQeGLn7Ef0nThwq4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-gpio@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 04/45] pinctrl: rockchip: fix leaked of_node references
Date:   Fri, 19 Jul 2019 00:12:23 -0400
Message-Id: <20190719041304.18849-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
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
index f826793e972c..417cd3bd7e0c 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2208,6 +2208,7 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank,
 						    base,
 						    &rockchip_regmap_config);
 		}
+		of_node_put(node);
 	}
 
 	bank->irq = irq_of_parse_and_map(bank->of_node, 0);
-- 
2.20.1

