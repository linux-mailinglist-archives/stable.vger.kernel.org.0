Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C741E0F47
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 15:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbgEYNTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 09:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390688AbgEYNTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 09:19:09 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DEDC061A0E;
        Mon, 25 May 2020 06:19:09 -0700 (PDT)
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C415724D;
        Mon, 25 May 2020 15:19:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1590412745;
        bh=LC8ysV2b9bTGuLITct/UwUGjPS8MrRakOH70P7jIc5A=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DbaOp9GW/rTRqvFzPZnflWpDnhkpJnlP1KlYU3D0Yxug4EOvZ9BtFRldHCQKJjvd9
         Ep0o/r0REulCaIgyJfel8PoUlXyHL1YYmo+sTeK9OYN+L4eE9ZApca8/Gi+2dem7mL
         Bmmr+6DO/3B+XAP6KIT1+17DwU/6kJR4i0MaDtZ0=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH] media: vsp1: dl: Fix NULL pointer dereference on unbind
To:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Eugeniu Rosca <roscaeugeniu@gmail.com>, stable@vger.kernel.org
References: <20200523081334.23531-1-erosca@de.adit-jv.com>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <d4544b1b-a695-bd70-0ccb-e2fb1838f3f8@ideasonboard.com>
Date:   Mon, 25 May 2020 14:19:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200523081334.23531-1-erosca@de.adit-jv.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eugeniu,

Yeouch. Looks like I really missed a trick there!

We should probably update the $SUBJECT to match what is performed in the
patch, which is perhaps more like:

"media: vsp1: dl: Store VSP reference when creating cmd pools"

On 23/05/2020 09:13, Eugeniu Rosca wrote:

And then we can explain here:

In commit f3b98e3c4d2e16 ("media: vsp1: Provide support for extended
command pools"), the vsp pointer used for referencing the VSP1 device
structure from a command pool during vsp1_dl_ext_cmd_pool_destroy() was
not populated.

Correctly assign the pointer to prevent the following
null-pointer-dereference when removing the device:

> v4.19 commit f3b98e3c4d2e16 ("media: vsp1: Provide support for extended
> command pools") introduced below issue [*], consistently reproduced.
> 
> In order to fix it, inspire from the sibling/predecessor v4.18-rc1
> commit 5de0473982aab2 ("media: vsp1: Provide a body pool"), which saves
> the vsp1 instance address in vsp1_dl_body_pool_create().
> 
> [*] h3ulcb-kf #>
> echo fea28000.vsp > /sys/bus/platform/devices/fea28000.vsp/driver/unbind
>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
>  Mem abort info:
>    ESR = 0x96000006
>    EC = 0x25: DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>  Data abort info:
>    ISV = 0, ISS = 0x00000006
>    CM = 0, WnR = 0
>  user pgtable: 4k pages, 48-bit VAs, pgdp=00000007318be000
>  [0000000000000028] pgd=00000007333a1003, pud=00000007333a6003, pmd=0000000000000000
>  Internal error: Oops: 96000006 [#1] PREEMPT SMP
>  Modules linked in:
>  CPU: 1 PID: 486 Comm: sh Not tainted 5.7.0-rc6-arm64-renesas-00118-ge644645abf47 #185
>  Hardware name: Renesas H3ULCB Kingfisher board based on r8a77951 (DT)
>  pstate: 40000005 (nZcv daif -PAN -UAO)
>  pc : vsp1_dlm_destroy+0xe4/0x11c
>  lr : vsp1_dlm_destroy+0xc8/0x11c
>  sp : ffff800012963b60
>  x29: ffff800012963b60 x28: ffff0006f83fc440
>  x27: 0000000000000000 x26: ffff0006f5e13e80
>  x25: ffff0006f5e13ed0 x24: ffff0006f5e13ed0
>  x23: ffff0006f5e13ed0 x22: dead000000000122
>  x21: ffff0006f5e3a080 x20: ffff0006f5df2938
>  x19: ffff0006f5df2980 x18: 0000000000000003
>  x17: 0000000000000000 x16: 0000000000000016
>  x15: 0000000000000003 x14: 00000000000393c0
>  x13: ffff800011a5ec18 x12: ffff800011d8d000
>  x11: ffff0006f83fcc68 x10: ffff800011a53d70
>  x9 : ffff8000111f3000 x8 : 0000000000000000
>  x7 : 0000000000210d00 x6 : 0000000000000000
>  x5 : ffff800010872e60 x4 : 0000000000000004
>  x3 : 0000000078068000 x2 : ffff800012781000
>  x1 : 0000000000002c00 x0 : 0000000000000000
>  Call trace:
>   vsp1_dlm_destroy+0xe4/0x11c
>   vsp1_wpf_destroy+0x10/0x20
>   vsp1_entity_destroy+0x24/0x4c
>   vsp1_destroy_entities+0x54/0x130
>   vsp1_remove+0x1c/0x40
>   platform_drv_remove+0x28/0x50
>   __device_release_driver+0x178/0x220
>   device_driver_detach+0x44/0xc0
>   unbind_store+0xe0/0x104
>   drv_attr_store+0x20/0x30
>   sysfs_kf_write+0x48/0x70
>   kernfs_fop_write+0x148/0x230
>   __vfs_write+0x18/0x40
>   vfs_write+0xdc/0x1c4
>   ksys_write+0x68/0xf0
>   __arm64_sys_write+0x18/0x20
>   el0_svc_common.constprop.0+0x70/0x170
>   do_el0_svc+0x20/0x80
>   el0_sync_handler+0x134/0x1b0
>   el0_sync+0x140/0x180
>  Code: b40000c2 f9403a60 d2800084 a9400663 (f9401400)
>  ---[ end trace 3875369841fb288a ]---
> 
> Fixes: f3b98e3c4d2e16 ("media: vsp1: Provide support for extended command pools")
> Cc: stable@vger.kernel.org # v4.19+
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
> 
> How about adding a new unit test perfoming unbind/rebind to
> http://git.ideasonboard.com/renesas/vsp-tests.git, to avoid
> such issues in future? 

Yes, now I wish I had done so back at 4.19! I hope this wasn't too
painful to diagnose and fix, and thank you for being so thorough in your
report!


> Locally, below command has been used to identify the problem:
> 
> for f in $(find /sys/bus/platform/devices/ -name "*vsp*" -o -name "*fdp*"); do \
>      b=$(basename $f); \
>      echo $b > $f/driver/unbind; \
> done
> 

I've created a test to add to vsp-tests, which I'll post next, thank you
for the suggestion.

Before your patch is applied, I experience the same crash you have seen,
and after your patch - I can successfully unbind/bind all of the VSP1
instances.

So I think you can have this too:

Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index d7b43037e500..e07b135613eb 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -431,6 +431,8 @@ vsp1_dl_cmd_pool_create(struct vsp1_device *vsp1, enum vsp1_extcmd_type type,
>  	if (!pool)
>  		return NULL;
>  
> +	pool->vsp1 = vsp1;
> +
>  	spin_lock_init(&pool->lock);
>  	INIT_LIST_HEAD(&pool->free);
>  
> 

