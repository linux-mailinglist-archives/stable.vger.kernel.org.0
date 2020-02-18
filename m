Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F21162E6D
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgBRSYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgBRSYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 13:24:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80AE024682;
        Tue, 18 Feb 2020 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582050242;
        bh=ASjGey5IRlaeQ/Z754o2YVsdRd0Ueh/TIybWHFvqs10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oh9z0R7uVWsNoanIfPLH6kzQEVZKdQuMFqGN2LdhZN66r5LvbdurCtGv6r2mqWCWQ
         D80LJJ8Zuj3A/WJMP3eu72JL35HM9RUUnyByMlq5aY3c2xVeAY/rbDhs0o/GtDyvXu
         2MolCJKYuoV+iRMHs5Q1SxjzLmKyiV2BhQ3xnk08=
Date:   Tue, 18 Feb 2020 19:23:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>, iommu@lists.linux-foundation.org,
        robdclark@gmail.com, bjorn.andersson@linaro.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        Will Deacon <will@kernel.org>, joro@8bytes.org,
        masneyb@onstation.org, lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>, robin.murphy@arm.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: drivers/iommu/qcom_iommu.c:348 qcom_iommu_domain_free+0x5c/0x70
Message-ID: <20200218182359.GC2635524@kroah.com>
References: <CA+G9fYtScOpkLvx=__gP903uJ2v87RwZgkAuL6RpF9_DTDs9Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtScOpkLvx=__gP903uJ2v87RwZgkAuL6RpF9_DTDs9Zw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 04:13:57PM +0530, Naresh Kamboju wrote:
> We have noticed these kernel warnings on APQ 8016 SBC  (dragonboard
> 410c ) running stable rc 5.5, 5.4 branches and linux mainline and
> linux-next master branches.
> 
> This warning started happening from linux mainline 5.3 onwards (2019-08-29)
> 
> [    5.488128] ------------[ cut here ]------------
> [    5.488161] WARNING: CPU: 3 PID: 221 at
> drivers/iommu/qcom_iommu.c:348 qcom_iommu_domain_free+0x5c/0x70
> [    5.491817] Modules linked in: crct10dif_ce(+) adv7511(+) cec
> msm(+) mdt_loader drm_kms_helper drm fuse
> [    5.491842] CPU: 3 PID: 221 Comm: systemd-udevd Not tainted
> 5.4.21-rc1-00037-g6f8f5c79416e #1
> [    5.491844] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [    5.491849] pstate: 00000005 (nzcv daif -PAN -UAO)
> [    5.491858] pc : qcom_iommu_domain_free+0x5c/0x70
> [    5.491865] lr : iommu_group_release+0x44/0x60
> [    5.491867] sp : ffff800011e83600
>          Starting Network Manager...[    5.491870] x29:
> ffff800011e83600 x28: 0000000000000100
> [    5.491893] x19: ffff000036a9e500 x18: 0000000000000001
> [    5.491898] x17: 0000000000000000 x16: 0000000000000000
> [    5.491902] x15: 0000000000000004 x14: 0000000000000000
> [    5.491907] x13: 0000000000000000 x12: ffff00003a137aa0
> [    5.491911] x11: ffff00003a137908 x10: 0000000000000000
> [    5.491916] x9 : ffff00000eb2c098 x8 : ffff00000eb2c090
> [    5.491920] x7 : 00000000400c0000 x6 : 0000000000000004
> [    5.491924] x5 : 0000000000000001 x4 : 0000000000000000
> [    5.491929] x3 : 0000000000000000 x2 : 0000000000000000
> [    5.491933] x1 : ffff00003bdb9680 x0 : ffff000036aa0ab0
> [    5.491938] Call trace:
> [    5.491946]  qcom_iommu_domain_free+0x5c/0x70
> [    5.491951]  iommu_group_release+0x44/0x60
> [    5.491957]  kobject_put+0x6c/0xf0
> [    5.491962]  kobject_del+0x50/0x68
> [    5.491966]  kobject_put+0xd0/0xf0
> [    5.491972]  iommu_group_remove_device+0xd8/0xec
> [    5.491977]  qcom_iommu_remove_device+0x44/0x60
> [    5.491982]  iommu_release_device+0x28/0x40
> [    5.491987]  iommu_bus_notifier+0xac/0xc0
> [    5.491993]  notifier_call_chain+0x58/0x98
> [    5.491998]  blocking_notifier_call_chain+0x54/0x78
> [    5.492003]  device_del+0x224/0x348
> [    5.492008]  platform_device_del.part.0+0x18/0x88
> [    5.492012]  platform_device_unregister+0x20/0x38
> [    5.492019]  of_platform_device_destroy+0xdc/0xf0
> [    5.492023]  device_for_each_child+0x58/0xa0
> [    5.492028]  of_platform_depopulate+0x38/0x78
> [    5.492155]  msm_pdev_probe+0x1c0/0x308 [msm]
> [    5.492166]  platform_drv_probe+0x50/0xa0
> [    5.682404]  really_probe+0xd4/0x308
> [    5.686388]  driver_probe_device+0x54/0xe8
> [    5.690035]  device_driver_attach+0x6c/0x78
> [    5.693940]  __driver_attach+0x54/0xd0
> [    5.698020]  bus_for_each_dev+0x6c/0xc0
> [    5.701838]  driver_attach+0x20/0x28
> [    5.705572]  bus_add_driver+0x140/0x1e8
> [    5.709390]  driver_register+0x60/0x110
> [    5.712950]  __platform_driver_register+0x44/0x50
> [    5.716886]  msm_drm_register+0x54/0x68 [msm]
> [    5.721633]  do_one_initcall+0x50/0x190
> [    5.725972]  do_init_module+0x50/0x208
> [    5.729615]  load_module+0x1d1c/0x2298
> [    5.733435]  __do_sys_finit_module+0xd0/0xe8
> [    5.737169]  __arm64_sys_finit_module+0x1c/0x28
> [    5.741598]  el0_svc_common.constprop.0+0x68/0x160
> [    5.745851]  el0_svc_handler+0x20/0x80
> [    5.750709]  el0_svc+0x8/0xc
> [    5.754443] ---[ end trace 0ebe200932dd18fc ]---
> 
> 
> Full test log link,
> https://lkft.validation.linaro.org/scheduler/job/1226062#L3841
> https://lkft.validation.linaro.org/scheduler/job/1227242#L3877
> 
> Ref:
> https://bugs.linaro.org/show_bug.cgi?id=5460

Can you bisect to find the offending commit?

thanks,

greg k-h
