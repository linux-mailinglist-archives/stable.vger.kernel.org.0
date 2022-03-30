Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5134EC280
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344337AbiC3Lzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344676AbiC3LxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C6326C2DD;
        Wed, 30 Mar 2022 04:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFC88B81C23;
        Wed, 30 Mar 2022 11:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A607EC36AE3;
        Wed, 30 Mar 2022 11:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640963;
        bh=YGc7WmUAaF+RqDeiav9aNLIe7E7IZAsP7q1KD+SY1pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvqMI68lgYD0ndtSuGX8lSNdIK9yZ3pgUrlQ6qvM7P33CKaBhSGsJ3Al/3vu2W8HA
         WIwYYgt27JwH4l2/Tbe91EWdJtVn5+xbCPBFmftgQQaHhdIhz6jJUbwvFsoO3vJNri
         o7EQGSMr3//6ekkkS1Dobfxxcq3cliV7CUhzj6rPwcNaooGCXfdqr01lGASEeLxW2J
         F8WnIZJU7wlib9YSU+F2A63/Zs1eIj0jP+CoCALJAyOgdcAijdEfW/wW8t0YKEcyKh
         MEy7auzcddKZVM58P4pSAglcBwkLQn4AwlF4dRgrPFnKGLWUJX/5oelFVGmb+wfPN2
         h8JMn4PklNzkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Brennan <stephen.s.brennan@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux@roeck-us.net,
        gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 5.16 33/59] printk: Drop console_sem during panic
Date:   Wed, 30 Mar 2022 07:48:05 -0400
Message-Id: <20220330114831.1670235-33-sashal@kernel.org>
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

[ Upstream commit 8ebc476fd51e6c0fd3174ec1959a20ba99d4c5e5 ]

If another CPU is in panic, we are about to be halted. Try to gracefully
abandon the console_sem, leaving it free for the panic CPU to grab.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220202171821.179394-5-stephen.s.brennan@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index f7c4c53a2c35..92eb7785e6e7 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2588,6 +2588,25 @@ static int have_callable_console(void)
 	return 0;
 }
 
+/*
+ * Return true when this CPU should unlock console_sem without pushing all
+ * messages to the console. This reduces the chance that the console is
+ * locked when the panic CPU tries to use it.
+ */
+static bool abandon_console_lock_in_panic(void)
+{
+	if (!panic_in_progress())
+		return false;
+
+	/*
+	 * We can use raw_smp_processor_id() here because it is impossible for
+	 * the task to be migrated to the panic_cpu, or away from it. If
+	 * panic_cpu has already been set, and we're not currently executing on
+	 * that CPU, then we never will be.
+	 */
+	return atomic_read(&panic_cpu) != raw_smp_processor_id();
+}
+
 /*
  * Can we actually use the console at this time on this cpu?
  *
@@ -2736,6 +2755,10 @@ void console_unlock(void)
 		if (handover)
 			return;
 
+		/* Allow panic_cpu to take over the consoles safely */
+		if (abandon_console_lock_in_panic())
+			break;
+
 		if (do_cond_resched)
 			cond_resched();
 	}
@@ -2753,7 +2776,7 @@ void console_unlock(void)
 	 * flush, no worries.
 	 */
 	retry = prb_read_valid(prb, next_seq, NULL);
-	if (retry && console_trylock())
+	if (retry && !abandon_console_lock_in_panic() && console_trylock())
 		goto again;
 }
 EXPORT_SYMBOL(console_unlock);
-- 
2.34.1

