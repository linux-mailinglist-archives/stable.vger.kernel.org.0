Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0448824BB5A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgHTM1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbgHTJwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:52:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650A62067C;
        Thu, 20 Aug 2020 09:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917156;
        bh=kyZ4OQTGL/UNsZkgR+TRXjK66fbqkC2ATajEKr+L0Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1cp/35ulq+rVWM+Qo8AbxpbS+AiwuRvSHnVAg/YaWS38c+cm3Dai3tQ7p+65hz/c
         u01jot9ym9UfXy8heZMwGsTfp94EKoUChKZZ1NVAUl3ACVJhSYMmEcjBPGGXul5om9
         HkvmenPUxahY056Jhrh/6T2Rrtj0aRajUpYboTnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugeniu Rosca <erosca@de.adit-jv.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 24/92] media: vsp1: dl: Fix NULL pointer dereference on unbind
Date:   Thu, 20 Aug 2020 11:21:09 +0200
Message-Id: <20200820091538.815430584@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

commit c92d30e4b78dc331909f8c6056c2792aa14e2166 upstream.

In commit f3b98e3c4d2e16 ("media: vsp1: Provide support for extended
command pools"), the vsp pointer used for referencing the VSP1 device
structure from a command pool during vsp1_dl_ext_cmd_pool_destroy() was
not populated.

Correctly assign the pointer to prevent the following
null-pointer-dereference when removing the device:

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
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vsp1/vsp1_dl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -431,6 +431,8 @@ vsp1_dl_cmd_pool_create(struct vsp1_devi
 	if (!pool)
 		return NULL;
 
+	pool->vsp1 = vsp1;
+
 	spin_lock_init(&pool->lock);
 	INIT_LIST_HEAD(&pool->free);
 


