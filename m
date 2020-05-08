Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2CF1CAD0D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgEHMyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730168AbgEHMyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B0F24959;
        Fri,  8 May 2020 12:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942450;
        bh=fz6CLdUpCDSaLjd3B3xuSOgy4BelqdfkSdmnrAQkoOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZG+RoErcyKAeBQddOpMwr+BMhJIRQebu5GWIq1e4LP/5uQ5yPtxVjxvdrju4OzMU6
         XrhO3vKWcv3fh69RUN64ifXV1R/vq3SZVrG55psDE9zR4gDpwolHZ6n8CNRXLBP/6M
         crSImXLq5gNns3KvDuIC+IAa8WRNg7a188vusc/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 50/50] PM / devfreq: Add missing locking while setting suspend_freq
Date:   Fri,  8 May 2020 14:35:56 +0200
Message-Id: <20200508123049.823407886@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit e1e047ace8cef6d143f38c7d769753f133becbe6 upstream.

Commit 2abb0d5268ae ("PM / devfreq: Lock devfreq in trans_stat_show")
revealed a missing locking while calling devfreq_update_status() function
during suspend/resume cycle.

Code analysis revealed that devfreq_set_target() function was called
without needed locks held for setting device specific suspend_freq if such
has been defined. This patch fixes that by adding the needed locking, what
fixes following kernel warning on Exynos4412-based OdroidU3 board during
system suspend:

PM: suspend entry (deep)
Filesystems sync: 0.002 seconds
Freezing user space processes ... (elapsed 0.001 seconds) done.
OOM killer disabled.
Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
------------[ cut here ]------------
WARNING: CPU: 2 PID: 1385 at drivers/devfreq/devfreq.c:204 devfreq_update_status+0xc0/0x188
Modules linked in:
CPU: 2 PID: 1385 Comm: rtcwake Not tainted 5.4.0-rc6-next-20191111 #6848
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[<c0112588>] (unwind_backtrace) from [<c010e070>] (show_stack+0x10/0x14)
[<c010e070>] (show_stack) from [<c0afb010>] (dump_stack+0xb4/0xe0)
[<c0afb010>] (dump_stack) from [<c01272e0>] (__warn+0xf4/0x10c)
[<c01272e0>] (__warn) from [<c01273a8>] (warn_slowpath_fmt+0xb0/0xb8)
[<c01273a8>] (warn_slowpath_fmt) from [<c07d105c>] (devfreq_update_status+0xc0/0x188)
[<c07d105c>] (devfreq_update_status) from [<c07d2d70>] (devfreq_set_target+0xb0/0x15c)
[<c07d2d70>] (devfreq_set_target) from [<c07d3598>] (devfreq_suspend+0x2c/0x64)
[<c07d3598>] (devfreq_suspend) from [<c05de0b0>] (dpm_suspend+0xa4/0x57c)
[<c05de0b0>] (dpm_suspend) from [<c05def74>] (dpm_suspend_start+0x98/0xa0)
[<c05def74>] (dpm_suspend_start) from [<c0195b58>] (suspend_devices_and_enter+0xec/0xc74)
[<c0195b58>] (suspend_devices_and_enter) from [<c0196a20>] (pm_suspend+0x340/0x410)
[<c0196a20>] (pm_suspend) from [<c019480c>] (state_store+0x6c/0xc8)
[<c019480c>] (state_store) from [<c033fc50>] (kernfs_fop_write+0x10c/0x228)
[<c033fc50>] (kernfs_fop_write) from [<c02a6d3c>] (__vfs_write+0x30/0x1d0)
[<c02a6d3c>] (__vfs_write) from [<c02a9afc>] (vfs_write+0xa4/0x180)
[<c02a9afc>] (vfs_write) from [<c02a9d58>] (ksys_write+0x60/0xd8)
[<c02a9d58>] (ksys_write) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xed3d7fa8 to 0xed3d7ff0)
...
irq event stamp: 9667
hardirqs last  enabled at (9679): [<c0b1e7c4>] _raw_spin_unlock_irq+0x20/0x58
hardirqs last disabled at (9698): [<c0b16a20>] __schedule+0xd8/0x818
softirqs last  enabled at (9694): [<c01026fc>] __do_softirq+0x4fc/0x5fc
softirqs last disabled at (9719): [<c012fe68>] irq_exit+0x16c/0x170
---[ end trace 41ac5b57d046bdbc ]---
------------[ cut here ]------------

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/devfreq/devfreq.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -902,7 +902,9 @@ int devfreq_suspend_device(struct devfre
 	}
 
 	if (devfreq->suspend_freq) {
+		mutex_lock(&devfreq->lock);
 		ret = devfreq_set_target(devfreq, devfreq->suspend_freq, 0);
+		mutex_unlock(&devfreq->lock);
 		if (ret)
 			return ret;
 	}
@@ -930,7 +932,9 @@ int devfreq_resume_device(struct devfreq
 		return 0;
 
 	if (devfreq->resume_freq) {
+		mutex_lock(&devfreq->lock);
 		ret = devfreq_set_target(devfreq, devfreq->resume_freq, 0);
+		mutex_unlock(&devfreq->lock);
 		if (ret)
 			return ret;
 	}


