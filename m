Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E183559BB75
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiHVIWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbiHVIWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BED31EC4E
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 424946102F
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD64C433D6;
        Mon, 22 Aug 2022 08:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661156555;
        bh=ytJnMbxJ2FtU6g2jkdV7ALwglb1BegGtuB2ELQXjGZQ=;
        h=Subject:To:Cc:From:Date:From;
        b=vAHx47gFJkcsPbm69KcBuvBziMPmJjfwezXykA9663E5Sj3g60AU7Gewkig/Mf36U
         4gWAkKcEGmXo+ETrSVSfQXKFplbaC0dUVGQaUoftoK5N6jTMPTv4K1OTWJ1kN0uxNB
         U+J9BETtzQDGEFw+1t2BHYfY2OxIXcWgoMATc89Y=
Subject: FAILED: patch "[PATCH] tcp: fix possible freeze in tx path under memory pressure" failed to apply to 4.19-stable tree
To:     edumazet@google.com, davem@davemloft.net, shakeelb@google.com,
        soheil@google.com, weiwan@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:22:28 +0200
Message-ID: <1661156548246168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f54755f6a11accb2db5ef17f8f75aad0875aefdc Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 14 Jun 2022 10:17:34 -0700
Subject: [PATCH] tcp: fix possible freeze in tx path under memory pressure

Blamed commit only dealt with applications issuing small writes.

Issue here is that we allow to force memory schedule for the sk_buff
allocation, but we have no guarantee that sendmsg() is able to
copy some payload in it.

In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.

For example, if we consider tcp_wmem[0] = 4096 (default on x86),
and initial skb->truesize being 1280, tcp_sendmsg() is able to
copy up to 2816 bytes under memory pressure.

Before this patch a sendmsg() sending more than 2816 bytes
would either block forever (if persistent memory pressure),
or return -EAGAIN.

For bigger MTU networks, it is advised to increase tcp_wmem[0]
to avoid sending too small packets.

v2: deal with zero copy paths.

Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b278063a1724..6c3eab485249 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -968,6 +968,23 @@ static int tcp_wmem_schedule(struct sock *sk, int copy)
 	return min(copy, sk->sk_forward_alloc);
 }
 
+static int tcp_wmem_schedule(struct sock *sk, int copy)
+{
+	int left;
+
+	if (likely(sk_wmem_schedule(sk, copy)))
+		return copy;
+
+	/* We could be in trouble if we have nothing queued.
+	 * Use whatever is left in sk->sk_forward_alloc and tcp_wmem[0]
+	 * to guarantee some progress.
+	 */
+	left = sock_net(sk)->ipv4.sysctl_tcp_wmem[0] - sk->sk_wmem_queued;
+	if (left > 0)
+		sk_forced_mem_schedule(sk, min(left, copy));
+	return min(copy, sk->sk_forward_alloc);
+}
+
 static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 				      struct page *page, int offset, size_t *size)
 {

