Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43117147FD8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbgAXLFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388880AbgAXLFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:05:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5DF2071A;
        Fri, 24 Jan 2020 11:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863932;
        bh=8d1nX4LAdMKqvkj0dwYAfO3ahLDhbe83T0nZz4dS5sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBB4SJWo8HMJC+JBWligqiZDRZc2TZ5IGCYR5XaTK3i9HavqzxRk7RUf4sAWEqkWf
         tkrjgQU58O0t8JH3beXWJMcSmdskJEnCihYDKa36LO/kWniGcyB/sLIe/FxfDeJgii
         4CjpqKINNhY+ZriTOALPFaTI9b/ijTUkEd6j0HOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/639] clk: mv98dx3236: fix refcount leak in mv98dx3236_clk_init()
Date:   Fri, 24 Jan 2020 10:24:43 +0100
Message-Id: <20200124093101.494522265@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 9b4eedf627045ae5ddcff60a484200cdd554c413 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Fixes: 337072604224 ("clk: mvebu: Expand mv98dx3236-core-clock support")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/mv98dx3236.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mvebu/mv98dx3236.c b/drivers/clk/mvebu/mv98dx3236.c
index 6e203af73cac1..c8a0d03d2cd60 100644
--- a/drivers/clk/mvebu/mv98dx3236.c
+++ b/drivers/clk/mvebu/mv98dx3236.c
@@ -174,7 +174,9 @@ static void __init mv98dx3236_clk_init(struct device_node *np)
 
 	mvebu_coreclk_setup(np, &mv98dx3236_core_clocks);
 
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, mv98dx3236_gating_desc);
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(mv98dx3236_clk, "marvell,mv98dx3236-core-clock", mv98dx3236_clk_init);
-- 
2.20.1



