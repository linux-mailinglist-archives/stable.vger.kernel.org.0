Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC09E4DDF
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394810AbfJYN5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502373AbfJYN5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28CDC222C4;
        Fri, 25 Oct 2019 13:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011829;
        bh=zeqYmL5GoaVYe5Q3NXD8KEAQqOx4fkn4rH1/8+vbsF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYQlufbZmOfkqYd7De4EcI2wn5WlWcHvwjBbPmiPnWKCwERPFxNzC3IVG6H1Y0O+J
         EoIAhprKZd3V5weNQODotRZGLP901bxtwNsdZOj8jcXNLFf2DJKTMNEjJcy0TkE9v4
         PeEIuAptOw+BDVyuUcA6ITqiME8BBimsvJzdToWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 36/37] bdi: Do not use freezable workqueue
Date:   Fri, 25 Oct 2019 09:56:00 -0400
Message-Id: <20191025135603.25093-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit a2b90f11217790ec0964ba9c93a4abb369758c26 ]

A removable block device, such as NVMe or SSD connected over Thunderbolt
can be hot-removed any time including when the system is suspended. When
device is hot-removed during suspend and the system gets resumed, kernel
first resumes devices and then thaws the userspace including freezable
workqueues. What happens in that case is that the NVMe driver notices
that the device is unplugged and removes it from the system. This ends
up calling bdi_unregister() for the gendisk which then schedules
wb_workfn() to be run one more time.

However, since the bdi_wq is still frozen flush_delayed_work() call in
wb_shutdown() blocks forever halting system resume process. User sees
this as hang as nothing is happening anymore.

Triggering sysrq-w reveals this:

  Workqueue: nvme-wq nvme_remove_dead_ctrl_work [nvme]
  Call Trace:
   ? __schedule+0x2c5/0x630
   ? wait_for_completion+0xa4/0x120
   schedule+0x3e/0xc0
   schedule_timeout+0x1c9/0x320
   ? resched_curr+0x1f/0xd0
   ? wait_for_completion+0xa4/0x120
   wait_for_completion+0xc3/0x120
   ? wake_up_q+0x60/0x60
   __flush_work+0x131/0x1e0
   ? flush_workqueue_prep_pwqs+0x130/0x130
   bdi_unregister+0xb9/0x130
   del_gendisk+0x2d2/0x2e0
   nvme_ns_remove+0xed/0x110 [nvme_core]
   nvme_remove_namespaces+0x96/0xd0 [nvme_core]
   nvme_remove+0x5b/0x160 [nvme]
   pci_device_remove+0x36/0x90
   device_release_driver_internal+0xdf/0x1c0
   nvme_remove_dead_ctrl_work+0x14/0x30 [nvme]
   process_one_work+0x1c2/0x3f0
   worker_thread+0x48/0x3e0
   kthread+0x100/0x140
   ? current_work+0x30/0x30
   ? kthread_park+0x80/0x80
   ret_from_fork+0x35/0x40

This is not limited to NVMes so exactly same issue can be reproduced by
hot-removing SSD (over Thunderbolt) while the system is suspended.

Prevent this from happening by removing WQ_FREEZABLE from bdi_wq.

Reported-by: AceLan Kao <acelan.kao@canonical.com>
Link: https://marc.info/?l=linux-kernel&m=138695698516487
Link: https://bugzilla.kernel.org/show_bug.cgi?id=204385
Link: https://lore.kernel.org/lkml/20191002122136.GD2819@lahna.fi.intel.com/#t
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/backing-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 72e6d0c55cfad..00277c8855c68 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -249,8 +249,8 @@ static int __init default_bdi_init(void)
 {
 	int err;
 
-	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_FREEZABLE |
-					      WQ_UNBOUND | WQ_SYSFS, 0);
+	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_UNBOUND |
+				 WQ_SYSFS, 0);
 	if (!bdi_wq)
 		return -ENOMEM;
 
-- 
2.20.1

