Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29334A9614
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357449AbiBDJWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41442 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357363AbiBDJVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:21:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A1A615C6;
        Fri,  4 Feb 2022 09:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47521C004E1;
        Fri,  4 Feb 2022 09:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966514;
        bh=9F8kMDKRv1Lq670/0FmIy6Ok2qsiVmZa1gKHzQJ6pSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCG3FHi62peTJXCb+LJCttx+B64kcelHgiTOPZOTVe+dAhSwDX0CR0fQYoiPmORT1
         /p7wikWfr81aVSb4IvosPWNgtoomAmYAUmm0CA7cQuPWdNrl9DpXJgHnWtse+e3IVY
         B95d7gmy+m4xhCtQDIZOEV9tNBmhAPdwGxLZ5x2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 22/25] rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
Date:   Fri,  4 Feb 2022 10:20:29 +0100
Message-Id: <20220204091914.991840217@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -3238,8 +3238,8 @@ static int __rtnl_newlink(struct sk_buff
 	struct nlattr *slave_attr[RTNL_SLAVE_MAX_TYPE + 1];
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct nlattr *linkinfo[IFLA_INFO_MAX + 1];
-	const struct rtnl_link_ops *m_ops = NULL;
-	struct net_device *master_dev = NULL;
+	const struct rtnl_link_ops *m_ops;
+	struct net_device *master_dev;
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
 	struct nlattr *tb[IFLA_MAX + 1];
@@ -3277,6 +3277,8 @@ replay:
 	else
 		dev = NULL;
 
+	master_dev = NULL;
+	m_ops = NULL;
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)


