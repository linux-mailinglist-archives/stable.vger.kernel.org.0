Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C52A56EB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbgKCVcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731622AbgKCU5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBC332053B;
        Tue,  3 Nov 2020 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437039;
        bh=K0R6uZJyW3odJVW6cimPpaFKkHg7qGdEuzBEtdNOCz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTgrWTbUgSaiZMrrytx6fF1htfaXwPVWcFcbhDxtklfFaNOW2dxqWRWlbbxXhnv/p
         BXMjHTHYEBvAga39dQLWS6joO5nutHStZq3hlZJB1AnYkO/hN5TXe3TxrY5KgZZ4U3
         d41n/LSqkiH2ir5PmyG1tWTPq/7rUQsHU1GdoGQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Jamie Iles <jamie@nuviainc.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 113/214] ACPI: debug: dont allow debugging when ACPI is disabled
Date:   Tue,  3 Nov 2020 21:36:01 +0100
Message-Id: <20201103203301.485943176@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>

commit 0fada277147ffc6d694aa32162f51198d4f10d94 upstream.

If ACPI is disabled then loading the acpi_dbg module will result in the
following splat when lock debugging is enabled.

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: CPU: 0 PID: 1 at kernel/locking/mutex.c:938 __mutex_lock+0xa10/0x1290
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc8+ #103
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   dump_backtrace+0x0/0x4d8
   show_stack+0x34/0x48
   dump_stack+0x174/0x1f8
   panic+0x360/0x7a0
   __warn+0x244/0x2ec
   report_bug+0x240/0x398
   bug_handler+0x50/0xc0
   call_break_hook+0x160/0x1d8
   brk_handler+0x30/0xc0
   do_debug_exception+0x184/0x340
   el1_dbg+0x48/0xb0
   el1_sync_handler+0x170/0x1c8
   el1_sync+0x80/0x100
   __mutex_lock+0xa10/0x1290
   mutex_lock_nested+0x6c/0xc0
   acpi_register_debugger+0x40/0x88
   acpi_aml_init+0xc4/0x114
   do_one_initcall+0x24c/0xb10
   kernel_init_freeable+0x690/0x728
   kernel_init+0x20/0x1e8
   ret_from_fork+0x10/0x18

This is because acpi_debugger.lock has not been initialized as
acpi_debugger_init() is not called when ACPI is disabled.  Fail module
loading to avoid this and any subsequent problems that might arise by
trying to debug AML when ACPI is disabled.

Fixes: 8cfb0cdf07e2 ("ACPI / debugger: Add IO interface to access debugger functionalities")
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_dbg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/acpi_dbg.c
+++ b/drivers/acpi/acpi_dbg.c
@@ -749,6 +749,9 @@ int __init acpi_aml_init(void)
 {
 	int ret;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	/* Initialize AML IO interface */
 	mutex_init(&acpi_aml_io.lock);
 	init_waitqueue_head(&acpi_aml_io.wait);


