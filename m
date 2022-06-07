Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7D35407E8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347803AbiFGRxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349933AbiFGRvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A7E13CA1C;
        Tue,  7 Jun 2022 10:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E34426160E;
        Tue,  7 Jun 2022 17:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB61FC385A5;
        Tue,  7 Jun 2022 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623497;
        bh=9o9q4WD8l/Xb1LIFiZ7mZPfpN8Qs+Tj9o9Js+pnAarU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbkgruOBNMotBLTmZ7etrqagZxvYU7OFsorDD0fU3uSLLNhsJZGnFOb6OedSDaYpg
         x5fmDDChQ91myVXFeekv6IYoahTyjHNK/jL+sSTHVUn5IkbykPgybQmLQvdyeGvrrf
         yD1sN1mZy25s0B27yTAehKFjwrQUyVI3C0Bhg0Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        kernel test robot <lkp@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 439/452] thermal/core: fix a UAF bug in __thermal_cooling_device_register()
Date:   Tue,  7 Jun 2022 19:04:56 +0200
Message-Id: <20220607164921.644649330@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 0a5c26712f963f0500161a23e0ffff8d29f742ab upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1092,7 +1092,7 @@ __thermal_cooling_device_register(struct
 {
 	struct thermal_cooling_device *cdev;
 	struct thermal_zone_device *pos = NULL;
-	int ret;
+	int id, ret;
 
 	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
 	    !ops->set_cur_state)
@@ -1106,6 +1106,7 @@ __thermal_cooling_device_register(struct
 	if (ret < 0)
 		goto out_kfree_cdev;
 	cdev->id = ret;
+	id = ret;
 
 	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
 	if (!cdev->type) {
@@ -1147,8 +1148,9 @@ out_kfree_type:
 	thermal_cooling_device_destroy_sysfs(cdev);
 	kfree(cdev->type);
 	put_device(&cdev->device);
+	cdev = NULL;
 out_ida_remove:
-	ida_simple_remove(&thermal_cdev_ida, cdev->id);
+	ida_simple_remove(&thermal_cdev_ida, id);
 out_kfree_cdev:
 	return ERR_PTR(ret);
 }


