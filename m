Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F261E3D5FAD
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhGZPSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236513AbhGZPRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:17:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E000760F70;
        Mon, 26 Jul 2021 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315055;
        bh=nOCnzzOAdsN24bfZsElojP6Q2fJlpF1q7LJRy2tPqRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXkMbF2ggDVFoP4Gj9OCBxtsh6pJ3H0niEdmNLDmrAdMaI9rlD2ybAPuuCgGq9G0d
         hIZqrgeK9EjWcENPyOGFOu1GzAYOiM9V0BOs1Sn0HfiBHzvu5mrnE62OMvt+NsnYk9
         vhNua8+o02EIwxmJPZ1mKn2fHjJgFi/UaVg50nVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/108] nvme-pci: dont WARN_ON in nvme_reset_work if ctrl.state is not RESETTING
Date:   Mon, 26 Jul 2021 17:39:01 +0200
Message-Id: <20210726153833.616622957@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 7764656b108cd308c39e9a8554353b8f9ca232a3 ]

Followling process:
nvme_probe
  nvme_reset_ctrl
    nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING)
    queue_work(nvme_reset_wq, &ctrl->reset_work)

-------------->	nvme_remove
		  nvme_change_ctrl_state(&dev->ctrl, NVME_CTRL_DELETING)
worker_thread
  process_one_work
    nvme_reset_work
    WARN_ON(dev->ctrl.state != NVME_CTRL_RESETTING)

, which will trigger WARN_ON in nvme_reset_work():
[  127.534298] WARNING: CPU: 0 PID: 139 at drivers/nvme/host/pci.c:2594
[  127.536161] CPU: 0 PID: 139 Comm: kworker/u8:7 Not tainted 5.13.0
[  127.552518] Call Trace:
[  127.552840]  ? kvm_sched_clock_read+0x25/0x40
[  127.553936]  ? native_send_call_func_single_ipi+0x1c/0x30
[  127.555117]  ? send_call_function_single_ipi+0x9b/0x130
[  127.556263]  ? __smp_call_single_queue+0x48/0x60
[  127.557278]  ? ttwu_queue_wakelist+0xfa/0x1c0
[  127.558231]  ? try_to_wake_up+0x265/0x9d0
[  127.559120]  ? ext4_end_io_rsv_work+0x160/0x290
[  127.560118]  process_one_work+0x28c/0x640
[  127.561002]  worker_thread+0x39a/0x700
[  127.561833]  ? rescuer_thread+0x580/0x580
[  127.562714]  kthread+0x18c/0x1e0
[  127.563444]  ? set_kthread_struct+0x70/0x70
[  127.564347]  ret_from_fork+0x1f/0x30

The preceding problem can be easily reproduced by executing following
script (based on blktests suite):
test() {
  pdev="$(_get_pci_dev_from_blkdev)"
  sysfs="/sys/bus/pci/devices/${pdev}"
  for ((i = 0; i < 10; i++)); do
    echo 1 > "$sysfs/remove"
    echo 1 > /sys/bus/pci/rescan
  done
}

Since the device ctrl could be updated as an non-RESETTING state by
repeating probe/remove in userspace (which is a normal situation), we
can replace stack dumping WARN_ON with a warnning message.

Fixes: 82b057caefaff ("nvme-pci: fix multiple ctrl removal schedulin")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f9dba1a3e655..af516c35afe6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2590,7 +2590,9 @@ static void nvme_reset_work(struct work_struct *work)
 	bool was_suspend = !!(dev->ctrl.ctrl_config & NVME_CC_SHN_NORMAL);
 	int result;
 
-	if (WARN_ON(dev->ctrl.state != NVME_CTRL_RESETTING)) {
+	if (dev->ctrl.state != NVME_CTRL_RESETTING) {
+		dev_warn(dev->ctrl.device, "ctrl state %d is not RESETTING\n",
+			 dev->ctrl.state);
 		result = -ENODEV;
 		goto out;
 	}
-- 
2.30.2



