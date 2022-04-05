Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1334F3C2A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbiDEMFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358231AbiDEK2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6511AD93;
        Tue,  5 Apr 2022 03:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 024FB617AA;
        Tue,  5 Apr 2022 10:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EADCC385A2;
        Tue,  5 Apr 2022 10:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153833;
        bh=Wu9EoBb4bBXtOyqt/h2vb+Y/ya1Bxiwt1yRBhqJpw4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdYN2DlMqgj/qwdQZJxrSVxlxKAQP0tznHEJip5uhDDw1l4p2VVhGRX1UtRyePF98
         WRppTgzWXx8BNjq5gEGAqnMuyd0ZZMyoYv2Ex0hc7H03N7MDw7izM0H9af0OaKmuOs
         jxDv1cnGpvq/c55WFxgsAxf3BzaRaxeQSXGbZpB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Will <derekrobertwill@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/599] can: isotp: support MSG_TRUNC flag when reading from socket
Date:   Tue,  5 Apr 2022 09:30:56 +0200
Message-Id: <20220405070309.604358102@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 42bf50a1795a1854d48717b7361dbdbce496b16b ]

When providing the MSG_TRUNC flag via recvmsg() syscall the return value
provides the real length of the packet or datagram, even when it was longer
than the passed buffer.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://github.com/linux-can/can-utils/issues/347#issuecomment-1065932671
Link: https://lore.kernel.org/all/20220316164258.54155-3-socketcan@hartkopp.net
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index cb5546c186bc..518014506fff 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1004,29 +1004,28 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	struct isotp_sock *so = isotp_sk(sk);
-	int err = 0;
-	int noblock;
+	int noblock = flags & MSG_DONTWAIT;
+	int ret = 0;
 
-	noblock = flags & MSG_DONTWAIT;
-	flags &= ~MSG_DONTWAIT;
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC))
+		return -EINVAL;
 
 	if (!so->bound)
 		return -EADDRNOTAVAIL;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags &= ~MSG_DONTWAIT;
+	skb = skb_recv_datagram(sk, flags, noblock, &ret);
 	if (!skb)
-		return err;
+		return ret;
 
 	if (size < skb->len)
 		msg->msg_flags |= MSG_TRUNC;
 	else
 		size = skb->len;
 
-	err = memcpy_to_msg(msg, skb->data, size);
-	if (err < 0) {
-		skb_free_datagram(sk, skb);
-		return err;
-	}
+	ret = memcpy_to_msg(msg, skb->data, size);
+	if (ret < 0)
+		goto out_err;
 
 	sock_recv_timestamp(msg, sk, skb);
 
@@ -1036,9 +1035,13 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 
+	/* set length of return value */
+	ret = (flags & MSG_TRUNC) ? skb->len : size;
+
+out_err:
 	skb_free_datagram(sk, skb);
 
-	return size;
+	return ret;
 }
 
 static int isotp_release(struct socket *sock)
-- 
2.34.1



