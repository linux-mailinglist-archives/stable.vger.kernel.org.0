Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2640F657ED6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbiL1P6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiL1P6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C22F183B8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C7CBB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9703CC433D2;
        Wed, 28 Dec 2022 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243086;
        bh=xadfa5UUa/VvR7/Q+w8xXinb6FW7rp5NXKRfhIxiI8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSVsAHwvbjxAs0LeR1fsrMp/kH8Q9sEj65EXvq9e34T5SZWfGBNbjzzcEgcQ9mdvb
         tO3LPhCWDIWF9M9Wxwc1k/if4Wi4OLdSm+VknrNYEfOEb5kocc0VEw8X9bH/K9NAez
         y9dEnHbMz6hBZwiolIX2cNSfVY+R+YHJYIRiFWA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 682/731] orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()
Date:   Wed, 28 Dec 2022 15:43:09 +0100
Message-Id: <20221228144316.241254170@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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



