Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A03D6DEEF1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjDLIqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjDLIq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8073A72A7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B41630F4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B29C433D2;
        Wed, 12 Apr 2023 08:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289125;
        bh=JJ9nssTwufA28MFU7n5bX97ooj8HJFUxVwvZdpFq9ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFS9YvOTBtZ5+6YwYk64CH9oHalT00C/8hUIeMF/UldpRi8mubV6RqkR1vVrSOkP5
         UcbmaHS6gtbTFTDGOg04imEEuWwnxvN11aJQNiOSyIfFhF5sw8PYDaECfs2m/VLCTJ
         9JiLUi0UQQqEU6yXV25G/ICk1IVTYFNggOLI78Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michal Sojka <michal.sojka@cvut.cz>,
        Jakub Jira <jirajak2@fel.cvut.cz>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 116/164] can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events
Date:   Wed, 12 Apr 2023 10:33:58 +0200
Message-Id: <20230412082841.543054986@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Sojka <michal.sojka@cvut.cz>

commit 79e19fa79cb5d5f1b3bf3e3ae24989ccb93c7b7b upstream.

When using select()/poll()/epoll() with a non-blocking ISOTP socket to
wait for when non-blocking write is possible, a false EPOLLOUT event
is sometimes returned. This can happen at least after sending a
message which must be split to multiple CAN frames.

The reason is that isotp_sendmsg() returns -EAGAIN when tx.state is
not equal to ISOTP_IDLE and this behavior is not reflected in
datagram_poll(), which is used in isotp_ops.

This is fixed by introducing ISOTP-specific poll function, which
suppresses the EPOLLOUT events in that case.

v2: https://lore.kernel.org/all/20230302092812.320643-1-michal.sojka@cvut.cz
v1: https://lore.kernel.org/all/20230224010659.48420-1-michal.sojka@cvut.cz
    https://lore.kernel.org/all/b53a04a2-ba1f-3858-84c1-d3eb3301ae15@hartkopp.net

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
Reported-by: Jakub Jira <jirajak2@fel.cvut.cz>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20230331125511.372783-1-michal.sojka@cvut.cz
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1615,6 +1615,21 @@ static int isotp_init(struct sock *sk)
 	return 0;
 }
 
+static __poll_t isotp_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct isotp_sock *so = isotp_sk(sk);
+
+	__poll_t mask = datagram_poll(file, sock, wait);
+	poll_wait(file, &so->wait, wait);
+
+	/* Check for false positives due to TX state */
+	if ((mask & EPOLLWRNORM) && (so->tx.state != ISOTP_IDLE))
+		mask &= ~(EPOLLOUT | EPOLLWRNORM);
+
+	return mask;
+}
+
 static int isotp_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -1630,7 +1645,7 @@ static const struct proto_ops isotp_ops
 	.socketpair = sock_no_socketpair,
 	.accept = sock_no_accept,
 	.getname = isotp_getname,
-	.poll = datagram_poll,
+	.poll = isotp_poll,
 	.ioctl = isotp_sock_no_ioctlcmd,
 	.gettstamp = sock_gettstamp,
 	.listen = sock_no_listen,


