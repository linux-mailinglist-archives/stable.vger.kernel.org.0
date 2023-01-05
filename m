Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2395D65E1F6
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 01:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjAEAt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 19:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjAEAtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 19:49:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B4E4A1B9;
        Wed,  4 Jan 2023 16:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73C2D618A6;
        Thu,  5 Jan 2023 00:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF63C433AF;
        Thu,  5 Jan 2023 00:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672879503;
        bh=ZC44hmsWKq5LKstc1mABPFNWTm5UBg7AJtRBZoxlpu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnU+YhqiP1tuA8VdokEYO92/3U9BeI9W4Dq0q5h2Y5iyZS8lJqsEQ5XDnI7IniHBM
         +lRNnJrEkC93tVEJGwBiYxtskaDx3eoGzMHV4kJK4IBmvaztAoeZtX6B9OvC0xISIz
         BmX+CT7rWKYDK2b/16XpgMwXXf3CIwK2M7En8autzrkgHOfOI1AXBxUkzwCY+3UrHm
         USk+XnACWyK3SIP2l5ncBK98nB6LH8xJ6JIIZi/t04uUgtrhxhNX9xHzpEDtB39oOF
         em/unGNy0NyN6b9rgXJ6H5jgfrKjPEdTSxbNUCayuFeR6/BwnPxf+H86SSrs1c0QXY
         jJi03WbVTaFZA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id F05205C1C89; Wed,  4 Jan 2023 16:45:02 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH rcu 7/7] torture: Fix hang during kthread shutdown phase
Date:   Wed,  4 Jan 2023 16:45:01 -0800
Message-Id: <20230105004501.1771332-13-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230105004454.GA1771168@paulmck-ThinkPad-P17-Gen-1>
References: <20230105004454.GA1771168@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

During rcutorture shutdown, the rcu_torture_cleanup() function calls
torture_cleanup_begin(), which sets the fullstop global variable to
FULLSTOP_RMMOD. This causes the rcutorture threads for readers and
fakewriters to exit all of their "while" loops and start shutting down.

They then call torture_kthread_stopping(), which in turn waits for
kthread_stop() to be called.  However, rcu_torture_cleanup() has
not yet called kthread_stop() on those threads, and before it gets a
chance to do so, multiple instances of torture_kthread_stopping() invoke
schedule_timeout_interruptible(1) in a tight loop.  Tracing confirms that
TIMER_SOFTIRQ can then continuously execute timer callbacks.  If that
TIMER_SOFTIRQ preempts the task executing rcu_torture_cleanup(), that
task might never invoke kthread_stop().

This commit improves this situation by increasing the timeout passed to
schedule_timeout_interruptible() from one jiffy to 1/20th of a second.
This change prevents TIMER_SOFTIRQ from monopolizing its CPU, thus
allowing rcu_torture_cleanup() to carry out the needed kthread_stop()
invocations.  Testing has shown 100 runs of TREE07 passing reliably,
as oppose to the tens-of-percent failure rates seen beforehand.

Cc: Paul McKenney <paulmck@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/torture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index 29afc62f2bfec..1a0519b836ac9 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -915,7 +915,7 @@ void torture_kthread_stopping(char *title)
 	VERBOSE_TOROUT_STRING(buf);
 	while (!kthread_should_stop()) {
 		torture_shutdown_absorb(title);
-		schedule_timeout_uninterruptible(1);
+		schedule_timeout_uninterruptible(HZ / 20);
 	}
 }
 EXPORT_SYMBOL_GPL(torture_kthread_stopping);
-- 
2.31.1.189.g2e36527f23

