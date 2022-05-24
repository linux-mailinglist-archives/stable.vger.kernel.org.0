Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D5C53301F
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbiEXSLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240202AbiEXSKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:10:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26CB6C0E5
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653415847; x=1684951847;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I8M5fIPaHh99TmMz/ShIUrTVDAxnpLhtI9rx+8UM15A=;
  b=bAmennvejpvkkKrsYLIx3z3fo2F74nkPXItW1U9l9GOeavaqFzwOYH5+
   g3AnSsQSTzWJlBkUFD541ikURbYHNW2NvApD/2bI/PwKl+HWr0oPTkdJu
   PrFYnaFKWjfHRr392zI4DhdiDzuxjONwtEpyDKWvTq/U8oN+LtjQ3S0r5
   lukZiCXksf3pOfGzYqIxjevWFRAdkKg7TaKpo3C4Rc1sEup/OtsAyl4i0
   Q5tWxGX0Kq77upSbTwue2kZuZbku3fBnoXEhbk5c2x3zVat4TXGa35aQ8
   /U5HWOEHFGPMz7StubRHW37RNHOHo1ggEULxA4xqZ53U5J5vKE2MLjDTo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="254116691"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="254116691"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 11:10:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="703582853"
Received: from emattson-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.151.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 11:10:46 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        gregkh@linuxfoundation.org, sashal@kernel.org,
        matthieu.baerts@tessares.net, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] mptcp: Do TCP fallback on early DSS checksum failure
Date:   Tue, 24 May 2022 11:10:41 -0700
Message-Id: <20220524181041.19543-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: <stable@vger.kernel.org> # 5.17.x
Cc: <stable@vger.kernel.org> # 5.15.x
Fixes: dd8bcd1768ff ("mptcp: validate the data checksum")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[mathew.j.martineau: backport: Resolved bitfield conflict in protocol.h]
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---

This patch is already in 5.17.10-rc1 and 5.15.42-rc1, but involves a
context dependency on upstream commit 4cf86ae84c71 which I have
requested to be dropped from the stable queues.

I'm posting this backport without the protocol.h conflict to
(hopefully?) make it easier for the stable maintainers to drop
4cf86ae84c71.

For context see https://lore.kernel.org/stable/fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com/

Thanks,

Mat

---
net/mptcp/protocol.h |  3 ++-
 net/mptcp/subflow.c  | 21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index aec767ee047a..46b343a0b17e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -442,7 +442,8 @@ struct mptcp_subflow_context {
 		rx_eof : 1,
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1,	    /* ctx can be free at ulp release time */
-		stale : 1;	    /* unable to snd/rcv data, do not use for xmit */
+		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
+		valid_csum_seen : 1;        /* at least one csum validated */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 651f01d13191..8d5ddf8e3ef7 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -913,11 +913,14 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
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
 
@@ -1099,6 +1102,18 @@ static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ss
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
@@ -1176,7 +1191,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		return true;
 	}
 
-	if (subflow->mp_join || subflow->fully_established) {
+	if (!subflow_can_fallback(subflow)) {
 		/* fatal protocol error, close the socket.
 		 * subflow_error_report() will introduce the appropriate barriers
 		 */
-- 
2.36.1

