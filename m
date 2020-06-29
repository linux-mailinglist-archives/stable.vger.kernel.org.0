Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B6D20DA2C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgF2Ty3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387674AbgF2Tk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBEC24844;
        Mon, 29 Jun 2020 15:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444355;
        bh=07Vxj0jMyxEReH4zKHfg1iNSpnv8m6eWdXnE5UUYfBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4oUVRzkIO2i3CTeFP1oIf2YZkEioAuZJqjr1yzE+t0mS+eT70FbevUsCtWcyFYdK
         fFn2qM0hroJ1+4KR4qcXubkhwiGv5WHeaNo5DkEl4c5/+RNwlTxNTz7hv8m2BPpgdI
         dBqROfpX46yl9o+ir4M5q4cyjDGN2rOqCONMH2go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Longchamp <valentin@longchamp.me>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/178] net: sched: export __netdev_watchdog_up()
Date:   Mon, 29 Jun 2020 11:22:55 -0400
Message-Id: <20200629152523.2494198-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>

[ Upstream commit 1a3db27ad9a72d033235b9673653962c02e3486e ]

Since the quiesce/activate rework, __netdev_watchdog_up() is directly
called in the ucc_geth driver.

Unfortunately, this function is not available for modules and thus
ucc_geth cannot be built as a module anymore. Fix it by exporting
__netdev_watchdog_up().

Since the commit introducing the regression was backported to stable
branches, this one should ideally be as well.

Fixes: 79dde73cf9bc ("net/ethernet/freescale: rework quiesce/activate for ucc_geth")
Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 7c3c5fdb82a96..896c9037155a5 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -469,6 +469,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 			dev_hold(dev);
 	}
 }
+EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
 
 static void dev_watchdog_up(struct net_device *dev)
 {
-- 
2.25.1

