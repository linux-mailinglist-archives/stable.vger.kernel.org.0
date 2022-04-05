Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B184F37FC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359805AbiDELUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349267AbiDEJtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E19E1902E;
        Tue,  5 Apr 2022 02:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDD3C615E5;
        Tue,  5 Apr 2022 09:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FD9C385A1;
        Tue,  5 Apr 2022 09:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151809;
        bh=CYBBhqqXnWioOKsqKoupoL8mV+Bt0Z2q89SwnPZ8n6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFJr/6ZSi7uqZ3Q9CwQZ4YChHWHImqL3CGVE7ta9H7XcRw4JIOVimnMEZ2MxqfRZK
         XyV4/x7Lo7xqcKgLGebM/eDxR5SmJy9Kkv0rEKni7XHh4Ogq1iUhWdDkXW6HIa9/Bi
         wy4irPnSDS7I7J7xq4C+3b4QZPVMchNYDx2OdgGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Will <derekrobertwill@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 550/913] can: isotp: return -EADDRNOTAVAIL when reading from unbound socket
Date:   Tue,  5 Apr 2022 09:26:52 +0200
Message-Id: <20220405070356.334244799@linuxfoundation.org>
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
 net/can/isotp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1005,12 +1005,16 @@ static int isotp_recvmsg(struct socket *
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


