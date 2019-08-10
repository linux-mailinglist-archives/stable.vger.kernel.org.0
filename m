Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B3C88D60
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfHJUp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:45:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55492 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfHJUoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDf-00053Y-02; Sat, 10 Aug 2019 21:44:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003c6-Ew; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Fabrice Gasnier" <fabrice.gasnier@st.com>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.457406167@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 058/157] iio: core: fix a possible circular locking
 dependency
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Gasnier <fabrice.gasnier@st.com>

commit 7f75591fc5a123929a29636834d1bcb8b5c9fee3 upstream.

This fixes a possible circular locking dependency detected warning seen
with:
- CONFIG_PROVE_LOCKING=y
- consumer/provider IIO devices (ex: "voltage-divider" consumer of "adc")

When using the IIO consumer interface, e.g. iio_channel_get(), the consumer
device will likely call iio_read_channel_raw() or similar that rely on
'info_exist_lock' mutex.

typically:
...
	mutex_lock(&chan->indio_dev->info_exist_lock);
	if (chan->indio_dev->info == NULL) {
		ret = -ENODEV;
		goto err_unlock;
	}
	ret = do_some_ops()
err_unlock:
	mutex_unlock(&chan->indio_dev->info_exist_lock);
	return ret;
...

Same mutex is also hold in iio_device_unregister().

The following deadlock warning happens when:
- the consumer device has called an API like iio_read_channel_raw()
  at least once.
- the consumer driver is unregistered, removed (unbind from sysfs)

======================================================
WARNING: possible circular locking dependency detected
4.19.24 #577 Not tainted
------------------------------------------------------
sh/372 is trying to acquire lock:
(kn->count#30){++++}, at: kernfs_remove_by_name_ns+0x3c/0x84

but task is already holding lock:
(&dev->info_exist_lock){+.+.}, at: iio_device_unregister+0x18/0x60

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&dev->info_exist_lock){+.+.}:
       __mutex_lock+0x70/0xa3c
       mutex_lock_nested+0x1c/0x24
       iio_read_channel_raw+0x1c/0x60
       iio_read_channel_info+0xa8/0xb0
       dev_attr_show+0x1c/0x48
       sysfs_kf_seq_show+0x84/0xec
       seq_read+0x154/0x528
       __vfs_read+0x2c/0x15c
       vfs_read+0x8c/0x110
       ksys_read+0x4c/0xac
       ret_fast_syscall+0x0/0x28
       0xbedefb60

-> #0 (kn->count#30){++++}:
       lock_acquire+0xd8/0x268
       __kernfs_remove+0x288/0x374
       kernfs_remove_by_name_ns+0x3c/0x84
       remove_files+0x34/0x78
       sysfs_remove_group+0x40/0x9c
       sysfs_remove_groups+0x24/0x34
       device_remove_attrs+0x38/0x64
       device_del+0x11c/0x360
       cdev_device_del+0x14/0x2c
       iio_device_unregister+0x24/0x60
       release_nodes+0x1bc/0x200
       device_release_driver_internal+0x1a0/0x230
       unbind_store+0x80/0x130
       kernfs_fop_write+0x100/0x1e4
       __vfs_write+0x2c/0x160
       vfs_write+0xa4/0x17c
       ksys_write+0x4c/0xac
       ret_fast_syscall+0x0/0x28
       0xbe906840

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&dev->info_exist_lock);
                               lock(kn->count#30);
                               lock(&dev->info_exist_lock);
  lock(kn->count#30);

 *** DEADLOCK ***
...

cdev_device_del() can be called without holding the lock. It should be safe
as info_exist_lock prevents kernelspace consumers to use the exported
routines during/after provider removal. cdev_device_del() is for userspace.

Help to reproduce:
See example: Documentation/devicetree/bindings/iio/afe/voltage-divider.txt
sysv {
	compatible = "voltage-divider";
	io-channels = <&adc 0>;
	output-ohms = <22>;
	full-ohms = <222>;
};

First, go to iio:deviceX for the "voltage-divider", do one read:
$ cd /sys/bus/iio/devices/iio:deviceX
$ cat in_voltage0_raw

Then, unbind the consumer driver. It triggers above deadlock warning.
$ cd /sys/bus/platform/drivers/iio-rescale/
$ echo sysv > unbind

Note I don't actually expect stable will pick this up all the
way back into IIO being in staging, but if's probably valid that
far back.

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Fixes: ac917a81117c ("staging:iio:core set the iio_dev.info pointer to null on unregister")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iio/industrialio-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1195,12 +1195,12 @@ EXPORT_SYMBOL(iio_device_register);
  **/
 void iio_device_unregister(struct iio_dev *indio_dev)
 {
-	mutex_lock(&indio_dev->info_exist_lock);
-
 	device_del(&indio_dev->dev);
 
 	if (indio_dev->chrdev.dev)
 		cdev_del(&indio_dev->chrdev);
+
+	mutex_lock(&indio_dev->info_exist_lock);
 	iio_device_unregister_debugfs(indio_dev);
 
 	iio_disable_all_buffers(indio_dev);

