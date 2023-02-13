Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33F694927
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjBMO4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjBMO4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:56:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7154F1D905
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F276B80E62
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64078C433EF;
        Mon, 13 Feb 2023 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300155;
        bh=lkjKwDHTAZ1VYrN43NqHOcIg11AWeH4x+eAm1PuIb1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVjkZZZkGHNZYxxt0WxD9bNAQiEfPLDTb3tYO3H/uGxmWIQxmC9dLbN+aG6AfsAXH
         zJ+wmBUOgXDO5J8WIKnz4UlXAUH4K7nBhXqWArXxK7H2OUfg0Sunpc1jImIuCbuY38
         ERCfk09Mi7xM/rVFUYoLgb1ZIVN4bc1zeg4ncCOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 079/114] mptcp: do not wait for bare sockets timeout
Date:   Mon, 13 Feb 2023 15:48:34 +0100
Message-Id: <20230213144746.251373216@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit d4e85922e3e7ef2071f91f65e61629b60f3a9cf4 upstream.

If the peer closes all the existing subflows for a given
mptcp socket and later the application closes it, the current
implementation let it survive until the timewait timeout expires.

While the above is allowed by the protocol specification it
consumes resources for almost no reason and additionally
causes sporadic self-tests failures.

Let's move the mptcp socket to the TCP_CLOSE state when there are
no alive subflows at close time, so that the allocated resources
will be freed immediately.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2908,6 +2908,7 @@ bool __mptcp_close(struct sock *sk, long
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool do_cancel_work = false;
+	int subflows_alive = 0;
 
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
@@ -2933,6 +2934,8 @@ cleanup:
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast_nested(ssk);
 
+		subflows_alive += ssk->sk_state != TCP_CLOSE;
+
 		/* since the close timeout takes precedence on the fail one,
 		 * cancel the latter
 		 */
@@ -2948,6 +2951,12 @@ cleanup:
 	}
 	sock_orphan(sk);
 
+	/* all the subflows are closed, only timeout can change the msk
+	 * state, let's not keep resources busy for no reasons
+	 */
+	if (subflows_alive == 0)
+		inet_sk_state_store(sk, TCP_CLOSE);
+
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
 	if (mptcp_sk(sk)->token)


