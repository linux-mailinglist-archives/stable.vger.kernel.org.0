Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5F2420D2F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhJDNMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235664AbhJDNKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B67E61AFF;
        Mon,  4 Oct 2021 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352644;
        bh=viIZgotVEB/9pg0QOwfS4z21bbhSoxavr5XUnD4ivvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n55/iYnebxx6OreCq7H+AKP+CfZFFTQLdlcwK2G8qgcLP6Fp5wiK7Y8PU30aRiWR/
         xP8LtFxkKgyJJpL2+BpTV9YQNZi9kDes3i5MKk0rFTks9gpVTUNMegj+osAbpQNM5j
         R8JmHCtdDondXX70vOL7qLbCyRXu+zr87ke62TJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 66/95] sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb
Date:   Mon,  4 Oct 2021 14:52:36 +0200
Message-Id: <20211004125035.723652364@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f7e745f8e94492a8ac0b0a26e25f2b19d342918f ]

We should always check if skb_header_pointer's return is NULL before
using it, otherwise it may cause null-ptr-deref, as syzbot reported:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
  RIP: 0010:sctp_rcv+0x1d84/0x3220 net/sctp/input.c:196
  Call Trace:
  <IRQ>
   sctp6_rcv+0x38/0x60 net/sctp/ipv6.c:1109
   ip6_protocol_deliver_rcu+0x2e9/0x1ca0 net/ipv6/ip6_input.c:422
   ip6_input_finish+0x62/0x170 net/ipv6/ip6_input.c:463
   NF_HOOK include/linux/netfilter.h:307 [inline]
   NF_HOOK include/linux/netfilter.h:301 [inline]
   ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:472
   dst_input include/net/dst.h:460 [inline]
   ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
   NF_HOOK include/linux/netfilter.h:307 [inline]
   NF_HOOK include/linux/netfilter.h:301 [inline]
   ipv6_rcv+0x28c/0x3c0 net/ipv6/ip6_input.c:297

Fixes: 3acb50c18d8d ("sctp: delay as much as possible skb_linearize")
Reported-by: syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 8b7c07fc66d4..64dc2923a21b 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -687,7 +687,7 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
 		ch = skb_header_pointer(skb, offset, sizeof(*ch), &_ch);
 
 		/* Break out if chunk length is less then minimal. */
-		if (ntohs(ch->length) < sizeof(_ch))
+		if (!ch || ntohs(ch->length) < sizeof(_ch))
 			break;
 
 		ch_end = offset + SCTP_PAD4(ntohs(ch->length));
-- 
2.33.0



