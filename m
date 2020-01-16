Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2866413EED9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405339AbgAPRhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405050AbgAPRf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:35:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7776D246C0;
        Thu, 16 Jan 2020 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196126;
        bh=kgcXj89cU6yu7VY5V4Lql3Si5XHC1Fct90VFT76Z6Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzAwNxQ4LJOgDoD/Imi29+1RKZH0ZfuwCix+Nrfw9qb8AmZxG2X15qchOjjx9Zz6m
         PHvLtmYe8o9zSt2bhZRpod3gNGVNtzztfZRzB7eHWh9Zh8rj10Zi7GMQVptHpseDyO
         ceUPLrlQmv6ErIBWZFIHQCr8Hxk2P2odNqzqxIIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 031/251] clk: vf610: fix refcount leak in vf610_clocks_init()
Date:   Thu, 16 Jan 2020 12:31:05 -0500
Message-Id: <20200116173445.21385-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 567177024e0313e4f0dcba7ba10c0732e50e655d ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 1f2c5fd5f048 ("ARM: imx: add VF610 clock support")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-vf610.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-vf610.c b/drivers/clk/imx/clk-vf610.c
index 0476353ab423..a19ab032d073 100644
--- a/drivers/clk/imx/clk-vf610.c
+++ b/drivers/clk/imx/clk-vf610.c
@@ -203,6 +203,7 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	np = of_find_compatible_node(NULL, NULL, "fsl,vf610-anatop");
 	anatop_base = of_iomap(np, 0);
 	BUG_ON(!anatop_base);
+	of_node_put(np);
 
 	np = ccm_node;
 	ccm_base = of_iomap(np, 0);
-- 
2.20.1

