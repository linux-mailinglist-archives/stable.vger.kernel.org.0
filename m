Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4397353FA4
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239470AbhDEJN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239481AbhDEJNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C46EE61393;
        Mon,  5 Apr 2021 09:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613997;
        bh=THLPcN4UcnuyAVNLa7ChqMmgZLzB+oqS0BiZYH46z70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckl7a5qgrx8rkKfxR4w0SePvrlaxT01/PwFIWaYa560ROI5nxTcgI+E6Eg+qqVxCf
         Kw19HUA8oyVqW6lwJdpOX0HvLLU3ZKzGUjb0F+Mj009rrQgs0TfL+b5gwrqZaDLicp
         1MNaSWgsWu4707mieTksmMEzGDzFj90DDmdUK/3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 046/152] mptcp: fix DATA_FIN processing for orphaned sockets
Date:   Mon,  5 Apr 2021 10:53:15 +0200
Message-Id: <20210405085035.774611362@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 341c65242fe18aac8900e4291d472df9f7ba7bc7 ]

Currently we move orphaned msk sockets directly from FIN_WAIT2
state to CLOSE, with the rationale that incoming additional
data could be just dropped by the TCP stack/TW sockets.

Anyhow we miss sending MPTCP-level ack on incoming DATA_FIN,
and that may hang the peers.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 67483e561b37..88f2d900a347 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2292,13 +2292,12 @@ static void mptcp_worker(struct work_struct *work)
 	__mptcp_check_send_data_fin(sk);
 	mptcp_check_data_fin(sk);
 
-	/* if the msk data is completely acked, or the socket timedout,
-	 * there is no point in keeping around an orphaned sk
+	/* There is no point in keeping around an orphaned sk timedout or
+	 * closed, but we need the msk around to reply to incoming DATA_FIN,
+	 * even if it is orphaned and in FIN_WAIT2 state
 	 */
 	if (sock_flag(sk, SOCK_DEAD) &&
-	    (mptcp_check_close_timeout(sk) ||
-	    (state != sk->sk_state &&
-	    ((1 << inet_sk_state_load(sk)) & (TCPF_CLOSE | TCPF_FIN_WAIT2))))) {
+	    (mptcp_check_close_timeout(sk) || sk->sk_state == TCP_CLOSE)) {
 		inet_sk_state_store(sk, TCP_CLOSE);
 		__mptcp_destroy_sock(sk);
 		goto unlock;
-- 
2.30.1



