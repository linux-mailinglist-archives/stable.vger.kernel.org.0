Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDACD450C35
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbhKORfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237801AbhKORah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84B856329C;
        Mon, 15 Nov 2021 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996801;
        bh=s24tg46ayL4Vmu7s2UeTIPhJWcU/NI+x76wjz0EoFgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxIvTJzM35736PQnD9Xmh/xtU/2qX2ZJ78gYQKU3qHCy9G+H3ffh2DBJKHbDuhMPS
         MyyAKPunqqa1cbw2caGRjlzFipiyeZPiFTlUX7GyXQm1P+zXtPCoxmsDEL5gDhEQfN
         cQei8gXkKsdsSOM5oHBVaxRfhP1wKfirJ845xM7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 271/355] clk: at91: check pmc node status before registering syscore ops
Date:   Mon, 15 Nov 2021 18:03:15 +0100
Message-Id: <20211115165322.503084537@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit c405f5c15e9f6094f2fa1658e73e56f3058e2122 ]

Currently, at91 pmc driver always register the syscore_ops whatever
the status of the pmc node that has been found. When set as secure
and disabled, the pmc should not be accessed or this will generate
abort exceptions.
To avoid this, add a check on node availability before registering
the syscore operations.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Link: https://lore.kernel.org/r/20210913082633.110168-1-clement.leger@bootlin.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Fixes: b3b02eac33ed ("clk: at91: Add sama5d2 suspend/resume")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/pmc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index b71515acdec1f..976ca41e9157e 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -275,6 +275,11 @@ static int __init pmc_register_ops(void)
 
 	np = of_find_matching_node(NULL, sama5d2_pmc_dt_ids);
 
+	if (!of_device_is_available(np)) {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
 	pmcreg = device_node_to_regmap(np);
 	if (IS_ERR(pmcreg))
 		return PTR_ERR(pmcreg);
-- 
2.33.0



