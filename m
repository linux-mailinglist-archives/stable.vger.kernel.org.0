Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D97198F3B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgCaJBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730376AbgCaJBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:01:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 755A320848;
        Tue, 31 Mar 2020 09:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645302;
        bh=1B1aebWkCEYVkaxkqB7iz+P4KZW79djIflH1OP/2ues=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQ531U7/PYC2oN4nQjDhWG6iwva450bIEzB0/Jdj+dyOJQ5o4vLjwvM/w0qZwXMMp
         b1y8equ1Q/nWfmJcBAdg+Ftjfzmu2Y3xnbasdkyILwxjKebZCra+bJi6HYAG9il2T8
         wx8N7jah4A7cprD0XxcrRJraFLj1efM85/zgeM08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 012/170] ipv4: fix a RCU-list lock in inet_dump_fib()
Date:   Tue, 31 Mar 2020 10:57:06 +0200
Message-Id: <20200331085425.441188487@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit dddeb30bfc43926620f954266fd12c65a7206f07 ]

There is a place,

inet_dump_fib()
  fib_table_dump
    fn_trie_dump_leaf()
      hlist_for_each_entry_rcu()

without rcu_read_lock() will trigger a warning,

 WARNING: suspicious RCU usage
 -----------------------------
 net/ipv4/fib_trie.c:2216 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by ip/1923:
  #0: ffffffff8ce76e40 (rtnl_mutex){+.+.}, at: netlink_dump+0xd6/0x840

 Call Trace:
  dump_stack+0xa1/0xea
  lockdep_rcu_suspicious+0x103/0x10d
  fn_trie_dump_leaf+0x581/0x590
  fib_table_dump+0x15f/0x220
  inet_dump_fib+0x4ad/0x5d0
  netlink_dump+0x350/0x840
  __netlink_dump_start+0x315/0x3e0
  rtnetlink_rcv_msg+0x4d1/0x720
  netlink_rcv_skb+0xf0/0x220
  rtnetlink_rcv+0x15/0x20
  netlink_unicast+0x306/0x460
  netlink_sendmsg+0x44b/0x770
  __sys_sendto+0x259/0x270
  __x64_sys_sendto+0x80/0xa0
  do_syscall_64+0x69/0xf4
  entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fixes: 18a8021a7be3 ("net/ipv4: Plumb support for filtering route dumps")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_frontend.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -997,7 +997,9 @@ static int inet_dump_fib(struct sk_buff
 			return -ENOENT;
 		}
 
+		rcu_read_lock();
 		err = fib_table_dump(tb, skb, cb, &filter);
+		rcu_read_unlock();
 		return skb->len ? : err;
 	}
 


