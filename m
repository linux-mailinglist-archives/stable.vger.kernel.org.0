Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF25B1F2E0F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgFHXNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgFHXNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B999D20897;
        Mon,  8 Jun 2020 23:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657997;
        bh=4mLUq8oF0+XPpJ0iLZPuz7kue4ub17LRH+eWo4UMPF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKL/EiZUPH8/ebEd7MGVPP97hGF/Q0wzpJfMQT6bWNIxbyLy/4qcz3YhmkSEX/fxG
         Vq8Yvv+Kg1n+Wa39vgBgHdC3CJ2W8kkBXIoViIU8Fu4QJXeNybJsVC3BBW2qIboZwH
         Cpp1aosWhg+YNw2AEn86ZhgVaA1hMJeOVFND1G3o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tero Kristo <t-kristo@ti.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 055/606] clk: ti: clkctrl: Fix Bad of_node_put within clkctrl_get_name
Date:   Mon,  8 Jun 2020 19:03:00 -0400
Message-Id: <20200608231211.3363633-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

commit e1f9e0d28ff025564dfdb1001a7839b4af5db2e2 upstream.

clkctrl_get_name incorrectly calls of_node_put when it is not really
doing of_node_get. This causes a boot time warning later on:

[    0.000000] OF: ERROR: Bad of_node_put() on /ocp/interconnect@4a000000/segmen
t@0/target-module@5000/cm_core_aon@0/ipu-cm@500/ipu1-clkctrl@20

Fix by dropping the of_node_put from the function.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 6c3090520554 ("clk: ti: clkctrl: Fix hidden dependency to node name")
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Link: https://lkml.kernel.org/r/20200424124725.9895-1-t-kristo@ti.com
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/ti/clkctrl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/ti/clkctrl.c b/drivers/clk/ti/clkctrl.c
index 062266034d84..9019624e37bc 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -461,7 +461,6 @@ static char * __init clkctrl_get_name(struct device_node *np)
 			return name;
 		}
 	}
-	of_node_put(np);
 
 	return NULL;
 }
-- 
2.25.1

