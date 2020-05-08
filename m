Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3853B1CABAD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgEHMp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgEHMp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCA121974;
        Fri,  8 May 2020 12:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941956;
        bh=KW6y5wmFLfiHusJt9VH5WdPcHaNDUYH9sRQ8FBD/nDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRCeBPrUd68D6OUIU7bgvhpwsG/Z/4yiDcENcWoY/BBG3VkEdSCvDj4P+Xdd0f2E2
         uq6diLjtBciIuey4Lo4OU2t/6AnrqxaBuOGnqqzCbqtG6r3Ga/26Pc1I/8uM2cvN5M
         m9wtBCmqIq4mkE2n5p4lHd1iaENsYC7RCXyvbAj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Jungel <tobias.jungel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 240/312] bonding: fix length of actor system
Date:   Fri,  8 May 2020 14:33:51 +0200
Message-Id: <20200508123141.304323372@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Jungel <tobias.jungel@gmail.com>

commit 414dd6fb9a1a1b59983aea7bf0f79f0085ecc5b8 upstream.

The attribute IFLA_BOND_AD_ACTOR_SYSTEM is sent to user space having the
length of sizeof(bond->params.ad_actor_system) which is 8 byte. This
patch aligns the length to ETH_ALEN to have the same MAC address exposed
as using sysfs.

Fixes: f87fda00b6ed2 ("bonding: prevent out of bound accesses")
Signed-off-by: Tobias Jungel <tobias.jungel@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/bonding/bond_netlink.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -628,8 +628,7 @@ static int bond_fill_info(struct sk_buff
 				goto nla_put_failure;
 
 			if (nla_put(skb, IFLA_BOND_AD_ACTOR_SYSTEM,
-				    sizeof(bond->params.ad_actor_system),
-				    &bond->params.ad_actor_system))
+				    ETH_ALEN, &bond->params.ad_actor_system))
 				goto nla_put_failure;
 		}
 		if (!bond_3ad_get_active_agg_info(bond, &info)) {


