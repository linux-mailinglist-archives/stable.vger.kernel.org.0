Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD33278895
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgIYM41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbgIYMxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA40E206DB;
        Fri, 25 Sep 2020 12:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038387;
        bh=A9J3qAOL+rX83hba1deH54ozsA7l50g5CSqGu5IA7FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhaYIqkyUCW+EwYQPnf2Lrbrr3D7wDdYTFGtu2Jkht1cQwisqits6bpvfOrAbGLEV
         W/6urwUbkHoXybgZyC3QSvgWvuka4Izko14esGXcYaBuTZdb/ngbiDRrIeit/Olkbp
         4KRz08EekGBXgvcC5klNulTtignkR42lewWeqREA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        wenxu <wenxu@ucloud.cn>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 14/43] ipv4: Initialize flowi4_multipath_hash in data path
Date:   Fri, 25 Sep 2020 14:48:26 +0200
Message-Id: <20200925124725.711828973@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 1869e226a7b3ef75b4f70ede2f1b7229f7157fa4 ]

flowi4_multipath_hash was added by the commit referenced below for
tunnels. Unfortunately, the patch did not initialize the new field
for several fast path lookups that do not initialize the entire flow
struct to 0. Fix those locations. Currently, flowi4_multipath_hash
is random garbage and affects the hash value computed by
fib_multipath_hash for multipath selection.

Fixes: 24ba14406c5c ("route: Add multipath_hash in flowi_common to make user-define hash")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: wenxu <wenxu@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow.h      |    1 +
 net/core/filter.c       |    1 +
 net/ipv4/fib_frontend.c |    1 +
 net/ipv4/route.c        |    1 +
 4 files changed, 4 insertions(+)

--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -116,6 +116,7 @@ static inline void flowi4_init_output(st
 	fl4->saddr = saddr;
 	fl4->fl4_dport = dport;
 	fl4->fl4_sport = sport;
+	fl4->flowi4_multipath_hash = 0;
 }
 
 /* Reset some input parameters after previous lookup */
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4650,6 +4650,7 @@ static int bpf_ipv4_fib_lookup(struct ne
 	fl4.saddr = params->ipv4_src;
 	fl4.fl4_sport = params->sport;
 	fl4.fl4_dport = params->dport;
+	fl4.flowi4_multipath_hash = 0;
 
 	if (flags & BPF_FIB_LOOKUP_DIRECT) {
 		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -372,6 +372,7 @@ static int __fib_validate_source(struct
 	fl4.flowi4_tun_key.tun_id = 0;
 	fl4.flowi4_flags = 0;
 	fl4.flowi4_uid = sock_net_uid(net, NULL);
+	fl4.flowi4_multipath_hash = 0;
 
 	no_addr = idev->ifa_list == NULL;
 
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2104,6 +2104,7 @@ static int ip_route_input_slow(struct sk
 	fl4.daddr = daddr;
 	fl4.saddr = saddr;
 	fl4.flowi4_uid = sock_net_uid(net, NULL);
+	fl4.flowi4_multipath_hash = 0;
 
 	if (fib4_rules_early_flow_dissect(net, skb, &fl4, &_flkeys)) {
 		flkeys = &_flkeys;


