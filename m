Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5FF651844
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiLTB0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiLTBYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:24:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C228FF1;
        Mon, 19 Dec 2022 17:22:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0B67B810FB;
        Tue, 20 Dec 2022 01:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF873C433A1;
        Tue, 20 Dec 2022 01:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499356;
        bh=xadfa5UUa/VvR7/Q+w8xXinb6FW7rp5NXKRfhIxiI8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/tyCxk0VUcqsQn6YpZMHqVFCD89O+zkk/RrhgoLHxpwyk6X2YjlYvRd1tKqnPJu+
         pBwhILbwOlBO0NJH4C7+X+5R4XIa6VEtethHHnlwjO3ok50d94ZzK7QCMQh8MOrlo1
         OrQuL7XVkAGa4ixB/hlDA9xIexO+WBTVfOBd+VbFh7u99ohL5x7tSBD8ccE4SBzaOt
         R0GwSCfbW03687a+sdR6aWral5ho937yeEIKwDZIeLGzVHUU2LmkmN1mj/c/mxyZZY
         9Ma6TglH8ooVo6EcgE1PEynY9r2Ztvhmj0r8VVv+dljc2nsoYjqFQyU0mvucwYm84e
         Uje9F1YdPhjUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 5.4 5/5] orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()
Date:   Mon, 19 Dec 2022 20:22:27 -0500
Message-Id: <20221220012227.1222729-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012227.1222729-1-sashal@kernel.org>
References: <20221220012227.1222729-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 31720a2b109b3080eb77e97b8f6f50a27b4ae599 ]

When insert and remove the orangefs module, there are memory leaked
as below:

unreferenced object 0xffff88816b0cc000 (size 2048):
  comm "insmod", pid 783, jiffies 4294813439 (age 65.512s)
  hex dump (first 32 bytes):
    6e 6f 6e 65 0a 00 00 00 00 00 00 00 00 00 00 00  none............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031ab7788>] kmalloc_trace+0x27/0xa0
    [<000000005b405fee>] orangefs_debugfs_init.cold+0xaf/0x17f
    [<00000000e5a0085b>] 0xffffffffa02780f9
    [<000000004232d9f7>] do_one_initcall+0x87/0x2a0
    [<0000000054f22384>] do_init_module+0xdf/0x320
    [<000000003263bdea>] load_module+0x2f98/0x3330
    [<0000000052cd4153>] __do_sys_finit_module+0x113/0x1b0
    [<00000000250ae02b>] do_syscall_64+0x35/0x80
    [<00000000f11c03c7>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Use the golbal variable as the buffer rather than dynamic allocate to
slove the problem.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index a848b6ef9599..1b508f543384 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -194,15 +194,10 @@ void orangefs_debugfs_init(int debug_mask)
  */
 static void orangefs_kernel_debug_init(void)
 {
-	int rc = -ENOMEM;
-	char *k_buffer = NULL;
+	static char k_buffer[ORANGEFS_MAX_DEBUG_STRING_LEN] = { };
 
 	gossip_debug(GOSSIP_DEBUGFS_DEBUG, "%s: start\n", __func__);
 
-	k_buffer = kzalloc(ORANGEFS_MAX_DEBUG_STRING_LEN, GFP_KERNEL);
-	if (!k_buffer)
-		goto out;
-
 	if (strlen(kernel_debug_string) + 1 < ORANGEFS_MAX_DEBUG_STRING_LEN) {
 		strcpy(k_buffer, kernel_debug_string);
 		strcat(k_buffer, "\n");
@@ -213,9 +208,6 @@ static void orangefs_kernel_debug_init(void)
 
 	debugfs_create_file(ORANGEFS_KMOD_DEBUG_FILE, 0444, debug_dir, k_buffer,
 			    &kernel_debug_fops);
-
-out:
-	gossip_debug(GOSSIP_DEBUGFS_DEBUG, "%s: rc:%d:\n", __func__, rc);
 }
 
 
@@ -299,18 +291,13 @@ static int help_show(struct seq_file *m, void *v)
 /*
  * initialize the client-debug file.
  */
-static int orangefs_client_debug_init(void)
+static void orangefs_client_debug_init(void)
 {
 
-	int rc = -ENOMEM;
-	char *c_buffer = NULL;
+	static char c_buffer[ORANGEFS_MAX_DEBUG_STRING_LEN] = { };
 
 	gossip_debug(GOSSIP_DEBUGFS_DEBUG, "%s: start\n", __func__);
 
-	c_buffer = kzalloc(ORANGEFS_MAX_DEBUG_STRING_LEN, GFP_KERNEL);
-	if (!c_buffer)
-		goto out;
-
 	if (strlen(client_debug_string) + 1 < ORANGEFS_MAX_DEBUG_STRING_LEN) {
 		strcpy(c_buffer, client_debug_string);
 		strcat(c_buffer, "\n");
@@ -324,13 +311,6 @@ static int orangefs_client_debug_init(void)
 						  debug_dir,
 						  c_buffer,
 						  &kernel_debug_fops);
-
-	rc = 0;
-
-out:
-
-	gossip_debug(GOSSIP_DEBUGFS_DEBUG, "%s: rc:%d:\n", __func__, rc);
-	return rc;
 }
 
 /* open ORANGEFS_KMOD_DEBUG_FILE or ORANGEFS_CLIENT_DEBUG_FILE.*/
-- 
2.35.1

