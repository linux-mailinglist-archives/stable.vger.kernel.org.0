Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F2960FDD4
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbiJ0Q71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiJ0Q7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDF317F677
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDBB4623EB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB975C433D7;
        Thu, 27 Oct 2022 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889962;
        bh=wtaCuprZStMmzN5w+ybxoB7+9PFyW1OW3UkTjKTCOuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZVXq4o1Fz2s1zKFj5RgmC9y9McGFnSQULtXw0dvr37QVUoUn3bn3Q6/Ys/8bi9PL
         xGoLiS3e3t5z1O3Iepkmf/bmRr74zsa1fDsQ4X8DVUvegM1BqYFNICzsCqOlWGZkcT
         tLn54kTDFAGYc8R4QW0qSMHERD4HgURhyXzbwG+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 57/94] ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed
Date:   Thu, 27 Oct 2022 18:54:59 +0200
Message-Id: <20221027165059.476440847@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 1ca695207ed2271ecbf8ee6c641970f621c157cc ]

If the initialization fails in calling addrconf_init_net(), devconf_all is
the pointer that has been released. Then ip6mr_sk_done() is called to
release the net, accessing devconf->mc_forwarding directly causes invalid
pointer access.

The process is as follows:
setup_net()
	ops_init()
		addrconf_init_net()
		all = kmemdup(...)           ---> alloc "all"
		...
		net->ipv6.devconf_all = all;
		__addrconf_sysctl_register() ---> failed
		...
		kfree(all);                  ---> ipv6.devconf_all invalid
		...
	ops_exit_list()
		...
		ip6mr_sk_done()
			devconf = net->ipv6.devconf_all;
			//devconf is invalid pointer
			if (!devconf || !atomic_read(&devconf->mc_forwarding))

The following is the Call Trace information:
BUG: KASAN: use-after-free in ip6mr_sk_done+0x112/0x3a0
Read of size 4 at addr ffff888075508e88 by task ip/14554
Call Trace:
<TASK>
dump_stack_lvl+0x8e/0xd1
print_report+0x155/0x454
kasan_report+0xba/0x1f0
kasan_check_range+0x35/0x1b0
ip6mr_sk_done+0x112/0x3a0
rawv6_close+0x48/0x70
inet_release+0x109/0x230
inet6_release+0x4c/0x70
sock_release+0x87/0x1b0
igmp6_net_exit+0x6b/0x170
ops_exit_list+0xb0/0x170
setup_net+0x7ac/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f7963322547

</TASK>
Allocated by task 14554:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
__kasan_kmalloc+0xa1/0xb0
__kmalloc_node_track_caller+0x4a/0xb0
kmemdup+0x28/0x60
addrconf_init_net+0x1be/0x840
ops_init+0xa5/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 14554:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
kasan_save_free_info+0x2a/0x40
____kasan_slab_free+0x155/0x1b0
slab_free_freelist_hook+0x11b/0x220
__kmem_cache_free+0xa4/0x360
addrconf_init_net+0x623/0x840
ops_init+0xa5/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 7d9b1b578d67 ("ip6mr: fix use-after-free in ip6mr_sk_done()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221017080331.16878-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 10ce86bf228e..d5967cba5b56 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7214,9 +7214,11 @@ static int __net_init addrconf_init_net(struct net *net)
 	__addrconf_sysctl_unregister(net, all, NETCONFA_IFINDEX_ALL);
 err_reg_all:
 	kfree(dflt);
+	net->ipv6.devconf_dflt = NULL;
 #endif
 err_alloc_dflt:
 	kfree(all);
+	net->ipv6.devconf_all = NULL;
 err_alloc_all:
 	kfree(net->ipv6.inet6_addr_lst);
 err_alloc_addr:
-- 
2.35.1



