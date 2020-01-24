Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85157147FD4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388839AbgAXLFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387655AbgAXLFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:05:25 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D8820838;
        Fri, 24 Jan 2020 11:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863924;
        bh=HJTSdxSXE3y+qH72vPnmbrNx69BkL7Zw3zo9k9sjUPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhB+oVlKAqRxEJhxRGHevz7NzSsRxiqIfBdD7iv9stX9J3fmxBINDGpmu8yKF7Np6
         MTSd/vVbbPHIep2c4NTdqAg50Z4DirE3fQvpmbJj9JyW/4nI/aSoDz2IoIfCzxNuWI
         EJ8Pg/K2tBkDpAYlW921RJ5ObPrspkdBIa+opFAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/639] clk: kirkwood: fix refcount leak in kirkwood_clk_init()
Date:   Fri, 24 Jan 2020 10:24:41 +0100
Message-Id: <20200124093101.252227832@linuxfoundation.org>
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
index a2a8d614039da..890ebf623261b 100644
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



