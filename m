Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5EB5830BF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbiG0Rln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242805AbiG0RlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:41:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77E188F26;
        Wed, 27 Jul 2022 09:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAF656153B;
        Wed, 27 Jul 2022 16:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B9DC433B5;
        Wed, 27 Jul 2022 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940698;
        bh=IycWulTsbIOVLrtfqv4k1FCYzWz7cNhjIqVpMmvVDzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6nVlh6tgdXU/WPnebctZZxisgBthH/TdYjxLOI4/VPqSKbLAIU7cXooBLhJbVQS8
         eeXQkEo67Q/c8wpG3zoiVomNw4nNzFIfw8t/jIvg+krxqWMwid3/+NX/7dAmS+VVW+
         vABXXTSPLJB/3x22kGaB0QFVj5aDwMX+M6eXGf64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 116/158] udp: Fix a data-race around sysctl_udp_l3mdev_accept.
Date:   Wed, 27 Jul 2022 18:13:00 +0200
Message-Id: <20220727161026.116104651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 3d72bb4188c708bb16758c60822fc4dda7a95174 ]

While reading sysctl_udp_l3mdev_accept, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 63a6fff353d0 ("net: Avoid receiving packets with an l3mdev on unbound UDP sockets")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/udp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 07d0ceadcf6e..abe91ab9030d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -238,7 +238,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 				       int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_udp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_udp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
-- 
2.35.1



