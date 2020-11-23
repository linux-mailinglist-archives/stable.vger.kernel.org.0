Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D822C077E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbgKWMlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732682AbgKWMlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDE32065E;
        Mon, 23 Nov 2020 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135296;
        bh=HyW5RGxfhSeP5WyEk7Wqkjl79jCKZx0NkQVMJgcx5Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGixH40rhYWR2rhPSlnRmssxshZ9Vd0YIiIuR7KacXlCMwqSx4j+8LmfclDIWYN8k
         X5hTwSpqh/ferxuHDRHNR7roozjWkAe5NxgDNaOwgG124n+fm6hBiUvucuub/C64Al
         4bBKyrNFWW+ojMXsiHv9yL0qMUqfKCxA1lanQ9AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 008/252] ipv6: Fix error path to cancel the meseage
Date:   Mon, 23 Nov 2020 13:19:18 +0100
Message-Id: <20201123121835.994003918@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit ceb736e1d45c253f5e86b185ca9b497cdd43063f ]

genlmsg_cancel() needs to be called in the error path of
inet6_fill_ifmcaddr and inet6_fill_ifacaddr to cancel
the message.

Fixes: 6ecf4c37eb3e ("ipv6: enable IFA_TARGET_NETNSID for RTM_GETADDR")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201112080950.1476302-1-zhangqilong3@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5022,8 +5022,10 @@ static int inet6_fill_ifmcaddr(struct sk
 		return -EMSGSIZE;
 
 	if (args->netnsid >= 0 &&
-	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
+	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid)) {
+		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
+	}
 
 	put_ifaddrmsg(nlh, 128, IFA_F_PERMANENT, scope, ifindex);
 	if (nla_put_in6_addr(skb, IFA_MULTICAST, &ifmca->mca_addr) < 0 ||
@@ -5054,8 +5056,10 @@ static int inet6_fill_ifacaddr(struct sk
 		return -EMSGSIZE;
 
 	if (args->netnsid >= 0 &&
-	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
+	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid)) {
+		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
+	}
 
 	put_ifaddrmsg(nlh, 128, IFA_F_PERMANENT, scope, ifindex);
 	if (nla_put_in6_addr(skb, IFA_ANYCAST, &ifaca->aca_addr) < 0 ||


