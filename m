Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B795DC2E
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfGCCQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbfGCCQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B8421882;
        Wed,  3 Jul 2019 02:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120188;
        bh=faa1a6s2txMEfksmcTfd11t6p3UsuBe9WIt3KIrJGSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUP9blv3ZeWL6mosxocT6ZFYpqaxUbw8WlfPNVrROC6C7K0SRlO8TdVb43OvvA2pX
         PLxVUTwV21X2Z8YoRT45KIxlGjRZ7U+0bonNlbSnAoKDV8GOKGWJRpZKaqEXUTXfTs
         KoAFB5Pe8Q52N6xtJ2RLT04ZGx6qpN/YObLjv5pw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/26] clk: ti: clkctrl: Fix returning uninitialized data
Date:   Tue,  2 Jul 2019 22:16:01 -0400
Message-Id: <20190703021625.18116-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021625.18116-1-sashal@kernel.org>
References: <20190703021625.18116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 41b3588dba6ef4b7995735a97e47ff0aeea6c276 ]

If we do a clk_get() for a clock that does not exists, we have
_ti_omap4_clkctrl_xlate() return uninitialized data if no match
is found. This can be seen in some cases with SLAB_DEBUG enabled:

Unable to handle kernel paging request at virtual address 5a5a5a5a
...
clk_hw_create_clk.part.33
sysc_notifier_call
notifier_call_chain
blocking_notifier_call_chain
device_add

Let's fix this by setting a found flag only when we find a match.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Fixes: 88a172526c32 ("clk: ti: add support for clkctrl clocks")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clkctrl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ti/clkctrl.c b/drivers/clk/ti/clkctrl.c
index ca3218337fd7..dfaa5aad0692 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -229,6 +229,7 @@ static struct clk_hw *_ti_omap4_clkctrl_xlate(struct of_phandle_args *clkspec,
 {
 	struct omap_clkctrl_provider *provider = data;
 	struct omap_clkctrl_clk *entry;
+	bool found = false;
 
 	if (clkspec->args_count != 2)
 		return ERR_PTR(-EINVAL);
@@ -238,11 +239,13 @@ static struct clk_hw *_ti_omap4_clkctrl_xlate(struct of_phandle_args *clkspec,
 
 	list_for_each_entry(entry, &provider->clocks, node) {
 		if (entry->reg_offset == clkspec->args[0] &&
-		    entry->bit_offset == clkspec->args[1])
+		    entry->bit_offset == clkspec->args[1]) {
+			found = true;
 			break;
+		}
 	}
 
-	if (!entry)
+	if (!found)
 		return ERR_PTR(-EINVAL);
 
 	return entry->clk;
-- 
2.20.1

