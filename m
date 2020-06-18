Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01A01FE764
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgFRBMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbgFRBMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDD020EDD;
        Thu, 18 Jun 2020 01:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442751;
        bh=G3npwubaEKnd3PGv+uBeBKcI2zNcuNgQoVB37CCG5rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4g0EsoKLEgbgSAfzAp3MqeVdFts08JAjMcW5MwkkAdJE+/DARZPPFkxE+2zaNcJw
         vAbqbLSbFpAkJ1PZYqlNYFB1CK0wWQr9fOI36T+JWg1ppUapxQebya1fJFCcyNkjbX
         0PCHSlgS45AJQUxKzNSJP0Z1Yo90+Q+J8oCLJrVQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tero Kristo <t-kristo@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 203/388] clk: ti: composite: fix memory leak
Date:   Wed, 17 Jun 2020 21:05:00 -0400
Message-Id: <20200618010805.600873-203-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit c7c1cbbc9217ebb5601b88d138d4a5358548de9d ]

The parent_names is never released for a component clock definition,
causing some memory leak. Fix by releasing it once it is no longer
needed.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Link: https://lkml.kernel.org/r/20200429131341.4697-2-t-kristo@ti.com
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/composite.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/composite.c b/drivers/clk/ti/composite.c
index 6a89936ba03a..eaa43575cfa5 100644
--- a/drivers/clk/ti/composite.c
+++ b/drivers/clk/ti/composite.c
@@ -196,6 +196,7 @@ static void __init _register_composite(void *user,
 		if (!cclk->comp_clks[i])
 			continue;
 		list_del(&cclk->comp_clks[i]->link);
+		kfree(cclk->comp_clks[i]->parent_names);
 		kfree(cclk->comp_clks[i]);
 	}
 
-- 
2.25.1

