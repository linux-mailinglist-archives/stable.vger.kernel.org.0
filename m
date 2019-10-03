Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD37CA61F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392161AbfJCQkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392443AbfJCQkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:40:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F197020830;
        Thu,  3 Oct 2019 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120807;
        bh=JU3UYg6sx8LyWlLxHpHoWHO0v347kA8UBDEFNFxli1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCfVy83XXK89wOTq4AZkFID75eqGAQl8g3M9vC1IxmyrcNl/1DBsXvjHFMilwPdIV
         ozya3uVUlC2giNnSRadFtwry3r8QXFtQcNb7ilJXTdJhp4jD8mB+RCQNRPQFQlPrTp
         JRz40xtHquOvewl0yZj2wtYG6XENHVZQ2Ao7rJq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Patrick Ruddy <pruddy@vyatta.att-mail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 028/344] vrf: Do not attempt to create IPv6 mcast rule if IPv6 is disabled
Date:   Thu,  3 Oct 2019 17:49:53 +0200
Message-Id: <20191003154542.872347050@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit dac91170f8e9c73784af5fad6225e954b795601c ]

A user reported that vrf create fails when IPv6 is disabled at boot using
'ipv6.disable=1':
   https://bugzilla.kernel.org/show_bug.cgi?id=204903

The failure is adding fib rules at create time. Add RTNL_FAMILY_IP6MR to
the check in vrf_fib_rule if ipv6_mod_enabled is disabled.

Fixes: e4a38c0c4b27 ("ipv6: add vrf table handling code for ipv6 mcast")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Patrick Ruddy <pruddy@vyatta.att-mail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1154,7 +1154,8 @@ static int vrf_fib_rule(const struct net
 	struct sk_buff *skb;
 	int err;
 
-	if (family == AF_INET6 && !ipv6_mod_enabled())
+	if ((family == AF_INET6 || family == RTNL_FAMILY_IP6MR) &&
+	    !ipv6_mod_enabled())
 		return 0;
 
 	skb = nlmsg_new(vrf_fib_rule_nl_size(), GFP_KERNEL);


