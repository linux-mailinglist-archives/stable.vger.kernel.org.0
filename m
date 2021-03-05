Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA14732E7F9
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhCEMYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhCEMX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 024EC6501F;
        Fri,  5 Mar 2021 12:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947039;
        bh=SzojYnQCwhc1w1wKOIOAH6N0pVGtFLcp5m3/nW4OaS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/YQwGmes3VM0ZGdkoMXTYbhUcsHVbem9NnPeq1Z3z6QtmEvC9qRbTYGzGxu86nus
         2DmhTR8FqMTcARrVaFUqEBMV6updaH6xAfMqv5AwLzi/btoB3Ts2gVn9CmXZsLm7Su
         Ii57KEvReil2CFNK32/1UQe8ExUy1ojSaA7D7gKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 025/104] mptcp: do not wakeup listener for MPJ subflows
Date:   Fri,  5 Mar 2021 13:20:30 +0100
Message-Id: <20210305120904.414387454@linuxfoundation.org>
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

commit 52557dbc7538ecceb27ef2206719a47a8039a335 upstream.

MPJ subflows are not exposed as fds to user spaces. As such,
incoming MPJ subflows are removed from the accept queue by
tcp_check_req()/tcp_get_cookie_sock().

Later tcp_child_process() invokes subflow_data_ready() on the
parent socket regardless of the subflow kind, leading to poll
wakeups even if the later accept will block.

Address the issue by double-checking the queue state before
waking the user-space.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/164
Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1026,6 +1026,12 @@ static void subflow_data_ready(struct so
 
 	msk = mptcp_sk(parent);
 	if (state & TCPF_LISTEN) {
+		/* MPJ subflow are removed from accept queue before reaching here,
+		 * avoid stray wakeups
+		 */
+		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
+			return;
+
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 		parent->sk_data_ready(parent);
 		return;


