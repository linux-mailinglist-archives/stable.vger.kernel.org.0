Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C112171B5
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgGGPYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgGGPYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC89B206F6;
        Tue,  7 Jul 2020 15:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135462;
        bh=co+nTpKG8qYDYuVZfFmnb13CQYw05JwSHsxV7dRzXTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+x8z/7gpJjx3WJobqgEmN4qkJCNooz1gtqxZuyj49vJsGwQ3i1iP1Kt7/LbMlYFi
         LEihZfQbBoByZ/OWOeTVVuEAmfd2PE2uxaCZz1PuAz+DfDZrfA3DgpQ0Y/c8ST9mb7
         /0u7hbgQ7b2F85B9oiixADsJ0v/c31Ja84F5420o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 050/112] mptcp: drop MP_JOIN request sock on syn cookies
Date:   Tue,  7 Jul 2020 17:16:55 +0200
Message-Id: <20200707145803.384930723@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9e365ff576b7c1623bbc5ef31ec652c533e2f65e ]

Currently any MPTCP socket using syn cookies will fallback to
TCP at 3rd ack time. In case of MP_JOIN requests, the RFC mandate
closing the child and sockets, but the existing error paths
do not handle the syncookie scenario correctly.

Address the issue always forcing the child shutdown in case of
MP_JOIN fallback.

Fixes: ae2dd7164943 ("mptcp: handle tcp fallback when using syn cookies")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index db3e4e74e7857..0112ead58fd8b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -424,22 +424,25 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk);
 	struct mptcp_subflow_request_sock *subflow_req;
 	struct mptcp_options_received mp_opt;
-	bool fallback_is_fatal = false;
+	bool fallback, fallback_is_fatal;
 	struct sock *new_msk = NULL;
-	bool fallback = false;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
 
-	/* we need later a valid 'mp_capable' value even when options are not
-	 * parsed
+	/* After child creation we must look for 'mp_capable' even when options
+	 * are not parsed
 	 */
 	mp_opt.mp_capable = 0;
-	if (tcp_rsk(req)->is_mptcp == 0)
+
+	/* hopefully temporary handling for MP_JOIN+syncookie */
+	subflow_req = mptcp_subflow_rsk(req);
+	fallback_is_fatal = subflow_req->mp_join;
+	fallback = !tcp_rsk(req)->is_mptcp;
+	if (fallback)
 		goto create_child;
 
 	/* if the sk is MP_CAPABLE, we try to fetch the client key */
-	subflow_req = mptcp_subflow_rsk(req);
 	if (subflow_req->mp_capable) {
 		if (TCP_SKB_CB(skb)->seq != subflow_req->ssn_offset + 1) {
 			/* here we can receive and accept an in-window,
@@ -460,12 +463,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		if (!new_msk)
 			fallback = true;
 	} else if (subflow_req->mp_join) {
-		fallback_is_fatal = true;
 		mptcp_get_options(skb, &mp_opt);
 		if (!mp_opt.mp_join ||
 		    !subflow_hmac_valid(req, &mp_opt)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-			return NULL;
+			fallback = true;
 		}
 	}
 
-- 
2.25.1



