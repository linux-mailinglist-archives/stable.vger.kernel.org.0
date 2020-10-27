Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067ED29C11C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368272AbgJ0Oyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766585AbgJ0OtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80FDE207DE;
        Tue, 27 Oct 2020 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810162;
        bh=1vzlWKVIFhdDYQeiCTaVEr3glNUUpWGJ7xCLr2S38a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUtdFqaZVOHXdIv5QFrFwj8dwTAhV2822G1ENg6HGaMJz5ixkxjMAPOMOf1ePus59
         FD6h7Qn3tP4TNytHrOADeWHyyle25gxbP/K9Mk0JRghMkIhzTOQcmSPFVN8dGkTGQX
         BUUvId3QRuv5LPcrsbAYHKOIklQ5Jb33THzljCeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 011/633] net: mptcp: make DACK4/DACK8 usage consistent among all subflows
Date:   Tue, 27 Oct 2020 14:45:54 +0100
Message-Id: <20201027135523.213700454@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 37198e93ced70733f0b993dff28b7c33857e254f ]

using packetdrill it's possible to observe the same MPTCP DSN being acked
by different subflows with DACK4 and DACK8. This is in contrast with what
specified in RFC8684 §3.3.2: if an MPTCP endpoint transmits a 64-bit wide
DSN, it MUST be acknowledged with a 64-bit wide DACK. Fix 'use_64bit_ack'
variable to make it a property of MPTCP sockets, not TCP subflows.

Fixes: a0c1d0eafd1e ("mptcp: Use 32-bit DATA_ACK when possible")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |    2 +-
 net/mptcp/protocol.h |    2 +-
 net/mptcp/subflow.c  |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -517,7 +517,7 @@ static bool mptcp_established_options_ds
 		return ret;
 	}
 
-	if (subflow->use_64bit_ack) {
+	if (READ_ONCE(msk->use_64bit_ack)) {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
 		opts->ext_copy.data_ack = msk->ack_seq;
 		opts->ext_copy.ack64 = 1;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -199,6 +199,7 @@ struct mptcp_sock {
 	u32		token;
 	unsigned long	flags;
 	bool		can_ack;
+	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct list_head conn_list;
@@ -285,7 +286,6 @@ struct mptcp_subflow_context {
 		data_avail : 1,
 		rx_eof : 1,
 		data_fin_tx_enable : 1,
-		use_64bit_ack : 1, /* Set when we received a 64-bit DSN */
 		can_ack : 1;	    /* only after processing the remote a key */
 	u64	data_fin_tx_seq;
 	u32	remote_nonce;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -682,12 +682,11 @@ static enum mapping_status get_mapping_s
 	if (!mpext->dsn64) {
 		map_seq = expand_seq(subflow->map_seq, subflow->map_data_len,
 				     mpext->data_seq);
-		subflow->use_64bit_ack = 0;
 		pr_debug("expanded seq=%llu", subflow->map_seq);
 	} else {
 		map_seq = mpext->data_seq;
-		subflow->use_64bit_ack = 1;
 	}
+	WRITE_ONCE(mptcp_sk(subflow->conn)->use_64bit_ack, !!mpext->dsn64);
 
 	if (subflow->map_valid) {
 		/* Allow replacing only with an identical map */


