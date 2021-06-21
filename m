Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316BE3AEEB2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhFUQbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232488AbhFUQ3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19BC360698;
        Mon, 21 Jun 2021 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292663;
        bh=OIJ5zuKMLWnx1LGBRc4sPjL5ZG9GfRsEd9Ll1vtkaso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVYfrJiTOaZdHQviwI9btbSJOdwOpoXbXuYk8plFT2bIzeaLq9s6t9Rja6G3aqbMq
         V39z3Y9rIWdGuO2FQaWDpzVKRU2VPa/ioZv2+FfFLjAZq/dF6eAkTC57U+a/ZZCnJl
         SCsum4FgDYJUKPNoIZw9hIqMNu1brSjJqebPBQLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/146] cxgb4: fix wrong ethtool n-tuple rule lookup
Date:   Mon, 21 Jun 2021 18:14:41 +0200
Message-Id: <20210621154913.379818528@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 09427c1915f754ebe7d3d8e54e79bbee48afe916 ]

The TID returned during successful filter creation is relative to
the region in which the filter is created. Using it directly always
returns Hi Prio/Normal filter region's entry for the first couple of
entries, even though the rule is actually inserted in Hash region.
Fix by analyzing in which region the filter has been inserted and
save the absolute TID to be used for lookup later.

Fixes: db43b30cd89c ("cxgb4: add ethtool n-tuple filter deletion")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index df20485b5744..83ed10ac8660 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1624,16 +1624,14 @@ static struct filter_entry *cxgb4_get_filter_entry(struct adapter *adap,
 						   u32 ftid)
 {
 	struct tid_info *t = &adap->tids;
-	struct filter_entry *f;
 
-	if (ftid < t->nhpftids)
-		f = &adap->tids.hpftid_tab[ftid];
-	else if (ftid < t->nftids)
-		f = &adap->tids.ftid_tab[ftid - t->nhpftids];
-	else
-		f = lookup_tid(&adap->tids, ftid);
+	if (ftid >= t->hpftid_base && ftid < t->hpftid_base + t->nhpftids)
+		return &t->hpftid_tab[ftid - t->hpftid_base];
+
+	if (ftid >= t->ftid_base && ftid < t->ftid_base + t->nftids)
+		return &t->ftid_tab[ftid - t->ftid_base];
 
-	return f;
+	return lookup_tid(t, ftid);
 }
 
 static void cxgb4_fill_filter_rule(struct ethtool_rx_flow_spec *fs,
@@ -1840,6 +1838,11 @@ static int cxgb4_ntuple_del_filter(struct net_device *dev,
 	filter_id = filter_info->loc_array[cmd->fs.location];
 	f = cxgb4_get_filter_entry(adapter, filter_id);
 
+	if (f->fs.prio)
+		filter_id -= adapter->tids.hpftid_base;
+	else if (!f->fs.hash)
+		filter_id -= (adapter->tids.ftid_base - adapter->tids.nhpftids);
+
 	ret = cxgb4_flow_rule_destroy(dev, f->fs.tc_prio, &f->fs, filter_id);
 	if (ret)
 		goto err;
@@ -1899,6 +1902,11 @@ static int cxgb4_ntuple_set_filter(struct net_device *netdev,
 
 	filter_info = &adapter->ethtool_filters->port[pi->port_id];
 
+	if (fs.prio)
+		tid += adapter->tids.hpftid_base;
+	else if (!fs.hash)
+		tid += (adapter->tids.ftid_base - adapter->tids.nhpftids);
+
 	filter_info->loc_array[cmd->fs.location] = tid;
 	set_bit(cmd->fs.location, filter_info->bmap);
 	filter_info->in_use++;
-- 
2.30.2



