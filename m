Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286F520D828
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732718AbgF2Tgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732976AbgF2Tae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2904251ED;
        Mon, 29 Jun 2020 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444910;
        bh=wnWbHIeC0vNL682tRqjN0VBlCI1lxlSjMrK/S1A0UNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPXAEd2LZFvjElUNoHEZ7s9ry/wVQu6uoRbIWowMWrJ3feIcwrr1eeuMCqXMQCey5
         bKuc/62lY1uOq1inomrxMoFvWoyWegOSnCCpbGkZ2GmchkB69vfuV9YmteANolQsTl
         67eNEMYbUwV/swPE40BV/oYcPSSkrJMI3U2ibZY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Longchamp <valentin@longchamp.me>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/131] net: sched: export __netdev_watchdog_up()
Date:   Mon, 29 Jun 2020 11:32:57 -0400
Message-Id: <20200629153502.2494656-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
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
index 8a4d01e427a22..119e20cad662b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -487,6 +487,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 			dev_hold(dev);
 	}
 }
+EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
 
 static void dev_watchdog_up(struct net_device *dev)
 {
-- 
2.25.1

