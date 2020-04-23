Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67F61B6835
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgDWXNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:13:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49994 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728484AbgDWXGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:50 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvX-0004mB-OV; Fri, 24 Apr 2020 00:06:39 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-00E6uT-2c; Fri, 24 Apr 2020 00:06:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Florian Westphal" <fw@strlen.de>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com,
        "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Date:   Fri, 24 Apr 2020 00:06:32 +0100
Message-ID: <lsq.1587683028.172167900@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 165/245] netfilter: ipset: avoid null deref when
 IPSET_ATTR_LINENO is present
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1549,6 +1549,7 @@ ip_set_utest(struct sock *ctnl, struct s
 	struct ip_set *set;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1] = {};
 	int ret = 0;
+	u32 lineno;
 
 	if (unlikely(protocol_failed(attr) ||
 		     attr[IPSET_ATTR_SETNAME] == NULL ||
@@ -1565,7 +1566,7 @@ ip_set_utest(struct sock *ctnl, struct s
 		return -IPSET_ERR_PROTOCOL;
 
 	read_lock_bh(&set->lock);
-	ret = set->variant->uadt(set, tb, IPSET_TEST, NULL, 0, 0);
+	ret = set->variant->uadt(set, tb, IPSET_TEST, &lineno, 0, 0);
 	read_unlock_bh(&set->lock);
 	/* Userspace can't trigger element to be re-added */
 	if (ret == -EAGAIN)

