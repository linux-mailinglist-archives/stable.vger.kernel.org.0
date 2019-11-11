Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4819F7CA6
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbfKKSsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbfKKSsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99E2F20674;
        Mon, 11 Nov 2019 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498101;
        bh=SDQES2hrKmepJtD9JkFbfN2ANoz/sTt67dXRkbr1UFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxwR0mCvlhcuoQT7znTTtLGdSMDPcyDlID7rqyAuW8QsblZDUW8lLjA8aLmuRJ27r
         VQYenqAD4hSFKIfTEPf08F9wFqky+O8fpkujLz1XZSAT8lM5QIaMakXDOtxN1U7RDI
         n0udnPWDmYBN0y4qxt39sgt5OcKhsE58TCBHcniY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hendrik Donner <hd@os-cillation.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 003/193] ipv4: Fix table id reference in fib_sync_down_addr
Date:   Mon, 11 Nov 2019 19:26:25 +0100
Message-Id: <20191111181500.106508304@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit e0a312629fefa943534fc46f7bfbe6de3fdaf463 ]

Hendrik reported routes in the main table using source address are not
removed when the address is removed. The problem is that fib_sync_down_addr
does not account for devices in the default VRF which are associated
with the main table. Fix by updating the table id reference.

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Reported-by: Hendrik Donner <hd@os-cillation.de>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1814,8 +1814,8 @@ int fib_sync_down_addr(struct net_device
 	int ret = 0;
 	unsigned int hash = fib_laddr_hashfn(local);
 	struct hlist_head *head = &fib_info_laddrhash[hash];
+	int tb_id = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
 	struct net *net = dev_net(dev);
-	int tb_id = l3mdev_fib_table(dev);
 	struct fib_info *fi;
 
 	if (!fib_info_laddrhash || local == 0)


