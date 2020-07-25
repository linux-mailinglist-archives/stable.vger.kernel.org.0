Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE95C22D569
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 08:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgGYGTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 02:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgGYGTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jul 2020 02:19:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A56206EB;
        Sat, 25 Jul 2020 06:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595657987;
        bh=J2L0riOBWuAUkavooTu75NP58MvqxirhPkMr/0JIWT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xf1x+ibdSvIvQkgJK+2vMJGd8x+vFbpsVxLDoISZoKzTGimfKHntQhmXVbK8OLXKv
         IhWHS4+/K8jif0PrXujoR0ku2ctP1G38qAwpI4AdQ1NetXuUQP1nn+lfeUzWKw597b
         +fX2sTAcArwqvDHy74GXZ5HsFPHhSSVHLiAW5WyM=
Date:   Sat, 25 Jul 2020 08:19:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Fix parameter type in function pointer
 prototype
Message-ID: <20200725061947.GA1051290@kroah.com>
References: <20200725060354.177009-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725060354.177009-1-natechancellor@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 24, 2020 at 11:03:54PM -0700, Nathan Chancellor wrote:
> When booting up on a Raspberry Pi 4 with Control Flow Integrity checking
> enabled, the following warning/panic happens:
> 
> [    1.626435] CFI failure (target: dwc2_set_bcm_params+0x0/0x4):
> [    1.632408] WARNING: CPU: 0 PID: 32 at kernel/cfi.c:30 __cfi_check_fail+0x54/0x5c
> [    1.640021] Modules linked in:
> [    1.643137] CPU: 0 PID: 32 Comm: kworker/0:1 Not tainted 5.8.0-rc6-next-20200724-00051-g89ba619726de #1
> [    1.652693] Hardware name: Raspberry Pi 4 Model B Rev 1.2 (DT)
> [    1.658637] Workqueue: events deferred_probe_work_func
> [    1.663870] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
> [    1.669542] pc : __cfi_check_fail+0x54/0x5c
> [    1.673798] lr : __cfi_check_fail+0x54/0x5c
> [    1.678050] sp : ffff8000102bbaa0
> [    1.681419] x29: ffff8000102bbaa0 x28: ffffab09e21c7000
> [    1.686829] x27: 0000000000000402 x26: ffff0000f6e7c228
> [    1.692238] x25: 00000000fb7cdb0d x24: 0000000000000005
> [    1.697647] x23: ffffab09e2515000 x22: ffffab09e069a000
> [    1.703055] x21: 4c550309df1cf4c1 x20: ffffab09e2433c60
> [    1.708462] x19: ffffab09e160dc50 x18: ffff0000f6e8cc78
> [    1.713870] x17: 0000000000000041 x16: ffffab09e0bce6f8
> [    1.719278] x15: ffffab09e1c819b7 x14: 0000000000000003
> [    1.724686] x13: 00000000ffffefff x12: 0000000000000000
> [    1.730094] x11: 0000000000000000 x10: 00000000ffffffff
> [    1.735501] x9 : c932f7abfc4bc600 x8 : c932f7abfc4bc600
> [    1.740910] x7 : 077207610770075f x6 : ffff0000f6c38f00
> [    1.746317] x5 : 0000000000000000 x4 : 0000000000000000
> [    1.751723] x3 : 0000000000000000 x2 : 0000000000000000
> [    1.757129] x1 : ffff8000102bb7d8 x0 : 0000000000000032
> [    1.762539] Call trace:
> [    1.765030]  __cfi_check_fail+0x54/0x5c
> [    1.768938]  __cfi_check+0x5fa6c/0x66afc
> [    1.772932]  dwc2_init_params+0xd74/0xd78
> [    1.777012]  dwc2_driver_probe+0x484/0x6ec
> [    1.781180]  platform_drv_probe+0xb4/0x100
> [    1.785350]  really_probe+0x228/0x63c
> [    1.789076]  driver_probe_device+0x80/0xc0
> [    1.793247]  __device_attach_driver+0x114/0x160
> [    1.797857]  bus_for_each_drv+0xa8/0x128
> [    1.801851]  __device_attach.llvm.14901095709067289134+0xc0/0x170
> [    1.808050]  bus_probe_device+0x44/0x100
> [    1.812044]  deferred_probe_work_func+0x78/0xb8
> [    1.816656]  process_one_work+0x204/0x3c4
> [    1.820736]  worker_thread+0x2f0/0x4c4
> [    1.824552]  kthread+0x174/0x184
> [    1.827837]  ret_from_fork+0x10/0x18
> 
> CFI validates that all indirect calls go to a function with the same
> exact function pointer prototype. In this case, dwc2_set_bcm_params
> is the target, which has a parameter of type 'struct dwc2_hsotg *',
> but it is being implicitly cast to have a parameter of type 'void *'
> because that is the set_params function pointer prototype. Make the
> function pointer protoype match the definitions so that there is no
> more violation.
> 
> Cc: stable@vger.kernel.org

Why does this matter for stable kernels, given that CFI is not in any
kernel tree yet?

thanks,

greg k-h
