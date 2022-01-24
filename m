Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6187B4990F9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354588AbiAXUIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:08:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54938 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352572AbiAXT6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:58:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCCDA60B88;
        Mon, 24 Jan 2022 19:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B405BC340E5;
        Mon, 24 Jan 2022 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054314;
        bh=bECX07xkx2k484fsrIWFoWPuZFgoO91gV/NWmls1Tc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT410Q8XZ6uHkHpUutT5UGdWLZbQbNMx1OgWIym4+Ofx4phN+001ID/h/WL/MnZTW
         qmQjPOnGKObxD3BzflVNj27mvrFJLLaTPwAXBRPqh7Dj2WjWqqcdmPenr92cP3V2lL
         LVnW+VMCTWc22comb2TM/LvIsCqgPJEW4sy2nARI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Suman Anna <s-anna@ti.com>, Nishanth Menon <nm@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/563] soc: ti: pruss: fix referenced node in error message
Date:   Mon, 24 Jan 2022 19:41:26 +0100
Message-Id: <20220124184035.537585419@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index cc0b4ad7a3d34..30695172a508f 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -131,7 +131,7 @@ static int pruss_clk_init(struct pruss *pruss, struct device_node *cfg_node)
 
 	clks_np = of_get_child_by_name(cfg_node, "clocks");
 	if (!clks_np) {
-		dev_err(dev, "%pOF is missing its 'clocks' node\n", clks_np);
+		dev_err(dev, "%pOF is missing its 'clocks' node\n", cfg_node);
 		return -ENODEV;
 	}
 
-- 
2.34.1



