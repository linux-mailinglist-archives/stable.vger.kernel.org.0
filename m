Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521856C550
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389798AbfGRDEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389055AbfGRDEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:04:49 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D19C2173E;
        Thu, 18 Jul 2019 03:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419088;
        bh=bdmD2+uqJyNBn2iJhb9XsUIP2o15xtwrW4og+g+m2uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlsGbL+je7dPNqak59hfK1awgjO928zDwU3H3An0ikqW3LFROsfCkFiX12M/YsVut
         zVyhBVg9F2bLbKAIcGG6D3okaR79kjF4IkUvaqTybqxKkpCIma1im+qZyqXqja2PgO
         tZOHH6ONNJ+v0jpPkcJIbMxQshZ+SrAXaTPOCP1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 11/54] clk: ti: clkctrl: Fix returning uninitialized data
Date:   Thu, 18 Jul 2019 12:01:06 +0900
Message-Id: <20190718030054.244474855@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 3325ee43bcc1..626090b59cd7 100644
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



