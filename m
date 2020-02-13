Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B545E15C329
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgBMP23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbgBMP22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:28 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE77A24670;
        Thu, 13 Feb 2020 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607707;
        bh=1T+Lv6dwQdwoLEOM6RoG5dOCBu5C2Z81q1Ngfj7iuFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r720+GrPFtJM1glCYM7Lt2+/U9HdBPaR0N1TDX1chhtzSbOGSv2DBx15+hOPJVjgu
         cdaA4UUieeCi0KoFMaPLd6nRE8NH90iiPAc6Dg/HUc+NBjTpK5reA8lHnE1xhsNlMt
         D6a4Qzarl1R20vOWyExA98bTan+aTgsONNvOCxXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.5 043/120] netdevsim: fix using uninitialized resources
Date:   Thu, 13 Feb 2020 07:20:39 -0800
Message-Id: <20200213151916.309670182@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit f5cd21605ecd249e5fc715411df22cc1bc877b32 upstream.

When module is being initialized, __init() calls bus_register() and
driver_register().
These functions internally create various resources and sysfs files.
The sysfs files are used for basic operations(add/del device).
/sys/bus/netdevsim/new_device
/sys/bus/netdevsim/del_device

These sysfs files use netdevsim resources, they are mostly allocated
and initialized in ->probe() function, which is nsim_dev_probe().
But, sysfs files could be executed before ->probe() is finished.
So, accessing uninitialized data would occur.

Another problem is very similar.
/sys/bus/netdevsim/new_device internally creates sysfs files.
/sys/devices/netdevsim<id>/new_port
/sys/devices/netdevsim<id>/del_port

These sysfs files also use netdevsim resources, they are mostly allocated
and initialized in creating device routine, which is nsim_bus_dev_new().
But they also could be executed before nsim_bus_dev_new() is finished.
So, accessing uninitialized data would occur.

To fix these problems, this patch adds flags, which means whether the
operation is finished or not.
The flag variable 'nsim_bus_enable' means whether netdevsim bus was
initialized or not.
This is protected by nsim_bus_dev_list_lock.
The flag variable 'nsim_bus_dev->init' means whether nsim_bus_dev was
initialized or not.
This could be used in {new/del}_port_store() with no lock.

Test commands:
    #SHELL1
    modprobe netdevsim
    while :
    do
        echo "1 1" > /sys/bus/netdevsim/new_device
        echo "1 1" > /sys/bus/netdevsim/del_device
    done

    #SHELL2
    while :
    do
        echo 1 > /sys/devices/netdevsim1/new_port
        echo 1 > /sys/devices/netdevsim1/del_port
    done

Splat looks like:
[   47.508954][ T1008] general protection fault, probably for non-canonical address 0xdffffc0000000021: 0000 I
[   47.510793][ T1008] KASAN: null-ptr-deref in range [0x0000000000000108-0x000000000000010f]
[   47.511963][ T1008] CPU: 2 PID: 1008 Comm: bash Not tainted 5.5.0+ #322
[   47.512823][ T1008] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   47.514041][ T1008] RIP: 0010:__mutex_lock+0x10a/0x14b0
[   47.514699][ T1008] Code: 08 84 d2 0f 85 7f 12 00 00 44 8b 0d 10 23 65 02 45 85 c9 75 29 49 8d 7f 68 48 b8 00 00 00 0f
[   47.517163][ T1008] RSP: 0018:ffff888059b4fbb0 EFLAGS: 00010206
[   47.517802][ T1008] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   47.518941][ T1008] RDX: 0000000000000021 RSI: ffffffff85926440 RDI: 0000000000000108
[   47.519732][ T1008] RBP: ffff888059b4fd30 R08: ffffffffc073fad0 R09: 0000000000000000
[   47.520729][ T1008] R10: ffff888059b4fd50 R11: ffff88804bb38040 R12: 0000000000000000
[   47.521702][ T1008] R13: dffffc0000000000 R14: ffffffff871976c0 R15: 00000000000000a0
[   47.522760][ T1008] FS:  00007fd4be05a740(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[   47.523877][ T1008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   47.524627][ T1008] CR2: 0000561c82b69cf0 CR3: 0000000065dd6004 CR4: 00000000000606e0
[   47.527662][ T1008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   47.528604][ T1008] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   47.529531][ T1008] Call Trace:
[   47.529874][ T1008]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[   47.530470][ T1008]  ? mutex_lock_io_nested+0x1380/0x1380
[   47.531018][ T1008]  ? _kstrtoull+0x76/0x160
[   47.531449][ T1008]  ? _parse_integer+0xf0/0xf0
[   47.531874][ T1008]  ? kernfs_fop_write+0x1cf/0x410
[   47.532330][ T1008]  ? sysfs_file_ops+0x160/0x160
[   47.532773][ T1008]  ? kstrtouint+0x86/0x110
[   47.533168][ T1008]  ? nsim_dev_port_add+0x50/0x150 [netdevsim]
[   47.533721][ T1008]  nsim_dev_port_add+0x50/0x150 [netdevsim]
[   47.534336][ T1008]  ? sysfs_file_ops+0x160/0x160
[   47.534858][ T1008]  new_port_store+0x99/0xb0 [netdevsim]
[   47.535439][ T1008]  ? del_port_store+0xb0/0xb0 [netdevsim]
[   47.536035][ T1008]  ? sysfs_file_ops+0x112/0x160
[   47.536544][ T1008]  ? sysfs_kf_write+0x3b/0x180
[   47.537029][ T1008]  kernfs_fop_write+0x276/0x410
[   47.537548][ T1008]  ? __sb_start_write+0x215/0x2e0
[   47.538110][ T1008]  vfs_write+0x197/0x4a0
[ ... ]

Fixes: f9d9db47d3ba ("netdevsim: add bus attributes to add new and delete devices")
Fixes: 794b2c05ca1c ("netdevsim: extend device attrs to support port addition and deletion")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/netdevsim/bus.c       |   43 +++++++++++++++++++++++++++++++++++---
 drivers/net/netdevsim/netdevsim.h |    1 
 2 files changed, 41 insertions(+), 3 deletions(-)

--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -17,6 +17,7 @@
 static DEFINE_IDA(nsim_bus_dev_ids);
 static LIST_HEAD(nsim_bus_dev_list);
 static DEFINE_MUTEX(nsim_bus_dev_list_lock);
+static bool nsim_bus_enable;
 
 static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 {
@@ -99,6 +100,9 @@ new_port_store(struct device *dev, struc
 	unsigned int port_index;
 	int ret;
 
+	/* Prevent to use nsim_bus_dev before initialization. */
+	if (!smp_load_acquire(&nsim_bus_dev->init))
+		return -EBUSY;
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
@@ -116,6 +120,9 @@ del_port_store(struct device *dev, struc
 	unsigned int port_index;
 	int ret;
 
+	/* Prevent to use nsim_bus_dev before initialization. */
+	if (!smp_load_acquire(&nsim_bus_dev->init))
+		return -EBUSY;
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
@@ -179,15 +186,30 @@ new_device_store(struct bus_type *bus, c
 		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
 		return -EINVAL;
 	}
-	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
-	if (IS_ERR(nsim_bus_dev))
-		return PTR_ERR(nsim_bus_dev);
 
 	mutex_lock(&nsim_bus_dev_list_lock);
+	/* Prevent to use resource before initialization. */
+	if (!smp_load_acquire(&nsim_bus_enable)) {
+		err = -EBUSY;
+		goto err;
+	}
+
+	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
+	if (IS_ERR(nsim_bus_dev)) {
+		err = PTR_ERR(nsim_bus_dev);
+		goto err;
+	}
+
+	/* Allow using nsim_bus_dev */
+	smp_store_release(&nsim_bus_dev->init, true);
+
 	list_add_tail(&nsim_bus_dev->list, &nsim_bus_dev_list);
 	mutex_unlock(&nsim_bus_dev_list_lock);
 
 	return count;
+err:
+	mutex_unlock(&nsim_bus_dev_list_lock);
+	return err;
 }
 static BUS_ATTR_WO(new_device);
 
@@ -215,6 +237,11 @@ del_device_store(struct bus_type *bus, c
 
 	err = -ENOENT;
 	mutex_lock(&nsim_bus_dev_list_lock);
+	/* Prevent to use resource before initialization. */
+	if (!smp_load_acquire(&nsim_bus_enable)) {
+		mutex_unlock(&nsim_bus_dev_list_lock);
+		return -EBUSY;
+	}
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		if (nsim_bus_dev->dev.id != id)
 			continue;
@@ -284,6 +311,8 @@ nsim_bus_dev_new(unsigned int id, unsign
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
+	/* Disallow using nsim_bus_dev */
+	smp_store_release(&nsim_bus_dev->init, false);
 
 	err = device_register(&nsim_bus_dev->dev);
 	if (err)
@@ -299,6 +328,8 @@ err_nsim_bus_dev_free:
 
 static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 {
+	/* Disallow using nsim_bus_dev */
+	smp_store_release(&nsim_bus_dev->init, false);
 	device_unregister(&nsim_bus_dev->dev);
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
 	kfree(nsim_bus_dev);
@@ -320,6 +351,8 @@ int nsim_bus_init(void)
 	err = driver_register(&nsim_driver);
 	if (err)
 		goto err_bus_unregister;
+	/* Allow using resources */
+	smp_store_release(&nsim_bus_enable, true);
 	return 0;
 
 err_bus_unregister:
@@ -331,12 +364,16 @@ void nsim_bus_exit(void)
 {
 	struct nsim_bus_dev *nsim_bus_dev, *tmp;
 
+	/* Disallow using resources */
+	smp_store_release(&nsim_bus_enable, false);
+
 	mutex_lock(&nsim_bus_dev_list_lock);
 	list_for_each_entry_safe(nsim_bus_dev, tmp, &nsim_bus_dev_list, list) {
 		list_del(&nsim_bus_dev->list);
 		nsim_bus_dev_del(nsim_bus_dev);
 	}
 	mutex_unlock(&nsim_bus_dev_list_lock);
+
 	driver_unregister(&nsim_driver);
 	bus_unregister(&nsim_bus);
 }
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -240,6 +240,7 @@ struct nsim_bus_dev {
 				  */
 	unsigned int num_vfs;
 	struct nsim_vf_config *vfconfigs;
+	bool init;
 };
 
 int nsim_bus_init(void);


