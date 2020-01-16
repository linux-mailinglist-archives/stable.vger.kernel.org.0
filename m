Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761EE13E29D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbgAPQ5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387472AbgAPQ5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8A0F24673;
        Thu, 16 Jan 2020 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193839;
        bh=SyzeMevQErGeZucr06G/o6zoqXfNu3lF1/gYb305y0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwLkfYc9D6hhAzQHtqUEAsAFPWWfrzkG1KHUQj7VaJje4hjCS2PcerBLlNj4suVR+
         l4SMaYPt4Qs8FAlCKsKrYDBGeBz4IXG6YnCrhY/aUWqe5+pCTwJ34TSsT3gGicPDdR
         o7SEW6TkJ8DGEObdSIFp4E9Rnea6gUDGvzFIV7Yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 094/671] clk: kirkwood: fix refcount leak in kirkwood_clk_init()
Date:   Thu, 16 Jan 2020 11:45:25 -0500
Message-Id: <20200116165502.8838-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit e7beeab9c61591cd0e690d8733d534c3f4278ff8 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Fixes: 58d516ae95cb ("clk: mvebu: kirkwood: maintain clock init order")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/kirkwood.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index a2a8d614039d..890ebf623261 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -333,6 +333,8 @@ static void __init kirkwood_clk_init(struct device_node *np)
 	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, kirkwood_gating_desc);
 		kirkwood_clk_muxing_setup(cgnp, kirkwood_mux_desc);
+
+		of_node_put(cgnp);
 	}
 }
 CLK_OF_DECLARE(kirkwood_clk, "marvell,kirkwood-core-clock",
-- 
2.20.1

