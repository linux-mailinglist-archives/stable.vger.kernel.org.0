Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75E84F2C89
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243124AbiDEJjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244112AbiDEJJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73E318377;
        Tue,  5 Apr 2022 01:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D953B81BAE;
        Tue,  5 Apr 2022 08:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA711C385A3;
        Tue,  5 Apr 2022 08:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149147;
        bh=sFS7G5rZj3C0ZMjUhhbET/vBcgSalnDjkfieF0x48Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCTfE9IoUAhinV75Vll4X4HYP3ZayopUiTfMmff5bF7ekv/UGZMjeH3TyJaXNcO2q
         Z7AI57G5ha+Pk7RmBGKjjYQ6sL6Svy7GOpRFNcHtrACNn27kUP6E2pctf7rJihgl09
         c1zXt+AXqlx+toTPJpFAPmHtCbR57bQOEkDjNEwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Will <derekrobertwill@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0611/1017] can: isotp: return -EADDRNOTAVAIL when reading from unbound socket
Date:   Tue,  5 Apr 2022 09:25:24 +0200
Message-Id: <20220405070412.417635334@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

[ Upstream commit 30ffd5332e06316bd69a654c06aa033872979b7c ]

When reading from an unbound can-isotp socket the syscall blocked
indefinitely. As unbound sockets (without given CAN address information)
do not make sense anyway we directly return -EADDRNOTAVAIL on read()
analogue to the known behavior from sendmsg().

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://github.com/linux-can/can-utils/issues/349
Link: https://lore.kernel.org/all/20220316164258.54155-2-socketcan@hartkopp.net
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index f8e3aeb79e3f..8966f06e0660 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1005,12 +1005,16 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
+	struct isotp_sock *so = isotp_sk(sk);
 	int err = 0;
 	int noblock;
 
 	noblock = flags & MSG_DONTWAIT;
 	flags &= ~MSG_DONTWAIT;
 
+	if (!so->bound)
+		return -EADDRNOTAVAIL;
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		return err;
-- 
2.34.1



