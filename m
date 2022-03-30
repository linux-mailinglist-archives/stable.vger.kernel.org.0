Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4894EC244
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiC3L7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345317AbiC3LyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4623278543;
        Wed, 30 Mar 2022 04:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43937B81C36;
        Wed, 30 Mar 2022 11:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E30C36AE5;
        Wed, 30 Mar 2022 11:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641051;
        bh=W28dUiUQFRtYyYKOqfOF5acJxI2YPCJwPhAGm1Nfn6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwKTBb1msXbuppPLM9IMgR3lgtWlC2y7P+MgQr/AecaR/t1iJLMZ2jNKBvrKtpSxr
         ysK4mdvCmRRW4IOXgtl5KF4qmDRg3ZXYjm3aie4605ioNEtTB+ey87cqIJylLQwkzl
         cGGhr2jOWYvifnwIKbMp/Q8SpclZ/VtcvGPkMwfvqbhKh8Q8t9hGGAkmQhuI1pyt64
         wPFwksLFsu9culfmffa4GbTVFP2qhwX/CbplmfDJ4CYXnBlt61bxBRNS9YafdoouE3
         YlpDOCbcLUgHJwYS6VjJ48E/mRzuFpHnr0+LESOmi5XgIlOl9QhiFf62YDzj3t3Ro7
         Uw6y8Za7PZ13g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Brennan <stephen.s.brennan@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 5.15 30/50] printk: Avoid livelock with heavy printk during panic
Date:   Wed, 30 Mar 2022 07:49:44 -0400
Message-Id: <20220330115005.1671090-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
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
index f9aebe88cc53..f37889b6cf9f 100644
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
@@ -2222,6 +2228,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (unlikely(suppress_printk))
 		return 0;
 
+	if (unlikely(suppress_panic_printk) &&
+	    atomic_read(&panic_cpu) != raw_smp_processor_id())
+		return 0;
+
 	if (level == LOGLEVEL_SCHED) {
 		level = LOGLEVEL_DEFAULT;
 		in_sched = true;
@@ -2607,6 +2617,7 @@ void console_unlock(void)
 {
 	static char ext_text[CONSOLE_EXT_LOG_MAX];
 	static char text[CONSOLE_LOG_MAX];
+	static int panic_console_dropped;
 	unsigned long flags;
 	bool do_cond_resched, retry;
 	struct printk_info info;
@@ -2661,6 +2672,10 @@ void console_unlock(void)
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

