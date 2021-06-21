Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3F63AEE57
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhFUQ2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231569AbhFUQ00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 481A9613B0;
        Mon, 21 Jun 2021 16:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292545;
        bh=Xk6NqxINjXSnPXTKGFSoNyso+38aztNwi/1UD232EQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPSQlnPrw+QLN2nynSIgbewS02bqFTehViW/RqSO6saRrCITPhtedj4a3bBcXNmJQ
         XK7VVAo1d4wq5p2Qznii9cGiMk0ICwEhDHZqpyMq+KM/4rcPembmfRjEhyAWJAE+tx
         DDUxfQN3WbpiMmIJtOZUZ9PNBeHd0VHgUuespEQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/146] mptcp: do not warn on bad input from the network
Date:   Mon, 21 Jun 2021 18:14:28 +0200
Message-Id: <20210621154912.589676201@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 61e710227e97172355d5f150d5c78c64175d9fb2 ]

warn_bad_map() produces a kernel WARN on bad input coming
from the network. Use pr_debug() to avoid spamming the system
log.

Additionally, when the right bound check fails, warn_bad_map() reports
the wrong ssn value, let's fix it.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/107
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 96b6aca9d0ae..851fb3d8c791 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -655,10 +655,10 @@ static u64 expand_seq(u64 old_seq, u16 old_data_len, u64 seq)
 	return seq | ((old_seq + old_data_len + 1) & GENMASK_ULL(63, 32));
 }
 
-static void warn_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
+static void dbg_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
 {
-	WARN_ONCE(1, "Bad mapping: ssn=%d map_seq=%d map_data_len=%d",
-		  ssn, subflow->map_subflow_seq, subflow->map_data_len);
+	pr_debug("Bad mapping: ssn=%d map_seq=%d map_data_len=%d",
+		 ssn, subflow->map_subflow_seq, subflow->map_data_len);
 }
 
 static bool skb_is_fully_mapped(struct sock *ssk, struct sk_buff *skb)
@@ -683,13 +683,13 @@ static bool validate_mapping(struct sock *ssk, struct sk_buff *skb)
 		/* Mapping covers data later in the subflow stream,
 		 * currently unsupported.
 		 */
-		warn_bad_map(subflow, ssn);
+		dbg_bad_map(subflow, ssn);
 		return false;
 	}
 	if (unlikely(!before(ssn, subflow->map_subflow_seq +
 				  subflow->map_data_len))) {
 		/* Mapping does covers past subflow data, invalid */
-		warn_bad_map(subflow, ssn + skb->len);
+		dbg_bad_map(subflow, ssn);
 		return false;
 	}
 	return true;
-- 
2.30.2



