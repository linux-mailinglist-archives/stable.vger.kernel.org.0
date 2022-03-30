Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7B4EC1BA
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbiC3Lzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344703AbiC3Lx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5027E26D102;
        Wed, 30 Mar 2022 04:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFBB36162C;
        Wed, 30 Mar 2022 11:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6050CC36AEA;
        Wed, 30 Mar 2022 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640962;
        bh=jKdMbV/aDuitwGBnxxb5mfw7Z300Q/lkHFHXWOjhUgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBUad8qUJdXyO4e/11ZOkj7xNlvZpoybITuT/a4qVOBhEKa1T8ob1d/OoAmelv+EQ
         hXWAxmGD9prsZDL7nyRVwfgHIBMR7DZSozVHU/kLRIBaBJjUz3fz9O71Gc+eKgaWje
         IgKdL2ZoH4FQF8+cCoJ3yk/rfuPH8XaZ9nhQmzyuaR6Gx1QRrkDiZkc6TUtBe6NKUY
         dpyIjb598o+SfoxQ8f9nbG73ORMxpgVXc1jQEEphe6TsZDUqHFlm8xLpfFKier9ZGA
         0HSq4UK/1VTX3YPA9E+ixXjCvNH9nMHNfbMrD2EFSHPH3N1S1sM9bO1TdacNpID8cE
         RCHdUSeQU+Qdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Brennan <stephen.s.brennan@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux@roeck-us.net
Subject: [PATCH AUTOSEL 5.16 32/59] printk: Avoid livelock with heavy printk during panic
Date:   Wed, 30 Mar 2022 07:48:04 -0400
Message-Id: <20220330114831.1670235-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Brennan <stephen.s.brennan@oracle.com>

[ Upstream commit 13fb0f74d7029df3b8137f11ef955e578a4a4a60 ]

During panic(), if another CPU is writing heavily the kernel log (e.g.
via /dev/kmsg), then the panic CPU may livelock writing out its messages
to the console. Note when too many messages are dropped during panic and
suppress further printk, except from the panic CPU. This could result in
some important messages being dropped. However, messages are already
being dropped, so this approach at least prevents a livelock.

Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220202171821.179394-4-stephen.s.brennan@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e3d986dd49a1..f7c4c53a2c35 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -93,6 +93,12 @@ EXPORT_SYMBOL_GPL(console_drivers);
  */
 int __read_mostly suppress_printk;
 
+/*
+ * During panic, heavy printk by other CPUs can delay the
+ * panic and risk deadlock on console resources.
+ */
+int __read_mostly suppress_panic_printk;
+
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map console_lock_dep_map = {
 	.name = "console_lock"
@@ -2223,6 +2229,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (unlikely(suppress_printk))
 		return 0;
 
+	if (unlikely(suppress_panic_printk) &&
+	    atomic_read(&panic_cpu) != raw_smp_processor_id())
+		return 0;
+
 	if (level == LOGLEVEL_SCHED) {
 		level = LOGLEVEL_DEFAULT;
 		in_sched = true;
@@ -2608,6 +2618,7 @@ void console_unlock(void)
 {
 	static char ext_text[CONSOLE_EXT_LOG_MAX];
 	static char text[CONSOLE_LOG_MAX];
+	static int panic_console_dropped;
 	unsigned long flags;
 	bool do_cond_resched, retry;
 	struct printk_info info;
@@ -2662,6 +2673,10 @@ void console_unlock(void)
 		if (console_seq != r.info->seq) {
 			console_dropped += r.info->seq - console_seq;
 			console_seq = r.info->seq;
+			if (panic_in_progress() && panic_console_dropped++ > 10) {
+				suppress_panic_printk = 1;
+				pr_warn_once("Too many dropped messages. Suppress messages on non-panic CPUs to prevent livelock.\n");
+			}
 		}
 
 		if (suppress_message_printing(r.info->level)) {
-- 
2.34.1

