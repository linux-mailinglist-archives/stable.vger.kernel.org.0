Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63791667383
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjALNtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjALNsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:48:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BAF50F69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:48:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484C7B81E67
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D45BC433D2;
        Thu, 12 Jan 2023 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531315;
        bh=SkzgfLa1IBwYgrkLQEy0zBd5zkw+79zYogxXU+QuDFY=;
        h=Subject:To:Cc:From:Date:From;
        b=S4hT1KQ0V8Tcdkqyx6c6ofXy4KyvvkUdwGFK/DktNOP/fKQ5zwYz9Y/z6Wma/RKPY
         5ikoO2dYP0mOylN6Ef3fqbFxk1BSX1Z8G8LRlu2ZIVjqm14dP65EQ6OqPV2RlSd5B/
         7nuVYfnoK1LLkvb5wZkYidEoE5SvH5zU09dWtDEw=
Subject: FAILED: patch "[PATCH] net/ulp: prevent ULP without clone op from entering the" failed to apply to 4.14-stable tree
To:     pabeni@redhat.com, kuba@kernel.org, slipper.alive@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Jan 2023 14:48:32 +0100
Message-ID: <167353131224941@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2c02d41d71f9 ("net/ulp: prevent ULP without clone op from entering the LISTEN status")
e276d62dcfde ("net/ulp: remove SOCK_SUPPORT_ZC from tls sockets")
e7049395b1c3 ("dccp/tcp: Remove an unused argument in inet_csk_listen_start().")
53632e111946 ("bpf: selftest: Use bpf_sk_storage in FENTRY/FEXIT/RAW_TP")
8b27dae5a2e8 ("tcp: add one skb cache for rx")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c02d41d71f90a5168391b6a5f2954112ba2307c Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 3 Jan 2023 12:19:17 +0100
Subject: [PATCH] net/ulp: prevent ULP without clone op from entering the
 LISTEN status

When an ULP-enabled socket enters the LISTEN status, the listener ULP data
pointer is copied inside the child/accepted sockets by sk_clone_lock().

The relevant ULP can take care of de-duplicating the context pointer via
the clone() operation, but only MPTCP and SMC implement such op.

Other ULPs may end-up with a double-free at socket disposal time.

We can't simply clear the ULP data at clone time, as TLS replaces the
socket ops with custom ones assuming a valid TLS ULP context is
available.

Instead completely prevent clone-less ULP sockets from entering the
LISTEN status.

Fixes: 734942cc4ea6 ("tcp: ULP infrastructure")
Reported-by: slipper <slipper.alive@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 848ffc3e0239..d1f837579398 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1200,12 +1200,26 @@ void inet_csk_prepare_forced_close(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
+static int inet_ulp_can_listen(const struct sock *sk)
+{
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
+		return -EINVAL;
+
+	return 0;
+}
+
 int inet_csk_listen_start(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
 	int err;
 
+	err = inet_ulp_can_listen(sk);
+	if (unlikely(err))
+		return err;
+
 	reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
 	sk->sk_ack_backlog = 0;
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 9ae50b1bd844..05b6077b9f2c 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -139,6 +139,10 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (sk->sk_socket)
 		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 
+	err = -EINVAL;
+	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
+		goto out_err;
+
 	err = ulp_ops->init(sk);
 	if (err)
 		goto out_err;

