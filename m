Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B517B4FCFF3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349279AbiDLGkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349644AbiDLGiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:38:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691A9193D3;
        Mon, 11 Apr 2022 23:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B3C61890;
        Tue, 12 Apr 2022 06:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D22AC385A1;
        Tue, 12 Apr 2022 06:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745307;
        bh=U7nZE4xAKGgGeU3wUhmEHb2wRx7I3QHOWJo/nkIfck4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrBC0NMUof4kk0LNo5+qL9Lc5qLOn0B7CZVzwcvRF3AtcpHkWtjAvUz3kbMvixDuv
         sYJ5h9I1gRd46TJkO4va0Juytp2pLHMgL4gpgagT+Rji3wR2F4uAQSeHOPCKOF/Y+O
         lQ5MLriGyALkdYIZA5H5uOG3FHM93C0/vsbrdibs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Harold Huang <baymaxhuang@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/171] tuntap: add sanity checks about msg_controllen in sendmsg
Date:   Tue, 12 Apr 2022 08:29:02 +0200
Message-Id: <20220412062929.360936837@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

From: Harold Huang <baymaxhuang@gmail.com>

[ Upstream commit 74a335a07a17d131b9263bfdbdcb5e40673ca9ca ]

In patch [1], tun_msg_ctl was added to allow pass batched xdp buffers to
tun_sendmsg. Although we donot use msg_controllen in this path, we should
check msg_controllen to make sure the caller pass a valid msg_ctl.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe8dd45bb7556246c6b76277b1ba4296c91c2505

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20220303022441.383865-1-baymaxhuang@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c   | 3 ++-
 drivers/net/tun.c   | 3 ++-
 drivers/vhost/net.c | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index f549d3a8e59c..8f7bb15206e9 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1202,7 +1202,8 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 	struct xdp_buff *xdp;
 	int i;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
+	    ctl && ctl->type == TUN_MSG_PTR) {
 		for (i = 0; i < ctl->num; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
 			tap_get_user_xdp(q, xdp);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ffbc7eda95ee..55ce141c93c7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2499,7 +2499,8 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (!tun)
 		return -EBADFD;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
+	    ctl && ctl->type == TUN_MSG_PTR) {
 		struct tun_page tpage;
 		int n = ctl->num;
 		int flush = 0;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index da02c3e96e7b..e303f6f073d2 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -472,6 +472,7 @@ static void vhost_tx_batch(struct vhost_net *net,
 		goto signal_used;
 
 	msghdr->msg_control = &ctl;
+	msghdr->msg_controllen = sizeof(ctl);
 	err = sock->ops->sendmsg(sock, msghdr, 0);
 	if (unlikely(err < 0)) {
 		vq_err(&nvq->vq, "Fail to batch sending packets\n");
-- 
2.35.1



