Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D783121891
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfLPR4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbfLPR4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:56:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75FDE205ED;
        Mon, 16 Dec 2019 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518990;
        bh=YgnrCgMEVvq7Ar+XmQux3CnFO0itKu5o+VNqhmGd2Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/2bWDpA/8Lgv6l9Lj8ut/joSzq6Y8Ql99pXRZZa4sHc3BWYCOgolmN07vvUhXri8
         8BCs7aLX/i90L72O2HKcbxchtwqWvt4j/YUBVDuHy6MisQtbcQe1v/WXEML/5vT6jt
         RSszQjbKj9bbvPSqMnJ4CFg/TEBx/wuP6WwWC3aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <wvw@google.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 4.14 151/267] thermal: Fix deadlock in thermal thermal_zone_device_check
Date:   Mon, 16 Dec 2019 18:47:57 +0100
Message-Id: <20191216174910.767810990@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <wvw@google.com>

commit 163b00cde7cf2206e248789d2780121ad5e6a70b upstream.

1851799e1d29 ("thermal: Fix use-after-free when unregistering thermal zone
device") changed cancel_delayed_work to cancel_delayed_work_sync to avoid
a use-after-free issue. However, cancel_delayed_work_sync could be called
insides the WQ causing deadlock.

[54109.642398] c0   1162 kworker/u17:1   D    0 11030      2 0x00000000
[54109.642437] c0   1162 Workqueue: thermal_passive_wq thermal_zone_device_check
[54109.642447] c0   1162 Call trace:
[54109.642456] c0   1162  __switch_to+0x138/0x158
[54109.642467] c0   1162  __schedule+0xba4/0x1434
[54109.642480] c0   1162  schedule_timeout+0xa0/0xb28
[54109.642492] c0   1162  wait_for_common+0x138/0x2e8
[54109.642511] c0   1162  flush_work+0x348/0x40c
[54109.642522] c0   1162  __cancel_work_timer+0x180/0x218
[54109.642544] c0   1162  handle_thermal_trip+0x2c4/0x5a4
[54109.642553] c0   1162  thermal_zone_device_update+0x1b4/0x25c
[54109.642563] c0   1162  thermal_zone_device_check+0x18/0x24
[54109.642574] c0   1162  process_one_work+0x3cc/0x69c
[54109.642583] c0   1162  worker_thread+0x49c/0x7c0
[54109.642593] c0   1162  kthread+0x17c/0x1b0
[54109.642602] c0   1162  ret_from_fork+0x10/0x18
[54109.643051] c0   1162 kworker/u17:2   D    0 16245      2 0x00000000
[54109.643067] c0   1162 Workqueue: thermal_passive_wq thermal_zone_device_check
[54109.643077] c0   1162 Call trace:
[54109.643085] c0   1162  __switch_to+0x138/0x158
[54109.643095] c0   1162  __schedule+0xba4/0x1434
[54109.643104] c0   1162  schedule_timeout+0xa0/0xb28
[54109.643114] c0   1162  wait_for_common+0x138/0x2e8
[54109.643122] c0   1162  flush_work+0x348/0x40c
[54109.643131] c0   1162  __cancel_work_timer+0x180/0x218
[54109.643141] c0   1162  handle_thermal_trip+0x2c4/0x5a4
[54109.643150] c0   1162  thermal_zone_device_update+0x1b4/0x25c
[54109.643159] c0   1162  thermal_zone_device_check+0x18/0x24
[54109.643167] c0   1162  process_one_work+0x3cc/0x69c
[54109.643177] c0   1162  worker_thread+0x49c/0x7c0
[54109.643186] c0   1162  kthread+0x17c/0x1b0
[54109.643195] c0   1162  ret_from_fork+0x10/0x18
[54109.644500] c0   1162 cat             D    0  7766      1 0x00000001
[54109.644515] c0   1162 Call trace:
[54109.644524] c0   1162  __switch_to+0x138/0x158
[54109.644536] c0   1162  __schedule+0xba4/0x1434
[54109.644546] c0   1162  schedule_preempt_disabled+0x80/0xb0
[54109.644555] c0   1162  __mutex_lock+0x3a8/0x7f0
[54109.644563] c0   1162  __mutex_lock_slowpath+0x14/0x20
[54109.644575] c0   1162  thermal_zone_get_temp+0x84/0x360
[54109.644586] c0   1162  temp_show+0x30/0x78
[54109.644609] c0   1162  dev_attr_show+0x5c/0xf0
[54109.644628] c0   1162  sysfs_kf_seq_show+0xcc/0x1a4
[54109.644636] c0   1162  kernfs_seq_show+0x48/0x88
[54109.644656] c0   1162  seq_read+0x1f4/0x73c
[54109.644664] c0   1162  kernfs_fop_read+0x84/0x318
[54109.644683] c0   1162  __vfs_read+0x50/0x1bc
[54109.644692] c0   1162  vfs_read+0xa4/0x140
[54109.644701] c0   1162  SyS_read+0xbc/0x144
[54109.644708] c0   1162  el0_svc_naked+0x34/0x38
[54109.845800] c0   1162 D 720.000s 1->7766->7766 cat [panic]

Fixes: 1851799e1d29 ("thermal: Fix use-after-free when unregistering thermal zone device")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Wang <wvw@google.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/thermal_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -299,7 +299,7 @@ static void thermal_zone_device_set_poll
 		mod_delayed_work(system_freezable_wq, &tz->poll_queue,
 				 msecs_to_jiffies(delay));
 	else
-		cancel_delayed_work_sync(&tz->poll_queue);
+		cancel_delayed_work(&tz->poll_queue);
 }
 
 static void monitor_thermal_zone(struct thermal_zone_device *tz)
@@ -1350,7 +1350,7 @@ void thermal_zone_device_unregister(stru
 
 	mutex_unlock(&thermal_list_lock);
 
-	thermal_zone_device_set_polling(tz, 0);
+	cancel_delayed_work_sync(&tz->poll_queue);
 
 	thermal_set_governor(tz, NULL);
 


