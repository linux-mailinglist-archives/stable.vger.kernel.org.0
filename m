Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA87531816
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbiEWRdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbiEWR0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BDD70936;
        Mon, 23 May 2022 10:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A634EB81201;
        Mon, 23 May 2022 17:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB63CC385A9;
        Mon, 23 May 2022 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326497;
        bh=5oRlh7tuF7dVaXSfZaL8viUWBLDUMf14LLLak6DqBOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nhQjbM4waT8+JsrN3d4t3pAUzPzKD+KE43uD28p1usFr2fJ/EnZDcCLgvVeOvVWg
         pL5lrXbLJ+tTP8y4BN6naHlXtRspwmpFYhEBWV9blL6yveUJMDXrfykZIDdwqZKTsk
         Bh92MQp1HWLvT/YPHA9XvkDuMj5eTUQLirs8N4Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/132] mptcp: Do TCP fallback on early DSS checksum failure
Date:   Mon, 23 May 2022 19:05:08 +0200
Message-Id: <20220523165839.836410309@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

[ Upstream commit ae66fb2ba6c3dcaf8b9612b65aa949a1a4bed150 ]

RFC 8684 section 3.7 describes several opportunities for a MPTCP
connection to "fall back" to regular TCP early in the connection
process, before it has been confirmed that MPTCP options can be
successfully propagated on all SYN, SYN/ACK, and data packets. If a peer
acknowledges the first received data packet with a regular TCP header
(no MPTCP options), fallback is allowed.

If the recipient of that first data packet finds a MPTCP DSS checksum
error, this provides an opportunity to fail gracefully with a TCP
fallback rather than resetting the connection (as might happen if a
checksum failure were detected later).

This commit modifies the checksum failure code to attempt fallback on
the initial subflow of a MPTCP connection, only if it's a failure in the
first data mapping. In cases where the peer initiates the connection,
requests checksums, is the first to send data, and the peer is sending
incorrect checksums (see
https://github.com/multipath-tcp/mptcp_net-next/issues/275), this allows
the connection to proceed as TCP rather than reset.

Fixes: dd8bcd1768ff ("mptcp: validate the data checksum")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h |  3 ++-
 net/mptcp/subflow.c  | 21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8d70e491139a..62ad31482644 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -437,7 +437,8 @@ struct mptcp_subflow_context {
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
-		local_id_valid : 1; /* local_id is correctly initialized */
+		local_id_valid : 1, /* local_id is correctly initialized */
+		valid_csum_seen : 1;        /* at least one csum validated */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 204dfb82f697..c52a824c0669 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -958,11 +958,14 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		subflow->send_mp_fail = 1;
-		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
+		if (subflow->mp_join || subflow->valid_csum_seen) {
+			subflow->send_mp_fail = 1;
+			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
+		}
 		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
 	}
 
+	subflow->valid_csum_seen = 1;
 	return MAPPING_OK;
 }
 
@@ -1144,6 +1147,18 @@ static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ss
 	}
 }
 
+static bool subflow_can_fallback(struct mptcp_subflow_context *subflow)
+{
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	if (subflow->mp_join)
+		return false;
+	else if (READ_ONCE(msk->csum_enabled))
+		return !subflow->valid_csum_seen;
+	else
+		return !subflow->fully_established;
+}
+
 static bool subflow_check_data_avail(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
@@ -1221,7 +1236,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		return true;
 	}
 
-	if (subflow->mp_join || subflow->fully_established) {
+	if (!subflow_can_fallback(subflow)) {
 		/* fatal protocol error, close the socket.
 		 * subflow_error_report() will introduce the appropriate barriers
 		 */
-- 
2.35.1



