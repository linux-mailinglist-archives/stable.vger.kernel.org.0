Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F7E6A7310
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCASMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCASMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:12:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3293B4AFE7
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFCDA6144F
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B00C433D2;
        Wed,  1 Mar 2023 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694332;
        bh=KHecUUfMefPZbkB5lscasoLHLCIIaq3jElsS3EtgwUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksou9u4gFkwwORyQ69IuTGV3lpC1LccBVYDipqgYzMPiMZIuY3mW3XGc4WUF1e6aZ
         20aOPHfoPiXB2B9/NPsKsKkDjaVP4JcrWJOM11KVLpdAyf3WWEdz8jCDkcghWPg3JZ
         e6DmlTDHbbWfP1IUAMOfg5NzZqQpgmw3Wf9b21UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 6.1 24/42] PM: sleep: Avoid using pr_cont() in the tasks freezing code
Date:   Wed,  1 Mar 2023 19:08:45 +0100
Message-Id: <20230301180658.122122337@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit a449dfbfc0894676ad0aa1873383265047529e3a upstream.

Using pr_cont() in the tasks freezing code related to system-wide
suspend and hibernation is problematic, because the continuation
messages printed there are susceptible to interspersing with other
unrelated messages which results in output that is hard to
understand.

Address this issue by modifying try_to_freeze_tasks() to print
messages that don't require continuations and adjusting its
callers accordingly.

Reported-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/process.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -27,6 +27,8 @@ unsigned int __read_mostly freeze_timeou
 
 static int try_to_freeze_tasks(bool user_only)
 {
+	const char *what = user_only ? "user space processes" :
+					"remaining freezable tasks";
 	struct task_struct *g, *p;
 	unsigned long end_time;
 	unsigned int todo;
@@ -36,6 +38,8 @@ static int try_to_freeze_tasks(bool user
 	bool wakeup = false;
 	int sleep_usecs = USEC_PER_MSEC;
 
+	pr_info("Freezing %s\n", what);
+
 	start = ktime_get_boottime();
 
 	end_time = jiffies + msecs_to_jiffies(freeze_timeout_msecs);
@@ -82,7 +86,6 @@ static int try_to_freeze_tasks(bool user
 	elapsed_msecs = ktime_to_ms(elapsed);
 
 	if (todo) {
-		pr_cont("\n");
 		pr_err("Freezing of tasks %s after %d.%03d seconds "
 		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
 		       wakeup ? "aborted" : "failed",
@@ -101,8 +104,8 @@ static int try_to_freeze_tasks(bool user
 			read_unlock(&tasklist_lock);
 		}
 	} else {
-		pr_cont("(elapsed %d.%03d seconds) ", elapsed_msecs / 1000,
-			elapsed_msecs % 1000);
+		pr_info("Freezing %s completed (elapsed %d.%03d seconds)\n",
+			what, elapsed_msecs / 1000, elapsed_msecs % 1000);
 	}
 
 	return todo ? -EBUSY : 0;
@@ -130,14 +133,11 @@ int freeze_processes(void)
 		static_branch_inc(&freezer_active);
 
 	pm_wakeup_clear(0);
-	pr_info("Freezing user space processes ... ");
 	pm_freezing = true;
 	error = try_to_freeze_tasks(true);
-	if (!error) {
+	if (!error)
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
-		pr_cont("done.");
-	}
-	pr_cont("\n");
+
 	BUG_ON(in_atomic());
 
 	/*
@@ -166,14 +166,9 @@ int freeze_kernel_threads(void)
 {
 	int error;
 
-	pr_info("Freezing remaining freezable tasks ... ");
-
 	pm_nosig_freezing = true;
 	error = try_to_freeze_tasks(false);
-	if (!error)
-		pr_cont("done.");
 
-	pr_cont("\n");
 	BUG_ON(in_atomic());
 
 	if (error)


