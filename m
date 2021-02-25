Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B86323D2D
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbhBXNFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhBXM70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:59:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 980E064F3E;
        Wed, 24 Feb 2021 12:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171158;
        bh=aGhCcj+6Y/ojFL5utpomFTPLVXUsMXnUhjfGyb09gdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fey7qpZcxXf75a1q7gSH501K3/SUmncfpNWAQ23hp5IUSi3N3Z1KpusoCOT084d4J
         7GcSYjgBoY33D1urUpyavd9vTVUBPJlnFNVz1YhPNKyS7DJW6Cdo9jYie+uhhqT7Dd
         Pha/BMU2YKgNZiPXJLd1OJTrZ+FjsJluDMjK+5ZV5WErWgXv9mcLsFA/+kUejaV767
         LR0/qYiKyEUz+W6MuO6OHgfPD1q+UdiWUtA641gsu5aNqrbNKQOrYRY9gbu9pGZUu6
         PiqvFcXqmBlDWMW8U/4cdX6e4G1iGKu2xS9tPj69l5ldV91QcYaJYeQ5421JCHgcOT
         myk9Ya5St1fgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 19/56] drm/hisilicon: Fix use-after-free
Date:   Wed, 24 Feb 2021 07:51:35 -0500
Message-Id: <20210224125212.482485-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit c855af2f9c5c60760fd1bed7889a81bc37d2591d ]

Fix the problem of dev being released twice.
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 75 PID: 15700 at lib/refcount.c:28 refcount_warn_saturate+0xd4/0x150
CPU: 75 PID: 15700 Comm: rmmod Tainted: G            E     5.10.0-rc3+ #3
Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDDA, BIOS 0.88 07/24/2019
pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
pc : refcount_warn_saturate+0xd4/0x150
lr : refcount_warn_saturate+0xd4/0x150
sp : ffff2028150cbc00
x29: ffff2028150cbc00 x28: ffff2028150121c0
x27: 0000000000000000 x26: 0000000000000000
x25: 0000000000000000 x24: 0000000000000003
x23: 0000000000000000 x22: ffff2028150cbc90
x21: ffff2020038a30a8 x20: ffff2028150cbc90
x19: ffff0020cd938020 x18: 0000000000000010
x17: 0000000000000000 x16: 0000000000000000
x15: ffffffffffffffff x14: ffff2028950cb88f
x13: ffff2028150cb89d x12: 0000000000000000
x11: 0000000005f5e0ff x10: ffff2028150cb800
x9 : 00000000ffffffd0 x8 : 75203b776f6c6672
x7 : ffff800011a6f7c8 x6 : 0000000000000001
x5 : 0000000000000000 x4 : 0000000000000000
x3 : 0000000000000000 x2 : ffff202ffe2f9dc0
x1 : ffffa02fecf40000 x0 : 0000000000000026
Call trace:
 refcount_warn_saturate+0xd4/0x150
 devm_drm_dev_init_release+0x50/0x70
 devm_action_release+0x20/0x30
 release_nodes+0x13c/0x218
 devres_release_all+0x80/0x170
 device_release_driver_internal+0x128/0x1f0
 driver_detach+0x6c/0xe0
 bus_remove_driver+0x74/0x100
 driver_unregister+0x34/0x60
 pci_unregister_driver+0x24/0xd8
 hibmc_pci_driver_exit+0x14/0xe858 [hibmc_drm]
 __arm64_sys_delete_module+0x1fc/0x2d0
 el0_svc_common.constprop.3+0xa8/0x188
 do_el0_svc+0x80/0xa0
 el0_sync_handler+0x8c/0xb0
 el0_sync+0x15c/0x180
CPU: 75 PID: 15700 Comm: rmmod Tainted: G            E     5.10.0-rc3+ #3
Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDDA, BIOS 0.88 07/24/2019
Call trace:
 dump_backtrace+0x0/0x208
 show_stack+0x2c/0x40
 dump_stack+0xd8/0x10c
 __warn+0xac/0x128
 report_bug+0xcc/0x180
 bug_handler+0x24/0x78
 call_break_hook+0x80/0xa0
 brk_handler+0x28/0x68
 do_debug_exception+0x9c/0x148
 el1_sync_handler+0x7c/0x128
 el1_sync+0x80/0x100
 refcount_warn_saturate+0xd4/0x150
 devm_drm_dev_init_release+0x50/0x70
 devm_action_release+0x20/0x30
 release_nodes+0x13c/0x218
 devres_release_all+0x80/0x170
 device_release_driver_internal+0x128/0x1f0
 driver_detach+0x6c/0xe0
 bus_remove_driver+0x74/0x100
 driver_unregister+0x34/0x60
 pci_unregister_driver+0x24/0xd8
 hibmc_pci_driver_exit+0x14/0xe858 [hibmc_drm]
 __arm64_sys_delete_module+0x1fc/0x2d0
 el0_svc_common.constprop.3+0xa8/0x188
 do_el0_svc+0x80/0xa0
 el0_sync_handler+0x8c/0xb0
 el0_sync+0x15c/0x180
---[ end trace 00718630d6e5ff18 ]---

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/1607941973-32287-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
index 085d1b2fa8c0a..d3485f742acc2 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c
@@ -368,7 +368,6 @@ static void hibmc_pci_remove(struct pci_dev *pdev)
 
 	drm_dev_unregister(dev);
 	hibmc_unload(dev);
-	drm_dev_put(dev);
 }
 
 static struct pci_device_id hibmc_pci_table[] = {
-- 
2.27.0

