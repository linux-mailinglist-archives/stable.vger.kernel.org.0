Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBB0621300
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiKHNpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbiKHNpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83FB4FFB7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D005B81AEE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B66C433C1;
        Tue,  8 Nov 2022 13:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915112;
        bh=vhV/YY3ItVBejGPWVtmo9R2u9cxE7gJQAXiY7SQb54o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4JuU9GrZvRdht66IuXXuHdF2insCVJ+1JH8g6yX6Ym6eV+jdetnPikJqSWLO3Ft+
         ZFnckQ1tkWvN1++p0h3Ya/FQ2z2kRCZ0mFqYIFtYE/THQ+UWMWRs4LuuZi4sjdKFfu
         ZFN9kOwXeKLr3wMdQJ7q+Khs3cdod3+Zy9XQS+yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/48] ipvs: fix WARNING in ip_vs_app_net_cleanup()
Date:   Tue,  8 Nov 2022 14:38:59 +0100
Message-Id: <20221108133330.010959541@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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

[ Upstream commit 5663ed63adb9619c98ab7479aa4606fa9b7a548c ]

During the initialization of ip_vs_app_net_init(), if file ip_vs_app
fails to be created, the initialization is successful by default.
Therefore, the ip_vs_app file doesn't be found during the remove in
ip_vs_app_net_cleanup(). It will cause WRNING.

The following is the stack information:
name 'ip_vs_app'
WARNING: CPU: 1 PID: 9 at fs/proc/generic.c:712 remove_proc_entry+0x389/0x460
Modules linked in:
Workqueue: netns cleanup_net
RIP: 0010:remove_proc_entry+0x389/0x460
Call Trace:
<TASK>
ops_exit_list+0x125/0x170
cleanup_net+0x4ea/0xb00
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: 457c4cbc5a3d ("[NET]: Make /proc/net per network namespace")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_app.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 80759aadd3e0..21149f4e0b6e 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -604,13 +604,19 @@ static const struct seq_operations ip_vs_app_seq_ops = {
 int __net_init ip_vs_app_net_init(struct netns_ipvs *ipvs)
 {
 	INIT_LIST_HEAD(&ipvs->app_list);
-	proc_create_net("ip_vs_app", 0, ipvs->net->proc_net, &ip_vs_app_seq_ops,
-			sizeof(struct seq_net_private));
+#ifdef CONFIG_PROC_FS
+	if (!proc_create_net("ip_vs_app", 0, ipvs->net->proc_net,
+			     &ip_vs_app_seq_ops,
+			     sizeof(struct seq_net_private)))
+		return -ENOMEM;
+#endif
 	return 0;
 }
 
 void __net_exit ip_vs_app_net_cleanup(struct netns_ipvs *ipvs)
 {
 	unregister_ip_vs_app(ipvs, NULL /* all */);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_vs_app", ipvs->net->proc_net);
+#endif
 }
-- 
2.35.1



