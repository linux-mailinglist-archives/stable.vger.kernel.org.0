Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DA56C183C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjCTPWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjCTPWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:22:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49EE2ED57
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8188261593
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC23C433EF;
        Mon, 20 Mar 2023 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325344;
        bh=xDcV1/srJoF5WCumscxvQSNTMwTYz8+Rs4NROu8Uv88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SC9e6p9jCQfqovfjwXy7kvMg2CR+3KRFJQHTH728217WFsjXGHsk5jQoew962sOm
         pJzEKwEQinML0OjDDCOSkFJQwYo07Pirk12pvjjz/nL6cRawuC5aC1tyo1Eup6zAjk
         Ag/w5bbwRqKRb3JDZUeYUJIld2eMdOGOm9TlIfSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH 5.15 093/115] mptcp: fix possible deadlock in subflow_error_report
Date:   Mon, 20 Mar 2023 15:55:05 +0100
Message-Id: <20230320145453.329372024@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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

commit b7a679ba7c652587b85294f4953f33ac0b756d40 upstream.

Christoph reported a possible deadlock while the TCP stack
destroys an unaccepted subflow due to an incoming reset: the
MPTCP socket error path tries to acquire the msk-level socket
lock while TCP still owns the listener socket accept queue
spinlock, and the reverse dependency already exists in the
TCP stack.

Note that the above is actually a lockdep false positive, as
the chain involves two separate sockets. A different per-socket
lockdep key will address the issue, but such a change will be
quite invasive.

Instead, we can simply stop earlier the socket error handling
for orphaned or unaccepted subflows, breaking the critical
lockdep chain. Error handling in such a scenario is a no-op.

Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/355
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1316,6 +1316,13 @@ static void subflow_error_report(struct
 {
 	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
 
+	/* bail early if this is a no-op, so that we avoid introducing a
+	 * problematic lockdep dependency between TCP accept queue lock
+	 * and msk socket spinlock
+	 */
+	if (!sk->sk_socket)
+		return;
+
 	mptcp_data_lock(sk);
 	if (!sock_owned_by_user(sk))
 		__mptcp_error_report(sk);


