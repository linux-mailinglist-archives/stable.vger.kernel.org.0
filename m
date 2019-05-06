Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C498114DAF
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbfEFOqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbfEFOqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA32620449;
        Mon,  6 May 2019 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154012;
        bh=PfctUM6oIIxO1h4owGlyOr3ZDoVD2mBUki2EavE2GpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GND8Vwfly2znYlzu1uoV15F6a8/ZHi70kmzmv6RthrNn4dA4I5x/yZgAiALhKNitg
         qSLQ036jVLoqgOAhQSY/EOiZKLJwSMtCpgTfUbARyQc7M0duB+oLZ4/0DgSYZJFVH6
         fnI+NNW/TQtHnn6h8adg2QwsFn0hUESjLOOK/uCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 50/75] net: hns: fix ICMP6 neighbor solicitation messages discard problem
Date:   Mon,  6 May 2019 16:32:58 +0200
Message-Id: <20190506143057.764149473@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f058e46855dcbc28edb2ed4736f38a71fd19cadb ]

ICMP6 neighbor solicitation messages will be discard by the Hip06
chips, because of not setting forwarding pool. Enable promisc mode
has the same problem.

This patch fix the wrong forwarding table configs for the multicast
vague matching when enable promisc mode, and add forwarding pool
for the forwarding table.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns/hns_dsaf_main.c    | 33 +++++++++++++++----
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
index 7e82dfbb4340..7d0f3cd8a002 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
@@ -2743,6 +2743,17 @@ int hns_dsaf_get_regs_count(void)
 	return DSAF_DUMP_REGS_NUM;
 }
 
+static int hns_dsaf_get_port_id(u8 port)
+{
+	if (port < DSAF_SERVICE_NW_NUM)
+		return port;
+
+	if (port >= DSAF_BASE_INNER_PORT_NUM)
+		return port - DSAF_BASE_INNER_PORT_NUM + DSAF_SERVICE_NW_NUM;
+
+	return -EINVAL;
+}
+
 static void set_promisc_tcam_enable(struct dsaf_device *dsaf_dev, u32 port)
 {
 	struct dsaf_tbl_tcam_ucast_cfg tbl_tcam_ucast = {0, 1, 0, 0, 0x80};
@@ -2808,23 +2819,33 @@ static void set_promisc_tcam_enable(struct dsaf_device *dsaf_dev, u32 port)
 	memset(&temp_key, 0x0, sizeof(temp_key));
 	mask_entry.addr[0] = 0x01;
 	hns_dsaf_set_mac_key(dsaf_dev, &mask_key, mask_entry.in_vlan_id,
-			     port, mask_entry.addr);
+			     0xf, mask_entry.addr);
 	tbl_tcam_mcast.tbl_mcast_item_vld = 1;
 	tbl_tcam_mcast.tbl_mcast_old_en = 0;
 
-	if (port < DSAF_SERVICE_NW_NUM) {
-		mskid = port;
-	} else if (port >= DSAF_BASE_INNER_PORT_NUM) {
-		mskid = port - DSAF_BASE_INNER_PORT_NUM + DSAF_SERVICE_NW_NUM;
-	} else {
+	/* set MAC port to handle multicast */
+	mskid = hns_dsaf_get_port_id(port);
+	if (mskid == -EINVAL) {
 		dev_err(dsaf_dev->dev, "%s,pnum(%d)error,key(%#x:%#x)\n",
 			dsaf_dev->ae_dev.name, port,
 			mask_key.high.val, mask_key.low.val);
 		return;
 	}
+	dsaf_set_bit(tbl_tcam_mcast.tbl_mcast_port_msk[mskid / 32],
+		     mskid % 32, 1);
 
+	/* set pool bit map to handle multicast */
+	mskid = hns_dsaf_get_port_id(port_num);
+	if (mskid == -EINVAL) {
+		dev_err(dsaf_dev->dev,
+			"%s, pool bit map pnum(%d)error,key(%#x:%#x)\n",
+			dsaf_dev->ae_dev.name, port_num,
+			mask_key.high.val, mask_key.low.val);
+		return;
+	}
 	dsaf_set_bit(tbl_tcam_mcast.tbl_mcast_port_msk[mskid / 32],
 		     mskid % 32, 1);
+
 	memcpy(&temp_key, &mask_key, sizeof(mask_key));
 	hns_dsaf_tcam_mc_cfg_vague(dsaf_dev, entry_index, &tbl_tcam_data_mc,
 				   (struct dsaf_tbl_tcam_data *)(&mask_key),
-- 
2.20.1



