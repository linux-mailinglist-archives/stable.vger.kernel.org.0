Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84756491723
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344684AbiARCiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:38:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45156 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344563AbiARCez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:34:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D04C4B8123D;
        Tue, 18 Jan 2022 02:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8DAC36AEF;
        Tue, 18 Jan 2022 02:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473292;
        bh=f8+DzzjtvvnxDthTcjNQ/23aDxrL03Fv6o1cZ2WdV3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chEn3aQLPKrkFYuwWjbWrUt3H268ihJBHoGUn2dqXEt2qnmB3a/BieGwsQSgyONxQ
         U7X7m2+rzNDRtuV7+8zivodBz/thZe48vx7+Ciqmrmu5CKjj2SkQL+pfu09+yzlCmP
         HXenG2rlPDuaJcqPivje12ff+7XqWzlHe0jVZHQVn83B3QsJbMtkha7dmbKtkGqaUZ
         swh5kaFLQvRci5k/Huv8lYRwDCBcKtkjJn80UQR+cMehH68HFTudMIforNsmkXuKgm
         tNbz6q4h9sYrBo2jV/gtP5AGbBLE9EmjGnAPmzIwobZMXwvKNenYWJJNlkSFzPZC3x
         R+pxglVHg0pDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>, Suman Anna <s-anna@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 054/188] soc: ti: pruss: fix referenced node in error message
Date:   Mon, 17 Jan 2022 21:29:38 -0500
Message-Id: <20220118023152.1948105-54-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit 8aa35e0bb5eaa42bac415ad0847985daa7b4890c ]

So far, "(null)" is reported for the node that is missing clocks.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/d6e24953-ea89-fd1c-6e16-7a0142118054@siemens.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/pruss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index 49da387d77494..b36779309e49b 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -129,7 +129,7 @@ static int pruss_clk_init(struct pruss *pruss, struct device_node *cfg_node)
 
 	clks_np = of_get_child_by_name(cfg_node, "clocks");
 	if (!clks_np) {
-		dev_err(dev, "%pOF is missing its 'clocks' node\n", clks_np);
+		dev_err(dev, "%pOF is missing its 'clocks' node\n", cfg_node);
 		return -ENODEV;
 	}
 
-- 
2.34.1

