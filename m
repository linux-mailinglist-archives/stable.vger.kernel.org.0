Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED93A3005F4
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbhAVOsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbhAVOY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2917023A6A;
        Fri, 22 Jan 2021 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325171;
        bh=vsPG3O9U4/Y9fiGl1bPICsZwVBcXGrTpnU2j1KOkFUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCMz6j0C4u2Z9Wh8yuCeQBorxeIZwiEUPu0oFA/k7BttoCA8OxC3K8DaYykeMfVPE
         6ZR3PSN10H1elnN3d02taHIuveZ9vFLvmCg8j5hBId8au1fcf8XIPSv6O3gbIt3ki+
         96HPbrD+vmVd/kcbEs+TEyZdFYB8M6z8yJngHj74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 41/43] cxgb4/chtls: Fix tid stuck due to wrong update of qid
Date:   Fri, 22 Jan 2021 15:12:57 +0100
Message-Id: <20210122135737.327990304@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

commit 8ad2a970d2010add3963e7219eb50367ab3fa4eb upstream.

TID stuck is seen when there is a race in
CPL_PASS_ACCEPT_RPL/CPL_ABORT_REQ and abort is arriving
before the accept reply, which sets the queue number.
In this case HW ends up sending CPL_ABORT_RPL_RSS to an
incorrect ingress queue.

V1->V2:
- Removed the unused variable len in chtls_set_quiesce_ctrl().

V2->V3:
- As kfree_skb() has a check for null skb, so removed this
check before calling kfree_skb() in func chtls_send_reset().

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Link: https://lore.kernel.org/r/20210112053600.24590-1-ayush.sawal@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h                 |    7 ++
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h    |    4 +
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |   32 ++++++++-
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c |   41 ++++++++++++
 4 files changed, 82 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
@@ -40,6 +40,13 @@
 #define TCB_L2T_IX_M		0xfffULL
 #define TCB_L2T_IX_V(x)		((x) << TCB_L2T_IX_S)
 
+#define TCB_T_FLAGS_W           1
+#define TCB_T_FLAGS_S           0
+#define TCB_T_FLAGS_M           0xffffffffffffffffULL
+#define TCB_T_FLAGS_V(x)        ((__u64)(x) << TCB_T_FLAGS_S)
+
+#define TCB_FIELD_COOKIE_TFLAG	1
+
 #define TCB_SMAC_SEL_W		0
 #define TCB_SMAC_SEL_S		24
 #define TCB_SMAC_SEL_M		0xffULL
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -573,7 +573,11 @@ int send_tx_flowc_wr(struct sock *sk, in
 void chtls_tcp_push(struct sock *sk, int flags);
 int chtls_push_frames(struct chtls_sock *csk, int comp);
 int chtls_set_tcb_tflag(struct sock *sk, unsigned int bit_pos, int val);
+void chtls_set_tcb_field_rpl_skb(struct sock *sk, u16 word,
+				 u64 mask, u64 val, u8 cookie,
+				 int through_l2t);
 int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 mode, int cipher_type);
+void chtls_set_quiesce_ctrl(struct sock *sk, int val);
 void skb_entail(struct sock *sk, struct sk_buff *skb, int flags);
 unsigned int keyid_to_addr(int start_addr, int keyid);
 void free_tls_keyid(struct sock *sk);
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -32,6 +32,7 @@
 #include "chtls.h"
 #include "chtls_cm.h"
 #include "clip_tbl.h"
+#include "t4_tcb.h"
 
 /*
  * State transitions and actions for close.  Note that if we are in SYN_SENT
@@ -267,7 +268,9 @@ static void chtls_send_reset(struct sock
 	if (sk->sk_state != TCP_SYN_RECV)
 		chtls_send_abort(sk, mode, skb);
 	else
-		goto out;
+		chtls_set_tcb_field_rpl_skb(sk, TCB_T_FLAGS_W,
+					    TCB_T_FLAGS_V(TCB_T_FLAGS_M), 0,
+					    TCB_FIELD_COOKIE_TFLAG, 1);
 
 	return;
 out:
@@ -1948,6 +1951,8 @@ static void chtls_close_con_rpl(struct s
 		else if (tcp_sk(sk)->linger2 < 0 &&
 			 !csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN))
 			chtls_abort_conn(sk, skb);
+		else if (csk_flag_nochk(csk, CSK_TX_DATA_SENT))
+			chtls_set_quiesce_ctrl(sk, 0);
 		break;
 	default:
 		pr_info("close_con_rpl in bad state %d\n", sk->sk_state);
@@ -2291,6 +2296,28 @@ static int chtls_wr_ack(struct chtls_dev
 	return 0;
 }
 
+static int chtls_set_tcb_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
+{
+	struct cpl_set_tcb_rpl *rpl = cplhdr(skb) + RSS_HDR;
+	unsigned int hwtid = GET_TID(rpl);
+	struct sock *sk;
+
+	sk = lookup_tid(cdev->tids, hwtid);
+
+	/* return EINVAL if socket doesn't exist */
+	if (!sk)
+		return -EINVAL;
+
+	/* Reusing the skb as size of cpl_set_tcb_field structure
+	 * is greater than cpl_abort_req
+	 */
+	if (TCB_COOKIE_G(rpl->cookie) == TCB_FIELD_COOKIE_TFLAG)
+		chtls_send_abort(sk, CPL_ABORT_SEND_RST, NULL);
+
+	kfree_skb(skb);
+	return 0;
+}
+
 chtls_handler_func chtls_handlers[NUM_CPL_CMDS] = {
 	[CPL_PASS_OPEN_RPL]     = chtls_pass_open_rpl,
 	[CPL_CLOSE_LISTSRV_RPL] = chtls_close_listsrv_rpl,
@@ -2303,5 +2330,6 @@ chtls_handler_func chtls_handlers[NUM_CP
 	[CPL_CLOSE_CON_RPL]     = chtls_conn_cpl,
 	[CPL_ABORT_REQ_RSS]     = chtls_conn_cpl,
 	[CPL_ABORT_RPL_RSS]     = chtls_conn_cpl,
-	[CPL_FW4_ACK]           = chtls_wr_ack,
+	[CPL_FW4_ACK]		= chtls_wr_ack,
+	[CPL_SET_TCB_RPL]	= chtls_set_tcb_rpl,
 };
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
@@ -88,6 +88,24 @@ static int chtls_set_tcb_field(struct so
 	return ret < 0 ? ret : 0;
 }
 
+void chtls_set_tcb_field_rpl_skb(struct sock *sk, u16 word,
+				 u64 mask, u64 val, u8 cookie,
+				 int through_l2t)
+{
+	struct sk_buff *skb;
+	unsigned int wrlen;
+
+	wrlen = sizeof(struct cpl_set_tcb_field) + sizeof(struct ulptx_idata);
+	wrlen = roundup(wrlen, 16);
+
+	skb = alloc_skb(wrlen, GFP_KERNEL | __GFP_NOFAIL);
+	if (!skb)
+		return;
+
+	__set_tcb_field(sk, skb, word, mask, val, cookie, 0);
+	send_or_defer(sk, tcp_sk(sk), skb, through_l2t);
+}
+
 /*
  * Set one of the t_flags bits in the TCB.
  */
@@ -113,6 +131,29 @@ static int chtls_set_tcb_quiesce(struct
 				   TF_RX_QUIESCE_V(val));
 }
 
+void chtls_set_quiesce_ctrl(struct sock *sk, int val)
+{
+	struct chtls_sock *csk;
+	struct sk_buff *skb;
+	unsigned int wrlen;
+	int ret;
+
+	wrlen = sizeof(struct cpl_set_tcb_field) + sizeof(struct ulptx_idata);
+	wrlen = roundup(wrlen, 16);
+
+	skb = alloc_skb(wrlen, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	csk = rcu_dereference_sk_user_data(sk);
+
+	__set_tcb_field(sk, skb, 1, TF_RX_QUIESCE_V(1), 0, 0, 1);
+	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->port_id);
+	ret = cxgb4_ofld_send(csk->egress_dev, skb);
+	if (ret < 0)
+		kfree_skb(skb);
+}
+
 /* TLS Key bitmap processing */
 int chtls_init_kmap(struct chtls_dev *cdev, struct cxgb4_lld_info *lldi)
 {


