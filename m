Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62B0657DFA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiL1Ps7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiL1Psp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:48:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13EA17E3B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EBE3613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80586C433F0;
        Wed, 28 Dec 2022 15:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242522;
        bh=w2VH7BR6TdFoK2qaCSRHDnGx24GePt9+BKxsLt61T5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L07h53kMVMj22TtYovQWneg/cilLXCIFFvS4CWj1h+N9mfxLlhNwbTy9MbE/xr2gR
         daECvMEduJkigItvIQSlmiU9+fSTs/+1PU+gimFaCfF9TTFTMeyRBY9HQFz5hWp8NW
         X5UpzK2YbrFrtlLSQ1FecuIfRBbe9DwNvqBKZP7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Changheon Lee <darklight2357@icloud.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 613/731] net: stream: purge sk_error_queue in sk_stream_kill_queues()
Date:   Wed, 28 Dec 2022 15:42:00 +0100
Message-Id: <20221228144314.303640263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e0c8bccd40fc1c19e1d246c39bcf79e357e1ada3 ]

Changheon Lee reported TCP socket leaks, with a nice repro.

It seems we leak TCP sockets with the following sequence:

1) SOF_TIMESTAMPING_TX_ACK is enabled on the socket.

   Each ACK will cook an skb put in error queue, from __skb_tstamp_tx().
   __skb_tstamp_tx() is using skb_clone(), unless
   SOF_TIMESTAMPING_OPT_TSONLY was also requested.

2) If the application is also using MSG_ZEROCOPY, then we put in the
   error queue cloned skbs that had a struct ubuf_info attached to them.

   Whenever an struct ubuf_info is allocated, sock_zerocopy_alloc()
   does a sock_hold().

   As long as the cloned skbs are still in sk_error_queue,
   socket refcount is kept elevated.

3) Application closes the socket, while error queue is not empty.

Since tcp_close() no longer purges the socket error queue,
we might end up with a TCP socket with at least one skb in
error queue keeping the socket alive forever.

This bug can be (ab)used to consume all kernel memory
and freeze the host.

We need to purge the error queue, with proper synchronization
against concurrent writers.

Fixes: 24bcbe1cc69f ("net: stream: don't purge sk_error_queue in sk_stream_kill_queues()")
Reported-by: Changheon Lee <darklight2357@icloud.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/stream.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/stream.c b/net/core/stream.c
index a61130504827..d7c5413d16d5 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -196,6 +196,12 @@ void sk_stream_kill_queues(struct sock *sk)
 	/* First the read buffer. */
 	__skb_queue_purge(&sk->sk_receive_queue);
 
+	/* Next, the error queue.
+	 * We need to use queue lock, because other threads might
+	 * add packets to the queue without socket lock being held.
+	 */
+	skb_queue_purge(&sk->sk_error_queue);
+
 	/* Next, the write queue. */
 	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
 
-- 
2.35.1



