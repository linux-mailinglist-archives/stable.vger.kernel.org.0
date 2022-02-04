Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7463F4A96D5
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358318AbiBDJaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357775AbiBDJ22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B636DC061776;
        Fri,  4 Feb 2022 01:27:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E19B836EE;
        Fri,  4 Feb 2022 09:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21D1C004E1;
        Fri,  4 Feb 2022 09:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966825;
        bh=Ai2pTBuMpi+ZpmwAJGWmVGypw5mKsno03Np5MzaPBcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m43e5HtfpO5oEd68qu9XGW4B1r6BCor85Gtz5Ly+pSAYg98khbr8Ez97jQ0otfHnB
         UG8PQevj+q4e46MscLpDoH1nsL+UpKSRZrJ7MPFjx+vbcvAdmoTfzpL6nvWQ7VCNFH
         frZ6SmYQauchIYfXt3TfEMwZXJf1fQ12HOVkT4NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 36/43] rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
Date:   Fri,  4 Feb 2022 10:22:43 +0100
Message-Id: <20220204091918.340196380@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
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
@@ -3254,8 +3254,8 @@ static int __rtnl_newlink(struct sk_buff
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
@@ -3293,6 +3293,8 @@ replay:
 	else
 		dev = NULL;
 
+	master_dev = NULL;
+	m_ops = NULL;
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)


