Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7315F20D96A
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgF2TrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387785AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B59BC24839;
        Mon, 29 Jun 2020 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444349;
        bh=Q0/KPKdoE+l7DUi5F1eMTVmjpkyw2495FuaeHQCbkcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Psr7DSTw2vtkiSM+I67tXYla/BzZS/dm+bCnDtKAPrFktsWzgqHN3qiMqmr7+gcsu
         G85lrvu2bpj7VC3GT840PBFyYOSh7hF2a1apVwS6jJ7EsDr022RIDorBycqFeZoHYw
         GbMaYE9HIZdxEohYpwS0apoajqkk/Vbheo81m/ig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 024/178] sch_cake: don't try to reallocate or unshare skb unconditionally
Date:   Mon, 29 Jun 2020 11:22:49 -0400
Message-Id: <20200629152523.2494198-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
index 2277369feae58..8020d0829f1a9 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1517,30 +1517,49 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 
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

