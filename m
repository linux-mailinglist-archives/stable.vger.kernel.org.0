Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6504615A32
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiKBD0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiKBD0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C5925E95
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06D03617BA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB41C433D6;
        Wed,  2 Nov 2022 03:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359598;
        bh=JU0dgYvgeFc+Ke94xxGjhDKNvfu77n8LVTBB7PSzecY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1mj+giKJa7fkdRF7uESFCuPSO50g5zl3iKzpqpW3B8udxalHyYqWl0UC2hcIYK9M
         lSvIOFYiipXq9r+LzAcueveHGZC4ROi6Ki9FoEFRV50r4CfyAxLD0j8hbE2kQXFdrV
         SYsTJfTAEMFJkaxOPGe5O/LQHLPGlecnl6pnWj1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/64] net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed
Date:   Wed,  2 Nov 2022 03:34:08 +0100
Message-Id: <20221102022053.177402464@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit d266935ac43d57586e311a087510fe6a084af742 ]

When the ops_init() interface is invoked to initialize the net, but
ops->init() fails, data is released. However, the ptr pointer in
net->gen is invalid. In this case, when nfqnl_nf_hook_drop() is invoked
to release the net, invalid address access occurs.

The process is as follows:
setup_net()
	ops_init()
		data = kzalloc(...)   ---> alloc "data"
		net_assign_generic()  ---> assign "date" to ptr in net->gen
		...
		ops->init()           ---> failed
		...
		kfree(data);          ---> ptr in net->gen is invalid
	...
	ops_exit_list()
		...
		nfqnl_nf_hook_drop()
			*q = nfnl_queue_pernet(net) ---> q is invalid

The following is the Call Trace information:
BUG: KASAN: use-after-free in nfqnl_nf_hook_drop+0x264/0x280
Read of size 8 at addr ffff88810396b240 by task ip/15855
Call Trace:
<TASK>
dump_stack_lvl+0x8e/0xd1
print_report+0x155/0x454
kasan_report+0xba/0x1f0
nfqnl_nf_hook_drop+0x264/0x280
nf_queue_nf_hook_drop+0x8b/0x1b0
__nf_unregister_net_hook+0x1ae/0x5a0
nf_unregister_net_hooks+0xde/0x130
ops_exit_list+0xb0/0x170
setup_net+0x7ac/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
</TASK>

Allocated by task 15855:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
__kasan_kmalloc+0xa1/0xb0
__kmalloc+0x49/0xb0
ops_init+0xe7/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 15855:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
kasan_save_free_info+0x2a/0x40
____kasan_slab_free+0x155/0x1b0
slab_free_freelist_hook+0x11b/0x220
__kmem_cache_free+0xa4/0x360
ops_init+0xb9/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: f875bae06533 ("net: Automatically allocate per namespace data.")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 62a972f04cef..b96df54d0036 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -120,6 +120,7 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
 
 static int ops_init(const struct pernet_operations *ops, struct net *net)
 {
+	struct net_generic *ng;
 	int err = -ENOMEM;
 	void *data = NULL;
 
@@ -138,7 +139,13 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 	if (!err)
 		return 0;
 
+	if (ops->id && ops->size) {
 cleanup:
+		ng = rcu_dereference_protected(net->gen,
+					       lockdep_is_held(&pernet_ops_rwsem));
+		ng->ptr[*ops->id] = NULL;
+	}
+
 	kfree(data);
 
 out:
-- 
2.35.1



