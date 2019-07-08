Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE9D622A7
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389074AbfGHP1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389106AbfGHP1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A434F21537;
        Mon,  8 Jul 2019 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599658;
        bh=jERcKUo9O7p5on7ItWLW4j+yaGRGbLcrt5ua44OV0N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpkU20uH8/7mZOcPTmAd3t7zfQ1S/dSQOOfPLDKB8UoSl5Qjzt402G+9Q6jVPLq4C
         cGKLtnbg3dBiKUn96qRX8uK+TljnLrsJeQ9xdp4dBeeST7EmW6O5E7R7xVDhNwHyJ/
         QZ9tgjEjiPlaceOR5gHtwc+EO9p/Dyxd0KIYpaK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@mellanox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/90] platform/mellanox: mlxreg-hotplug: Add devm_free_irq call to remove flow
Date:   Mon,  8 Jul 2019 17:12:59 +0200
Message-Id: <20190708150524.227951745@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index eca16d00e310..d52c821b8584 100644
--- a/drivers/platform/mellanox/mlxreg-hotplug.c
+++ b/drivers/platform/mellanox/mlxreg-hotplug.c
@@ -673,6 +673,7 @@ static int mlxreg_hotplug_remove(struct platform_device *pdev)
 
 	/* Clean interrupts setup. */
 	mlxreg_hotplug_unset_irq(priv);
+	devm_free_irq(&pdev->dev, priv->irq, priv);
 
 	return 0;
 }
-- 
2.20.1



