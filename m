Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DB8450E23
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbhKOSMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240054AbhKOSFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED116337C;
        Mon, 15 Nov 2021 17:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998111;
        bh=AgxfXm9l8C9YN4aKCuqWuNai4N6nSe/vbJTBbCrEHds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkSbN/c4sbUxdg8+GbiIbDAuRww0u63dfbkWkli+TqtybPkRh+Vtx6izHjOhJpHjs
         aV0k8G6u73xNLqxj9cR6SE+TcqsorZ9rRcr4eL118Mvuu5pxNJulN6sgvKLJxiXrRA
         khMWXnktVgSCPu/ZXXeKF2W3EUFICvjv5MWhYeLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/575] clk: mvebu: ap-cpu-clk: Fix a memory leak in error handling paths
Date:   Mon, 15 Nov 2021 18:01:55 +0100
Message-Id: <20211115165357.252584401@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit af9617b419f77cf0b99702a7b2b0519da0d27715 ]

If we exit the for_each_of_cpu_node loop early, the reference on the
current node must be decremented, otherwise there is a leak.

Fixes: f756e362d938 ("clk: mvebu: add CPU clock driver for Armada 7K/8K")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/545df946044fc1fc05a4217cdf0054be7a79e49e.1619161112.git.christophe.jaillet@wanadoo.fr
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/ap-cpu-clk.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mvebu/ap-cpu-clk.c b/drivers/clk/mvebu/ap-cpu-clk.c
index b4259b60dcfd6..25de4b6da776f 100644
--- a/drivers/clk/mvebu/ap-cpu-clk.c
+++ b/drivers/clk/mvebu/ap-cpu-clk.c
@@ -256,12 +256,15 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 		int cpu, err;
 
 		err = of_property_read_u32(dn, "reg", &cpu);
-		if (WARN_ON(err))
+		if (WARN_ON(err)) {
+			of_node_put(dn);
 			return err;
+		}
 
 		/* If cpu2 or cpu3 is enabled */
 		if (cpu & APN806_CLUSTER_NUM_MASK) {
 			nclusters = 2;
+			of_node_put(dn);
 			break;
 		}
 	}
@@ -288,8 +291,10 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 		int cpu, err;
 
 		err = of_property_read_u32(dn, "reg", &cpu);
-		if (WARN_ON(err))
+		if (WARN_ON(err)) {
+			of_node_put(dn);
 			return err;
+		}
 
 		cluster_index = cpu & APN806_CLUSTER_NUM_MASK;
 		cluster_index >>= APN806_CLUSTER_NUM_OFFSET;
@@ -301,6 +306,7 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 		parent = of_clk_get(np, cluster_index);
 		if (IS_ERR(parent)) {
 			dev_err(dev, "Could not get the clock parent\n");
+			of_node_put(dn);
 			return -EINVAL;
 		}
 		parent_name =  __clk_get_name(parent);
@@ -319,8 +325,10 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 		init.parent_names = &parent_name;
 
 		ret = devm_clk_hw_register(dev, &ap_cpu_clk[cluster_index].hw);
-		if (ret)
+		if (ret) {
+			of_node_put(dn);
 			return ret;
+		}
 		ap_cpu_data->hws[cluster_index] = &ap_cpu_clk[cluster_index].hw;
 	}
 
-- 
2.33.0



