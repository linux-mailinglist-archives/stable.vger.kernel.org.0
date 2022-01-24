Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003AF499C02
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574589AbiAXV6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576167AbiAXVxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:53:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F340EC07A97E;
        Mon, 24 Jan 2022 12:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 943C4614EC;
        Mon, 24 Jan 2022 20:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C1BC340E5;
        Mon, 24 Jan 2022 20:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056474;
        bh=f8+DzzjtvvnxDthTcjNQ/23aDxrL03Fv6o1cZ2WdV3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrTp55f5cY/eYO/S5kTlZv3WBLz3Zg0NrD16iy5vNCg3bGpcMG1+gTcBRxtzP4DKE
         coty7of/lslEuOEtRsLrDqBFeXRtAKUhSpvMmSn2driQWRyxrkfWCA8aZ90IGGSJDE
         N8llQVH+nZhPoENhlYErVW4+0mXs2+QxDbCaTCk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Suman Anna <s-anna@ti.com>, Nishanth Menon <nm@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/846] soc: ti: pruss: fix referenced node in error message
Date:   Mon, 24 Jan 2022 19:40:13 +0100
Message-Id: <20220124184118.115451640@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



