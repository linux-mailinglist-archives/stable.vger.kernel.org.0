Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B49D55FE7
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfFZDnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfFZDnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:16 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C706820883;
        Wed, 26 Jun 2019 03:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520594;
        bh=IH+6EZpg08KlszRjbeydaCe8y5/Ljqv5UQz8x6Wzkjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKTa/b5rG0QicFE8ZIa9pBk+kIlMgKydMcMyaLDLtpkTuzuj3mVKBkwyzQlzZjDJ7
         26YsYjAFcapjoghWpM+wYAqMvlT0Z1gjG1h+3v5RAvl5ZlviPeI2BeAvNWKqQwHH1p
         8z+/wanNaOoHx8j/nmEQd8rqJQGAKL83R0/594rk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Pasternak <vadimp@mellanox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 43/51] platform/mellanox: mlxreg-hotplug: Add devm_free_irq call to remove flow
Date:   Tue, 25 Jun 2019 23:40:59 -0400
Message-Id: <20190626034117.23247-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 8c2eb7b6468ad4aa5600aed01aa0715f921a3f8b ]

Add devm_free_irq() call to mlxreg-hotplug remove() for clean release
of devices irq resource. Fix debugobjects warning triggered by rmmod
It prevents of use-after-free memory, related to
mlxreg_hotplug_work_handler.

Issue has been reported as debugobjects warning triggered by
'rmmod mlxtreg-hotplug' flow, while running kernel with
CONFIG_DEBUG_OBJECTS* options.

[ 2489.623551] ODEBUG: free active (active state 0) object type: work_struct hint: mlxreg_hotplug_work_handler+0x0/0x7f0 [mlxreg_hotplug]
[ 2489.637097] WARNING: CPU: 5 PID: 3924 at lib/debugobjects.c:328 debug_print_object+0xfe/0x180
[ 2489.637165] RIP: 0010:debug_print_object+0xfe/0x180
?
[ 2489.637214] Call Trace:
[ 2489.637225]  __debug_check_no_obj_freed+0x25e/0x320
[ 2489.637231]  kfree+0x82/0x110
[ 2489.637238]  release_nodes+0x33c/0x4e0
[ 2489.637242]  ? devres_remove_group+0x1b0/0x1b0
[ 2489.637247]  device_release_driver_internal+0x146/0x270
[ 2489.637251]  driver_detach+0x73/0xe0
[ 2489.637254]  bus_remove_driver+0xa1/0x170
[ 2489.637261]  __x64_sys_delete_module+0x29e/0x320
[ 2489.637265]  ? __ia32_sys_delete_module+0x320/0x320
[ 2489.637268]  ? blkcg_exit_queue+0x20/0x20
[ 2489.637273]  ? task_work_run+0x7d/0x100
[ 2489.637278]  ? exit_to_usermode_loop+0x5b/0xf0
[ 2489.637281]  do_syscall_64+0x73/0x160
[ 2489.637287]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2489.637290] RIP: 0033:0x7f95c3596fd7

The difference in release flow with and with no devm_free_irq is listed
below:

bus: 'platform': remove driver mlxreg-hotplug
 mlxreg_hotplug_remove(start)
					-> devm_free_irq (with new code)
 mlxreg_hotplug_remove (end)
 release_nodes (start)
  mlxreg-hotplug: DEVRES REL devm_hwmon_release (8 bytes)
  device: 'hwmon3': device_unregister
  PM: Removing info for No Bus:hwmon3
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (88 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (6 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (5 bytes)
  mlxreg-hotplug: DEVRES REL devm_irq_release (16 bytes) (no new code)
  mlxreg-hotplug: DEVRES REL devm_kzalloc_release (1376 bytes)
   ------------[ cut here ]------------ (no new code):
   ODEBUG: free active (active state 0) object type: work_struct hint: mlxreg_hotplug_work_handler

 release_nodes(end)
driver: 'mlxreg-hotplug': driver_release

Fixes: 1f976f6978bf ("platform/x86: Move Mellanox platform hotplug driver to platform/mellanox")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxreg-hotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/mellanox/mlxreg-hotplug.c b/drivers/platform/mellanox/mlxreg-hotplug.c
index 687ce6817d0d..f85a1b9d129b 100644
--- a/drivers/platform/mellanox/mlxreg-hotplug.c
+++ b/drivers/platform/mellanox/mlxreg-hotplug.c
@@ -694,6 +694,7 @@ static int mlxreg_hotplug_remove(struct platform_device *pdev)
 
 	/* Clean interrupts setup. */
 	mlxreg_hotplug_unset_irq(priv);
+	devm_free_irq(&pdev->dev, priv->irq, priv);
 
 	return 0;
 }
-- 
2.20.1

