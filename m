Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91648452616
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbhKPCBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240144AbhKOSF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A423563382;
        Mon, 15 Nov 2021 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998184;
        bh=susqupJ+Dygupq88Lp3tGxosSgZU+Qn+gXubyF3rN+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NseE01rCzg1xdBqi+J1hedOA6PegKYz3A8O0rvOuNT18Qd7Ghad+kpfKXLzYoSCj9
         Dxvnh6y9bK/ORG3LpfPllMjgCUeZe/Ur1mRLzRQmnoEal481v9XXpAMaptdfVZ1TRb
         GPLib6S2RUcJCxLYpnTe5SjUNofSsigfpQRZtvUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/575] clk: at91: check pmc node status before registering syscore ops
Date:   Mon, 15 Nov 2021 18:02:23 +0100
Message-Id: <20211115165358.213867087@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 20ee9dccee787..b40035b011d0a 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -267,6 +267,11 @@ static int __init pmc_register_ops(void)
 	if (!np)
 		return -ENODEV;
 
+	if (!of_device_is_available(np)) {
+		of_node_put(np);
+		return -ENODEV;
+	}
+
 	pmcreg = device_node_to_regmap(np);
 	of_node_put(np);
 	if (IS_ERR(pmcreg))
-- 
2.33.0



