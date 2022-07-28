Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A358421A
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiG1Op6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiG1Opw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:45:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE7913F9C;
        Thu, 28 Jul 2022 07:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B14EB618CE;
        Thu, 28 Jul 2022 14:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94983C433D6;
        Thu, 28 Jul 2022 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659019550;
        bh=cvXVrHoV/VoCvik4/K9WffoVclA9N0vSHcikU4U9hLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHhDM+dMyIZL92eZ0x20Eh8MUfpte8EdbmKHM0ItyHc1/IYgXmwXWwAIZZ2tCB2R7
         HfTns+ZwnOVmnktFbUz3r9VZvvGaZHFMBJYLfKBNVZEAc2oSlmUWxM1nZOSIO9BaA0
         9G3P3ucccg2G5pOw8mxwvbZwz8YbtcOYAbAFqIWc=
Date:   Thu, 28 Jul 2022 16:45:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tim Lewis <elatllat@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        "From: Christoph Hellwig" <hch@lst.de>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        slade@sladewatkins.com
Subject: Re: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
Message-ID: <YuKhG2q5B5ocbGy0@kroah.com>
References: <CA+3zgmvu46YGOEBY8YX10PBtQUuDrvPeB=XC7ve2yfo3aONVsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+3zgmvu46YGOEBY8YX10PBtQUuDrvPeB=XC7ve2yfo3aONVsg@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 10:23:18AM -0400, Tim Lewis wrote:
> Also trying to mount btrfs after boot:
> 
> [ 2075.535319] Btrfs loaded, crc32c=crc32c-generic
> [ 2075.537092] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000068
> [ 2075.540237] Mem abort info:
> [ 2075.542974]   ESR = 0x96000004
> [ 2075.546591]   EC = 0x25: DABT (current EL), IL = 32 bits
> [ 2075.551332]   SET = 0, FnV = 0
> [ 2075.554309]   EA = 0, S1PTW = 0
> [ 2075.558240] Data abort info:
> [ 2075.560259]   ISV = 0, ISS = 0x00000004
> [ 2075.564102]   CM = 0, WnR = 0
> [ 2075.566962] user pgtable: 4k pages, 48-bit VAs, pgdp=000000001e0f3000
> [ 2075.573388] [0000000000000068] pgd=0000000000000000, p4d=0000000000000000
> [ 2075.580098] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [ 2075.585581] Modules linked in: btrfs blake2b_generic zstd_compress
> raid0 raid1 dm_raid raid456 async_raid6_recov async_memcpy async_pq
> md_mod raid6_pq dm_integrity async_xor async_tx xor xor_neon xfs
> bridge stp llc ip6t_REJECT ip6table_filter ip6table_mangle ip6_tables
> xt_set ipt_REJECT xt_conntrack iptable_filter xt_MASQUERADE
> iptable_nat xt_CHECKSUM xt_tcpudp iptable_mangle ip_set_hash_ip
> ip_set_hash_net ip_set snd_soc_hdmi_codec dw_hdmi_i2s_audio
> dw_hdmi_cec dwmac_generic meson_gxl realtek dwmac_meson8b
> meson_dw_hdmi stmmac_platform axg_audio rc_odroid dw_hdmi
> snd_soc_meson_g12a_tohdmitx stmmac sclk_div
> snd_soc_meson_axg_sound_card panfrost meson_rng meson_drm meson_ir
> snd_soc_meson_axg_tdm_interface crct10dif_ce rc_core
> snd_soc_meson_axg_tdmout reset_meson_audio_arb cec
> snd_soc_meson_codec_glue snd_soc_meson_axg_frddr rtc_meson_vrtc
> rng_core gpu_sched clk_phase meson_canvas snd_soc_meson_axg_fifo
> drm_kms_helper snd_soc_meson_card_utils pcs_xpcs nvmem_meson_efuse
> [ 2075.585716]  snd_soc_meson_axg_tdm_formatter display_connector
> nft_reject_inet nf_reject_ipv6 nft_reject drm ip_tables x_tables ipv6
> [ 2075.682357] CPU: 0 PID: 5100 Comm: systemd-udevd Not tainted
> 5.10.134-rc1-dirty #1
> [ 2075.689858] Hardware name: Hardkernel ODROID-C4 (DT)
> [ 2075.694776] pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
> [ 2075.700732] pc : bio_alloc_bioset+0x20/0x270
> [ 2075.704980] lr : btrfs_alloc_device+0x64/0x190 [btrfs]
> [ 2075.710040] sp : ffff80001500bc60
> [ 2075.713317] x29: ffff80001500bc60 x28: ffff8000095a1000
> [ 2075.718578] x27: 0000000000000000 x26: ffff00001cf8ec78
> [ 2075.723839] x25: 0000000000032e45 x24: ffff000000ca6580
> [ 2075.729101] x23: 0000000000000000 x22: 0000000000000000
> [ 2075.734362] x21: ffff000000ca6580 x20: 0000000000000000
> [ 2075.739623] x19: ffff00001cf8ee00 x18: 0000000000000000
> [ 2075.744884] x17: 0000000000000000 x16: 0000000000000000
> [ 2075.750146] x15: 0000000000000000 x14: 0000000000000000
> [ 2075.755407] x13: 0000000000000002 x12: 0000000000000000
> [ 2075.760668] x11: 0000000000000001 x10: 0000000000000a30
> [ 2075.765929] x9 : 0000000000000000 x8 : ffff00001cf8f000
> [ 2075.771191] x7 : 0000000000000000 x6 : 000000000000003f
> [ 2075.776452] x5 : 0000000000000040 x4 : 0000000000000000
> [ 2075.781713] x3 : 0000000000000004 x2 : 0000000000000000
> [ 2075.786974] x1 : 0000000000000000 x0 : 0000000000000cc0
> [ 2075.792237] Call trace:
> [ 2075.794657]  bio_alloc_bioset+0x20/0x270
> [ 2075.798560]  btrfs_alloc_device+0x64/0x190 [btrfs]
> [ 2075.803299]  device_list_add+0x418/0x6b8 [btrfs]
> [ 2075.807870]  btrfs_scan_one_device+0xd8/0x208 [btrfs]
> [ 2075.812876]  btrfs_control_ioctl+0xdc/0x188 [btrfs]
> [ 2075.817686]  __arm64_sys_ioctl+0xa8/0xf0
> [ 2075.821565]  el0_svc_common.constprop.0+0x78/0x1c8
> [ 2075.826306]  do_el0_svc+0x24/0x90
> [ 2075.829585]  el0_svc+0x14/0x20
> [ 2075.832602]  el0_sync_handler+0xb0/0xb8
> [ 2075.836397]  el0_sync+0x180/0x1c0
> [ 2075.839677] Code: aa0203f4 a90363f7 2a0103f7 d5384118 (f9403441)
> [ 2075.845714] ---[ end trace fd4b78de8314a3ec ]---
> [10758.363281] Process accounting resumed
> 
> There was a change to bio_alloc_bioset:
> 
> https://lore.kernel.org/all/20220727161012.364032637@linuxfoundation.org/

Thanks, I've now dropped that one and some others and will push out a
-rc2 in a few minutes...

greg k-h
