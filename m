Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E03B797F6
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389429AbfG2Tpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389684AbfG2Tpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103592054F;
        Mon, 29 Jul 2019 19:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429533;
        bh=8JFWAouRfci5VnEtp4/OWU62qL5P6hS03Li64OSWmEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4DRSkQB6iRxr+bTP19zVolf7/L4TevBPdWTMdulWc4ZFHC091/sf6HGZDFCH4Fjd
         caDpODQyGoVtcHKzoyQrpYBK5TcKgQKCrzxJDGH2ASr5se/U/XezVlQpuoeLw24iZd
         si55W6HenwIn2BrSMNw5EPkzOUJe6Qoxurc1B1Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-gpio@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 015/215] pinctrl: rockchip: fix leaked of_node references
Date:   Mon, 29 Jul 2019 21:20:11 +0200
Message-Id: <20190729190742.091745059@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



