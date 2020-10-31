Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A582D2A16DE
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgJaLlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbgJaLlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFAAD20719;
        Sat, 31 Oct 2020 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144481;
        bh=/y+m4Tc8gvyMdyoG2Hzp3h2LIVq/0DJcNK+cd7IdjjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7/RiHYAm+ysYLkK4f9BmlGiPN1B84Y3zfebE6mlJEJOqwfw5o9VeCaQJSmHyR2AZ
         +DjtbVzPwlJ0QU2q7aBIr/Rd5XpKk8uawzqUrwBVlk7mPsgyzYJPTBotr69+BZ3fHK
         njnJ27etJOfIe9kKKambYxSLbQMX9dJBcuYW1TEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 35/70] cxgb4: set up filter action after rewrites
Date:   Sat, 31 Oct 2020 12:36:07 +0100
Message-Id: <20201031113501.178874014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit 937d8420588421eaa5c7aa5c79b26b42abb288ef ]

The current code sets up the filter action field before
rewrites are set up. When the action 'switch' is used
with rewrites, this may result in initial few packets
that get switched out don't have rewrites applied
on them.

So, make sure filter action is set up along with rewrites
or only after everything else is set up for rewrites.

Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Link: https://lore.kernel.org/r/20201023115852.18262-1-rajur@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |   56 ++++++++++------------
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h       |    4 +
 2 files changed, 31 insertions(+), 29 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -145,13 +145,13 @@ static int configure_filter_smac(struct
 	int err;
 
 	/* do a set-tcb for smac-sel and CWR bit.. */
-	err = set_tcb_tflag(adap, f, f->tid, TF_CCTRL_CWR_S, 1, 1);
-	if (err)
-		goto smac_err;
-
 	err = set_tcb_field(adap, f, f->tid, TCB_SMAC_SEL_W,
 			    TCB_SMAC_SEL_V(TCB_SMAC_SEL_M),
 			    TCB_SMAC_SEL_V(f->smt->idx), 1);
+	if (err)
+		goto smac_err;
+
+	err = set_tcb_tflag(adap, f, f->tid, TF_CCTRL_CWR_S, 1, 1);
 	if (!err)
 		return 0;
 
@@ -865,6 +865,7 @@ int set_filter_wr(struct adapter *adapte
 		      FW_FILTER_WR_DIRSTEERHASH_V(f->fs.dirsteerhash) |
 		      FW_FILTER_WR_LPBK_V(f->fs.action == FILTER_SWITCH) |
 		      FW_FILTER_WR_DMAC_V(f->fs.newdmac) |
+		      FW_FILTER_WR_SMAC_V(f->fs.newsmac) |
 		      FW_FILTER_WR_INSVLAN_V(f->fs.newvlan == VLAN_INSERT ||
 					     f->fs.newvlan == VLAN_REWRITE) |
 		      FW_FILTER_WR_RMVLAN_V(f->fs.newvlan == VLAN_REMOVE ||
@@ -882,7 +883,7 @@ int set_filter_wr(struct adapter *adapte
 		 FW_FILTER_WR_OVLAN_VLD_V(f->fs.val.ovlan_vld) |
 		 FW_FILTER_WR_IVLAN_VLDM_V(f->fs.mask.ivlan_vld) |
 		 FW_FILTER_WR_OVLAN_VLDM_V(f->fs.mask.ovlan_vld));
-	fwr->smac_sel = 0;
+	fwr->smac_sel = f->smt->idx;
 	fwr->rx_chan_rx_rpl_iq =
 		htons(FW_FILTER_WR_RX_CHAN_V(0) |
 		      FW_FILTER_WR_RX_RPL_IQ_V(adapter->sge.fw_evtq.abs_id));
@@ -1321,11 +1322,8 @@ static void mk_act_open_req6(struct filt
 			    TX_QUEUE_V(f->fs.nat_mode) |
 			    T5_OPT_2_VALID_F |
 			    RX_CHANNEL_V(cxgb4_port_e2cchan(f->dev)) |
-			    CONG_CNTRL_V((f->fs.action == FILTER_DROP) |
-					 (f->fs.dirsteer << 1)) |
 			    PACE_V((f->fs.maskhash) |
-				   ((f->fs.dirsteerhash) << 1)) |
-			    CCTRL_ECN_V(f->fs.action == FILTER_SWITCH));
+				   ((f->fs.dirsteerhash) << 1)));
 }
 
 static void mk_act_open_req(struct filter_entry *f, struct sk_buff *skb,
@@ -1361,11 +1359,8 @@ static void mk_act_open_req(struct filte
 			    TX_QUEUE_V(f->fs.nat_mode) |
 			    T5_OPT_2_VALID_F |
 			    RX_CHANNEL_V(cxgb4_port_e2cchan(f->dev)) |
-			    CONG_CNTRL_V((f->fs.action == FILTER_DROP) |
-					 (f->fs.dirsteer << 1)) |
 			    PACE_V((f->fs.maskhash) |
-				   ((f->fs.dirsteerhash) << 1)) |
-			    CCTRL_ECN_V(f->fs.action == FILTER_SWITCH));
+				   ((f->fs.dirsteerhash) << 1)));
 }
 
 static int cxgb4_set_hash_filter(struct net_device *dev,
@@ -2037,6 +2032,20 @@ void hash_filter_rpl(struct adapter *ada
 			}
 			return;
 		}
+		switch (f->fs.action) {
+		case FILTER_PASS:
+			if (f->fs.dirsteer)
+				set_tcb_tflag(adap, f, tid,
+					      TF_DIRECT_STEER_S, 1, 1);
+			break;
+		case FILTER_DROP:
+			set_tcb_tflag(adap, f, tid, TF_DROP_S, 1, 1);
+			break;
+		case FILTER_SWITCH:
+			set_tcb_tflag(adap, f, tid, TF_LPBK_S, 1, 1);
+			break;
+		}
+
 		break;
 
 	default:
@@ -2104,22 +2113,11 @@ void filter_rpl(struct adapter *adap, co
 			if (ctx)
 				ctx->result = 0;
 		} else if (ret == FW_FILTER_WR_FLT_ADDED) {
-			int err = 0;
-
-			if (f->fs.newsmac)
-				err = configure_filter_smac(adap, f);
-
-			if (!err) {
-				f->pending = 0;  /* async setup completed */
-				f->valid = 1;
-				if (ctx) {
-					ctx->result = 0;
-					ctx->tid = idx;
-				}
-			} else {
-				clear_filter(adap, f);
-				if (ctx)
-					ctx->result = err;
+			f->pending = 0;  /* async setup completed */
+			f->valid = 1;
+			if (ctx) {
+				ctx->result = 0;
+				ctx->tid = idx;
 			}
 		} else {
 			/* Something went wrong.  Issue a warning about the
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
@@ -50,6 +50,10 @@
 #define TCB_T_FLAGS_M		0xffffffffffffffffULL
 #define TCB_T_FLAGS_V(x)	((__u64)(x) << TCB_T_FLAGS_S)
 
+#define TF_DROP_S		22
+#define TF_DIRECT_STEER_S	23
+#define TF_LPBK_S		59
+
 #define TF_CCTRL_ECE_S		60
 #define TF_CCTRL_CWR_S		61
 #define TF_CCTRL_RFR_S		62


