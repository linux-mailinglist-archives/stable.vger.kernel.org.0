Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6802C0B00
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgKWMeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgKWMen (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782952065E;
        Mon, 23 Nov 2020 12:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134883;
        bh=UTV6c5nyP1tQaV4bghAeg0XRfIOXeDnGyp3A194zU/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvvuSwGgUbpqIVsoDW+6MPFr9oDs6Kxg6ak/IgXAianp8FtyjUs2woK1ahZBlhpqt
         ObrSrhDiM1EXonughQF09KvPoWaGEcyBKmLhmq2eo3F3hpNNnDrxKwF9jVaTt9jAHt
         6H8lVUo2v6wQw8VR9qWjc9fjV9ZTfZCncTV50M7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 007/158] ipv6: Fix error path to cancel the meseage
Date:   Mon, 23 Nov 2020 13:20:35 +0100
Message-Id: <20201123121820.292572149@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
@@ -4984,8 +4984,10 @@ static int inet6_fill_ifmcaddr(struct sk
 		return -EMSGSIZE;
 
 	if (args->netnsid >= 0 &&
-	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
+	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid)) {
+		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
+	}
 
 	put_ifaddrmsg(nlh, 128, IFA_F_PERMANENT, scope, ifindex);
 	if (nla_put_in6_addr(skb, IFA_MULTICAST, &ifmca->mca_addr) < 0 ||
@@ -5016,8 +5018,10 @@ static int inet6_fill_ifacaddr(struct sk
 		return -EMSGSIZE;
 
 	if (args->netnsid >= 0 &&
-	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
+	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid)) {
+		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
+	}
 
 	put_ifaddrmsg(nlh, 128, IFA_F_PERMANENT, scope, ifindex);
 	if (nla_put_in6_addr(skb, IFA_ANYCAST, &ifaca->aca_addr) < 0 ||


