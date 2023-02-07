Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2535668D8C3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjBGNMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjBGNMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:12:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB5939CD4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209F861383
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC4CC433EF;
        Tue,  7 Feb 2023 13:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775498;
        bh=31PGigVaWwsYxdx0F+/sk0jL4EAU83tF/tnCicsEiYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRZfaBOWNxVGF+9DdPpJrbmlivvvAw3U6XEZ7jCK2FZaJuP4wdMEhKKlglV2nHr3l
         yFd+ClUpewY1JTTmeNdFCodGAFuh6fZbte6zzfLN5I+432zcYFCXsqD9CrNbGOiDQh
         KB4SHSMS25xqrgueyvsT5RoaTHukdmc+8km7Iits=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hyunwoo Kim <v4bel@theori.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/120] net/x25: Fix to not accept on connected socket
Date:   Tue,  7 Feb 2023 13:57:11 +0100
Message-Id: <20230207125621.315217538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit f2b0b5210f67c56a3bcdf92ff665fb285d6e0067 ]

When listen() and accept() are called on an x25 socket
that connect() succeeds, accept() succeeds immediately.
This is because x25_connect() queues the skb to
sk->sk_receive_queue, and x25_accept() dequeues it.

This creates a child socket with the sk of the parent
x25 socket, which can cause confusion.

Fix x25_listen() to return -EINVAL if the socket has
already been successfully connect()ed to avoid this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3a171828638b..07f6206e7cb4 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -482,6 +482,12 @@ static int x25_listen(struct socket *sock, int backlog)
 	int rc = -EOPNOTSUPP;
 
 	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		rc = -EINVAL;
+		release_sock(sk);
+		return rc;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		memset(&x25_sk(sk)->dest_addr, 0, X25_ADDR_LEN);
 		sk->sk_max_ack_backlog = backlog;
-- 
2.39.0



