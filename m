Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DA21199B3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfLJVHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727565AbfLJVHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8911224680;
        Tue, 10 Dec 2019 21:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012068;
        bh=I8ZcA7YLcVL7qpiDmUC38KkXKYAYm0txg9RBQVOxOyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1uuNO98TxwXi71JEmh5N58FQGEtFGfJ8b8WDPGU8dwPILYBY5fgWYNfflBewP+LI
         mzezmXRaPlOwEsvkpE6lxCOZjpGQPkpzKCVfpyf9PJY2uK9B8v0vozF4l71PpXaNIW
         8ICSQ5rPbBOi2fRxuxUNemZIOHd315zwBiJYA47o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 049/350] media: vimc: Fix gpf in rmmod path when stream is active
Date:   Tue, 10 Dec 2019 16:02:34 -0500
Message-Id: <20191210210735.9077-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit d7fb5c361c2a2666d20e044206e1756bc8e87df2 ]

If vimc module is removed while streaming is in progress, sensor subdev
unregister runs into general protection fault when it tries to unregister
media entities. This is a common subdev problem related to releasing
pads from v4l2_device_unregister_subdev() before calling unregister.
Unregister references pads during unregistering subdev.

The sd release handler is the right place for releasing all sd resources
including pads. The release handlers currently release all resources
except the pads.

Fix v4l2_device_unregister_subdev() not release pads and release pads
from the sd_int_op release handlers.

kernel: [ 4136.715839] general protection fault: 0000 [#1] SMP PTI
kernel: [ 4136.715847] CPU: 2 PID: 1972 Comm: bash Not tainted 5.3.0-rc2+ #4
kernel: [ 4136.715850] Hardware name: Dell Inc. OptiPlex 790/0HY9JP, BIOS A18 09/24/2013
kernel: [ 4136.715858] RIP: 0010:media_gobj_destroy.part.16+0x1f/0x60
kernel: [ 4136.715863] Code: ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 fe 48 89 e5 53 48 89 fb 48 c7 c7 00 7f cf b0 e8 24 fa ff ff 48 8b 03 <48> 83 80 a0 00 00 00 01 48 8b 43 18 48 8b 53 10 48 89 42 08 48 89
kernel: [ 4136.715866] RSP: 0018:ffff9b2248fe3cb0 EFLAGS: 00010246
kernel: [ 4136.715870] RAX: bcf2bfbfa0d63c2f RBX: ffff88c3eb37e9c0 RCX: 00000000802a0018
kernel: [ 4136.715873] RDX: ffff88c3e4f6a078 RSI: ffff88c3eb37e9c0 RDI: ffffffffb0cf7f00
kernel: [ 4136.715876] RBP: ffff9b2248fe3cb8 R08: 0000000001000002 R09: ffffffffb0492b00
kernel: [ 4136.715879] R10: ffff9b2248fe3c28 R11: 0000000000000001 R12: 0000000000000038
kernel: [ 4136.715881] R13: ffffffffc09a1628 R14: ffff88c3e4f6a028 R15: fffffffffffffff2
kernel: [ 4136.715885] FS:  00007f8389647740(0000) GS:ffff88c465500000(0000) knlGS:0000000000000000
kernel: [ 4136.715888] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [ 4136.715891] CR2: 000055d008f80fd8 CR3: 00000001996ec005 CR4: 00000000000606e0
kernel: [ 4136.715894] Call Trace:
kernel: [ 4136.715903]  media_gobj_destroy+0x14/0x20
kernel: [ 4136.715908]  __media_device_unregister_entity+0xb3/0xe0
kernel: [ 4136.715915]  media_device_unregister_entity+0x30/0x40
kernel: [ 4136.715920]  v4l2_device_unregister_subdev+0xa8/0xe0
kernel: [ 4136.715928]  vimc_ent_sd_unregister+0x1e/0x30 [vimc]
kernel: [ 4136.715933]  vimc_sen_rm+0x16/0x20 [vimc]
kernel: [ 4136.715938]  vimc_remove+0x3e/0xa0 [vimc]
kernel: [ 4136.715945]  platform_drv_remove+0x25/0x50
kernel: [ 4136.715951]  device_release_driver_internal+0xe0/0x1b0
kernel: [ 4136.715956]  device_driver_detach+0x14/0x20
kernel: [ 4136.715960]  unbind_store+0xd1/0x130
kernel: [ 4136.715965]  drv_attr_store+0x27/0x40
kernel: [ 4136.715971]  sysfs_kf_write+0x48/0x60
kernel: [ 4136.715976]  kernfs_fop_write+0x128/0x1b0
kernel: [ 4136.715982]  __vfs_write+0x1b/0x40
kernel: [ 4136.715987]  vfs_write+0xc3/0x1d0
kernel: [ 4136.715993]  ksys_write+0xaa/0xe0
kernel: [ 4136.715999]  __x64_sys_write+0x1a/0x20
kernel: [ 4136.716005]  do_syscall_64+0x5a/0x130
kernel: [ 4136.716010]  entry_SYSCALL_64_after_hwframe+0x4

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-common.c  | 3 +--
 drivers/media/platform/vimc/vimc-debayer.c | 1 +
 drivers/media/platform/vimc/vimc-scaler.c  | 1 +
 drivers/media/platform/vimc/vimc-sensor.c  | 1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 7e1ae0b12f1e0..a3120f4f7a90e 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -375,7 +375,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 {
 	int ret;
 
-	/* Allocate the pads */
+	/* Allocate the pads. Should be released from the sd_int_op release */
 	ved->pads = vimc_pads_init(num_pads, pads_flag);
 	if (IS_ERR(ved->pads))
 		return PTR_ERR(ved->pads);
@@ -424,7 +424,6 @@ EXPORT_SYMBOL_GPL(vimc_ent_sd_register);
 void vimc_ent_sd_unregister(struct vimc_ent_device *ved, struct v4l2_subdev *sd)
 {
 	media_entity_cleanup(ved->ent);
-	vimc_pads_cleanup(ved->pads);
 	v4l2_device_unregister_subdev(sd);
 }
 EXPORT_SYMBOL_GPL(vimc_ent_sd_unregister);
diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index b72b8385067bf..baafd9d7fb2c1 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -484,6 +484,7 @@ static void vimc_deb_release(struct v4l2_subdev *sd)
 	struct vimc_deb_device *vdeb =
 				container_of(sd, struct vimc_deb_device, sd);
 
+	vimc_pads_cleanup(vdeb->ved.pads);
 	kfree(vdeb);
 }
 
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
index 49ab8d9dd9c9c..c0d9f43d5777b 100644
--- a/drivers/media/platform/vimc/vimc-scaler.c
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -343,6 +343,7 @@ static void vimc_sca_release(struct v4l2_subdev *sd)
 	struct vimc_sca_device *vsca =
 				container_of(sd, struct vimc_sca_device, sd);
 
+	vimc_pads_cleanup(vsca->ved.pads);
 	kfree(vsca);
 }
 
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 6c53b9fc16176..6f56d4ac50cae 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -297,6 +297,7 @@ static void vimc_sen_release(struct v4l2_subdev *sd)
 
 	v4l2_ctrl_handler_free(&vsen->hdl);
 	tpg_free(&vsen->tpg);
+	vimc_pads_cleanup(vsen->ved.pads);
 	kfree(vsen);
 }
 
-- 
2.20.1

