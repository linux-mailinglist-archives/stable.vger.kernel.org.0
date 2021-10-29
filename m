Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D6743FE56
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJ2OXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:23:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36388 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJ2OXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 10:23:21 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AD8A421637;
        Fri, 29 Oct 2021 14:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635517251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7R9uA+LpPYmFjie5UDdlkOgIald16ENiSYZa7Y+izN4=;
        b=ajMXA7qP6da3jX2Lm8M8CmYif0cqYQtFZQBtUQ002zP1AGAbtipFTgPOVK1RnrkII7LzBb
        tM7maZ3GATqAG8qvot2qHhjqjoN9COaeWLvLkXnOh5kRnuZSUM3HwtrsKR5eTu1LvDm/cz
        byovVaNLPy0slzzddwVYvSWiszt8ozM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 777CD13F6F;
        Fri, 29 Oct 2021 14:20:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QGDIG0MDfGFxMwAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 29 Oct 2021 14:20:51 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH v3] xen/balloon: add late_initcall_sync() for initial ballooning done
Date:   Fri, 29 Oct 2021 16:20:49 +0200
Message-Id: <20211029142049.25198-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running as PVH or HVM guest with actual memory < max memory the
hypervisor is using "populate on demand" in order to allow the guest
to balloon down from its maximum memory size. For this to work
correctly the guest must not touch more memory pages than its target
memory size as otherwise the PoD cache will be exhausted and the guest
is crashed as a result of that.

In extreme cases ballooning down might not be finished today before
the init process is started, which can consume lots of memory.

In order to avoid random boot crashes in such cases, add a late init
call to wait for ballooning down having finished for PVH/HVM guests.

Warn on console if initial ballooning fails, panic() after stalling
for more than 3 minutes per default. Add a module parameter for
changing this timeout.

Cc: <stable@vger.kernel.org>
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- add warning and panic() when stalling (Marek Marczykowski-Górecki)
- don't wait if credit > 0
V3:
- issue warning only after ballooning failed (Marek Marczykowski-Górecki)
- make panic() timeout configurable via parameter
---
 .../stable/sysfs-devices-system-xen_memory    | 10 +++
 drivers/xen/balloon.c                         | 63 +++++++++++++++----
 drivers/xen/xen-balloon.c                     |  2 +
 include/xen/balloon.h                         |  1 +
 4 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-system-xen_memory b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
index 6d83f95a8a8e..2da062e2c94a 100644
--- a/Documentation/ABI/stable/sysfs-devices-system-xen_memory
+++ b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
@@ -84,3 +84,13 @@ Description:
 		Control scrubbing pages before returning them to Xen for others domains
 		use. Can be set with xen_scrub_pages cmdline
 		parameter. Default value controlled with CONFIG_XEN_SCRUB_PAGES_DEFAULT.
+
+What:		/sys/devices/system/xen_memory/xen_memory0/boot_timeout
+Date:		November 2021
+KernelVersion:	5.16
+Contact:	xen-devel@lists.xenproject.org
+Description:
+		The time (in seconds) to wait before giving up to boot in case
+		initial ballooning fails to free enough memory. Applies only
+		when running as HVM or PVH guest and started with less memory
+		configured than allowed at max.
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 3a50f097ed3e..98fae43d4cec 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -125,12 +125,12 @@ static struct ctl_table xen_root[] = {
  * BP_ECANCELED: error, balloon operation canceled.
  */
 
-enum bp_state {
+static enum bp_state {
 	BP_DONE,
 	BP_WAIT,
 	BP_EAGAIN,
 	BP_ECANCELED
-};
+} balloon_state = BP_DONE;
 
 /* Main waiting point for xen-balloon thread. */
 static DECLARE_WAIT_QUEUE_HEAD(balloon_thread_wq);
@@ -494,9 +494,9 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
  * Stop waiting if either state is BP_DONE and ballooning action is
  * needed, or if the credit has changed while state is not BP_DONE.
  */
-static bool balloon_thread_cond(enum bp_state state, long credit)
+static bool balloon_thread_cond(long credit)
 {
-	if (state == BP_DONE)
+	if (balloon_state == BP_DONE)
 		credit = 0;
 
 	return current_credit() != credit || kthread_should_stop();
@@ -510,13 +510,12 @@ static bool balloon_thread_cond(enum bp_state state, long credit)
  */
 static int balloon_thread(void *unused)
 {
-	enum bp_state state = BP_DONE;
 	long credit;
 	unsigned long timeout;
 
 	set_freezable();
 	for (;;) {
-		switch (state) {
+		switch (balloon_state) {
 		case BP_DONE:
 		case BP_ECANCELED:
 			timeout = 3600 * HZ;
@@ -532,7 +531,7 @@ static int balloon_thread(void *unused)
 		credit = current_credit();
 
 		wait_event_freezable_timeout(balloon_thread_wq,
-			balloon_thread_cond(state, credit), timeout);
+			balloon_thread_cond(credit), timeout);
 
 		if (kthread_should_stop())
 			return 0;
@@ -543,22 +542,23 @@ static int balloon_thread(void *unused)
 
 		if (credit > 0) {
 			if (balloon_is_inflated())
-				state = increase_reservation(credit);
+				balloon_state = increase_reservation(credit);
 			else
-				state = reserve_additional_memory();
+				balloon_state = reserve_additional_memory();
 		}
 
 		if (credit < 0) {
 			long n_pages;
 
 			n_pages = min(-credit, si_mem_available());
-			state = decrease_reservation(n_pages, GFP_BALLOON);
-			if (state == BP_DONE && n_pages != -credit &&
+			balloon_state = decrease_reservation(n_pages,
+							     GFP_BALLOON);
+			if (balloon_state == BP_DONE && n_pages != -credit &&
 			    n_pages < totalreserve_pages)
-				state = BP_EAGAIN;
+				balloon_state = BP_EAGAIN;
 		}
 
-		state = update_schedule(state);
+		balloon_state = update_schedule(balloon_state);
 
 		mutex_unlock(&balloon_mutex);
 
@@ -731,6 +731,7 @@ static int __init balloon_init(void)
 	balloon_stats.max_schedule_delay = 32;
 	balloon_stats.retry_count = 1;
 	balloon_stats.max_retry_count = 4;
+	balloon_stats.boot_timeout = 180;
 
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	set_online_page_callback(&xen_online_page);
@@ -765,3 +766,39 @@ static int __init balloon_init(void)
 	return 0;
 }
 subsys_initcall(balloon_init);
+
+static int __init balloon_wait_finish(void)
+{
+	long credit, last_credit = 0;
+	unsigned long last_changed;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	/* PV guests don't need to wait. */
+	if (xen_pv_domain() || !current_credit())
+		return 0;
+
+	pr_info("Waiting for initial ballooning down having finished.\n");
+
+	while ((credit = current_credit()) < 0) {
+		if (credit != last_credit) {
+			last_changed = jiffies;
+			last_credit = credit;
+		}
+		if (balloon_state == BP_ECANCELED) {
+			pr_warn_once("Initial ballooning failed, %ld pages need to be freed.\n",
+				     -credit);
+			if (jiffies - last_changed >=
+			    HZ * balloon_stats.boot_timeout)
+				panic("Initial ballooning failed!\n");
+		}
+
+		schedule_timeout_interruptible(HZ / 10);
+	}
+
+	pr_info("Initial ballooning down finished.\n");
+
+	return 0;
+}
+late_initcall_sync(balloon_wait_finish);
diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
index 8cd583db20b1..6e5db50ede0f 100644
--- a/drivers/xen/xen-balloon.c
+++ b/drivers/xen/xen-balloon.c
@@ -150,6 +150,7 @@ static DEVICE_ULONG_ATTR(schedule_delay, 0444, balloon_stats.schedule_delay);
 static DEVICE_ULONG_ATTR(max_schedule_delay, 0644, balloon_stats.max_schedule_delay);
 static DEVICE_ULONG_ATTR(retry_count, 0444, balloon_stats.retry_count);
 static DEVICE_ULONG_ATTR(max_retry_count, 0644, balloon_stats.max_retry_count);
+static DEVICE_ULONG_ATTR(boot_timeout, 0644, balloon_stats.boot_timeout);
 static DEVICE_BOOL_ATTR(scrub_pages, 0644, xen_scrub_pages);
 
 static ssize_t target_kb_show(struct device *dev, struct device_attribute *attr,
@@ -211,6 +212,7 @@ static struct attribute *balloon_attrs[] = {
 	&dev_attr_max_schedule_delay.attr.attr,
 	&dev_attr_retry_count.attr.attr,
 	&dev_attr_max_retry_count.attr.attr,
+	&dev_attr_boot_timeout.attr.attr,
 	&dev_attr_scrub_pages.attr.attr,
 	NULL
 };
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index 6dbdb0b3fd03..95a4187f263b 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -20,6 +20,7 @@ struct balloon_stats {
 	unsigned long max_schedule_delay;
 	unsigned long retry_count;
 	unsigned long max_retry_count;
+	unsigned long boot_timeout;
 };
 
 extern struct balloon_stats balloon_stats;
-- 
2.26.2

