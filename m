Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4864EC06C
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343962AbiC3LvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344054AbiC3LuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED4126E57A;
        Wed, 30 Mar 2022 04:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C8E061640;
        Wed, 30 Mar 2022 11:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB445C3410F;
        Wed, 30 Mar 2022 11:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640857;
        bh=TzG0HYbJE5ho7Q6C9mjjowcE4QBfxtGF5O9CptascjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZTz1r3yCD1kz8yQ9vMUEv48xdjbH5NINWKo+cqI6B7YvfXgmxLw8vGX9Wp635Oi8
         0rqdHOl28kIldv11JKCsAWO6zwBx1I/tShqeAUJCA1iwXKPytYENgHHGLnmKWQyOlD
         z/CkvWkwx/ikYxGcOdqJcoWiyUyqN1zE+L1roPczKsMCvuTzDlLzPXvIyAhdfwGhb9
         w9Aic7xDoaC6vVY5OVpr29kYjxoSETohkucbntkrBKHQSGwj83h5IaC0i8MYMpRSRv
         nBmHQuBwwcF371v0dvKMNvO6yH9Powc3tM3npJnk2eQsMs5KRn2T1V+68mMGxhUZwA
         qwRjH+3ZnSzzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Brennan <stephen.s.brennan@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux@roeck-us.net,
        gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 5.17 33/66] printk: Drop console_sem during panic
Date:   Wed, 30 Mar 2022 07:46:12 -0400
Message-Id: <20220330114646.1669334-33-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
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
index 4f31290256ad..bc5cbdeb38f3 100644
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

