Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B3F1AB622
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389962AbgDPDPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDPDOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:14:55 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80FE820725;
        Thu, 16 Apr 2020 03:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587006894;
        bh=W39uGhjYP4yZBKznW9eS/o76ZO5dxn9RIyZQqCr4Lvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPMYxcrj1QMuKjXRm0zcom6wg0b8qTC7/08YOcHQi6P4lbeBIetSRKr9b1f8Z1qVZ
         dieN7aqyuRzgB3cdJy/s3fcJXQWBevLA/aL2rfAuWTX0+TKuZeF5Ko9HZoxuqN2Y4m
         7befFqPv+h1drYyTNyT7pM8NnD8ZXzY2I0ztgEv4=
Date:   Wed, 15 Apr 2020 23:14:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     wenyang@linux.alibaba.com, arnd@arndb.de, cminyard@mvista.com,
        minyard@acm.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipmi: fix hung processes in __get_guid()"
 failed to apply to 4.14-stable tree
Message-ID: <20200416031453.GE1068@sasha-vm>
References: <15869513487994@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15869513487994@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:49:08PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From 32830a0534700f86366f371b150b17f0f0d140d7 Mon Sep 17 00:00:00 2001
>From: Wen Yang <wenyang@linux.alibaba.com>
>Date: Fri, 3 Apr 2020 17:04:08 +0800
>Subject: [PATCH] ipmi: fix hung processes in __get_guid()
>
>The wait_event() function is used to detect command completion.
>When send_guid_cmd() returns an error, smi_send() has not been
>called to send data. Therefore, wait_event() should not be used
>on the error path, otherwise it will cause the following warning:
>
>[ 1361.588808] systemd-udevd   D    0  1501   1436 0x00000004
>[ 1361.588813]  ffff883f4b1298c0 0000000000000000 ffff883f4b188000 ffff887f7e3d9f40
>[ 1361.677952]  ffff887f64bd4280 ffffc90037297a68 ffffffff8173ca3b ffffc90000000010
>[ 1361.767077]  00ffc90037297ad0 ffff887f7e3d9f40 0000000000000286 ffff883f4b188000
>[ 1361.856199] Call Trace:
>[ 1361.885578]  [<ffffffff8173ca3b>] ? __schedule+0x23b/0x780
>[ 1361.951406]  [<ffffffff8173cfb6>] schedule+0x36/0x80
>[ 1362.010979]  [<ffffffffa071f178>] get_guid+0x118/0x150 [ipmi_msghandler]
>[ 1362.091281]  [<ffffffff810d5350>] ? prepare_to_wait_event+0x100/0x100
>[ 1362.168533]  [<ffffffffa071f755>] ipmi_register_smi+0x405/0x940 [ipmi_msghandler]
>[ 1362.258337]  [<ffffffffa0230ae9>] try_smi_init+0x529/0x950 [ipmi_si]
>[ 1362.334521]  [<ffffffffa022f350>] ? std_irq_setup+0xd0/0xd0 [ipmi_si]
>[ 1362.411701]  [<ffffffffa0232bd2>] init_ipmi_si+0x492/0x9e0 [ipmi_si]
>[ 1362.487917]  [<ffffffffa0232740>] ? ipmi_pci_probe+0x280/0x280 [ipmi_si]
>[ 1362.568219]  [<ffffffff810021a0>] do_one_initcall+0x50/0x180
>[ 1362.636109]  [<ffffffff812231b2>] ? kmem_cache_alloc_trace+0x142/0x190
>[ 1362.714330]  [<ffffffff811b2ae1>] do_init_module+0x5f/0x200
>[ 1362.781208]  [<ffffffff81123ca8>] load_module+0x1898/0x1de0
>[ 1362.848069]  [<ffffffff811202e0>] ? __symbol_put+0x60/0x60
>[ 1362.913886]  [<ffffffff8130696b>] ? security_kernel_post_read_file+0x6b/0x80
>[ 1362.998514]  [<ffffffff81124465>] SYSC_finit_module+0xe5/0x120
>[ 1363.068463]  [<ffffffff81124465>] ? SYSC_finit_module+0xe5/0x120
>[ 1363.140513]  [<ffffffff811244be>] SyS_finit_module+0xe/0x10
>[ 1363.207364]  [<ffffffff81003c04>] do_syscall_64+0x74/0x180
>
>Fixes: 50c812b2b951 ("[PATCH] ipmi: add full sysfs support")
>Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
>Cc: Corey Minyard <minyard@acm.org>
>Cc: Arnd Bergmann <arnd@arndb.de>
>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Cc: openipmi-developer@lists.sourceforge.net
>Cc: linux-kernel@vger.kernel.org
>Cc: stable@vger.kernel.org # 2.6.17-
>Message-Id: <20200403090408.58745-1-wenyang@linux.alibaba.com>
>Signed-off-by: Corey Minyard <cminyard@mvista.com>

Conflict because we're missing:

28f26ac7a963 ("ipmi: Dynamically fetch GUID periodically")
aa9c9ab2443e ("ipmi: allow dynamic BMC version information")

Fixed and queued up.

-- 
Thanks,
Sasha
