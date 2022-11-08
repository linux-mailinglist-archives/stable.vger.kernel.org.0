Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B30A621473
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbiKHOBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbiKHOBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:01:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B4D68689
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:01:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC4BB816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBBDC433C1;
        Tue,  8 Nov 2022 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916079;
        bh=c6p4enN19Jvc9NjsI6cg3XDbDT0Tna+ygVX4/y9TOBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HW6+k6/U6Q4jLDOp9PFYWplm2FYXTtol92ymq8lZDkvizElkuc8Ba5V3gizBOlnvV
         3sS632veknJb+k4U6Kp6A4/UAcnBy77BJpBRbXO1f/+rOQAtzxb4y++W7tKmBTDQHf
         NIBE7ZHhwdwivL0LnduLtUEkHJCzkNoWP1SgORDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/144] ipv6: fix WARNING in ip6_route_net_exit_late()
Date:   Tue,  8 Nov 2022 14:38:54 +0100
Message-Id: <20221108133347.673523311@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
index 27274fc3619a..0655fd8c67e9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6570,10 +6570,16 @@ static void __net_exit ip6_route_net_exit(struct net *net)
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



