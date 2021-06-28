Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3763B6286
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhF1OsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235052AbhF1OoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1537A61CF8;
        Mon, 28 Jun 2021 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890833;
        bh=IX4a4N6TESruNYh+Y4ncDHDL2h15X+WJ6y3HB5FqG4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X67bFENscTp0xwhQgVsmQIUPKJpKEOedrQfBZYEphx8vo1CT99Ib0APMVYlLlKs8O
         /ZfauIcf7ED6so/8pAu9zAPQMxbCEnoRgQoHk8PQSd6cjlS2oFcfzRVki2RwXdYgWB
         M9uoaYk5nH5AbIWESN+MqzQK/Sn6CkWyrfW1xeHKPwadVrTo2ZJ9PX2SpswR/ScRoc
         0zFgEVcWGiRTuD74oajZAWZevmG1FjEELGRxNYHt0DC/2PsAp72WzOIqTeTCZx+U1v
         MCetYtrjUCR8O8AKQ75HLRkrwG2tl0sn6Mx62CqxstYVxW3GkdpsN1j6NO6oYPAu+R
         eVmOMVnHmRM2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Juliusz Chroboczek <jch@irif.fr>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/109] icmp: don't send out ICMP messages with a source address of 0.0.0.0
Date:   Mon, 28 Jun 2021 10:32:08 -0400
Message-Id: <20210628143305.32978-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 321827477360934dc040e9d3c626bf1de6c3ab3c ]

When constructing ICMP response messages, the kernel will try to pick a
suitable source address for the outgoing packet. However, if no IPv4
addresses are configured on the system at all, this will fail and we end up
producing an ICMP message with a source address of 0.0.0.0. This can happen
on a box routing IPv4 traffic via v6 nexthops, for instance.

Since 0.0.0.0 is not generally routable on the internet, there's a good
chance that such ICMP messages will never make it back to the sender of the
original packet that the ICMP message was sent in response to. This, in
turn, can create connectivity and PMTUd problems for senders. Fortunately,
RFC7600 reserves a dummy address to be used as a source for ICMP
messages (192.0.0.8/32), so let's teach the kernel to substitute that
address as a last resort if the regular source address selection procedure
fails.

Below is a quick example reproducing this issue with network namespaces:

ip netns add ns0
ip l add type veth peer netns ns0
ip l set dev veth0 up
ip a add 10.0.0.1/24 dev veth0
ip a add fc00:dead:cafe:42::1/64 dev veth0
ip r add 10.1.0.0/24 via inet6 fc00:dead:cafe:42::2
ip -n ns0 l set dev veth0 up
ip -n ns0 a add fc00:dead:cafe:42::2/64 dev veth0
ip -n ns0 r add 10.0.0.0/24 via inet6 fc00:dead:cafe:42::1
ip netns exec ns0 sysctl -w net.ipv4.icmp_ratelimit=0
ip netns exec ns0 sysctl -w net.ipv4.ip_forward=1
tcpdump -tpni veth0 -c 2 icmp &
ping -w 1 10.1.0.1 > /dev/null
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on veth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 29, seq 1, length 64
IP 0.0.0.0 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92
2 packets captured
2 packets received by filter
0 packets dropped by kernel

With this patch the above capture changes to:
IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 31127, seq 1, length 64
IP 192.0.0.8 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Juliusz Chroboczek <jch@irif.fr>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/in.h | 3 +++
 net/ipv4/icmp.c         | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 48e8a225b985..2a66ab49f14d 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -280,6 +280,9 @@ struct sockaddr_in {
 /* Address indicating an error return. */
 #define	INADDR_NONE		((unsigned long int) 0xffffffff)
 
+/* Dummy address for src of ICMP replies if no real address is set (RFC7600). */
+#define	INADDR_DUMMY		((unsigned long int) 0xc0000008)
+
 /* Network number for local host loopback. */
 #define	IN_LOOPBACKNET		127
 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index b048125ea099..dde6cf82e9f0 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -744,6 +744,13 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		icmp_param.data_len = room;
 	icmp_param.head_len = sizeof(struct icmphdr);
 
+	/* if we don't have a source address at this point, fall back to the
+	 * dummy address instead of sending out a packet with a source address
+	 * of 0.0.0.0
+	 */
+	if (!fl4.saddr)
+		fl4.saddr = htonl(INADDR_DUMMY);
+
 	icmp_push_reply(&icmp_param, &fl4, &ipc, &rt);
 ende:
 	ip_rt_put(rt);
-- 
2.30.2

