Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6C020186C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388010AbgFSOjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388008AbgFSOjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:39:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A58208B8;
        Fri, 19 Jun 2020 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577554;
        bh=lC9ferR9X4gmT4FMRJp5dYkyPXSIP4zs76hVyxo4wis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPIeDqwYgBNLf4LlATcqq3Cu7nAzeo0PXBJC48jS39q1SZ37utbuEP6MTsio8eiGK
         /I3OJqncCnAEVhWeNkK1GGgof9YEXmZDbNfZvh7+x9fUC7Z6SVNzUUTAGoKlnrVJNq
         OOBkTA8tDDess05Irw5+zrkiuhWpLE1weamLzQk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 095/101] drivers/macintosh: Fix memleak in windfarm_pm112 driver
Date:   Fri, 19 Jun 2020 16:33:24 +0200
Message-Id: <20200619141618.939716511@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 93900337b9ac2f4eca427eff6d187be2dc3b5551 upstream.

create_cpu_loop() calls smu_sat_get_sdb_partition() which does
kmalloc() and returns the allocated buffer. In fact it's called twice,
and neither buffer is freed.

This results in a memory leak as reported by Erhard:
  unreferenced object 0xc00000047081f840 (size 32):
    comm "kwindfarm", pid 203, jiffies 4294880630 (age 5552.877s)
    hex dump (first 32 bytes):
      c8 06 02 7f ff 02 ff 01 fb bf 00 41 00 20 00 00  ...........A. ..
      00 07 89 37 00 a0 00 00 00 00 00 00 00 00 00 00  ...7............
    backtrace:
      [<0000000083f0a65c>] .smu_sat_get_sdb_partition+0xc4/0x2d0 [windfarm_smu_sat]
      [<000000003010fcb7>] .pm112_wf_notify+0x104c/0x13bc [windfarm_pm112]
      [<00000000b958b2dd>] .notifier_call_chain+0xa8/0x180
      [<0000000070490868>] .blocking_notifier_call_chain+0x64/0x90
      [<00000000131d8149>] .wf_thread_func+0x114/0x1a0
      [<000000000d54838d>] .kthread+0x13c/0x190
      [<00000000669b72bc>] .ret_from_kernel_thread+0x58/0x64
  unreferenced object 0xc0000004737089f0 (size 16):
    comm "kwindfarm", pid 203, jiffies 4294880879 (age 5552.050s)
    hex dump (first 16 bytes):
      c4 04 01 7f 22 11 e0 e6 ff 55 7b 12 ec 11 00 00  ...."....U{.....
    backtrace:
      [<0000000083f0a65c>] .smu_sat_get_sdb_partition+0xc4/0x2d0 [windfarm_smu_sat]
      [<00000000b94ef7e1>] .pm112_wf_notify+0x1294/0x13bc [windfarm_pm112]
      [<00000000b958b2dd>] .notifier_call_chain+0xa8/0x180
      [<0000000070490868>] .blocking_notifier_call_chain+0x64/0x90
      [<00000000131d8149>] .wf_thread_func+0x114/0x1a0
      [<000000000d54838d>] .kthread+0x13c/0x190
      [<00000000669b72bc>] .ret_from_kernel_thread+0x58/0x64

Fix it by rearranging the logic so we deal with each buffer
separately, which then makes it easy to free the buffer once we're
done with it.

Fixes: ac171c46667c ("[PATCH] powerpc: Thermal control for dual core G5s")
Cc: stable@vger.kernel.org # v2.6.16+
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Erhard F. <erhard_f@mailbox.org>
Link: https://lore.kernel.org/r/20200423060038.3308530-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/macintosh/windfarm_pm112.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/macintosh/windfarm_pm112.c
+++ b/drivers/macintosh/windfarm_pm112.c
@@ -133,14 +133,6 @@ static int create_cpu_loop(int cpu)
 	s32 tmax;
 	int fmin;
 
-	/* Get PID params from the appropriate SAT */
-	hdr = smu_sat_get_sdb_partition(chip, 0xC8 + core, NULL);
-	if (hdr == NULL) {
-		printk(KERN_WARNING"windfarm: can't get CPU PID fan config\n");
-		return -EINVAL;
-	}
-	piddata = (struct smu_sdbp_cpupiddata *)&hdr[1];
-
 	/* Get FVT params to get Tmax; if not found, assume default */
 	hdr = smu_sat_get_sdb_partition(chip, 0xC4 + core, NULL);
 	if (hdr) {
@@ -153,6 +145,16 @@ static int create_cpu_loop(int cpu)
 	if (tmax < cpu_all_tmax)
 		cpu_all_tmax = tmax;
 
+	kfree(hdr);
+
+	/* Get PID params from the appropriate SAT */
+	hdr = smu_sat_get_sdb_partition(chip, 0xC8 + core, NULL);
+	if (hdr == NULL) {
+		printk(KERN_WARNING"windfarm: can't get CPU PID fan config\n");
+		return -EINVAL;
+	}
+	piddata = (struct smu_sdbp_cpupiddata *)&hdr[1];
+
 	/*
 	 * Darwin has a minimum fan speed of 1000 rpm for the 4-way and
 	 * 515 for the 2-way.  That appears to be overkill, so for now,
@@ -175,6 +177,9 @@ static int create_cpu_loop(int cpu)
 		pid.min = fmin;
 
 	wf_cpu_pid_init(&cpu_pid[cpu], &pid);
+
+	kfree(hdr);
+
 	return 0;
 }
 


