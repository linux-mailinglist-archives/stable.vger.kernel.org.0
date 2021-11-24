Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF8945C52F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347115AbhKXNzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354237AbhKXNur (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1660661B4D;
        Wed, 24 Nov 2021 13:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759030;
        bh=5SBKCrp6ENxKrLCv/rYT6oYdU3UZ0hV7ilIpLJn6PUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ub3fekOplc7PqdSbGJy5rfI3cuq9aK3S5t8Vb/P+jnrOcR2m0s3jZWEQp0ruMFSuO
         QE2f42aglWJRrlIHr+VyWA3uOpbS6NIaEzlh+zU+HSTTtd8IrzInqufplJv/QTWQXT
         I0AObcHqzZkldl8TmjEmiENScDHLZUltw2GZawdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/279] tcp: Fix uninitialized access in skb frags array for Rx 0cp.
Date:   Wed, 24 Nov 2021 12:56:37 +0100
Message-Id: <20211124115722.580959025@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

[ Upstream commit 70701b83e208767f2720d8cd3e6a62cddafb3a30 ]

TCP Receive zerocopy iterates through the SKB queue via
tcp_recv_skb(), acquiring a pointer to an SKB and an offset within
that SKB to read from. From there, it iterates the SKB frags array to
determine which offset to start remapping pages from.

However, this is built on the assumption that the offset read so far
within the SKB is smaller than the SKB length. If this assumption is
violated, we can attempt to read an invalid frags array element, which
would cause a fault.

tcp_recv_skb() can cause such an SKB to be returned when the TCP FIN
flag is set. Therefore, we must guard against this occurrence inside
skb_advance_frag().

One way that we can reproduce this error follows:
1) In a receiver program, call getsockopt(TCP_ZEROCOPY_RECEIVE) with:
char some_array[32 * 1024];
struct tcp_zerocopy_receive zc = {
  .copybuf_address  = (__u64) &some_array[0],
  .copybuf_len = 32 * 1024,
};

2) In a sender program, after a TCP handshake, send the following
sequence of packets:
  i) Seq = [X, X+4000]
  ii) Seq = [X+4000, X+5000]
  iii) Seq = [X+4000, X+5000], Flags = FIN | URG, urgptr=1000

(This can happen without URG, if we have a signal pending, but URG is
a convenient way to reproduce the behaviour).

In this case, the following event sequence will occur on the receiver:

tcp_zerocopy_receive():
-> receive_fallback_to_copy() // copybuf_len >= inq
-> tcp_recvmsg_locked() // reads 5000 bytes, then breaks due to URG
-> tcp_recv_skb() // yields skb with skb->len == offset
-> tcp_zerocopy_set_hint_for_skb()
-> skb_advance_to_frag() // will returns a frags ptr. >= nr_frags
-> find_next_mappable_frag() // will dereference this bad frags ptr.

With this patch, skb_advance_to_frag() will no longer return an
invalid frags pointer, and will return NULL instead, fixing the issue.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
Link: https://lore.kernel.org/r/20211111235215.2605384-1-arjunroy.kdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8affba5909bdf..844c6e5a82891 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1776,6 +1776,9 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
 {
 	skb_frag_t *frag;
 
+	if (unlikely(offset_skb >= skb->len))
+		return NULL;
+
 	offset_skb -= skb_headlen(skb);
 	if ((int)offset_skb < 0 || skb_has_frag_list(skb))
 		return NULL;
-- 
2.33.0



