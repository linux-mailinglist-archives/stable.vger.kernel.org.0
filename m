Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F15F1DF5FA
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 10:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbgEWIOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 04:14:03 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:46584 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387471AbgEWIOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 04:14:03 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id A3B733C04C1;
        Sat, 23 May 2020 10:13:59 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FXhyqC6y9xiR; Sat, 23 May 2020 10:13:53 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id A96693C001F;
        Sat, 23 May 2020 10:13:53 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.4) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sat, 23 May
 2020 10:13:53 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>, <stable@vger.kernel.org>
Subject: [PATCH] media: vsp1: dl: Fix NULL pointer dereference on unbind
Date:   Sat, 23 May 2020 10:13:34 +0200
Message-ID: <20200523081334.23531-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.94.4]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v4.19 commit f3b98e3c4d2e16 ("media: vsp1: Provide support for extended
command pools") introduced below issue [*], consistently reproduced.

In order to fix it, inspire from the sibling/predecessor v4.18-rc1
commit 5de0473982aab2 ("media: vsp1: Provide a body pool"), which saves
the vsp1 instance address in vsp1_dl_body_pool_create().

[*] h3ulcb-kf #>
echo fea28000.vsp > /sys/bus/platform/devices/fea28000.vsp/driver/unbind
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
 Mem abort info:
   ESR = 0x96000006
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000006
   CM = 0, WnR = 0
 user pgtable: 4k pages, 48-bit VAs, pgdp=00000007318be000
 [0000000000000028] pgd=00000007333a1003, pud=00000007333a6003, pmd=0000000000000000
 Internal error: Oops: 96000006 [#1] PREEMPT SMP
 Modules linked in:
 CPU: 1 PID: 486 Comm: sh Not tainted 5.7.0-rc6-arm64-renesas-00118-ge644645abf47 #185
 Hardware name: Renesas H3ULCB Kingfisher board based on r8a77951 (DT)
 pstate: 40000005 (nZcv daif -PAN -UAO)
 pc : vsp1_dlm_destroy+0xe4/0x11c
 lr : vsp1_dlm_destroy+0xc8/0x11c
 sp : ffff800012963b60
 x29: ffff800012963b60 x28: ffff0006f83fc440
 x27: 0000000000000000 x26: ffff0006f5e13e80
 x25: ffff0006f5e13ed0 x24: ffff0006f5e13ed0
 x23: ffff0006f5e13ed0 x22: dead000000000122
 x21: ffff0006f5e3a080 x20: ffff0006f5df2938
 x19: ffff0006f5df2980 x18: 0000000000000003
 x17: 0000000000000000 x16: 0000000000000016
 x15: 0000000000000003 x14: 00000000000393c0
 x13: ffff800011a5ec18 x12: ffff800011d8d000
 x11: ffff0006f83fcc68 x10: ffff800011a53d70
 x9 : ffff8000111f3000 x8 : 0000000000000000
 x7 : 0000000000210d00 x6 : 0000000000000000
 x5 : ffff800010872e60 x4 : 0000000000000004
 x3 : 0000000078068000 x2 : ffff800012781000
 x1 : 0000000000002c00 x0 : 0000000000000000
 Call trace:
  vsp1_dlm_destroy+0xe4/0x11c
  vsp1_wpf_destroy+0x10/0x20
  vsp1_entity_destroy+0x24/0x4c
  vsp1_destroy_entities+0x54/0x130
  vsp1_remove+0x1c/0x40
  platform_drv_remove+0x28/0x50
  __device_release_driver+0x178/0x220
  device_driver_detach+0x44/0xc0
  unbind_store+0xe0/0x104
  drv_attr_store+0x20/0x30
  sysfs_kf_write+0x48/0x70
  kernfs_fop_write+0x148/0x230
  __vfs_write+0x18/0x40
  vfs_write+0xdc/0x1c4
  ksys_write+0x68/0xf0
  __arm64_sys_write+0x18/0x20
  el0_svc_common.constprop.0+0x70/0x170
  do_el0_svc+0x20/0x80
  el0_sync_handler+0x134/0x1b0
  el0_sync+0x140/0x180
 Code: b40000c2 f9403a60 d2800084 a9400663 (f9401400)
 ---[ end trace 3875369841fb288a ]---

Fixes: f3b98e3c4d2e16 ("media: vsp1: Provide support for extended command pools")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---

How about adding a new unit test perfoming unbind/rebind to
http://git.ideasonboard.com/renesas/vsp-tests.git, to avoid
such issues in future? 

Locally, below command has been used to identify the problem:

for f in $(find /sys/bus/platform/devices/ -name "*vsp*" -o -name "*fdp*"); do \
     b=$(basename $f); \
     echo $b > $f/driver/unbind; \
done

---
 drivers/media/platform/vsp1/vsp1_dl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index d7b43037e500..e07b135613eb 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -431,6 +431,8 @@ vsp1_dl_cmd_pool_create(struct vsp1_device *vsp1, enum vsp1_extcmd_type type,
 	if (!pool)
 		return NULL;
 
+	pool->vsp1 = vsp1;
+
 	spin_lock_init(&pool->lock);
 	INIT_LIST_HEAD(&pool->free);
 
-- 
2.26.2

