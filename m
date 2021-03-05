Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2198D32E7F7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCEMYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhCEMYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1AC56501C;
        Fri,  5 Mar 2021 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947042;
        bh=BrIL91X7w/K/6K3lseu2UGZ/tSpzjJoiG51w+joUvzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2R3HXt1iilnvN+UUHpSBf9I+iy7EEnFFvefTYgEJnIsHMGhoWYp/HwKP8ZeHdI6F
         pyg+Gw4YKZnMpCOBieUBot2itUTkghR78moGbQsu+sOYr+e3I9uZaIgWrBLKpGh1dS
         Nq4W/zq7lic8fP4cp2w9JMl/4pbHlMim0QQ2aZRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 026/104] mptcp: fix DATA_FIN generation on early shutdown
Date:   Fri,  5 Mar 2021 13:20:31 +0100
Message-Id: <20210305120904.462928273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit d87903b63e3ce1eafaa701aec5cc1d0ecd0d84dc upstream.

If the msk is closed before sending or receiving any data,
no DATA_FIN is generated, instead an MPC ack packet is
crafted out.

In the above scenario, the MPTCP protocol creates and sends a
pure ack and such packets matches also the criteria for an
MPC ack and the protocol tries first to insert MPC options,
leading to the described error.

This change addresses the issue by avoiding the insertion of an
MPC option for DATA_FIN packets or if the sub-flow is not
established.

To avoid doing multiple times the same test, fetch the data_fin
flag in a bool variable and pass it to both the interested
helpers.

Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -401,6 +401,7 @@ static void clear_3rdack_retransmission(
 }
 
 static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
+					 bool snd_data_fin_enable,
 					 unsigned int *size,
 					 unsigned int remaining,
 					 struct mptcp_out_options *opts)
@@ -418,9 +419,10 @@ static bool mptcp_established_options_mp
 	if (!skb)
 		return false;
 
-	/* MPC/MPJ needed only on 3rd ack packet */
-	if (subflow->fully_established ||
-	    subflow->snd_isn != TCP_SKB_CB(skb)->seq)
+	/* MPC/MPJ needed only on 3rd ack packet, DATA_FIN and TCP shutdown take precedence */
+	if (subflow->fully_established || snd_data_fin_enable ||
+	    subflow->snd_isn != TCP_SKB_CB(skb)->seq ||
+	    sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
 	if (subflow->mp_capable) {
@@ -492,6 +494,7 @@ static void mptcp_write_data_fin(struct
 }
 
 static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
+					  bool snd_data_fin_enable,
 					  unsigned int *size,
 					  unsigned int remaining,
 					  struct mptcp_out_options *opts)
@@ -499,13 +502,11 @@ static bool mptcp_established_options_ds
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	unsigned int dss_size = 0;
-	u64 snd_data_fin_enable;
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
 	bool ret = false;
 
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
-	snd_data_fin_enable = mptcp_data_fin_enabled(msk);
 
 	if (!skb || (mpext && mpext->use_map) || snd_data_fin_enable) {
 		unsigned int map_size;
@@ -683,12 +684,15 @@ bool mptcp_established_options(struct so
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	unsigned int opt_size = 0;
+	bool snd_data_fin;
 	bool ret = false;
 
 	opts->suboptions = 0;
 
-	if (unlikely(mptcp_check_fallback(sk)))
+	if (unlikely(__mptcp_check_fallback(msk)))
 		return false;
 
 	/* prevent adding of any MPTCP related options on reset packet
@@ -697,10 +701,10 @@ bool mptcp_established_options(struct so
 	if (unlikely(skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_RST))
 		return false;
 
-	if (mptcp_established_options_mp(sk, skb, &opt_size, remaining, opts))
+	snd_data_fin = mptcp_data_fin_enabled(msk);
+	if (mptcp_established_options_mp(sk, skb, snd_data_fin, &opt_size, remaining, opts))
 		ret = true;
-	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
-					       opts))
+	else if (mptcp_established_options_dss(sk, skb, snd_data_fin, &opt_size, remaining, opts))
 		ret = true;
 
 	/* we reserved enough space for the above options, and exceeding the


