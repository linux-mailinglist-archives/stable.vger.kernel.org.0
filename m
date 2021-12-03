Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C918D4676D1
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 12:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhLCL4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 06:56:54 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:54819 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhLCL4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 06:56:53 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J5B6Y3zCCz4xR9;
        Fri,  3 Dec 2021 22:53:25 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     benh@kernel.crashing.org, chunkeey@gmail.com,
        gregkh@linuxfoundation.org, hurricos@gmail.com,
        chenhui.zhao@freescale.com, stable@vger.kernel.org,
        Xiaoming Ni <nixiaoming@huawei.com>, wangle6@huawei.com,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        oss@buserror.net, paulus@samba.org, chenjianguo3@huawei.com,
        linux-kernel@vger.kernel.org, liuwenliang@huawei.com,
        Yuantian.Tang@feescale.com, paul.gortmaker@windriver.com
In-Reply-To: <20211126041153.16926-1-nixiaoming@huawei.com>
References: <5f56f1af-9404-21fa-eda0-05a75d769427@huawei.com> <20211126041153.16926-1-nixiaoming@huawei.com>
Subject: Re: [PATCH] powerpc/85xx: fix oops when CONFIG_FSL_PMC=n
Message-Id: <163853238100.2903976.13035103513287667638.b4-ty@ellerman.id.au>
Date:   Fri, 03 Dec 2021 22:53:01 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Nov 2021 12:11:53 +0800, Xiaoming Ni wrote:
> When CONFIG_FSL_PMC is set to n, no value is assigned to cpu_up_prepare
>  in the mpc85xx_pm_ops structure. As a result, oops is triggered in
>  smp_85xx_start_cpu().
> 
> 	[    0.627233] smp: Bringing up secondary CPUs ...
> 	[    0.681659] kernel tried to execute user page (0) - exploit attempt? (uid: 0)
> 	[    0.766618] BUG: Unable to handle kernel instruction fetch (NULL pointer?)
> 	[    0.848899] Faulting instruction address: 0x00000000
> 	[    0.908273] Oops: Kernel access of bad area, sig: 11 [#1]
> 	...
> 	[    1.758220] NIP [00000000] 0x0
> 	[    1.794688] LR [c0021d2c] smp_85xx_kick_cpu+0xe8/0x568
> 	[    1.856126] Call Trace:
> 	[    1.885295] [c1051da8] [c0021cb8] smp_85xx_kick_cpu+0x74/0x568 (unreliable)
> 	[    1.968633] [c1051de8] [c0011460] __cpu_up+0xc0/0x228
> 	[    2.029038] [c1051e18] [c0031bbc] bringup_cpu+0x30/0x224
> 	[    2.092572] [c1051e48] [c0031f3c] cpu_up.constprop.0+0x180/0x33c
> 	[    2.164443] [c1051e88] [c00322e8] bringup_nonboot_cpus+0x88/0xc8
> 	[    2.236326] [c1051eb8] [c07e67bc] smp_init+0x30/0x78
> 	[    2.295698] [c1051ed8] [c07d9e28] kernel_init_freeable+0x118/0x2a8
> 	[    2.369641] [c1051f18] [c00032d8] kernel_init+0x14/0x124
> 	[    2.433176] [c1051f38] [c0010278] ret_from_kernel_thread+0x14/0x1c
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/85xx: fix oops when CONFIG_FSL_PMC=n
      https://git.kernel.org/powerpc/c/3dc709e518b47386e6af937eaec37bb36539edfd

cheers
