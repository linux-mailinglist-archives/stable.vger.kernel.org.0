Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1298145004
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbgAVJnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387825AbgAVJnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99AA32467B;
        Wed, 22 Jan 2020 09:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686185;
        bh=8u5bBSZvcbj5TDvKR7jmKt4eiSeLil8Ogw8aRHcZKuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0dYCflvnv4wheV0zwV5xlJtiQTIH0RoSoEQRlsIs+6dMN0GW2jFgcFPyYpVG+LKd
         jJQbpAqjFKbriFzyD47PeQsy5haBWwRf6Gie2nNAAQ4KrTk4ec30uEPda7QnwbCAh5
         8rLRt8Nd2NoyyhQjRpMIxLGxI7VnSm04zwrybbDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 078/103] mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters
Date:   Wed, 22 Jan 2020 10:29:34 +0100
Message-Id: <20200122092814.651229415@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

commit 85005b82e59fa7bb7388b12594ab2067bf73d66c upstream.

mlxsw configures Spectrum in such a way that BUM traffic is passed not
through its nominal traffic class TC, but through its MC counterpart TC+8.
However, when collecting statistics, Qdiscs only look at the nominal TC and
ignore the MC TC.

Add two helpers to compute the value for logical TC from the constituents,
one for backlog, the other for tail drops. Use them throughout instead of
going through the xstats pointer directly.

Counters for TX bytes and packets are deduced from packet priority
counters, and therefore already include BUM traffic. wred_drop counter is
irrelevant on MC TCs, because RED is not enabled on them.

Fixes: 7b8195306694 ("mlxsw: spectrum: Configure MC-aware mode on mlxsw ports")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c |   30 ++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -195,6 +195,20 @@ mlxsw_sp_qdisc_get_xstats(struct mlxsw_s
 	return -EOPNOTSUPP;
 }
 
+static u64
+mlxsw_sp_xstats_backlog(struct mlxsw_sp_port_xstats *xstats, int tclass_num)
+{
+	return xstats->backlog[tclass_num] +
+	       xstats->backlog[tclass_num + 8];
+}
+
+static u64
+mlxsw_sp_xstats_tail_drop(struct mlxsw_sp_port_xstats *xstats, int tclass_num)
+{
+	return xstats->tail_drop[tclass_num] +
+	       xstats->tail_drop[tclass_num + 8];
+}
+
 static void
 mlxsw_sp_qdisc_bstats_per_priority_get(struct mlxsw_sp_port_xstats *xstats,
 				       u8 prio_bitmap, u64 *tx_packets,
@@ -269,7 +283,7 @@ mlxsw_sp_setup_tc_qdisc_red_clean_stats(
 					       &stats_base->tx_bytes);
 	red_base->prob_mark = xstats->ecn;
 	red_base->prob_drop = xstats->wred_drop[tclass_num];
-	red_base->pdrop = xstats->tail_drop[tclass_num];
+	red_base->pdrop = mlxsw_sp_xstats_tail_drop(xstats, tclass_num);
 
 	stats_base->overlimits = red_base->prob_drop + red_base->prob_mark;
 	stats_base->drops = red_base->prob_drop + red_base->pdrop;
@@ -369,7 +383,8 @@ mlxsw_sp_qdisc_get_red_xstats(struct mlx
 
 	early_drops = xstats->wred_drop[tclass_num] - xstats_base->prob_drop;
 	marks = xstats->ecn - xstats_base->prob_mark;
-	pdrops = xstats->tail_drop[tclass_num] - xstats_base->pdrop;
+	pdrops = mlxsw_sp_xstats_tail_drop(xstats, tclass_num) -
+		 xstats_base->pdrop;
 
 	res->pdrop += pdrops;
 	res->prob_drop += early_drops;
@@ -402,9 +417,10 @@ mlxsw_sp_qdisc_get_red_stats(struct mlxs
 
 	overlimits = xstats->wred_drop[tclass_num] + xstats->ecn -
 		     stats_base->overlimits;
-	drops = xstats->wred_drop[tclass_num] + xstats->tail_drop[tclass_num] -
+	drops = xstats->wred_drop[tclass_num] +
+		mlxsw_sp_xstats_tail_drop(xstats, tclass_num) -
 		stats_base->drops;
-	backlog = xstats->backlog[tclass_num];
+	backlog = mlxsw_sp_xstats_backlog(xstats, tclass_num);
 
 	_bstats_update(stats_ptr->bstats, tx_bytes, tx_packets);
 	stats_ptr->qstats->overlimits += overlimits;
@@ -575,9 +591,9 @@ mlxsw_sp_qdisc_get_prio_stats(struct mlx
 	tx_packets = stats->tx_packets - stats_base->tx_packets;
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		drops += xstats->tail_drop[i];
+		drops += mlxsw_sp_xstats_tail_drop(xstats, i);
 		drops += xstats->wred_drop[i];
-		backlog += xstats->backlog[i];
+		backlog += mlxsw_sp_xstats_backlog(xstats, i);
 	}
 	drops = drops - stats_base->drops;
 
@@ -613,7 +629,7 @@ mlxsw_sp_setup_tc_qdisc_prio_clean_stats
 
 	stats_base->drops = 0;
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		stats_base->drops += xstats->tail_drop[i];
+		stats_base->drops += mlxsw_sp_xstats_tail_drop(xstats, i);
 		stats_base->drops += xstats->wred_drop[i];
 	}
 


