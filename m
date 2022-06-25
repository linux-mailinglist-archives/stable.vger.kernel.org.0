Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05F855ABA0
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 18:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiFYQob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 12:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiFYQob (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 12:44:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888FF14008
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 09:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D1D60AAF
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 16:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09853C3411C;
        Sat, 25 Jun 2022 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656175468;
        bh=Geg+5XlzYixUTV3CmVE0KP0pCVZ2wxiFREf+OoFrCsE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lswxXwhy7AKXZPCl3Cez5IfeYFtSo3HVu40F91mlYwDV8O1fLFvMcTACIzkwknM9v
         ZzKf6d9zBC1DAsA2PA45a3HizjWm1uRVvYsVJn3RdHPYmQT3RJxaIMI4sbaHwKxzsP
         4wxcPcA4RjO1Pj16yMXAX1z2+vHRi92F88qUaEuk=
Date:   Sat, 25 Jun 2022 18:44:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Natalsson <harmoniesworlds@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: echo mem > /sys/power/state write error "Device or resource
 busy" on Amlogic A311D device
Message-ID: <Yrc7Z6R4iG26FkmD@kroah.com>
References: <CADs9LoMEF86Fp2-0ji7d9CNA5F=8ArwPWnj09h_Cwo6poNsWVA@mail.gmail.com>
 <YqMdS+3qpYHfWN9f@kroah.com>
 <CADs9LoMAgCNU6Rx2y0t7kRMmLw-Qd06Ayq19qM2-PkOJUgdxig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADs9LoMAgCNU6Rx2y0t7kRMmLw-Qd06Ayq19qM2-PkOJUgdxig@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sat, Jun 25, 2022 at 06:01:22PM +0300, Alex Natalsson wrote:
> New kernels freezing after resume only when scaling governor is
> "conservative". Yes, I using this because my solar battery produce a
> few of electricity. When scaling governor is performance system not
> freezing after resume.
> However, sometimes I received "Device or resource busy" error after
> echo mem > /sys/power/state.
> Later I found out what this was related with another bug:
> pipewire-media-session is <defunct>, nosound and many processes which
> using audio as mplayer, ffplay, alsamixer and etc was not responding
> and not terminating even throught kill -9.
> The log after alsamixer launch:
> [  103.786358] Internal error: Oops: 96000004 [#1] SMP
> [  103.786509] Modules linked in: snd_seq_dummy snd_hrtimer snd_seq
> snd_seq_device bnep nls_utf8 mt7601u mac80211 hci_uart libarc4 joydev
> brcmfmac btbcm panfrost bluetooth meson_vdec(C) brcmutil gpu_sched
> cfg80211 dwmac_generic videobuf2_dma_contig v4l2_mem2mem
> videobuf2_memops videobuf2_v4l2 videobuf2_common drm_shmem_helper
> ecdh_generic dwmac_meson8b stmmac_platform dw_hdmi_i2s_audio stmmac
> ecc ir_nec_decoder videodev pcs_xpcs rc_khadas phylink ptp
> meson_saradc meson_ir rc_core snd_soc_meson_axg_frddr
> snd_soc_meson_axg_toddr snd_soc_meson_axg_sound_card
> snd_soc_meson_card_utils snd_soc_meson_axg_fifo ao_cec_g12a
> snd_soc_meson_axg_tdmin snd_soc_meson_axg_tdm_interface
> snd_soc_meson_axg_tdmout snd_soc_meson_axg_tdm_formatter rfkill
> meson_gxbb_wdt fuse crypto_user uas usb_storage adc_keys
> gpio_keys_polled industrialio
> [  103.857778] CPU: 3 PID: 530 Comm: pipewire-media- Tainted: G
>  C        5.16.0-ARCH+ #8

But this is 5.16.0, the commit you pointed to is in 5.17.



> [  103.857791] Hardware name: Khadas VIM3 (DT)
> [  103.857795] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  103.857801] pc : dpcm_be_connect+0xd0/0x2d0
> [  103.881758] lr : dpcm_add_paths.isra.0+0xcc/0x1e0
> [  103.881763] sp : ffff800009f4b870
> [  103.881765] x29: ffff800009f4b870 x28: ffff000003b944c0 x27: 0000000000000001
> [  103.881772] x26: 0000000000000001 x25: 0000000000000340 x24: 00000000000002a0
> [  103.881777] x23: 0000000000000001 x22: 0000000000000000 x21: ffff000005b18080
> [  103.881782] x20: ffff000005b183c0 x19: ffff000005b1c080 x18: 0000000000000000
> [  103.881787] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> [  103.881792] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> [  103.881797] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> [  103.881801] x8 : ffff000012020400 x7 : 0000000000000000 x6 : 000000000000003f
> [  103.881806] x5 : 0000000000000040 x4 : 0000000000000000 x3 : ffff000002822000
> [  103.881811] x2 : ffff000002861b50 x1 : ffff00000282f800 x0 : ffff000002861800
> [  103.881817] Call trace:
> [  103.881819]  dpcm_be_connect+0xd0/0x2d0
> [  103.881823]  dpcm_add_paths.isra.0+0xcc/0x1e0
> [  103.881826]  dpcm_fe_dai_open+0x80/0x194
> [  103.881831]  snd_pcm_open_substream+0xa4/0x174
> [  103.881838]  snd_pcm_open.part.0+0xd8/0x1dc
> [  103.881843]  snd_pcm_capture_open+0x64/0x94
> [  103.992730]  snd_open+0xac/0x1d0
> [  103.992739]  chrdev_open+0xe0/0x2d0
> [  103.999389]  do_dentry_open+0x12c/0x3a0
> [  103.999397]  vfs_open+0x30/0x3c
> [  103.999401]  do_open+0x204/0x414
> [  103.999405]  path_openat+0x10c/0x27c
> [  103.999408]  do_filp_open+0x80/0x130
> [  103.999412]  do_sys_openat2+0xb4/0x170
> [  103.999414]  __arm64_sys_openat+0x64/0xb0
> [  103.999416]  invoke_syscall+0x48/0x114
> [  103.999426]  el0_svc_common.constprop.0+0xd4/0xfc
> [  103.999429]  do_el0_svc+0x28/0x90
> [  103.999432]  el0_svc+0x28/0x80
> [  103.999440]  el0t_64_sync_handler+0xa4/0x130
> [  103.999442]  el0t_64_sync+0x1a0/0x1a4
> [  103.999451] Code: 8b000020 f9406841 f9406816 f9400020 (f94002c1)
> [  103.999457] ---[ end trace e01b673b8147057d ]---
> 
> 
> After I removed pipewire software "Device or resource busy" error was
> disappear. But the sound and media still doesn't working and alsamixer
> cannot change sound card to my usb audio device after commit
> bbf7d3b1c4f40eb02dd1dffb500ba00b0bff0303.

Can you send the info to the sound mailing list and cc the developers of
that commit with your information?  That commit looks odd to be causing
problems.

thanks,

greg k-h
