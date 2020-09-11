Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9938A26607E
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 15:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIKNlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 09:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgIKN20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:28:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2167F204EC;
        Fri, 11 Sep 2020 13:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829204;
        bh=Ri8JwN8tCQ9NDHK7NDYR8XYP5a7ACkHHRW9pL0zYCzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6g9yVYe/bqhu18tb83ZTUTQh7ThQoRLosjt1/PnfDcfCYSJiAdMsowRdRXqocDV1
         cpH+N/rcNm9uT7VUv0cIAaNPiewTPWKxR2BzYMT4OBChJNUSQd8dZw/gcYy2JMSdZL
         CgLukEQVTbamk1VPyqrDD1/ifoL1t2U2Y8+Ut238=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 08/16] ipv6: Fix sysctl max for fib_multipath_hash_policy
Date:   Fri, 11 Sep 2020 14:47:25 +0200
Message-Id: <20200911122459.984827826@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
References: <20200911122459.585735377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 05d4487197b2b71d5363623c28924fd58c71c0b6 ]

Cited commit added the possible value of '2', but it cannot be set. Fix
it by adjusting the maximum value to '2'. This is consistent with the
corresponding IPv4 sysctl.

Before:

# sysctl -w net.ipv6.fib_multipath_hash_policy=2
sysctl: setting key "net.ipv6.fib_multipath_hash_policy": Invalid argument
net.ipv6.fib_multipath_hash_policy = 2
# sysctl net.ipv6.fib_multipath_hash_policy
net.ipv6.fib_multipath_hash_policy = 0

After:

# sysctl -w net.ipv6.fib_multipath_hash_policy=2
net.ipv6.fib_multipath_hash_policy = 2
# sysctl net.ipv6.fib_multipath_hash_policy
net.ipv6.fib_multipath_hash_policy = 2

Fixes: d8f74f0975d8 ("ipv6: Support multipath hashing on inner IP pkts")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sysctl_net_ipv6.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -21,6 +21,7 @@
 #include <net/calipso.h>
 #endif
 
+static int two = 2;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_min;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
@@ -150,7 +151,7 @@ static struct ctl_table ipv6_table_templ
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "seg6_flowlabel",


