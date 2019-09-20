Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1EBB927F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388813AbfITOcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:32:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36452 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388271AbfITOZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqB-0004vq-SR; Fri, 20 Sep 2019 15:24:55 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqA-0007p6-UX; Fri, 20 Sep 2019 15:24:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Uwe Kleine-=?UTF-8?Q?K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        "Hoan Nguyen An" <na-hoan@jinso.co.jp>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Yoshihiro Shimoda" <yoshihiro.shimoda.uh@renesas.com>,
        "Simon Horman" <horms+renesas@verge.net.au>,
        "Phong Hoang" <phong.hoang.wz@renesas.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.864654857@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 007/132] pwm: Fix deadlock warning when removing PWM
 device
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Phong Hoang <phong.hoang.wz@renesas.com>

commit 347ab9480313737c0f1aaa08e8f2e1a791235535 upstream.

This patch fixes deadlock warning if removing PWM device
when CONFIG_PROVE_LOCKING is enabled.

This issue can be reproceduced by the following steps on
the R-Car H3 Salvator-X board if the backlight is disabled:

 # cd /sys/class/pwm/pwmchip0
 # echo 0 > export
 # ls
 device  export  npwm  power  pwm0  subsystem  uevent  unexport
 # cd device/driver
 # ls
 bind  e6e31000.pwm  uevent  unbind
 # echo e6e31000.pwm > unbind

[   87.659974] ======================================================
[   87.666149] WARNING: possible circular locking dependency detected
[   87.672327] 5.0.0 #7 Not tainted
[   87.675549] ------------------------------------------------------
[   87.681723] bash/2986 is trying to acquire lock:
[   87.686337] 000000005ea0e178 (kn->count#58){++++}, at: kernfs_remove_by_name_ns+0x50/0xa0
[   87.694528]
[   87.694528] but task is already holding lock:
[   87.700353] 000000006313b17c (pwm_lock){+.+.}, at: pwmchip_remove+0x28/0x13c
[   87.707405]
[   87.707405] which lock already depends on the new lock.
[   87.707405]
[   87.715574]
[   87.715574] the existing dependency chain (in reverse order) is:
[   87.723048]
[   87.723048] -> #1 (pwm_lock){+.+.}:
[   87.728017]        __mutex_lock+0x70/0x7e4
[   87.732108]        mutex_lock_nested+0x1c/0x24
[   87.736547]        pwm_request_from_chip.part.6+0x34/0x74
[   87.741940]        pwm_request_from_chip+0x20/0x40
[   87.746725]        export_store+0x6c/0x1f4
[   87.750820]        dev_attr_store+0x18/0x28
[   87.754998]        sysfs_kf_write+0x54/0x64
[   87.759175]        kernfs_fop_write+0xe4/0x1e8
[   87.763615]        __vfs_write+0x40/0x184
[   87.767619]        vfs_write+0xa8/0x19c
[   87.771448]        ksys_write+0x58/0xbc
[   87.775278]        __arm64_sys_write+0x18/0x20
[   87.779721]        el0_svc_common+0xd0/0x124
[   87.783986]        el0_svc_compat_handler+0x1c/0x24
[   87.788858]        el0_svc_compat+0x8/0x18
[   87.792947]
[   87.792947] -> #0 (kn->count#58){++++}:
[   87.798260]        lock_acquire+0xc4/0x22c
[   87.802353]        __kernfs_remove+0x258/0x2c4
[   87.806790]        kernfs_remove_by_name_ns+0x50/0xa0
[   87.811836]        remove_files.isra.1+0x38/0x78
[   87.816447]        sysfs_remove_group+0x48/0x98
[   87.820971]        sysfs_remove_groups+0x34/0x4c
[   87.825583]        device_remove_attrs+0x6c/0x7c
[   87.830197]        device_del+0x11c/0x33c
[   87.834201]        device_unregister+0x14/0x2c
[   87.838638]        pwmchip_sysfs_unexport+0x40/0x4c
[   87.843509]        pwmchip_remove+0xf4/0x13c
[   87.847773]        rcar_pwm_remove+0x28/0x34
[   87.852039]        platform_drv_remove+0x24/0x64
[   87.856651]        device_release_driver_internal+0x18c/0x21c
[   87.862391]        device_release_driver+0x14/0x1c
[   87.867175]        unbind_store+0xe0/0x124
[   87.871265]        drv_attr_store+0x20/0x30
[   87.875442]        sysfs_kf_write+0x54/0x64
[   87.879618]        kernfs_fop_write+0xe4/0x1e8
[   87.884055]        __vfs_write+0x40/0x184
[   87.888057]        vfs_write+0xa8/0x19c
[   87.891887]        ksys_write+0x58/0xbc
[   87.895716]        __arm64_sys_write+0x18/0x20
[   87.900154]        el0_svc_common+0xd0/0x124
[   87.904417]        el0_svc_compat_handler+0x1c/0x24
[   87.909289]        el0_svc_compat+0x8/0x18
[   87.913378]
[   87.913378] other info that might help us debug this:
[   87.913378]
[   87.921374]  Possible unsafe locking scenario:
[   87.921374]
[   87.927286]        CPU0                    CPU1
[   87.931808]        ----                    ----
[   87.936331]   lock(pwm_lock);
[   87.939293]                                lock(kn->count#58);
[   87.945120]                                lock(pwm_lock);
[   87.950599]   lock(kn->count#58);
[   87.953908]
[   87.953908]  *** DEADLOCK ***
[   87.953908]
[   87.959821] 4 locks held by bash/2986:
[   87.963563]  #0: 00000000ace7bc30 (sb_writers#6){.+.+}, at: vfs_write+0x188/0x19c
[   87.971044]  #1: 00000000287991b2 (&of->mutex){+.+.}, at: kernfs_fop_write+0xb4/0x1e8
[   87.978872]  #2: 00000000f739d016 (&dev->mutex){....}, at: device_release_driver_internal+0x40/0x21c
[   87.988001]  #3: 000000006313b17c (pwm_lock){+.+.}, at: pwmchip_remove+0x28/0x13c
[   87.995481]
[   87.995481] stack backtrace:
[   87.999836] CPU: 0 PID: 2986 Comm: bash Not tainted 5.0.0 #7
[   88.005489] Hardware name: Renesas Salvator-X board based on r8a7795 ES1.x (DT)
[   88.012791] Call trace:
[   88.015235]  dump_backtrace+0x0/0x190
[   88.018891]  show_stack+0x14/0x1c
[   88.022204]  dump_stack+0xb0/0xec
[   88.025514]  print_circular_bug.isra.32+0x1d0/0x2e0
[   88.030385]  __lock_acquire+0x1318/0x1864
[   88.034388]  lock_acquire+0xc4/0x22c
[   88.037958]  __kernfs_remove+0x258/0x2c4
[   88.041874]  kernfs_remove_by_name_ns+0x50/0xa0
[   88.046398]  remove_files.isra.1+0x38/0x78
[   88.050487]  sysfs_remove_group+0x48/0x98
[   88.054490]  sysfs_remove_groups+0x34/0x4c
[   88.058580]  device_remove_attrs+0x6c/0x7c
[   88.062671]  device_del+0x11c/0x33c
[   88.066154]  device_unregister+0x14/0x2c
[   88.070070]  pwmchip_sysfs_unexport+0x40/0x4c
[   88.074421]  pwmchip_remove+0xf4/0x13c
[   88.078163]  rcar_pwm_remove+0x28/0x34
[   88.081906]  platform_drv_remove+0x24/0x64
[   88.085996]  device_release_driver_internal+0x18c/0x21c
[   88.091215]  device_release_driver+0x14/0x1c
[   88.095478]  unbind_store+0xe0/0x124
[   88.099048]  drv_attr_store+0x20/0x30
[   88.102704]  sysfs_kf_write+0x54/0x64
[   88.106359]  kernfs_fop_write+0xe4/0x1e8
[   88.110275]  __vfs_write+0x40/0x184
[   88.113757]  vfs_write+0xa8/0x19c
[   88.117065]  ksys_write+0x58/0xbc
[   88.120374]  __arm64_sys_write+0x18/0x20
[   88.124291]  el0_svc_common+0xd0/0x124
[   88.128034]  el0_svc_compat_handler+0x1c/0x24
[   88.132384]  el0_svc_compat+0x8/0x18

The sysfs unexport in pwmchip_remove() is completely asymmetric
to what we do in pwmchip_add_with_polarity() and commit 0733424c9ba9
("pwm: Unexport children before chip removal") is a strong indication
that this was wrong to begin with. We should just move
pwmchip_sysfs_unexport() where it belongs, which is right after
pwmchip_sysfs_unexport_children(). In that case, we do not need
separate functions anymore either.

We also really want to remove sysfs irrespective of whether or not
the chip will be removed as a result of pwmchip_remove(). We can only
assume that the driver will be gone after that, so we shouldn't leave
any dangling sysfs files around.

This warning disappears if we move pwmchip_sysfs_unexport() to
the top of pwmchip_remove(), pwmchip_sysfs_unexport_children().
That way it is also outside of the pwm_lock section, which indeed
doesn't seem to be needed.

Moving the pwmchip_sysfs_export() call outside of that section also
seems fine and it'd be perfectly symmetric with pwmchip_remove() again.

So, this patch fixes them.

Signed-off-by: Phong Hoang <phong.hoang.wz@renesas.com>
[shimoda: revise the commit log and code]
Fixes: 76abbdde2d95 ("pwm: Add sysfs interface")
Fixes: 0733424c9ba9 ("pwm: Unexport children before chip removal")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Hoan Nguyen An <na-hoan@jinso.co.jp>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pwm/core.c  | 10 +++++-----
 drivers/pwm/sysfs.c | 14 +-------------
 include/linux/pwm.h |  5 -----
 3 files changed, 6 insertions(+), 23 deletions(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -273,10 +273,12 @@ int pwmchip_add(struct pwm_chip *chip)
 	if (IS_ENABLED(CONFIG_OF))
 		of_pwmchip_add(chip);
 
-	pwmchip_sysfs_export(chip);
-
 out:
 	mutex_unlock(&pwm_lock);
+
+	if (!ret)
+		pwmchip_sysfs_export(chip);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pwmchip_add);
@@ -293,7 +295,7 @@ int pwmchip_remove(struct pwm_chip *chip
 	unsigned int i;
 	int ret = 0;
 
-	pwmchip_sysfs_unexport_children(chip);
+	pwmchip_sysfs_unexport(chip);
 
 	mutex_lock(&pwm_lock);
 
@@ -313,8 +315,6 @@ int pwmchip_remove(struct pwm_chip *chip
 
 	free_pwms(chip);
 
-	pwmchip_sysfs_unexport(chip);
-
 out:
 	mutex_unlock(&pwm_lock);
 	return ret;
--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -330,19 +330,6 @@ void pwmchip_sysfs_export(struct pwm_chi
 void pwmchip_sysfs_unexport(struct pwm_chip *chip)
 {
 	struct device *parent;
-
-	parent = class_find_device(&pwm_class, NULL, chip,
-				   pwmchip_sysfs_match);
-	if (parent) {
-		/* for class_find_device() */
-		put_device(parent);
-		device_unregister(parent);
-	}
-}
-
-void pwmchip_sysfs_unexport_children(struct pwm_chip *chip)
-{
-	struct device *parent;
 	unsigned int i;
 
 	parent = class_find_device(&pwm_class, NULL, chip,
@@ -358,6 +345,7 @@ void pwmchip_sysfs_unexport_children(str
 	}
 
 	put_device(parent);
+	device_unregister(parent);
 }
 
 static int __init pwm_sysfs_init(void)
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -299,7 +299,6 @@ static inline void pwm_add_table(struct
 #ifdef CONFIG_PWM_SYSFS
 void pwmchip_sysfs_export(struct pwm_chip *chip);
 void pwmchip_sysfs_unexport(struct pwm_chip *chip);
-void pwmchip_sysfs_unexport_children(struct pwm_chip *chip);
 #else
 static inline void pwmchip_sysfs_export(struct pwm_chip *chip)
 {
@@ -308,10 +307,6 @@ static inline void pwmchip_sysfs_export(
 static inline void pwmchip_sysfs_unexport(struct pwm_chip *chip)
 {
 }
-
-static inline void pwmchip_sysfs_unexport_children(struct pwm_chip *chip)
-{
-}
 #endif /* CONFIG_PWM_SYSFS */
 
 #endif /* __LINUX_PWM_H */

