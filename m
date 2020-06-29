Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FAE20DB6C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388566AbgF2UG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732665AbgF2Ta1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE5BC2521D;
        Mon, 29 Jun 2020 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444937;
        bh=4JS9mGeU2OHBwi42V6yiTDZFBXzJ+sFeEZSphCVFZPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buliLr0eMFOvvm+YyuG9q5ZIaHFMNGr9Sfs7nMaG66gMKHaES7MU+SypIGL7H9S1h
         +DyuUY6qrNSg2zSBObS7OcXppm5NjYG0tS0sFMYnmd9mjrIqtn20ixWzQthdCoW0tV
         X4EpRYo7Z0SMV889z7y1uMZh9JkJyfsqWbvPNh6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 034/131] sch_cake: don't try to reallocate or unshare skb unconditionally
Date:   Mon, 29 Jun 2020 11:33:25 -0400
Message-Id: <20200629153502.2494656-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>

[ Upstream commit 9208d2863ac689a563b92f2161d8d1e7127d0add ]

cake_handle_diffserv() tries to linearize mac and network header parts of
skb and to make it writable unconditionally. In some cases it leads to full
skb reallocation, which reduces throughput and increases CPU load. Some
measurements of IPv4 forward + NAPT on MIPS router with 580 MHz single-core
CPU was conducted. It appears that on kernel 4.9 skb_try_make_writable()
reallocates skb, if skb was allocated in ethernet driver via so-called
'build skb' method from page cache (it was discovered by strange increase
of kmalloc-2048 slab at first).

Obtain DSCP value via read-only skb_header_pointer() call, and leave
linearization only for DSCP bleaching or ECN CE setting. And, as an
additional optimisation, skip diffserv parsing entirely if it is not needed
by the current configuration.

Fixes: c87b4ecdbe8d ("sch_cake: Make sure we can write the IP header before changing DSCP bits")
Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
[ fix a few style issues, reflow commit message ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cake.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 824e3c37e5dd6..c0d92a251bcb6 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1510,30 +1510,49 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 
 static u8 cake_handle_diffserv(struct sk_buff *skb, u16 wash)
 {
-	int wlen = skb_network_offset(skb);
+	const int offset = skb_network_offset(skb);
+	u16 *buf, buf_;
 	u8 dscp;
 
 	switch (tc_skb_protocol(skb)) {
 	case htons(ETH_P_IP):
-		wlen += sizeof(struct iphdr);
-		if (!pskb_may_pull(skb, wlen) ||
-		    skb_try_make_writable(skb, wlen))
+		buf = skb_header_pointer(skb, offset, sizeof(buf_), &buf_);
+		if (unlikely(!buf))
 			return 0;
 
-		dscp = ipv4_get_dsfield(ip_hdr(skb)) >> 2;
-		if (wash && dscp)
+		/* ToS is in the second byte of iphdr */
+		dscp = ipv4_get_dsfield((struct iphdr *)buf) >> 2;
+
+		if (wash && dscp) {
+			const int wlen = offset + sizeof(struct iphdr);
+
+			if (!pskb_may_pull(skb, wlen) ||
+			    skb_try_make_writable(skb, wlen))
+				return 0;
+
 			ipv4_change_dsfield(ip_hdr(skb), INET_ECN_MASK, 0);
+		}
+
 		return dscp;
 
 	case htons(ETH_P_IPV6):
-		wlen += sizeof(struct ipv6hdr);
-		if (!pskb_may_pull(skb, wlen) ||
-		    skb_try_make_writable(skb, wlen))
+		buf = skb_header_pointer(skb, offset, sizeof(buf_), &buf_);
+		if (unlikely(!buf))
 			return 0;
 
-		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
-		if (wash && dscp)
+		/* Traffic class is in the first and second bytes of ipv6hdr */
+		dscp = ipv6_get_dsfield((struct ipv6hdr *)buf) >> 2;
+
+		if (wash && dscp) {
+			const int wlen = offset + sizeof(struct ipv6hdr);
+
+			if (!pskb_may_pull(skb, wlen) ||
+			    skb_try_make_writable(skb, wlen))
+				return 0;
+
 			ipv6_change_dsfield(ipv6_hdr(skb), INET_ECN_MASK, 0);
+		}
+
 		return dscp;
 
 	case htons(ETH_P_ARP):
-- 
2.25.1

