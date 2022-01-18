Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8492F4914DE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiARCZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:25:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39790 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245169AbiARCXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 163FA60A6B;
        Tue, 18 Jan 2022 02:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58E6C36AEB;
        Tue, 18 Jan 2022 02:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472591;
        bh=f8+DzzjtvvnxDthTcjNQ/23aDxrL03Fv6o1cZ2WdV3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgFzGaRGj1u0cmq9l7KGaEZUoQJNeDEoXsAxiUHCarSAtz8ONRE7bDXbKfuF+744h
         aTiU/Jg4inc9qTc3Ohv923IC58DkCAyZGoowq8ZcIR3kDdDqyVCNMgEuVBhPjU6O/u
         EL/njOQiiRQ1Xa/J/pcJhDT9UXSVCIM+9JiXihUyhukQEDbdlO3Zy6VLf0h2/f5cSN
         9EALAQRDNXl8xf4BxjHx6hsuyVlNd6OyyutCJuI0hJd2S1N+CmsmQ8x8NHrhndeh3r
         zJuvh76JKQYVDG10yAuDlRba+1Imk/erQh4BqSUPK8L16BVD+kLiB/x2VQGAGaCgXu
         VLzHohEn9se0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>, Suman Anna <s-anna@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 062/217] soc: ti: pruss: fix referenced node in error message
Date:   Mon, 17 Jan 2022 21:17:05 -0500
Message-Id: <20220118021940.1942199-62-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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

