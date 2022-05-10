Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC32521AD9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbiEJOEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242506AbiEJOEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:04:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16CE98085;
        Tue, 10 May 2022 06:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49C8CB81D24;
        Tue, 10 May 2022 13:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD728C385A6;
        Tue, 10 May 2022 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190035;
        bh=pzdjDdykdV0GuijjeSO1zMlMsGhcfnxWnN7/tA5VIEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRfirbS7dlvxxuR2AlLczhDWiJz1qIrRo7sx9dT0lq4hxxxQ2YXx9AVOA3JOrxh0d
         XPYmY4m5oxIOyHw4AgFvjB4Ux2FcRpkqB43JkRd9Ya5Alx3Sn3JGaVm0magykMNv7G
         7Fg8l0llsRhTvCBpfShkUZ9JRHrFBhZvWmRI4up0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 107/140] net: rds: acquire refcount on TCP sockets
Date:   Tue, 10 May 2022 15:08:17 +0200
Message-Id: <20220510130744.664750864@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3a58f13a881ed351198ffab4cf9953cf19d2ab3a ]

syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
for TCP socket used by RDS is accessing sock_net() without acquiring a
refcount on net namespace. Since TCP's retransmission can happen after
a process which created net namespace terminated, we need to explicitly
acquire a refcount.

Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
Link: https://lore.kernel.org/r/a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 5327d130c4b5..2f638f8b7b1e 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -495,6 +495,14 @@ void rds_tcp_tune(struct socket *sock)
 
 	tcp_sock_set_nodelay(sock->sk);
 	lock_sock(sk);
+	/* TCP timer functions might access net namespace even after
+	 * a process which created this net namespace terminated.
+	 */
+	if (!sk->sk_net_refcnt) {
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
+	}
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
-- 
2.35.1



