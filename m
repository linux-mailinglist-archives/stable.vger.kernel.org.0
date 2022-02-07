Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3464ABB2B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384254AbiBGL0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379698AbiBGLQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:16:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D926C043189;
        Mon,  7 Feb 2022 03:16:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F51B6113B;
        Mon,  7 Feb 2022 11:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1B3C004E1;
        Mon,  7 Feb 2022 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232572;
        bh=F9nM7RC2KedaKUX+hil3fXIdjk9e2x621P2GLnez9Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzmuKsiQzbvB537vUoUqWs6PuSxNoujvRVzqKljLDE1wM2PhmaWDktfiDDj1NOSDG
         W9LUkgz0EvGwlHE5VZodToB32sEKqhTnX8eSvq9MusdqXAJiJ8srv2utFoNkMlm9zI
         JYVNmRo+Nf/xFhnctehPn6rbzr/DRHuUCWlrRElw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 52/86] rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
Date:   Mon,  7 Feb 2022 12:06:15 +0100
Message-Id: <20220207103759.263872926@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit c6f6f2444bdbe0079e41914a35081530d0409963 upstream.

While looking at one unrelated syzbot bug, I found the replay logic
in __rtnl_newlink() to potentially trigger use-after-free.

It is better to clear master_dev and m_ops inside the loop,
in case we have to replay it.

Fixes: ba7d49b1f0f8 ("rtnetlink: provide api for getting and setting slave info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20220201012106.216495-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2942,9 +2942,9 @@ static int rtnl_newlink(struct sk_buff *
 {
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
-	const struct rtnl_link_ops *m_ops = NULL;
+	const struct rtnl_link_ops *m_ops;
 	struct net_device *dev;
-	struct net_device *master_dev = NULL;
+	struct net_device *master_dev;
 	struct ifinfomsg *ifm;
 	char kind[MODULE_NAME_LEN];
 	char ifname[IFNAMSIZ];
@@ -2979,6 +2979,8 @@ replay:
 			dev = NULL;
 	}
 
+	master_dev = NULL;
+	m_ops = NULL;
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)


