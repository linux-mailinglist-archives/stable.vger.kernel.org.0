Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FF16505BD
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 00:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiLRXoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 18:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLRXoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 18:44:37 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5AD63DD;
        Sun, 18 Dec 2022 15:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pM745wdQur5+R/jYHQA2I3LWyyZHcYT8xDsenki1WaM=; b=JctGwSaT6jMGcCxUXqh7rIwI2w
        izGTgfStRrSQAXNli8SvNdz3l7NL8kdl0uVDDlgDHwwJRaDj+VeJyYA6AJy7ueDb5lMqIzspvU/WE
        VX4dAFGBWseYkGJx1lr7rXHSu7yQL22EnjOSQCMnyCiX7hIWswFqPl2Jack3a3LWb0sFCdMeu3qhw
        ygIaWDEBSw04G3Sx1rfrf3omrg7AahQstZkMZ2VJxPvHvGqdYaJyy8eB6xgr1gsYI26KUJ+nJXClA
        LpJSUYkmCagfJIE9ZODmypRn7J/eNoVB1LLXsrLzJIGxQh7WghoikkwNWDWs67apotXFSVLk5lnEX
        PEd4pq+Q==;
Received: from 200-158-226-94.dsl.telesp.net.br ([200.158.226.94] helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1p73KU-005szJ-4o; Mon, 19 Dec 2022 00:44:26 +0100
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        kernel-dev@igalia.com, kernel@gpiccoli.net, fenghua.yu@intel.com,
        joshua@froggi.es, pgofman@codeweavers.com, pavel@denx.de,
        pgriffais@valvesoftware.com, zfigura@codeweavers.com,
        cristian.ciocaltea@collabora.com,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andre Almeida <andrealmeid@igalia.com>
Subject: [PATCH 6.0.y / 6.1.y] x86/split_lock: Add sysctl to control the misery mode
Date:   Sun, 18 Dec 2022 20:44:00 -0300
Message-Id: <20221218234400.795055-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 727209376f4998bc84db1d5d8af15afea846a92b upstream.

Commit b041b525dab9 ("x86/split_lock: Make life miserable for split lockers")
changed the way the split lock detector works when in "warn" mode;
basically, it not only shows the warn message, but also intentionally
introduces a slowdown through sleeping plus serialization mechanism
on such task. Based on discussions in [0], seems the warning alone
wasn't enough motivation for userspace developers to fix their
applications.

This slowdown is enough to totally break some proprietary (aka.
unfixable) userspace[1].

Happens that originally the proposal in [0] was to add a new mode
which would warns + slowdown the "split locking" task, keeping the
old warn mode untouched. In the end, that idea was discarded and
the regular/default "warn" mode now slows down the applications. This
is quite aggressive with regards proprietary/legacy programs that
basically are unable to properly run in kernel with this change.
While it is understandable that a malicious application could DoS
by split locking, it seems unacceptable to regress old/proprietary
userspace programs through a default configuration that previously
worked. An example of such breakage was reported in [1].

Add a sysctl to allow controlling the "misery mode" behavior, as per
Thomas suggestion on [2]. This way, users running legacy and/or
proprietary software are allowed to still execute them with a decent
performance while still observing the warning messages on kernel log.

[0] https://lore.kernel.org/lkml/20220217012721.9694-1-tony.luck@intel.com/
[1] https://github.com/doitsujin/dxvk/issues/2938
[2] https://lore.kernel.org/lkml/87pmf4bter.ffs@tglx/

[ dhansen: minor changelog tweaks, including clarifying the actual
  	   problem ]

Fixes: b041b525dab9 ("x86/split_lock: Make life miserable for split lockers")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Andre Almeida <andrealmeid@igalia.com>
Link: https://lore.kernel.org/all/20221024200254.635256-1-gpiccoli%40igalia.com
---


Hi folks, I've build tested this on both 6.0.13 and 6.1, worked fine. The
split lock detector code changed almost nothing since 6.0, so that makes
sense...

I think this is important to have in stable, some gaming community members
seems excited with that, it'll help with general proprietary software
(that is basically unfixable), making them run smoothly on 6.0.y and 6.1.y.

I've CCed some folks more than just the stable list, to gather more
opinions on that, so apologies if you received this email but think
that you shouldn't have.

Thanks in advance,

Guilherme


 Documentation/admin-guide/sysctl/kernel.rst | 23 ++++++++
 arch/x86/kernel/cpu/intel.c                 | 63 +++++++++++++++++----
 2 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 98d1b198b2b4..c2c64c1b706f 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1314,6 +1314,29 @@ watchdog work to be queued by the watchdog timer function, otherwise the NMI
 watchdog — if enabled — can detect a hard lockup condition.
 
 
+split_lock_mitigate (x86 only)
+==============================
+
+On x86, each "split lock" imposes a system-wide performance penalty. On larger
+systems, large numbers of split locks from unprivileged users can result in
+denials of service to well-behaved and potentially more important users.
+
+The kernel mitigates these bad users by detecting split locks and imposing
+penalties: forcing them to wait and only allowing one core to execute split
+locks at a time.
+
+These mitigations can make those bad applications unbearably slow. Setting
+split_lock_mitigate=0 may restore some application performance, but will also
+increase system exposure to denial of service attacks from split lock users.
+
+= ===================================================================
+0 Disable the mitigation mode - just warns the split lock on kernel log
+  and exposes the system to denials of service from the split lockers.
+1 Enable the mitigation mode (this is the default) - penalizes the split
+  lockers with intentional performance degradation.
+= ===================================================================
+
+
 stack_erasing
 =============
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2d7ea5480ec3..427899650483 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1034,8 +1034,32 @@ static const struct {
 
 static struct ratelimit_state bld_ratelimit;
 
+static unsigned int sysctl_sld_mitigate = 1;
 static DEFINE_SEMAPHORE(buslock_sem);
 
+#ifdef CONFIG_PROC_SYSCTL
+static struct ctl_table sld_sysctls[] = {
+	{
+		.procname       = "split_lock_mitigate",
+		.data           = &sysctl_sld_mitigate,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{}
+};
+
+static int __init sld_mitigate_sysctl_init(void)
+{
+	register_sysctl_init("kernel", sld_sysctls);
+	return 0;
+}
+
+late_initcall(sld_mitigate_sysctl_init);
+#endif
+
 static inline bool match_option(const char *arg, int arglen, const char *opt)
 {
 	int len = strlen(opt), ratelimit;
@@ -1146,12 +1170,20 @@ static void split_lock_init(void)
 		split_lock_verify_msr(sld_state != sld_off);
 }
 
-static void __split_lock_reenable(struct work_struct *work)
+static void __split_lock_reenable_unlock(struct work_struct *work)
 {
 	sld_update_msr(true);
 	up(&buslock_sem);
 }
 
+static DECLARE_DELAYED_WORK(sl_reenable_unlock, __split_lock_reenable_unlock);
+
+static void __split_lock_reenable(struct work_struct *work)
+{
+	sld_update_msr(true);
+}
+static DECLARE_DELAYED_WORK(sl_reenable, __split_lock_reenable);
+
 /*
  * If a CPU goes offline with pending delayed work to re-enable split lock
  * detection then the delayed work will be executed on some other CPU. That
@@ -1169,10 +1201,9 @@ static int splitlock_cpu_offline(unsigned int cpu)
 	return 0;
 }
 
-static DECLARE_DELAYED_WORK(split_lock_reenable, __split_lock_reenable);
-
 static void split_lock_warn(unsigned long ip)
 {
+	struct delayed_work *work;
 	int cpu;
 
 	if (!current->reported_split_lock)
@@ -1180,14 +1211,26 @@ static void split_lock_warn(unsigned long ip)
 				    current->comm, current->pid, ip);
 	current->reported_split_lock = 1;
 
-	/* misery factor #1, sleep 10ms before trying to execute split lock */
-	if (msleep_interruptible(10) > 0)
-		return;
-	/* Misery factor #2, only allow one buslocked disabled core at a time */
-	if (down_interruptible(&buslock_sem) == -EINTR)
-		return;
+	if (sysctl_sld_mitigate) {
+		/*
+		 * misery factor #1:
+		 * sleep 10ms before trying to execute split lock.
+		 */
+		if (msleep_interruptible(10) > 0)
+			return;
+		/*
+		 * Misery factor #2:
+		 * only allow one buslocked disabled core at a time.
+		 */
+		if (down_interruptible(&buslock_sem) == -EINTR)
+			return;
+		work = &sl_reenable_unlock;
+	} else {
+		work = &sl_reenable;
+	}
+
 	cpu = get_cpu();
-	schedule_delayed_work_on(cpu, &split_lock_reenable, 2);
+	schedule_delayed_work_on(cpu, work, 2);
 
 	/* Disable split lock detection on this CPU to make progress */
 	sld_update_msr(false);
-- 
2.38.1

