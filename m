Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02C46673CB
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjALN6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjALN6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:58:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B2748CE6
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:57:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA0166202A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C83C433F0;
        Thu, 12 Jan 2023 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531872;
        bh=3+u11lPi/YASPJ8JjHPxHvsZ1Psr/k1W+uTTsEVTIzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Us2BcOc2vyix0PrKPQN34O2S1vGVvRnsJ4U7O1R3Py4ICYzvKTGR1LMQja0czKVw
         dj7sSzMgRnkIz8shID2HgyI8PrgHWX/0VKqbdFdz8ExAe5GIc4vTFiE/ClUrZTshoW
         JY3A9DJLMjbNvSgF3kdxEA8rIRrZNsaqhqEbtsdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, slipper <slipper.alive@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 10/10] net/ulp: prevent ULP without clone op from entering the LISTEN status
Date:   Thu, 12 Jan 2023 14:56:47 +0100
Message-Id: <20230112135327.087488002@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
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

commit 2c02d41d71f90a5168391b6a5f2954112ba2307c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |   16 +++++++++++++++-
 net/ipv4/tcp_ulp.c              |    4 ++++
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1040,11 +1040,25 @@ void inet_csk_prepare_forced_close(struc
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
 int inet_csk_listen_start(struct sock *sk, int backlog)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	int err = -EADDRINUSE;
+	int err;
+
+	err = inet_ulp_can_listen(sk);
+	if (unlikely(err))
+		return err;
 
 	reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -136,6 +136,10 @@ static int __tcp_set_ulp(struct sock *sk
 	if (icsk->icsk_ulp_ops)
 		goto out_err;
 
+	err = -EINVAL;
+	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
+		goto out_err;
+
 	err = ulp_ops->init(sk);
 	if (err)
 		goto out_err;


