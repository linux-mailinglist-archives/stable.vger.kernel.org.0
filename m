Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CF468966A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjBCKaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbjBCK3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:29:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202C3A0009
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:28:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F824B82A65
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52CFC433D2;
        Fri,  3 Feb 2023 10:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420117;
        bh=rBz1iUzD7uNqEOkP/AExGjfhoSIGKaEVBdJrjfZcUqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+MNQEZq/bZnZj+1xXuct5it1bbh46u9V8Sp/oRelpJUm5G4T462bALD1Lrt5uSQF
         tJ/wNdX22SQNVegOka9Jr+vx9ViEQqgna11ZiqA3jeT2pdG8sY3muwiCy4lD7vWZ/I
         7u9JLBGMLbIpNUdoDdbotE/NsXHaPcm6h4kr4GJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/134] net: fix UaF in netns ops registration error path
Date:   Fri,  3 Feb 2023 11:13:10 +0100
Message-Id: <20230203101027.685065254@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 71ab9c3e2253619136c31c89dbb2c69305cc89b1 ]

If net_assign_generic() fails, the current error path in ops_init() tries
to clear the gen pointer slot. Anyway, in such error path, the gen pointer
itself has not been modified yet, and the existing and accessed one is
smaller than the accessed index, causing an out-of-bounds error:

 BUG: KASAN: slab-out-of-bounds in ops_init+0x2de/0x320
 Write of size 8 at addr ffff888109124978 by task modprobe/1018

 CPU: 2 PID: 1018 Comm: modprobe Not tainted 6.2.0-rc2.mptcp_ae5ac65fbed5+ #1641
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc37 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x6a/0x9f
  print_address_description.constprop.0+0x86/0x2b5
  print_report+0x11b/0x1fb
  kasan_report+0x87/0xc0
  ops_init+0x2de/0x320
  register_pernet_operations+0x2e4/0x750
  register_pernet_subsys+0x24/0x40
  tcf_register_action+0x9f/0x560
  do_one_initcall+0xf9/0x570
  do_init_module+0x190/0x650
  load_module+0x1fa5/0x23c0
  __do_sys_finit_module+0x10d/0x1b0
  do_syscall_64+0x58/0x80
  entry_SYSCALL_64_after_hwframe+0x72/0xdc
 RIP: 0033:0x7f42518f778d
 Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48
       89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
       ff 73 01 c3 48 8b 0d cb 56 2c 00 f7 d8 64 89 01 48
 RSP: 002b:00007fff96869688 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
 RAX: ffffffffffffffda RBX: 00005568ef7f7c90 RCX: 00007f42518f778d
 RDX: 0000000000000000 RSI: 00005568ef41d796 RDI: 0000000000000003
 RBP: 00005568ef41d796 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
 R13: 00005568ef7f7d30 R14: 0000000000040000 R15: 0000000000000000
  </TASK>

This change addresses the issue by skipping the gen pointer
de-reference in the mentioned error-path.

Found by code inspection and verified with explicit error injection
on a kasan-enabled kernel.

Fixes: d266935ac43d ("net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/cec4e0f3bb2c77ac03a6154a8508d3930beb5f0f.1674154348.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index b96df54d0036..534a53124d14 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -140,12 +140,12 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 		return 0;
 
 	if (ops->id && ops->size) {
-cleanup:
 		ng = rcu_dereference_protected(net->gen,
 					       lockdep_is_held(&pernet_ops_rwsem));
 		ng->ptr[*ops->id] = NULL;
 	}
 
+cleanup:
 	kfree(data);
 
 out:
-- 
2.39.0



