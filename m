Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205616212FE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiKHNpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiKHNpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510A14FF9B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF43B81AEF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62297C433D6;
        Tue,  8 Nov 2022 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915108;
        bh=TSd+0uUAJw4B93h//LUg6MPOu4XB0I+UuW2x4lRB344=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5eXMGOUtFBLY3v8EJnre3yBViBnUYNBzcfHBvyWvuRCZ5OYAQTvMJuRDWkjGFRzO
         YmWrsyBlO+AkVMvkDoehc8pI88JHK+RSB3rRJx/P/8PvzcVZqnt8vHl8Wc3r9pMriM
         q5SNr4KVxISOHhH/QVuK/sx7KtVHFf5tMOUSGq30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/48] ipvs: fix WARNING in __ip_vs_cleanup_batch()
Date:   Tue,  8 Nov 2022 14:38:58 +0100
Message-Id: <20221108133329.982556695@linuxfoundation.org>
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

[ Upstream commit 3d00c6a0da8ddcf75213e004765e4a42acc71d5d ]

During the initialization of ip_vs_conn_net_init(), if file ip_vs_conn
or ip_vs_conn_sync fails to be created, the initialization is successful
by default. Therefore, the ip_vs_conn or ip_vs_conn_sync file doesn't
be found during the remove.

The following is the stack information:
name 'ip_vs_conn_sync'
WARNING: CPU: 3 PID: 9 at fs/proc/generic.c:712
remove_proc_entry+0x389/0x460
Modules linked in:
Workqueue: netns cleanup_net
RIP: 0010:remove_proc_entry+0x389/0x460
Call Trace:
<TASK>
__ip_vs_cleanup_batch+0x7d/0x120
ops_exit_list+0x125/0x170
cleanup_net+0x4ea/0xb00
process_one_work+0x9bf/0x1710
worker_thread+0x665/0x1080
kthread+0x2e4/0x3a0
ret_from_fork+0x1f/0x30
</TASK>

Fixes: 61b1ab4583e2 ("IPVS: netns, add basic init per netns.")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 5ebc7998529a..51679d1e2d7d 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1378,20 +1378,36 @@ int __net_init ip_vs_conn_net_init(struct netns_ipvs *ipvs)
 {
 	atomic_set(&ipvs->conn_count, 0);
 
-	proc_create_net("ip_vs_conn", 0, ipvs->net->proc_net,
-			&ip_vs_conn_seq_ops, sizeof(struct ip_vs_iter_state));
-	proc_create_net("ip_vs_conn_sync", 0, ipvs->net->proc_net,
-			&ip_vs_conn_sync_seq_ops,
-			sizeof(struct ip_vs_iter_state));
+#ifdef CONFIG_PROC_FS
+	if (!proc_create_net("ip_vs_conn", 0, ipvs->net->proc_net,
+			     &ip_vs_conn_seq_ops,
+			     sizeof(struct ip_vs_iter_state)))
+		goto err_conn;
+
+	if (!proc_create_net("ip_vs_conn_sync", 0, ipvs->net->proc_net,
+			     &ip_vs_conn_sync_seq_ops,
+			     sizeof(struct ip_vs_iter_state)))
+		goto err_conn_sync;
+#endif
+
 	return 0;
+
+#ifdef CONFIG_PROC_FS
+err_conn_sync:
+	remove_proc_entry("ip_vs_conn", ipvs->net->proc_net);
+err_conn:
+	return -ENOMEM;
+#endif
 }
 
 void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
 {
 	/* flush all the connection entries first */
 	ip_vs_conn_flush(ipvs);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_vs_conn", ipvs->net->proc_net);
 	remove_proc_entry("ip_vs_conn_sync", ipvs->net->proc_net);
+#endif
 }
 
 int __init ip_vs_conn_init(void)
-- 
2.35.1



