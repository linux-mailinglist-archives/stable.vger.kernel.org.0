Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C2C390BB
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbfFGPrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731504AbfFGPrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:47:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C842147A;
        Fri,  7 Jun 2019 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922422;
        bh=Av7qk+XXhXvULeVJk0bNx7YqD+M42bGGZrRJlYuPqZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfFDaA6BwRrI0kDKuXCHGYb1XoolP9lt5oVkOR7qQ1PEeUxzxowXoreH5b/+qHE/s
         h/L22BdlDdidFYx/QONNbbRqS9ZdPmHYTqLksNvZ3gabNJfJ+7dtfMBolRpW9UdGGo
         PcUQIg5O42JdtK3ylMZboryiTw9R/qxkECp0VK5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 4.19 35/73] drm/nouveau/i2c: Disable i2c bus access after ->fini()
Date:   Fri,  7 Jun 2019 17:39:22 +0200
Message-Id: <20190607153853.012042229@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 342406e4fbba9a174125fbfe6aeac3d64ef90f76 upstream.

For a while, we've had the problem of i2c bus access not grabbing
a runtime PM ref when it's being used in userspace by i2c-dev, resulting
in nouveau spamming the kernel log with errors if anything attempts to
access the i2c bus while the GPU is in runtime suspend. An example:

[  130.078386] nouveau 0000:01:00.0: i2c: aux 000d: begin idle timeout ffffffff

Since the GPU is in runtime suspend, the MMIO region that the i2c bus is
on isn't accessible. On x86, the standard behavior for accessing an
unavailable MMIO region is to just return ~0.

Except, that turned out to be a lie. While computers with a clean
concious will return ~0 in this scenario, some machines will actually
completely hang a CPU on certian bad MMIO accesses. This was witnessed
with someone's Lenovo ThinkPad P50, where sensors-detect attempting to
access the i2c bus while the GPU was suspended would result in a CPU
hang:

  CPU: 5 PID: 12438 Comm: sensors-detect Not tainted 5.0.0-0.rc4.git3.1.fc30.x86_64 #1
  Hardware name: LENOVO 20EQS64N17/20EQS64N17, BIOS N1EET74W (1.47 ) 11/21/2017
  RIP: 0010:ioread32+0x2b/0x30
  Code: 81 ff ff ff 03 00 77 20 48 81 ff 00 00 01 00 76 05 0f b7 d7 ed c3
  48 c7 c6 e1 0c 36 96 e8 2d ff ff ff b8 ff ff ff ff c3 8b 07 <c3> 0f 1f
  40 00 49 89 f0 48 81 fe ff ff 03 00 76 04 40 88 3e c3 48
  RSP: 0018:ffffaac3c5007b48 EFLAGS: 00000292 ORIG_RAX: ffffffffffffff13
  RAX: 0000000001111000 RBX: 0000000001111000 RCX: 0000043017a97186
  RDX: 0000000000000aaa RSI: 0000000000000005 RDI: ffffaac3c400e4e4
  RBP: ffff9e6443902c00 R08: ffffaac3c400e4e4 R09: ffffaac3c5007be7
  R10: 0000000000000004 R11: 0000000000000001 R12: ffff9e6445dd0000
  R13: 000000000000e4e4 R14: 00000000000003c4 R15: 0000000000000000
  FS:  00007f253155a740(0000) GS:ffff9e644f600000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00005630d1500358 CR3: 0000000417c44006 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   g94_i2c_aux_xfer+0x326/0x850 [nouveau]
   nvkm_i2c_aux_i2c_xfer+0x9e/0x140 [nouveau]
   __i2c_transfer+0x14b/0x620
   i2c_smbus_xfer_emulated+0x159/0x680
   ? _raw_spin_unlock_irqrestore+0x1/0x60
   ? rt_mutex_slowlock.constprop.0+0x13d/0x1e0
   ? __lock_is_held+0x59/0xa0
   __i2c_smbus_xfer+0x138/0x5a0
   i2c_smbus_xfer+0x4f/0x80
   i2cdev_ioctl_smbus+0x162/0x2d0 [i2c_dev]
   i2cdev_ioctl+0x1db/0x2c0 [i2c_dev]
   do_vfs_ioctl+0x408/0x750
   ksys_ioctl+0x5e/0x90
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x60/0x1e0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f25317f546b
  Code: 0f 1e fa 48 8b 05 1d da 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
  ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
  f0 ff ff 73 01 c3 48 8b 0d ed d9 0c 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffc88caab68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00005630d0fe7260 RCX: 00007f25317f546b
  RDX: 00005630d1598e80 RSI: 0000000000000720 RDI: 0000000000000003
  RBP: 00005630d155b968 R08: 0000000000000001 R09: 00005630d15a1da0
  R10: 0000000000000070 R11: 0000000000000246 R12: 00005630d1598e80
  R13: 00005630d12f3d28 R14: 0000000000000720 R15: 00005630d12f3ce0
  watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [sensors-detect:12438]

Yikes! While I wanted to try to make it so that accessing an i2c bus on
nouveau would wake up the GPU as needed, airlied pointed out that pretty
much any usecase for userspace accessing an i2c bus on a GPU (mainly for
the DDC brightness control that some displays have) is going to only be
useful while there's at least one display enabled on the GPU anyway, and
the GPU never sleeps while there's displays running.

Since teaching the i2c bus to wake up the GPU on userspace accesses is a
good deal more difficult than it might seem, mostly due to the fact that
we have to use the i2c bus during runtime resume of the GPU, we instead
opt for the easiest solution: don't let userspace access i2c busses on
the GPU at all while it's in runtime suspend.

Changes since v1:
* Also disable i2c busses that run over DP AUX

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h |    2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c     |   26 +++++++++++++++++++++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h     |    2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c    |   15 ++++++++++++
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c     |   21 ++++++++++++++++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h     |    1 
 6 files changed, 65 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h
@@ -38,6 +38,7 @@ struct nvkm_i2c_bus {
 	struct mutex mutex;
 	struct list_head head;
 	struct i2c_adapter i2c;
+	u8 enabled;
 };
 
 int nvkm_i2c_bus_acquire(struct nvkm_i2c_bus *);
@@ -57,6 +58,7 @@ struct nvkm_i2c_aux {
 	struct mutex mutex;
 	struct list_head head;
 	struct i2c_adapter i2c;
+	u8 enabled;
 
 	u32 intr;
 };
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
@@ -105,9 +105,15 @@ nvkm_i2c_aux_acquire(struct nvkm_i2c_aux
 {
 	struct nvkm_i2c_pad *pad = aux->pad;
 	int ret;
+
 	AUX_TRACE(aux, "acquire");
 	mutex_lock(&aux->mutex);
-	ret = nvkm_i2c_pad_acquire(pad, NVKM_I2C_PAD_AUX);
+
+	if (aux->enabled)
+		ret = nvkm_i2c_pad_acquire(pad, NVKM_I2C_PAD_AUX);
+	else
+		ret = -EIO;
+
 	if (ret)
 		mutex_unlock(&aux->mutex);
 	return ret;
@@ -145,6 +151,24 @@ nvkm_i2c_aux_del(struct nvkm_i2c_aux **p
 	}
 }
 
+void
+nvkm_i2c_aux_init(struct nvkm_i2c_aux *aux)
+{
+	AUX_TRACE(aux, "init");
+	mutex_lock(&aux->mutex);
+	aux->enabled = true;
+	mutex_unlock(&aux->mutex);
+}
+
+void
+nvkm_i2c_aux_fini(struct nvkm_i2c_aux *aux)
+{
+	AUX_TRACE(aux, "fini");
+	mutex_lock(&aux->mutex);
+	aux->enabled = false;
+	mutex_unlock(&aux->mutex);
+}
+
 int
 nvkm_i2c_aux_ctor(const struct nvkm_i2c_aux_func *func,
 		  struct nvkm_i2c_pad *pad, int id,
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h
@@ -16,6 +16,8 @@ int nvkm_i2c_aux_ctor(const struct nvkm_
 int nvkm_i2c_aux_new_(const struct nvkm_i2c_aux_func *, struct nvkm_i2c_pad *,
 		      int id, struct nvkm_i2c_aux **);
 void nvkm_i2c_aux_del(struct nvkm_i2c_aux **);
+void nvkm_i2c_aux_init(struct nvkm_i2c_aux *);
+void nvkm_i2c_aux_fini(struct nvkm_i2c_aux *);
 int nvkm_i2c_aux_xfer(struct nvkm_i2c_aux *, bool retry, u8 type,
 		      u32 addr, u8 *data, u8 *size);
 
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c
@@ -160,8 +160,18 @@ nvkm_i2c_fini(struct nvkm_subdev *subdev
 {
 	struct nvkm_i2c *i2c = nvkm_i2c(subdev);
 	struct nvkm_i2c_pad *pad;
+	struct nvkm_i2c_bus *bus;
+	struct nvkm_i2c_aux *aux;
 	u32 mask;
 
+	list_for_each_entry(aux, &i2c->aux, head) {
+		nvkm_i2c_aux_fini(aux);
+	}
+
+	list_for_each_entry(bus, &i2c->bus, head) {
+		nvkm_i2c_bus_fini(bus);
+	}
+
 	if ((mask = (1 << i2c->func->aux) - 1), i2c->func->aux_stat) {
 		i2c->func->aux_mask(i2c, NVKM_I2C_ANY, mask, 0);
 		i2c->func->aux_stat(i2c, &mask, &mask, &mask, &mask);
@@ -180,6 +190,7 @@ nvkm_i2c_init(struct nvkm_subdev *subdev
 	struct nvkm_i2c *i2c = nvkm_i2c(subdev);
 	struct nvkm_i2c_bus *bus;
 	struct nvkm_i2c_pad *pad;
+	struct nvkm_i2c_aux *aux;
 
 	list_for_each_entry(pad, &i2c->pad, head) {
 		nvkm_i2c_pad_init(pad);
@@ -189,6 +200,10 @@ nvkm_i2c_init(struct nvkm_subdev *subdev
 		nvkm_i2c_bus_init(bus);
 	}
 
+	list_for_each_entry(aux, &i2c->aux, head) {
+		nvkm_i2c_aux_init(aux);
+	}
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c
@@ -110,6 +110,19 @@ nvkm_i2c_bus_init(struct nvkm_i2c_bus *b
 	BUS_TRACE(bus, "init");
 	if (bus->func->init)
 		bus->func->init(bus);
+
+	mutex_lock(&bus->mutex);
+	bus->enabled = true;
+	mutex_unlock(&bus->mutex);
+}
+
+void
+nvkm_i2c_bus_fini(struct nvkm_i2c_bus *bus)
+{
+	BUS_TRACE(bus, "fini");
+	mutex_lock(&bus->mutex);
+	bus->enabled = false;
+	mutex_unlock(&bus->mutex);
 }
 
 void
@@ -126,9 +139,15 @@ nvkm_i2c_bus_acquire(struct nvkm_i2c_bus
 {
 	struct nvkm_i2c_pad *pad = bus->pad;
 	int ret;
+
 	BUS_TRACE(bus, "acquire");
 	mutex_lock(&bus->mutex);
-	ret = nvkm_i2c_pad_acquire(pad, NVKM_I2C_PAD_I2C);
+
+	if (bus->enabled)
+		ret = nvkm_i2c_pad_acquire(pad, NVKM_I2C_PAD_I2C);
+	else
+		ret = -EIO;
+
 	if (ret)
 		mutex_unlock(&bus->mutex);
 	return ret;
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h
@@ -18,6 +18,7 @@ int nvkm_i2c_bus_new_(const struct nvkm_
 		      int id, struct nvkm_i2c_bus **);
 void nvkm_i2c_bus_del(struct nvkm_i2c_bus **);
 void nvkm_i2c_bus_init(struct nvkm_i2c_bus *);
+void nvkm_i2c_bus_fini(struct nvkm_i2c_bus *);
 
 int nvkm_i2c_bit_xfer(struct nvkm_i2c_bus *, struct i2c_msg *, int);
 


