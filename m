Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECA93F63DF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhHXQ6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234141AbhHXQ55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C68B8613E8;
        Tue, 24 Aug 2021 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824221;
        bh=AC+paf6EwFaNut7IpNd78GQ7pEckRr4QQF1wF1GHONY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sl67exZq+MYNrMy6Ar2vUoaQW1Kkzfy9D2Bhjeu+bjc1BLnfyX4nmVKTMTnxRYysO
         NZl3C1o4MOT4g0+3SZkldhVIBJVB1tmf+NyfcRL1hlXwSTY5sdVwJmuf3hLSLJReNs
         GSB+XpjRGtZGF+vfglz1FclBMLYV/A+BoQ45BmxRqiSEyjvULPNWPehn+FpITQkSoN
         3/fTmFc+2Ka0dYIhLuQF+Qe8HX/AhSgsZVZxhR9yfy9PKDpmtvNVj3WfAf4A79czND
         JA1DPzuIwshkPm9FCkWVZCjF9zzJtaYividEZoc4Z5KL2K2ifSQ9bK3cr+8BVWLYuJ
         pOlgPEqEnfACw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 054/127] bnxt: count Tx drops
Date:   Tue, 24 Aug 2021 12:54:54 -0400
Message-Id: <20210824165607.709387-55-sashal@kernel.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fb9f7190092d2bbd1f8f0b1cc252732cbe99a87e ]

Drivers should count packets they are dropping.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ea67c8c07a8b..a30ded73bba1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -409,6 +409,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
 		dev_kfree_skb_any(skb);
+		atomic_long_inc(&dev->tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -663,6 +664,7 @@ tx_kick_pending:
 	if (txr->kick_pending)
 		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
 	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
+	atomic_long_inc(&dev->tx_dropped);
 	return NETDEV_TX_OK;
 }
 
-- 
2.30.2

