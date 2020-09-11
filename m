Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936E326641F
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgIKQbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgIKPTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4E8A22226;
        Fri, 11 Sep 2020 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829215;
        bh=JrLztB9YR9rV95zKnvwpDb5/OzCC3LdzhveX60ZxFnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wK0BS5+ejbsD2uUphkd56ddCmwS/53e4g1MPtp+7HIiRir5JbpWRt+pbIr4P5ffW9
         4YJJM4A27W0gJPuulbfQYc+anNDvWc3W/3pyNDEF0uaSdsIO9IO5Cs7pmfEhLf869j
         Hzy+gCITCYiZO792ru6u8HjQme1os5JOHuHFcFok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 2/8] ipv6: Fix sysctl max for fib_multipath_hash_policy
Date:   Fri, 11 Sep 2020 14:54:40 +0200
Message-Id: <20200911125420.701606317@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911125420.580564179@linuxfoundation.org>
References: <20200911125420.580564179@linuxfoundation.org>
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
@@ -151,7 +152,7 @@ static struct ctl_table ipv6_table_templ
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "seg6_flowlabel",


