Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8126213CD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiKHNyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiKHNx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:53:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDD0F4F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EB1F615A4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E92DC433C1;
        Tue,  8 Nov 2022 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915635;
        bh=7jc2wxCL+yZzWo0SH7Kq6tdOLHTsDTk5lqgYwoKDpyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLn2o44HR9609JnAaqd7QQq1PpFrazMgJatyKygxU+pW9zrkdSDWq+kXfPjnevXuh
         RUCd9xvxTXoY0kOModKPOCQLD4/oNFyCLHgT9q2UVrLDpo7YNvIaUyLXFEgFieor5i
         JS73kHBwstqG3tS4QcilVEApxf/1Chuor/gpqCJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/118] ipv6: fix WARNING in ip6_route_net_exit_late()
Date:   Tue,  8 Nov 2022 14:38:44 +0100
Message-Id: <20221108133342.686466599@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 768b3c745fe5789f2430bdab02f35a9ad1148d97 ]

During the initialization of ip6_route_net_init_late(), if file
ipv6_route or rt6_stats fails to be created, the initialization is
successful by default. Therefore, the ipv6_route or rt6_stats file
doesn't be found during the remove in ip6_route_net_exit_late(). It
will cause WRNING.

The following is the stack information:
name 'rt6_stats'
WARNING: CPU: 0 PID: 9 at fs/proc/generic.c:712 remove_proc_entry+0x389/0x460
Modules linked in:
Workqueue: netns cleanup_net
RIP: 0010:remove_proc_entry+0x389/0x460
PKRU: 55555554
Call Trace:
<TASK>
ops_exit_list+0xb0/0x170
cleanup_net+0x4ea/0xb00
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: cdb1876192db ("[NETNS][IPV6] route6 - create route6 proc files for the namespace")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221102020610.351330-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index cdf215442d37..803d1aa83140 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6405,10 +6405,16 @@ static void __net_exit ip6_route_net_exit(struct net *net)
 static int __net_init ip6_route_net_init_late(struct net *net)
 {
 #ifdef CONFIG_PROC_FS
-	proc_create_net("ipv6_route", 0, net->proc_net, &ipv6_route_seq_ops,
-			sizeof(struct ipv6_route_iter));
-	proc_create_net_single("rt6_stats", 0444, net->proc_net,
-			rt6_stats_seq_show, NULL);
+	if (!proc_create_net("ipv6_route", 0, net->proc_net,
+			     &ipv6_route_seq_ops,
+			     sizeof(struct ipv6_route_iter)))
+		return -ENOMEM;
+
+	if (!proc_create_net_single("rt6_stats", 0444, net->proc_net,
+				    rt6_stats_seq_show, NULL)) {
+		remove_proc_entry("ipv6_route", net->proc_net);
+		return -ENOMEM;
+	}
 #endif
 	return 0;
 }
-- 
2.35.1



