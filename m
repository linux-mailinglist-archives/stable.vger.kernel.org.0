Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261A56C6E4
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390385AbfGRDUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390632AbfGRDLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:11:30 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD8C20818;
        Thu, 18 Jul 2019 03:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419489;
        bh=ktO7hA2V2D/efF9ziFKYPw519gW3TXtB5RseJH0Pieo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GY9A3+c9UnsQaj77wj1EyPxHnWfC4lxazj1Zwgk8xYXBSw+HD0bAer4tS2cWxOINm
         TQHk+QKPUEQyUw7uwkIMyThNwhFKL5j34C7yW0G8wfP4fnbbj8ftnnsP1Xitib7nTC
         EtWBT4iIVCF5F6khOl2xbTM56YXGqlvTmA3P5DRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 62/80] clk: ti: clkctrl: Fix returning uninitialized data
Date:   Thu, 18 Jul 2019 12:01:53 +0900
Message-Id: <20190718030103.297617998@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
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
index 82e4d5cccf84..2df8564f08a0 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -215,6 +215,7 @@ static struct clk_hw *_ti_omap4_clkctrl_xlate(struct of_phandle_args *clkspec,
 {
 	struct omap_clkctrl_provider *provider = data;
 	struct omap_clkctrl_clk *entry;
+	bool found = false;
 
 	if (clkspec->args_count != 2)
 		return ERR_PTR(-EINVAL);
@@ -224,11 +225,13 @@ static struct clk_hw *_ti_omap4_clkctrl_xlate(struct of_phandle_args *clkspec,
 
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



