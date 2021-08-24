Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351D43F6401
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbhHXRAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234763AbhHXQ6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3991B61406;
        Tue, 24 Aug 2021 16:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824242;
        bh=xBwl2Vca0Jv/CiffPehhNuOtZFSIZI85WMB7Eam6TRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEjXydSp2Djb4ljz6DA2tus0m2rJwvzUYmzUza6MWSWPjphEWwPjAQfgCbG5f6bPN
         vjQi7mJ6IimfW6qzkbB7fBmNsj6U+V4avm1qqFXWBqaViA1Lf5smhauw6iRZfoVPXE
         FIwaRfkHxEsHL3X5xjvQ7bphPgPP0Z8fGYmMfmiJf+4CIs2aMsDNPOle9+Q/aSW2cB
         JLNiyflLdXoGc/EgAiYVUuGKb+TNm29himDTqBz8hhNVsyNG7T9vaJwhzg09FTzoKU
         EROstdhpOjuMLe3Rne9JgGG9/DvVwd8TetA6/L0DXUbb34RV9cDiVqk2K57MQWGkHL
         jKHd5HsIgrgLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 075/127] net: mscc: ocelot: allow forwarding from bridge ports to the tag_8021q CPU port
Date:   Tue, 24 Aug 2021 12:55:15 -0400
Message-Id: <20210824165607.709387-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c1930148a3941f891ddbd76fceaa4e10a957ccf2 ]

Currently we are unable to ping a bridge on top of a felix switch which
uses the ocelot-8021q tagger. The packets are dropped on the ingress of
the user port and the 'drop_local' counter increments (the counter which
denotes drops due to no valid destinations).

Dumping the PGID tables, it becomes clear that the PGID_SRC of the user
port is zero, so it has no valid destinations.

But looking at the code, the cpu_fwd_mask (the bit mask of DSA tag_8021q
ports) is clearly missing from the forwarding mask of ports that are
under a bridge. So this has always been broken.

Looking at the version history of the patch, in v7
https://patchwork.kernel.org/project/netdevbpf/patch/20210125220333.1004365-12-olteanv@gmail.com/
the code looked like this:

	/* Standalone ports forward only to DSA tag_8021q CPU ports */
	unsigned long mask = cpu_fwd_mask;

(...)
	} else if (ocelot->bridge_fwd_mask & BIT(port)) {
		mask |= ocelot->bridge_fwd_mask & ~BIT(port);

while in v8 (the merged version)
https://patchwork.kernel.org/project/netdevbpf/patch/20210129010009.3959398-12-olteanv@gmail.com/
it looked like this:

	unsigned long mask;

(...)
	} else if (ocelot->bridge_fwd_mask & BIT(port)) {
		mask = ocelot->bridge_fwd_mask & ~BIT(port);

So the breakage was introduced between v7 and v8 of the patch.

Fixes: e21268efbe26 ("net: dsa: felix: perform switch setup for tag_8021q")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20210817160425.3702809-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index adfb9781799e..2948d731a1c1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1334,6 +1334,7 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot_get_bridge_fwd_mask(ocelot, bridge);
+			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
 			if (bond) {
 				mask &= ~ocelot_get_bond_mask(ocelot, bond,
-- 
2.30.2

