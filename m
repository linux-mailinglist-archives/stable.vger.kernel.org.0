Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [23.128.96.19])
	by mail.lfdr.de (Postfix) with ESMTP id C57C11A63FF
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 10:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgDMIVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 04:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgDMIVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 04:21:39 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC198C014CDB;
        Mon, 13 Apr 2020 01:21:39 -0700 (PDT)
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F310E20692;
        Mon, 13 Apr 2020 08:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586766099;
        bh=MQm1wWb2hwpv0w9XdV4EvpcKIJ5A46S2JOi+pdHXLV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yXjWK9xjTpc/v9E4OAeGO3IiiWXOMf+NVd9PXpdas8IOfF0wDwhGBJ78euJnAZejp
         Y6T4q5OGcNG8KTCh9dV2yjHXQhv7pudywmglP1h9cWeYJl7+82Ga6NHMtvXcxXxmbW
         a1FAovW+rDZkITYg4mgOWHzjiz8KREiRyRp3K0AI=
Date:   Mon, 13 Apr 2020 10:21:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sboyd@kernel.org, swboyd@chromium.org, jcrouse@codeaurora.org,
        robdclark@chromium.org, seanpaul@chromium.org, lee.jones@linaro.org
Subject: Re: [PATCH 4.19 50/54] drm/msm: stop abusing dma_map/unmap for cache
Message-ID: <20200413082137.GB2792388@kroah.com>
References: <20200411115508.284500414@linuxfoundation.org>
 <20200411115513.709554942@linuxfoundation.org>
 <OSAPR01MB366788E02572D95F246D6DEC92DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB366788E02572D95F246D6DEC92DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 05:03:26AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi,
> 
> > -----Original Message-----
> > From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.org] On Behalf Of Greg Kroah-Hartman
> > Sent: Saturday, April 11, 2020 9:10 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kernel.org; Stephen Boyd <sboyd@kernel.org>; Stephen
> > Boyd <swboyd@chromium.org>; Jordan Crouse <jcrouse@codeaurora.org>; Rob Clark <robdclark@chromium.org>; Sean Paul
> > <seanpaul@chromium.org>; Lee Jones <lee.jones@linaro.org>
> > Subject: [PATCH 4.19 50/54] drm/msm: stop abusing dma_map/unmap for cache
> > 
> > From: Rob Clark <robdclark@chromium.org>
> > 
> > commit 0036bc73ccbe7e600a3468bf8e8879b122252274 upstream.
> > 
> > Recently splats like this started showing up:
> > 
> >    WARNING: CPU: 4 PID: 251 at drivers/iommu/dma-iommu.c:451 __iommu_dma_unmap+0xb8/0xc0
> >    Modules linked in: ath10k_snoc ath10k_core fuse msm ath mac80211 uvcvideo cfg80211 videobuf2_vmalloc videobuf2_memops
> > vide
> >    CPU: 4 PID: 251 Comm: kworker/u16:4 Tainted: G        W         5.2.0-rc5-next-20190619+ #2317
> >    Hardware name: LENOVO 81JL/LNVNB161216, BIOS 9UCN23WW(V1.06) 10/25/2018
> >    Workqueue: msm msm_gem_free_work [msm]
> >    pstate: 80c00005 (Nzcv daif +PAN +UAO)
> >    pc : __iommu_dma_unmap+0xb8/0xc0
> >    lr : __iommu_dma_unmap+0x54/0xc0
> >    sp : ffff0000119abce0
> >    x29: ffff0000119abce0 x28: 0000000000000000
> >    x27: ffff8001f9946648 x26: ffff8001ec271068
> >    x25: 0000000000000000 x24: ffff8001ea3580a8
> >    x23: ffff8001f95ba010 x22: ffff80018e83ba88
> >    x21: ffff8001e548f000 x20: fffffffffffff000
> >    x19: 0000000000001000 x18: 00000000c00001fe
> >    x17: 0000000000000000 x16: 0000000000000000
> >    x15: ffff000015b70068 x14: 0000000000000005
> >    x13: 0003142cc1be1768 x12: 0000000000000001
> >    x11: ffff8001f6de9100 x10: 0000000000000009
> >    x9 : ffff000015b78000 x8 : 0000000000000000
> >    x7 : 0000000000000001 x6 : fffffffffffff000
> >    x5 : 0000000000000fff x4 : ffff00001065dbc8
> >    x3 : 000000000000000d x2 : 0000000000001000
> >    x1 : fffffffffffff000 x0 : 0000000000000000
> >    Call trace:
> >     __iommu_dma_unmap+0xb8/0xc0
> >     iommu_dma_unmap_sg+0x98/0xb8
> >     put_pages+0x5c/0xf0 [msm]
> >     msm_gem_free_work+0x10c/0x150 [msm]
> >     process_one_work+0x1e0/0x330
> >     worker_thread+0x40/0x438
> >     kthread+0x12c/0x130
> >     ret_from_fork+0x10/0x18
> >    ---[ end trace afc0dc5ab81a06bf ]---
> > 
> > Not quite sure what triggered that, but we really shouldn't be abusing
> > dma_{map,unmap}_sg() for cache maint.
> > 
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Tested-by: Stephen Boyd <swboyd@chromium.org>
> > Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
> > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20190630124735.27786-1-robdclark@gmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This commit also requires the following commits:
> 
> commit 3de433c5b38af49a5fc7602721e2ab5d39f1e69c
> Author: Rob Clark <robdclark@chromium.org>
> Date:   Tue Jul 30 14:46:28 2019 -0700
> 
>     drm/msm: Use the correct dma_sync calls in msm_gem
>     
>     [subject was: drm/msm: shake fist angrily at dma-mapping]
>     
>     So, using dma_sync_* for our cache needs works out w/ dma iommu ops, but
>     it falls appart with dma direct ops.  The problem is that, depending on
>     display generation, we can have either set of dma ops (mdp4 and dpu have
>     iommu wired to mdss node, which maps to toplevel drm device, but mdp5
>     has iommu wired up to the mdp sub-node within mdss).
>     
>     Fixes this splat on mdp5 devices:
>     
>        Unable to handle kernel paging request at virtual address ffffffff80000000
>        Mem abort info:
>          ESR = 0x96000144
>          Exception class = DABT (current EL), IL = 32 bits
>          SET = 0, FnV = 0
>          EA = 0, S1PTW = 0
>        Data abort info:
>          ISV = 0, ISS = 0x00000144
>          CM = 1, WnR = 1
>        swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000810e4000
>        [ffffffff80000000] pgd=0000000000000000
>        Internal error: Oops: 96000144 [#1] SMP
>        Modules linked in: btqcomsmd btqca bluetooth cfg80211 ecdh_generic ecc rfkill libarc4 panel_simple msm wcnss_ctrl qrtr_smd drm_kms_helper venus_enc venus_dec videobuf2_dma_sg videobuf2_memops drm venus_core ipv6 qrtr qcom_wcnss_pil v4l2_mem2mem qcom_sysmon videobuf2_v4l2 qmi_helpers videobuf2_common crct10dif_ce mdt_loader qcom_common videodev qcom_glink_smem remoteproc bmc150_accel_i2c bmc150_magn_i2c bmc150_accel_core bmc150_magn snd_soc_lpass_apq8016 snd_soc_msm8916_analog mms114 mc nf_defrag_ipv6 snd_soc_lpass_cpu snd_soc_apq8016_sbc industrialio_triggered_buffer kfifo_buf snd_soc_lpass_platform snd_soc_msm8916_digital drm_panel_orientation_quirks
>        CPU: 2 PID: 33 Comm: kworker/2:1 Not tainted 5.3.0-rc2 #1
>        Hardware name: Samsung Galaxy A5U (EUR) (DT)
>        Workqueue: events deferred_probe_work_func
>        pstate: 80000005 (Nzcv daif -PAN -UAO)
>        pc : __clean_dcache_area_poc+0x20/0x38
>        lr : arch_sync_dma_for_device+0x28/0x30
>        sp : ffff0000115736a0
>        x29: ffff0000115736a0 x28: 0000000000000001
>        x27: ffff800074830800 x26: ffff000011478000
>        x25: 0000000000000000 x24: 0000000000000001
>        x23: ffff000011478a98 x22: ffff800009fd1c10
>        x21: 0000000000000001 x20: ffff800075ad0a00
>        x19: 0000000000000000 x18: ffff0000112b2000
>        x17: 0000000000000000 x16: 0000000000000000
>        x15: 00000000fffffff0 x14: ffff000011455d70
>        x13: 0000000000000000 x12: 0000000000000028
>        x11: 0000000000000001 x10: ffff00001106c000
>        x9 : ffff7e0001d6b380 x8 : 0000000000001000
>        x7 : ffff7e0001d6b380 x6 : ffff7e0001d6b382
>        x5 : 0000000000000000 x4 : 0000000000001000
>        x3 : 000000000000003f x2 : 0000000000000040
>        x1 : ffffffff80001000 x0 : ffffffff80000000
>        Call trace:
>         __clean_dcache_area_poc+0x20/0x38
>         dma_direct_sync_sg_for_device+0xb8/0xe8
>         get_pages+0x22c/0x250 [msm]
>         msm_gem_get_and_pin_iova+0xdc/0x168 [msm]
>         ...
>     
>     Fixes the combination of two patches:
>     
>     Fixes: 0036bc73ccbe (drm/msm: stop abusing dma_map/unmap for cache)
>     Fixes: 449fa54d6815 (dma-direct: correct the physical addr in dma_direct_sync_sg_for_cpu/device)
>     Tested-by: Stephan Gerhold <stephan@gerhold.net>
>     Signed-off-by: Rob Clark <robdclark@chromium.org>
>     [seanpaul changed subject to something more desriptive]
>     Signed-off-by: Sean Paul <seanpaul@chromium.org>
>     Link: https://patchwork.freedesktop.org/patch/msgid/20190730214633.17820-1-robdclark@gmail.com
> 
> 
> And this commit requires not only 4.19 but also 4.9 and 4.14.
> Please apply this.

Now queued up, thanks!

greg k-h
