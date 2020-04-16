Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE751AC944
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390811AbgDPPVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898627AbgDPNqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:46:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F5C208E4;
        Thu, 16 Apr 2020 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044806;
        bh=YvEO37qKCjWeczjWU6192GteB1w/O74tNl8rInnF+to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1nj8Rdabzv399htP5Gu8MUs/8t2uTpLWzogsQz8V33OpEtbXo5GEy0DdOrBSu61+
         PYkUdAt0JvuEvzYz/rfgqdbs5ijfqq/ZrHmapQE5ZLQimgA9xLwZ9Y+gPW88WtC2Sh
         A+VEYXApTRyBSrLf2d01FGnkZUHBpasgrFXYiDMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCH 5.4 109/232] cpu/hotplug: Ignore pm_wakeup_pending() for disable_nonboot_cpus()
Date:   Thu, 16 Apr 2020 15:23:23 +0200
Message-Id: <20200416131328.777564526@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit e98eac6ff1b45e4e73f2e6031b37c256ccb5d36b upstream.

A recent change to freeze_secondary_cpus() which added an early abort if a
wakeup is pending missed the fact that the function is also invoked for
shutdown, reboot and kexec via disable_nonboot_cpus().

In case of disable_nonboot_cpus() the wakeup event needs to be ignored as
the purpose is to terminate the currently running kernel.

Add a 'suspend' argument which is only set when the freeze is in context of
a suspend operation. If not set then an eventually pending wakeup event is
ignored.

Fixes: a66d955e910a ("cpu/hotplug: Abort disabling secondary CPUs if wakeup is pending")
Reported-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/874kuaxdiz.fsf@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cpu.h |   12 +++++++++---
 kernel/cpu.c        |    4 ++--
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -138,12 +138,18 @@ static inline void get_online_cpus(void)
 static inline void put_online_cpus(void) { cpus_read_unlock(); }
 
 #ifdef CONFIG_PM_SLEEP_SMP
-extern int freeze_secondary_cpus(int primary);
+int __freeze_secondary_cpus(int primary, bool suspend);
+static inline int freeze_secondary_cpus(int primary)
+{
+	return __freeze_secondary_cpus(primary, true);
+}
+
 static inline int disable_nonboot_cpus(void)
 {
-	return freeze_secondary_cpus(0);
+	return __freeze_secondary_cpus(0, false);
 }
-extern void enable_nonboot_cpus(void);
+
+void enable_nonboot_cpus(void);
 
 static inline int suspend_disable_secondary_cpus(void)
 {
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1212,7 +1212,7 @@ EXPORT_SYMBOL_GPL(cpu_up);
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
 
-int freeze_secondary_cpus(int primary)
+int __freeze_secondary_cpus(int primary, bool suspend)
 {
 	int cpu, error = 0;
 
@@ -1237,7 +1237,7 @@ int freeze_secondary_cpus(int primary)
 		if (cpu == primary)
 			continue;
 
-		if (pm_wakeup_pending()) {
+		if (suspend && pm_wakeup_pending()) {
 			pr_info("Wakeup pending. Abort CPU freeze\n");
 			error = -EBUSY;
 			break;


