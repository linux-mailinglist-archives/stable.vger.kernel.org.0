Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C221CAF0E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgEHNOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbgEHMr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83E162495E;
        Fri,  8 May 2020 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942049;
        bh=KSVvn16QkRt1X+Kar8TuyNt30jtJU7AmfhsrCJcYU0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwQinPJv1IeMgdmXGBT3H6dUkVq+C/uEMk0TsFhPpdnV5/r2StKafZT86D6ES4TAJ
         toELa3WCyxhE2L+svlNH5XiH8VLLrtHfYMDoMEuprQJUxOGEI2ORcd52RIAKYehGDr
         li7MDl/jdrbXq1oJE/d/ywx+Ny+M+T/vt6ZpwSR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hendrik Donner <hd@os-cillation.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 236/312] ipv4: Fix table id reference in fib_sync_down_addr
Date:   Fri,  8 May 2020 14:33:47 +0200
Message-Id: <20200508123141.018140753@linuxfoundation.org>
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

From: David Ahern <dsahern@kernel.org>

commit e0a312629fefa943534fc46f7bfbe6de3fdaf463 upstream.

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
@@ -1358,8 +1358,8 @@ int fib_sync_down_addr(struct net_device
 	int ret = 0;
 	unsigned int hash = fib_laddr_hashfn(local);
 	struct hlist_head *head = &fib_info_laddrhash[hash];
+	int tb_id = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
 	struct net *net = dev_net(dev);
-	int tb_id = l3mdev_fib_table(dev);
 	struct fib_info *fi;
 
 	if (!fib_info_laddrhash || local == 0)


