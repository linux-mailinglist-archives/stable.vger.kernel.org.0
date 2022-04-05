Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C24F37F8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359796AbiDELUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349270AbiDEJtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE80C3C;
        Tue,  5 Apr 2022 02:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E22F36164D;
        Tue,  5 Apr 2022 09:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B26C385A2;
        Tue,  5 Apr 2022 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151812;
        bh=NaS2k9YLoTJbH9gXtayf1MhnWDIzbvLwPaMgSYcGQvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtsH3TSXR8Mb5XDoQtUU3H8W4exlUZ+ui1wrxgcpBM0mDN8F3yf/aZzycmginbNYs
         G/L+tVrYx10YOwGA+iJTvspt0gxUldnoMWP1OvAEBjyp/RxDu72aL5eMm+ky2y9hEU
         I4bdGQ3vubsSxjGOmiHRWhqwLoP96TYaYy1tAZaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Will <derekrobertwill@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 551/913] can: isotp: support MSG_TRUNC flag when reading from socket
Date:   Tue,  5 Apr 2022 09:26:53 +0200
Message-Id: <20220405070356.364146782@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
 net/can/isotp.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1006,29 +1006,28 @@ static int isotp_recvmsg(struct socket *
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
 
@@ -1038,9 +1037,13 @@ static int isotp_recvmsg(struct socket *
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


