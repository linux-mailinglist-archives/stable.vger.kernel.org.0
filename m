Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997833D6289
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhGZPgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhGZPfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E0156056B;
        Mon, 26 Jul 2021 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316170;
        bh=uNnboFeGRHzhsbMnsKDoReIh4z875Ruuq0ZcNc7DW+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxvFdEDILZVSRZ/IL7NQOIqgslTNgPBkKkLiQOUnQU/5PzbAb+4ScdHj85X0AwHR0
         710MZg//jytngq918f/MjZ5KQeGhEJsIpDx9biMZwT3/PZPw5Ne2RshA35g3h7LEUG
         Az53G5R36fL1qmFm1Yf8PnJIh4JjOianUaJ1nGLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 215/223] mptcp: fix masking a bool warning
Date:   Mon, 26 Jul 2021 17:40:07 +0200
Message-Id: <20210726153853.215833533@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit c4512c63b1193c73b3f09c598a6d0a7f88da1dd8 upstream.

Dan Carpenter reported an issue introduced in
commit fde56eea01f9 ("mptcp: refine mptcp_cleanup_rbuf") where a new
boolean (ack_pending) is masked with 0x9.

This is not the intention to ignore values by using a boolean. This
variable should not have a 'bool' type: we should keep the 'u8' to allow
this comparison.

Fixes: fde56eea01f9 ("mptcp: refine mptcp_cleanup_rbuf")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -446,7 +446,7 @@ static void mptcp_subflow_cleanup_rbuf(s
 static bool mptcp_subflow_could_cleanup(const struct sock *ssk, bool rx_empty)
 {
 	const struct inet_connection_sock *icsk = inet_csk(ssk);
-	bool ack_pending = READ_ONCE(icsk->icsk_ack.pending);
+	u8 ack_pending = READ_ONCE(icsk->icsk_ack.pending);
 	const struct tcp_sock *tp = tcp_sk(ssk);
 
 	return (ack_pending & ICSK_ACK_SCHED) &&


