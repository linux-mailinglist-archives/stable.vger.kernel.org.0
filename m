Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891DB12E156
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 01:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgABAgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 19:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbgABAgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 19:36:31 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C804D20848;
        Thu,  2 Jan 2020 00:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577925391;
        bh=fNIJlGvvPGg0qmPlvCJOygYOQjbjNLfoqlRn7e+vbgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e9340Kk+OyNObH2elbuU5QMncIsnZK9cS8XU7UVM/dsBG6z1KmYpdGnivQtktnjYy
         TOQLI4PL9yEMhcbvmD23ttMlFhFC+TdKfeR3ZuaXfxBF0+0Z//O4IRHYuo6XZIFBRn
         2CNIdKZSAYcJ9L2cGCOMSGArdO0p0ewezLfcJaSQ=
Date:   Wed, 1 Jan 2020 19:36:29 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     christophe.leroy@c-s.fr, broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: fsl: don't map irq during probe"
 failed to apply to 4.19-stable tree
Message-ID: <20200102003629.GA16372@sasha-vm>
References: <157762920917019@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157762920917019@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 03:20:09PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 3194d2533efffae8b815d84729ecc58b6a9000ab Mon Sep 17 00:00:00 2001
>From: Christophe Leroy <christophe.leroy@c-s.fr>
>Date: Mon, 9 Dec 2019 15:27:27 +0000
>Subject: [PATCH] spi: fsl: don't map irq during probe
>
>With lastest kernel, the following warning is observed at startup:
>
>[    1.500609] ------------[ cut here ]------------
>[    1.505225] remove_proc_entry: removing non-empty directory 'irq/22', leaking at least 'fsl_spi'
>[    1.514234] WARNING: CPU: 0 PID: 1 at fs/proc/generic.c:682 remove_proc_entry+0x198/0x1c0
>[    1.522403] CPU: 0 PID: 1 Comm: swapper Not tainted 5.4.0-s3k-dev-02248-g93532430a4ff #2564
>[    1.530724] NIP:  c0197694 LR: c0197694 CTR: c0050d80
>[    1.535762] REGS: df4a5af0 TRAP: 0700   Not tainted  (5.4.0-02248-g93532430a4ff)
>[    1.543818] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 22028222  XER: 00000000
>[    1.550524]
>[    1.550524] GPR00: c0197694 df4a5ba8 df4a0000 00000054 00000000 00000000 00004a38 00000010
>[    1.550524] GPR08: c07c5a30 00000800 00000000 00001032 22000208 00000000 c0004b14 00000000
>[    1.550524] GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 c0830000 c07fc078
>[    1.550524] GPR24: c08e8ca0 df665d10 df60ea98 c07c9db8 00000001 df5d5ae3 df5d5a80 df43f8e3
>[    1.585327] NIP [c0197694] remove_proc_entry+0x198/0x1c0
>[    1.590628] LR [c0197694] remove_proc_entry+0x198/0x1c0
>[    1.595829] Call Trace:
>[    1.598280] [df4a5ba8] [c0197694] remove_proc_entry+0x198/0x1c0 (unreliable)
>[    1.605321] [df4a5bd8] [c0067acc] unregister_irq_proc+0x5c/0x70
>[    1.611238] [df4a5bf8] [c005fbc4] free_desc+0x3c/0x80
>[    1.616286] [df4a5c18] [c005fe2c] irq_free_descs+0x70/0xa8
>[    1.621778] [df4a5c38] [c033d3fc] of_fsl_spi_probe+0xdc/0x3cc
>[    1.627525] [df4a5c88] [c02f0f64] platform_drv_probe+0x44/0xa4
>[    1.633350] [df4a5c98] [c02eee44] really_probe+0x1ac/0x418
>[    1.638829] [df4a5cc8] [c02ed3e8] bus_for_each_drv+0x64/0xb0
>[    1.644481] [df4a5cf8] [c02ef950] __device_attach+0xd4/0x128
>[    1.650132] [df4a5d28] [c02ed61c] bus_probe_device+0xa0/0xbc
>[    1.655783] [df4a5d48] [c02ebbe8] device_add+0x544/0x74c
>[    1.661096] [df4a5d88] [c0382b78] of_platform_device_create_pdata+0xa4/0x100
>[    1.668131] [df4a5da8] [c0382cf4] of_platform_bus_create+0x120/0x20c
>[    1.674474] [df4a5df8] [c0382d50] of_platform_bus_create+0x17c/0x20c
>[    1.680818] [df4a5e48] [c0382e88] of_platform_bus_probe+0x9c/0xf0
>[    1.686907] [df4a5e68] [c0751404] __machine_initcall_cmpcpro_cmpcpro_declare_of_platform_devices+0x74/0x1a4
>[    1.696629] [df4a5e98] [c072a4cc] do_one_initcall+0x8c/0x1d4
>[    1.702282] [df4a5ef8] [c072a768] kernel_init_freeable+0x154/0x204
>[    1.708455] [df4a5f28] [c0004b2c] kernel_init+0x18/0x110
>[    1.713769] [df4a5f38] [c00122ac] ret_from_kernel_thread+0x14/0x1c
>[    1.719926] Instruction dump:
>[    1.722889] 2c030000 4182004c 3863ffb0 3c80c05f 80e3005c 388436a0 3c60c06d 7fa6eb78
>[    1.730630] 7fe5fb78 38840280 38634178 4be8c611 <0fe00000> 4bffff6c 3c60c071 7fe4fb78
>[    1.738556] ---[ end trace 05d0720bf2e352e2 ]---
>
>The problem comes from the error path which calls
>irq_dispose_mapping() while the IRQ has been requested with
>devm_request_irq().
>
>IRQ doesn't need to be mapped with irq_of_parse_and_map(). The only
>need is to get the IRQ virtual number. For that, use
>of_irq_to_resource() instead of the
>irq_of_parse_and_map()/irq_dispose_mapping() pair.
>
>Fixes: 500a32abaf81 ("spi: fsl: Call irq_dispose_mapping in err path")
>Cc: stable@vger.kernel.org
>Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>Link: https://lore.kernel.org/r/518cfb83347d5372748e7fe72f94e2e9443d0d4a.1575905123.git.christophe.leroy@c-s.fr
>Signed-off-by: Mark Brown <broonie@kernel.org>

Minor context conflicts. Fixed up and queued for 4.19 and 4.14.

-- 
Thanks,
Sasha
