Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E901113A6D5
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbgANKNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733108AbgANKNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:13:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5572624676;
        Tue, 14 Jan 2020 10:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996828;
        bh=7+tDIkDKEgMJ/MxV6Y7r6xHMBAn2XLb88L/SHHq88rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VX1bCOB+B8n4wRAm/5P3LkR+k5kB+fkpQ+wicfSpVxwJRYJCqLafufaiP18k+rwM
         bRQ6jO0IQLMDXi3bD6u7QxMVsJsK9MdSb42JKCt4T7Fa+jL71Owt5EzvxmW9U8RSDC
         0iih5/ZWp3IiAEFNypSye81c2qFEn3eMFhUCLrx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 28/28] netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present
Date:   Tue, 14 Jan 2020 11:02:30 +0100
Message-Id: <20200114094345.119644409@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
References: <20200114094336.845958665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 22dad713b8a5ff488e07b821195270672f486eb2 upstream.

The set uadt functions assume lineno is never NULL, but it is in
case of ip_set_utest().

syzkaller managed to generate a netlink message that calls this with
LINENO attr present:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:hash_mac4_uadt+0x1bc/0x470 net/netfilter/ipset/ip_set_hash_mac.c:104
Call Trace:
 ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563

pass a dummy lineno storage, its easier than patching all set
implementations.

This seems to be a day-0 bug.

Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Fixes: a7b4f989a6294 ("netfilter: ipset: IP set core support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1619,6 +1619,7 @@ ip_set_utest(struct sock *ctnl, struct s
 	struct ip_set *set;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
 	int ret = 0;
+	u32 lineno;
 
 	if (unlikely(protocol_failed(attr) ||
 		     !attr[IPSET_ATTR_SETNAME] ||
@@ -1635,7 +1636,7 @@ ip_set_utest(struct sock *ctnl, struct s
 		return -IPSET_ERR_PROTOCOL;
 
 	rcu_read_lock_bh();
-	ret = set->variant->uadt(set, tb, IPSET_TEST, NULL, 0, 0);
+	ret = set->variant->uadt(set, tb, IPSET_TEST, &lineno, 0, 0);
 	rcu_read_unlock_bh();
 	/* Userspace can't trigger element to be re-added */
 	if (ret == -EAGAIN)


