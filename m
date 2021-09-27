Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E657419C02
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhI0RYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237233AbhI0RXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF5A4613AB;
        Mon, 27 Sep 2021 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762884;
        bh=S0p4WUS4LJtWaHWvAul1QZYw3FimA81j09LhNdskdug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/yZ28ul5GCy2hZdFoWOg3ZhU/s1J5OY7ikYsfDTIiy9VGNjzh4k+1bFPF2jxzK6I
         OFVEIKhYkB8YoDS0oMVNR/FyMwQNwbUZ4nXJElcr5Xv+kZ76cpS460z+6IWN27flMX
         SmXNowoF0XhBqb2V5NmqRtXFQGk0eCDYJ84ZuWUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 086/162] net: ethernet: mtk_eth_soc: avoid creating duplicate offload entries
Date:   Mon, 27 Sep 2021 19:02:12 +0200
Message-Id: <20210927170236.415458361@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit e68daf61ed13832aef8892200a874139700ca754 ]

Sometimes multiple CLS_REPLACE calls are issued for the same connection.
rhashtable_insert_fast does not check for these duplicates, so multiple
hardware flow entries can be created.
Fix this by checking for an existing entry early

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index b5f68f66d42a..7bb1f20002b5 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -186,6 +186,9 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	int hash;
 	int i;
 
+	if (rhashtable_lookup(&eth->flow_table, &f->cookie, mtk_flow_ht_params))
+		return -EEXIST;
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
 		struct flow_match_meta match;
 
-- 
2.33.0



