Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11A3491A91
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352592AbiARDAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346559AbiARCtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:49:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC89C06175E;
        Mon, 17 Jan 2022 18:41:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A88E0B81239;
        Tue, 18 Jan 2022 02:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1750C36AE3;
        Tue, 18 Jan 2022 02:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473690;
        bh=bECX07xkx2k484fsrIWFoWPuZFgoO91gV/NWmls1Tc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTgej2snnU2ifNA/2UNYP4yKOOG+57EA9G10s12fj5p90IObQ/A9oEVJNBAWXHk0/
         i6G6uphlgvYXNhS8lLoAuMGpmv6gSeZ9VuZCGWdAeaklVP/IO9rBNXU2IPBmU9iU2X
         Z9lpKPGi8hokcK96vXThcZh/bJC1vSInTjCu2M5V31kmv0qPsetDvyapeSLZ4qbuA8
         6jtu445//JrI0qLGgvNn0hV2xQofEt0yCpQWjTlN/Q+rMV2olm/uIZLTBjur8ckwWY
         Bqq1T52jO825d/y+ljo6lluCgLw1B7SIWo44lorqFp3EdDV9pjhi3M1rqPrsLYcIQT
         4zv7lLBETEWgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>, Suman Anna <s-anna@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 024/116] soc: ti: pruss: fix referenced node in error message
Date:   Mon, 17 Jan 2022 21:38:35 -0500
Message-Id: <20220118024007.1950576-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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

