Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65907593791
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243778AbiHOSrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243863AbiHOSp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:45:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553BB31228;
        Mon, 15 Aug 2022 11:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94D38B81081;
        Mon, 15 Aug 2022 18:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDED5C433D6;
        Mon, 15 Aug 2022 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588059;
        bh=tncehYp3RIreavQFAJJmsSQ5PE2Xm9k9/Z+h64kWCsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fi7utdLG/NsolvOE1jLc7d6umBQP9jm8PVgmDkSLkD0taE0Fa9XVoZ7ymI9SAmKI0
         iBvPFCaD3ZrDfYz/xLxCkbxg/tFuGGz3D3GUrGeLvlL2iyNkDQC9+OTcRwFdPxiFxU
         r04+43Uhihqol+mNTEh3oYPtj8D8R1KboWEjqiwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/779] rcutorture: Warn on individual rcu_torture_init() error conditions
Date:   Mon, 15 Aug 2022 19:58:46 +0200
Message-Id: <20220815180349.367984790@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit efeff6b39b9de4480572c7b0c5eb77204795cb57 ]

When running rcutorture as a module, any rcu_torture_init() issues will be
reflected in the error code from modprobe or insmod, as the case may be.
However, these error codes are not available when running rcutorture
built-in, for example, when using the kvm.sh script.  This commit
therefore adds WARN_ON_ONCE() to allow distinguishing rcu_torture_init()
errors when running rcutorture built-in.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/torture.h |  8 ++++++++
 kernel/rcu/rcutorture.c | 30 +++++++++++++++---------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 0910c5803f35..24f58e50a94b 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -47,6 +47,14 @@ do {										\
 } while (0)
 void verbose_torout_sleep(void);
 
+#define torture_init_error(firsterr)						\
+({										\
+	int ___firsterr = (firsterr);						\
+										\
+	WARN_ONCE(!IS_MODULE(CONFIG_RCU_TORTURE_TEST) && ___firsterr < 0, "Torture-test initialization failed with error code %d\n", ___firsterr); \
+	___firsterr < 0;								\
+})
+
 /* Definitions for online/offline exerciser. */
 #ifdef CONFIG_HOTPLUG_CPU
 int torture_num_online_cpus(void);
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index f922937eb39a..c1b36c52e896 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -3066,7 +3066,7 @@ rcu_torture_init(void)
 	rcu_torture_write_types();
 	firsterr = torture_create_kthread(rcu_torture_writer, NULL,
 					  writer_task);
-	if (firsterr)
+	if (torture_init_error(firsterr))
 		goto unwind;
 	if (nfakewriters > 0) {
 		fakewriter_tasks = kcalloc(nfakewriters,
@@ -3081,7 +3081,7 @@ rcu_torture_init(void)
 	for (i = 0; i < nfakewriters; i++) {
 		firsterr = torture_create_kthread(rcu_torture_fakewriter,
 						  NULL, fakewriter_tasks[i]);
-		if (firsterr)
+		if (torture_init_error(firsterr))
 			goto unwind;
 	}
 	reader_tasks = kcalloc(nrealreaders, sizeof(reader_tasks[0]),
@@ -3097,7 +3097,7 @@ rcu_torture_init(void)
 		rcu_torture_reader_mbchk[i].rtc_chkrdr = -1;
 		firsterr = torture_create_kthread(rcu_torture_reader, (void *)i,
 						  reader_tasks[i]);
-		if (firsterr)
+		if (torture_init_error(firsterr))
 			goto unwind;
 	}
 	nrealnocbers = nocbs_nthreads;
@@ -3117,18 +3117,18 @@ rcu_torture_init(void)
 	}
 	for (i = 0; i < nrealnocbers; i++) {
 		firsterr = torture_create_kthread(rcu_nocb_toggle, NULL, nocb_tasks[i]);
-		if (firsterr)
+		if (torture_init_error(firsterr))
 			goto unwind;
 	}
 	if (stat_interval > 0) {
 		firsterr = torture_create_kthread(rcu_torture_stats, NULL,
 						  stats_task);
-		if (firsterr)
+		if (torture_init_error(firsterr))
 			goto unwind;
 	}
 	if (test_no_idle_hz && shuffle_interval > 0) {
 		firsterr = torture_shuffle_init(shuffle_interval * HZ);
-		if (firsterr)
+		if (torture_init_error(firsterr))
 			goto unwind;
 	}
 	if (stutter < 0)
@@ -3138,7 +3138,7 @@ rcu_torture_init(void)
 
 		t = cur_ops->stall_dur ? cur_ops->stall_dur() : stutter * HZ;
 		firsterr = torture_stutter_init(stutter * HZ, t);
-		if (firsterr)
+		if (torture_init_error(firsterr))
 			goto unwind;
 	}
 	if (fqs_duration < 0)
@@ -3147,7 +3147,7 @@ rcu_torture_init(void)
 		/* Create the fqs thread */
 		firsterr = torture_create_kthread(rcu_torture_fqs, NULL,
 						  fqs_task);
-		if (firsterr)
+		if (torture_init_error(firsterr))
 			goto unwind;
 	}
 	if (test_boost_interval < 1)
@@ -3161,7 +3161,7 @@ rcu_torture_init(void)
 		firsterr = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "RCU_TORTURE",
 					     rcutorture_booster_init,
 					     rcutorture_booster_cleanup);
-		if (firsterr < 0)
+		if (torture_init_error(firsterr))
 			goto unwind;
 		rcutor_hp = firsterr;
 
@@ -3182,23 +3182,23 @@ rcu_torture_init(void)
 	}
 	shutdown_jiffies = jiffies + shutdown_secs * HZ;
 	firsterr = torture_shutdown_init(shutdown_secs, rcu_torture_cleanup);
-	if (firsterr)
+	if (torture_init_error(firsterr))
 		goto unwind;
 	firsterr = torture_onoff_init(onoff_holdoff * HZ, onoff_interval,
 				      rcutorture_sync);
-	if (firsterr)
+	if (torture_init_error(firsterr))
 		goto unwind;
 	firsterr = rcu_torture_stall_init();
-	if (firsterr)
+	if (torture_init_error(firsterr))
 		goto unwind;
 	firsterr = rcu_torture_fwd_prog_init();
-	if (firsterr)
+	if (torture_init_error(firsterr))
 		goto unwind;
 	firsterr = rcu_torture_barrier_init();
-	if (firsterr)
+	if (torture_init_error(firsterr))
 		goto unwind;
 	firsterr = rcu_torture_read_exit_init();
-	if (firsterr)
+	if (torture_init_error(firsterr))
 		goto unwind;
 	if (object_debug)
 		rcu_test_debug_objects();
-- 
2.35.1



