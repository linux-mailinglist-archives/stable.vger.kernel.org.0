Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57369451DDD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346045AbhKPAeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343902AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9423635F6;
        Mon, 15 Nov 2021 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002092;
        bh=0qWVlmnLrMZ+EWmiMSXxICve5sLZ/91HU590eReGbM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APQdSzdLVq4QZNw9Eiv1roEKWg6J5N8xobuei5bNUj81EPAQ3hYAnN1fK++BzPsUE
         Yjc63OddjVqsevU81DMlV5mgBPlgtMf8jHJIVVFaZdyQ7bQKYtBUcsQfDh35hWzny/
         fEeygQaqRFimkyF6O6mhyNdsSjQFJ6qk6JjTmRpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        kernel test robot <lkp@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/917] thermal/core: fix a UAF bug in __thermal_cooling_device_register()
Date:   Mon, 15 Nov 2021 17:58:50 +0100
Message-Id: <20211115165443.539978665@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 0a5c26712f963f0500161a23e0ffff8d29f742ab ]

When device_register() return failed, program will goto out_kfree_type
to release 'cdev->device' by put_device(). That will call thermal_release()
to free 'cdev'. But the follow-up processes access 'cdev' continually.
That trggers the UAF bug.

====================================================================
BUG: KASAN: use-after-free in __thermal_cooling_device_register+0x75b/0xa90
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 dump_stack_lvl+0xe2/0x152
 print_address_description.constprop.0+0x21/0x140
 ? __thermal_cooling_device_register+0x75b/0xa90
 kasan_report.cold+0x7f/0x11b
 ? __thermal_cooling_device_register+0x75b/0xa90
 __thermal_cooling_device_register+0x75b/0xa90
 ? memset+0x20/0x40
 ? __sanitizer_cov_trace_pc+0x1d/0x50
 ? __devres_alloc_node+0x130/0x180
 devm_thermal_of_cooling_device_register+0x67/0xf0
 max6650_probe.cold+0x557/0x6aa
......

Freed by task 258:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0x109/0x140
 kfree+0x117/0x4c0
 thermal_release+0xa0/0x110
 device_release+0xa7/0x240
 kobject_put+0x1ce/0x540
 put_device+0x20/0x30
 __thermal_cooling_device_register+0x731/0xa90
 devm_thermal_of_cooling_device_register+0x67/0xf0
 max6650_probe.cold+0x557/0x6aa [max6650]

Do not use 'cdev' again after put_device() to fix the problem like doing
in thermal_zone_device_register().

[dlezcano]: as requested by Rafael, change the affectation into two statements.

Fixes: 584837618100 ("thermal/drivers/core: Use a char pointer for the cooling device name")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20211015024504.947520-1-william.xuanziyang@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d094ebbde0ed7..30134f49b037a 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -887,7 +887,7 @@ __thermal_cooling_device_register(struct device_node *np,
 {
 	struct thermal_cooling_device *cdev;
 	struct thermal_zone_device *pos = NULL;
-	int ret;
+	int id, ret;
 
 	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
 	    !ops->set_cur_state)
@@ -901,6 +901,7 @@ __thermal_cooling_device_register(struct device_node *np,
 	if (ret < 0)
 		goto out_kfree_cdev;
 	cdev->id = ret;
+	id = ret;
 
 	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
 	if (ret)
@@ -944,8 +945,9 @@ __thermal_cooling_device_register(struct device_node *np,
 out_kfree_type:
 	kfree(cdev->type);
 	put_device(&cdev->device);
+	cdev = NULL;
 out_ida_remove:
-	ida_simple_remove(&thermal_cdev_ida, cdev->id);
+	ida_simple_remove(&thermal_cdev_ida, id);
 out_kfree_cdev:
 	kfree(cdev);
 	return ERR_PTR(ret);
-- 
2.33.0



