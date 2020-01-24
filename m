Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E763A148222
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391277AbgAXLZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391062AbgAXLZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:25:32 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93ACF2077C;
        Fri, 24 Jan 2020 11:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865132;
        bh=q8FEEnP4A9fr6JDFaxyd6h/aYNGub3Ui9XeBx/s1D5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5lTQafKciN3QzLRZ8m1OtUuL+6/Ad+FsTeshmP3cvVsMZ2a4arEmh523wcheebhr
         EOVAq1VboB40xYVd/Aeahr8e9Xbh/piOpLGKZP1MNaoMELWWytvQ0xwiqvvyIw2Kpp
         CAxD4s3T0iBVjls+3NNYjhAFDxM8Odi/RInLwNN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 446/639] ip6_fib: Dont discard nodes with valid routing information in fib6_locate_1()
Date:   Fri, 24 Jan 2020 10:30:16 +0100
Message-Id: <20200124093142.891105179@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 40cb35d5dc04e7f89cbc7b1fc9b4b48d9f1e5343 ]

When we perform an inexact match on FIB nodes via fib6_locate_1(), longer
prefixes will be preferred to shorter ones. However, it might happen that
a node, with higher fn_bit value than some other, has no valid routing
information.

In this case, we'll pick that node, but it will be discarded by the check
on RTN_RTINFO in fib6_locate(), and we might miss nodes with valid routing
information but with lower fn_bit value.

This is apparent when a routing exception is created for a default route:
 # ip -6 route list
 fc00:1::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fc00:2::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 pref medium
 fe80::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fe80::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 default via fc00:1::2 dev veth_A-R1 metric 1024 pref medium
 # ip -6 route list cache
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 expires 593sec mtu 1500 pref medium
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 593sec mtu 1500 pref medium
 # ip -6 route flush cache    # node for default route is discarded
 Failed to send flush request: No such process
 # ip -6 route list cache
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 586sec mtu 1500 pref medium

Check right away if the node has a RTN_RTINFO flag, before replacing the
'prev' pointer, that indicates the longest matching prefix found so far.

Fixes: 38fbeeeeccdb ("ipv6: prepare fib6_locate() for exception table")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index bbb5ffb3397d8..7091568b9f630 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1529,7 +1529,8 @@ static struct fib6_node *fib6_locate_1(struct fib6_node *root,
 		if (plen == fn->fn_bit)
 			return fn;
 
-		prev = fn;
+		if (fn->fn_flags & RTN_RTINFO)
+			prev = fn;
 
 next:
 		/*
-- 
2.20.1



