Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C082171D2
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgGGP0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728204AbgGGP0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 908F6206F6;
        Tue,  7 Jul 2020 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135563;
        bh=wCFNEDP8D51tznNCOFcDtJf8QeDFjuMpaveZjrg5AME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOLNEJcqp4OG4qTN6FNOpK8HSgjBOTZJ1BS9svvwr5dbRJrAZE9ezKxhkC13/EyTw
         ty1hKp+MsyzMg4HBMcnS09oCka+GGQLLSg4hXncezBIJnK313MMg1X5CXFp+zferSk
         KLP3B5XizYVSSbSL1YxnY9nckgSNWL956nYymXiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 060/112] cxgb4: fix endian conversions for L4 ports in filters
Date:   Tue,  7 Jul 2020 17:17:05 +0200
Message-Id: <20200707145803.855733001@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 63b53b0b99cd5f2d9754a21eda2ed8e706646cc9 ]

The source and destination L4 ports in filter offload need to be
in CPU endian. They will finally be converted to Big Endian after
all operations are done and before giving them to hardware. The
L4 ports for NAT are expected to be passed as a byte stream TCB.
So, treat them as such.

Fixes following sparse warnings in several places:
cxgb4_tc_flower.c:159:33: warning: cast from restricted __be16
cxgb4_tc_flower.c:159:33: warning: incorrect type in argument 1 (different
base types)
cxgb4_tc_flower.c:159:33:    expected unsigned short [usertype] val
cxgb4_tc_flower.c:159:33:    got restricted __be16 [usertype] dst

Fixes: dca4faeb812f ("cxgb4: Add LE hash collision bug fix path in LLD driver")
Fixes: 62488e4b53ae ("cxgb4: add basic tc flower offload support")
Fixes: 557ccbf9dfa8 ("cxgb4: add tc flower support for L3/L4 rewrite")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 15 +++++++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 30 +++++++------------
 3 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 796555255207c..c6bf2648fe420 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -165,6 +165,9 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 			   unsigned int tid, bool dip, bool sip, bool dp,
 			   bool sp)
 {
+	u8 *nat_lp = (u8 *)&f->fs.nat_lport;
+	u8 *nat_fp = (u8 *)&f->fs.nat_fport;
+
 	if (dip) {
 		if (f->fs.type) {
 			set_tcb_field(adap, f, tid, TCB_SND_UNA_RAW_W,
@@ -236,8 +239,9 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 	}
 
 	set_tcb_field(adap, f, tid, TCB_PDU_HDR_LEN_W, WORD_MASK,
-		      (dp ? f->fs.nat_lport : 0) |
-		      (sp ? f->fs.nat_fport << 16 : 0), 1);
+		      (dp ? (nat_lp[1] | nat_lp[0] << 8) : 0) |
+		      (sp ? (nat_fp[1] << 16 | nat_fp[0] << 24) : 0),
+		      1);
 }
 
 /* Validate filter spec against configuration done on the card. */
@@ -909,6 +913,9 @@ int set_filter_wr(struct adapter *adapter, int fidx)
 	fwr->fpm = htons(f->fs.mask.fport);
 
 	if (adapter->params.filter2_wr_support) {
+		u8 *nat_lp = (u8 *)&f->fs.nat_lport;
+		u8 *nat_fp = (u8 *)&f->fs.nat_fport;
+
 		fwr->natmode_to_ulp_type =
 			FW_FILTER2_WR_ULP_TYPE_V(f->fs.nat_mode ?
 						 ULP_MODE_TCPDDP :
@@ -916,8 +923,8 @@ int set_filter_wr(struct adapter *adapter, int fidx)
 			FW_FILTER2_WR_NATMODE_V(f->fs.nat_mode);
 		memcpy(fwr->newlip, f->fs.nat_lip, sizeof(fwr->newlip));
 		memcpy(fwr->newfip, f->fs.nat_fip, sizeof(fwr->newfip));
-		fwr->newlport = htons(f->fs.nat_lport);
-		fwr->newfport = htons(f->fs.nat_fport);
+		fwr->newlport = htons(nat_lp[1] | nat_lp[0] << 8);
+		fwr->newfport = htons(nat_fp[1] | nat_fp[0] << 8);
 	}
 
 	/* Mark the filter as "pending" and ship off the Filter Work Request.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a70018f067aa8..e8934c48f09b6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2604,7 +2604,7 @@ int cxgb4_create_server_filter(const struct net_device *dev, unsigned int stid,
 
 	/* Clear out filter specifications */
 	memset(&f->fs, 0, sizeof(struct ch_filter_specification));
-	f->fs.val.lport = cpu_to_be16(sport);
+	f->fs.val.lport = be16_to_cpu(sport);
 	f->fs.mask.lport  = ~0;
 	val = (u8 *)&sip;
 	if ((val[0] | val[1] | val[2] | val[3]) != 0) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 4a5fa9eba0b64..59b65d4db086e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -58,10 +58,6 @@ static struct ch_tc_pedit_fields pedits[] = {
 	PEDIT_FIELDS(IP6_, DST_63_32, 4, nat_lip, 4),
 	PEDIT_FIELDS(IP6_, DST_95_64, 4, nat_lip, 8),
 	PEDIT_FIELDS(IP6_, DST_127_96, 4, nat_lip, 12),
-	PEDIT_FIELDS(TCP_, SPORT, 2, nat_fport, 0),
-	PEDIT_FIELDS(TCP_, DPORT, 2, nat_lport, 0),
-	PEDIT_FIELDS(UDP_, SPORT, 2, nat_fport, 0),
-	PEDIT_FIELDS(UDP_, DPORT, 2, nat_lport, 0),
 };
 
 static struct ch_tc_flower_entry *allocate_flower_entry(void)
@@ -156,14 +152,14 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 		struct flow_match_ports match;
 
 		flow_rule_match_ports(rule, &match);
-		fs->val.lport = cpu_to_be16(match.key->dst);
-		fs->mask.lport = cpu_to_be16(match.mask->dst);
-		fs->val.fport = cpu_to_be16(match.key->src);
-		fs->mask.fport = cpu_to_be16(match.mask->src);
+		fs->val.lport = be16_to_cpu(match.key->dst);
+		fs->mask.lport = be16_to_cpu(match.mask->dst);
+		fs->val.fport = be16_to_cpu(match.key->src);
+		fs->mask.fport = be16_to_cpu(match.mask->src);
 
 		/* also initialize nat_lport/fport to same values */
-		fs->nat_lport = cpu_to_be16(match.key->dst);
-		fs->nat_fport = cpu_to_be16(match.key->src);
+		fs->nat_lport = fs->val.lport;
+		fs->nat_fport = fs->val.fport;
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
@@ -354,12 +350,9 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 		switch (offset) {
 		case PEDIT_TCP_SPORT_DPORT:
 			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
-				offload_pedit(fs, cpu_to_be32(val) >> 16,
-					      cpu_to_be32(mask) >> 16,
-					      TCP_SPORT);
+				fs->nat_fport = val;
 			else
-				offload_pedit(fs, cpu_to_be32(val),
-					      cpu_to_be32(mask), TCP_DPORT);
+				fs->nat_lport = val >> 16;
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 		break;
@@ -367,12 +360,9 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 		switch (offset) {
 		case PEDIT_UDP_SPORT_DPORT:
 			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
-				offload_pedit(fs, cpu_to_be32(val) >> 16,
-					      cpu_to_be32(mask) >> 16,
-					      UDP_SPORT);
+				fs->nat_fport = val;
 			else
-				offload_pedit(fs, cpu_to_be32(val),
-					      cpu_to_be32(mask), UDP_DPORT);
+				fs->nat_lport = val >> 16;
 		}
 		fs->nat_mode = NAT_MODE_ALL;
 	}
-- 
2.25.1



