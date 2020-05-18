Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6811D808F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgERRk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbgERRk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F3D920657;
        Mon, 18 May 2020 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823625;
        bh=+5Hx6j8XeznTB/ncyoRGCyiroW+T2QpU5wS0iwqqkEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CifkUaDDmLvQ3+Rx0sisk5GcM93F1axhYyh52xo/F/c78E0ryCHicy8YeijL8v3cX
         d6vFl+MRNU//7cxVuKnyvloHBpH9Q26vTBai/VWPtGI6QtzF1sBeAxna/ZDI7pg+XL
         uboJ2MvFPje1oxfshiY88H4p6LX7bQS1PGmIW5vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 09/86] ipv6: fix cleanup ordering for ip6_mr failure
Date:   Mon, 18 May 2020 19:35:40 +0200
Message-Id: <20200518173452.201457230@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
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
@@ -1029,11 +1029,11 @@ netfilter_fail:
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


