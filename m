Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C192E6927
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgL1Qph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:45:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbgL1M4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62862224D2;
        Mon, 28 Dec 2020 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160164;
        bh=GwLfizYky5koo3y6Jw4xslhpspIHRjQRdYqK8Qj9jUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBmejKic6Oa9XdVYEcmz+pz5+91HgDEqY4uDtPAtlubXXMnc0io9t6bWaW5+YNr1v
         zyyyfo7cPWTX//kbBu+yftHRIdoWrfy37da8d5ZJAbFxw8GQFvRb1ppq+4LIJWp5uH
         VoYapmcRR48y6BRuMiGfqLilO5LmZPZ+0s+/piOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Calum Mackay <calum.mackay@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 061/132] lockd: dont use interval-based rebinding over TCP
Date:   Mon, 28 Dec 2020 13:49:05 +0100
Message-Id: <20201228124849.401233508@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Calum Mackay <calum.mackay@oracle.com>

[ Upstream commit 9b82d88d5976e5f2b8015d58913654856576ace5 ]

NLM uses an interval-based rebinding, i.e. it clears the transport's
binding under certain conditions if more than 60 seconds have elapsed
since the connection was last bound.

This rebinding is not necessary for an autobind RPC client over a
connection-oriented protocol like TCP.

It can also cause problems: it is possible for nlm_bind_host() to clear
XPRT_BOUND whilst a connection worker is in the middle of trying to
reconnect, after it had already been checked in xprt_connect().

When the connection worker notices that XPRT_BOUND has been cleared
under it, in xs_tcp_finish_connecting(), that results in:

	xs_tcp_setup_socket: connect returned unhandled error -107

Worse, it's possible that the two can get into lockstep, resulting in
the same behaviour repeated indefinitely, with the above error every
300 seconds, without ever recovering, and the connection never being
established. This has been seen in practice, with a large number of NLM
client tasks, following a server restart.

The existing callers of nlm_bind_host & nlm_rebind_host should not need
to force the rebind, for TCP, so restrict the interval-based rebinding
to UDP only.

For TCP, we will still rebind when needed, e.g. on timeout, and connection
error (including closure), since connection-related errors on an existing
connection, ECONNREFUSED when trying to connect, and rpc_check_timeout(),
already unconditionally clear XPRT_BOUND.

To avoid having to add the fix, and explanation, to both nlm_bind_host()
and nlm_rebind_host(), remove the duplicate code from the former, and
have it call the latter.

Drop the dprintk, which adds no value over a trace.

Signed-off-by: Calum Mackay <calum.mackay@oracle.com>
Fixes: 35f5a422ce1a ("SUNRPC: new interface to force an RPC rebind")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/host.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index c7eb47f2fb6c3..603fa652b965d 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -430,12 +430,7 @@ nlm_bind_host(struct nlm_host *host)
 	 * RPC rebind is required
 	 */
 	if ((clnt = host->h_rpcclnt) != NULL) {
-		if (time_after_eq(jiffies, host->h_nextrebind)) {
-			rpc_force_rebind(clnt);
-			host->h_nextrebind = jiffies + NLM_HOST_REBIND;
-			dprintk("lockd: next rebind in %lu jiffies\n",
-					host->h_nextrebind - jiffies);
-		}
+		nlm_rebind_host(host);
 	} else {
 		unsigned long increment = nlmsvc_timeout;
 		struct rpc_timeout timeparms = {
@@ -483,13 +478,20 @@ nlm_bind_host(struct nlm_host *host)
 	return clnt;
 }
 
-/*
- * Force a portmap lookup of the remote lockd port
+/**
+ * nlm_rebind_host - If needed, force a portmap lookup of the peer's lockd port
+ * @host: NLM host handle for peer
+ *
+ * This is not needed when using a connection-oriented protocol, such as TCP.
+ * The existing autobind mechanism is sufficient to force a rebind when
+ * required, e.g. on connection state transitions.
  */
 void
 nlm_rebind_host(struct nlm_host *host)
 {
-	dprintk("lockd: rebind host %s\n", host->h_name);
+	if (host->h_proto != IPPROTO_UDP)
+		return;
+
 	if (host->h_rpcclnt && time_after_eq(jiffies, host->h_nextrebind)) {
 		rpc_force_rebind(host->h_rpcclnt);
 		host->h_nextrebind = jiffies + NLM_HOST_REBIND;
-- 
2.27.0



