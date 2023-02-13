Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B016949A2
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBMPAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjBMPAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7961E1CAFA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:00:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BDCCB80DF1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFCEC433D2;
        Mon, 13 Feb 2023 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300378;
        bh=euOhVgYGuI8oZbdL2rie3QqxtQf/rzPsyBUWRRycc2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWR5JqU2vgyfWAg93irEi5zwKvn33y0zoLvPVfYyiyfKbHuPEu9i+oewIFLsbzhHS
         PbDEfVZEvprfO4j2Dq44rg7TOWHNxjJlSNpRp/khiyFBDhK9GzaLttJHHuIRLy8e2s
         7qp/JwEFvM2vUNwtds8k0aZVFckiIf+tucY3obUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 51/67] mptcp: be careful on subflow status propagation on errors
Date:   Mon, 13 Feb 2023 15:49:32 +0100
Message-Id: <20230213144734.812602154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 1249db44a102d9d3541ed7798d4b01ffdcf03524 upstream.

Currently the subflow error report callback unconditionally
propagates the fallback subflow status to the owning msk.

If the msk is already orphaned, the above prevents the code
from correctly tracking the msk moving to the TCP_CLOSE state
and doing the appropriate cleanup.

All the above causes increasing memory usage over time and
sporadic self-tests failures.

There is a great deal of infrastructure trying to propagate
correctly the fallback subflow status to the owning mptcp socket,
e.g. via mptcp_subflow_eof() and subflow_sched_work_if_closed():
in the error propagation path we need only to cope with unorphaned
sockets.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/339
Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1284,6 +1284,7 @@ void __mptcp_error_report(struct sock *s
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		int err = sock_error(ssk);
+		int ssk_state;
 
 		if (!err)
 			continue;
@@ -1294,7 +1295,14 @@ void __mptcp_error_report(struct sock *s
 		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
 			continue;
 
-		inet_sk_state_store(sk, inet_sk_state_load(ssk));
+		/* We need to propagate only transition to CLOSE state.
+		 * Orphaned socket will see such state change via
+		 * subflow_sched_work_if_closed() and that path will properly
+		 * destroy the msk as needed.
+		 */
+		ssk_state = inet_sk_state_load(ssk);
+		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
+			inet_sk_state_store(sk, ssk_state);
 		sk->sk_err = -err;
 
 		/* This barrier is coupled with smp_rmb() in mptcp_poll() */


