Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1158C147FA7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388491AbgAXLEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388484AbgAXLEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:04:05 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E6782077C;
        Fri, 24 Jan 2020 11:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863845;
        bh=EEYnWDAz8s9VJB9YCO4bmiCPMQpP2fvkqQXYePHbQVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FThfmL74tz9dUe1Y1vugUQ2tO6xbUJmfSO6NTDfL95UgJzY6tSa4hNOn8MI5pwnDW
         f+7PiL2vcMR7iJiIBBpZHd/1d9yI+5BxshOol0E+ydQCWfLH2uP55eVnYUCsuSqePI
         abl0+VhnVK1hbYdIko30geqXPXp3RkDbjJKyXSiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/639] clk: ti: fix refcount leak in ti_dt_clocks_register()
Date:   Fri, 24 Jan 2020 10:24:33 +0100
Message-Id: <20200124093100.261680873@linuxfoundation.org>
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

[ Upstream commit 2274d8001fbb5e1942fbcab5ad2eb15553b09ed2 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 5b385a45e001 ("clk: ti: add support for clkctrl aliases")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index 27e0979b31586..0cc87c6ae91c9 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -188,9 +188,13 @@ void __init ti_dt_clocks_register(struct ti_dt_clk oclks[])
 			clkdev_add(&c->lk);
 		} else {
 			if (num_args && !has_clkctrl_data) {
-				if (of_find_compatible_node(NULL, NULL,
-							    "ti,clkctrl")) {
+				struct device_node *np;
+
+				np = of_find_compatible_node(NULL, NULL,
+							     "ti,clkctrl");
+				if (np) {
 					has_clkctrl_data = true;
+					of_node_put(np);
 				} else {
 					clkctrl_nodes_missing = true;
 
-- 
2.20.1



