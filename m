Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672D61D8139
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgERRqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730014AbgERRqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5905420671;
        Mon, 18 May 2020 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823959;
        bh=Gk9Zi+4wiOkpDw7YJtmvc8Y2fAss9rnZguBaccCTGzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0x1YewE6U/3Hd0JEp5N3xg/OzcI8tZj9s+D0T3als91ljnkDQhgRjtcSkoGTPysJT
         PwGv/l3qxT2hBXe8I63g5suU3fH17jqZiKcQFKEjKGqsSWwStAHb+HbyUdlPVlNs3A
         rNY6TDdkg1b5jp/ztAvBCZ2/VxhdPoMd08DmNSJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 015/114] ipv6: fix cleanup ordering for ip6_mr failure
Date:   Mon, 18 May 2020 19:35:47 +0200
Message-Id: <20200518173506.406246778@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit afe49de44c27a89e8e9631c44b5ffadf6ace65e2 upstream.

Commit 15e668070a64 ("ipv6: reorder icmpv6_init() and ip6_mr_init()")
moved the cleanup label for ipmr_fail, but should have changed the
contents of the cleanup labels as well. Now we can end up cleaning up
icmpv6 even though it hasn't been initialized (jump to icmp_fail or
ipmr_fail).

Simply undo things in the reverse order of their initialization.

Example of panic (triggered by faking a failure of icmpv6_init):

    kasan: GPF could be caused by NULL-ptr deref or user memory access
    general protection fault: 0000 [#1] PREEMPT SMP KASAN PTI
    [...]
    RIP: 0010:__list_del_entry_valid+0x79/0x160
    [...]
    Call Trace:
     ? lock_release+0x8a0/0x8a0
     unregister_pernet_operations+0xd4/0x560
     ? ops_free_list+0x480/0x480
     ? down_write+0x91/0x130
     ? unregister_pernet_subsys+0x15/0x30
     ? down_read+0x1b0/0x1b0
     ? up_read+0x110/0x110
     ? kmem_cache_create_usercopy+0x1b4/0x240
     unregister_pernet_subsys+0x1d/0x30
     icmpv6_cleanup+0x1d/0x30
     inet6_init+0x1b5/0x23f

Fixes: 15e668070a64 ("ipv6: reorder icmpv6_init() and ip6_mr_init()")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/af_inet6.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1088,11 +1088,11 @@ netfilter_fail:
 igmp_fail:
 	ndisc_cleanup();
 ndisc_fail:
-	ip6_mr_cleanup();
+	icmpv6_cleanup();
 icmp_fail:
-	unregister_pernet_subsys(&inet6_net_ops);
+	ip6_mr_cleanup();
 ipmr_fail:
-	icmpv6_cleanup();
+	unregister_pernet_subsys(&inet6_net_ops);
 register_pernet_fail:
 	sock_unregister(PF_INET6);
 	rtnl_unregister_all(PF_INET6);


