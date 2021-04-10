Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C825835ACED
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhDJLYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234091AbhDJLYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8704A610CB;
        Sat, 10 Apr 2021 11:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618053881;
        bh=HW0d0eO3v4EhDvfbtxrFUAT9yVpKkp9co0ssN0SMbQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X2fFvLwMlrHdDh+b3Y9ktC4ZZaFNK3mi1qyjp2vTavNhm8xaAiRCuIx2jKAT4c/lU
         yJ4sgVT/FQVeyayB7v8wyz5fqrfsQX/uLnQmeHMWiflrXnllc1bWx4LzSXJG+8gieU
         DAvCJM/FmXloBxUoSFdVsdhW/gP9XKRgR93WRduI=
Date:   Sat, 10 Apr 2021 13:24:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/18] 4.19.186-rc1 review
Message-ID: <YHGK9p687604pOUv@kroah.com>
References: <20210409095301.525783608@linuxfoundation.org>
 <a3241bd5-c8cd-dd47-03a8-906b66cf74e8@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3241bd5-c8cd-dd47-03a8-906b66cf74e8@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 02:55:16PM -0600, Shuah Khan wrote:
> On 4/9/21 3:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.186 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.186-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> I am seeing a new warn - will debug later on today and let you know
> what I find:
> 
> 
> WARNING: CPU: 9 PID: 0 at drivers/net/wireless/ath/ath10k/htt_rx.c:46
> ath10k_htt_rx_pop_paddr+0xde/0x100 [ath10k_core]
> Modules linked in: cmac algif_hash algif_skcipher af_alg bnep arc4
> nls_iso8859_1 wmi_bmof snd_hda_codec_realtek snd_hda_codec_generic
> snd_hda_codec_hdmi edac_mce_amd snd_hda_intel snd_hda_codec kvm_amd
> snd_hda_core ccp snd_hwdep kvm snd_pcm snd_seq_midi crct10dif_pclmul
> snd_seq_midi_event ghash_clmulni_intel pcbc snd_rawmidi ath10k_pci snd_seq
> ath10k_core aesni_intel ath snd_seq_device rtsx_usb_ms btusb aes_x86_64
> snd_timer crypto_simd btrtl cryptd joydev btbcm glue_helper memstick
> mac80211 snd btintel input_leds bluetooth soundcore cfg80211 ecdh_generic
> video wmi mac_hid sch_fq_codel parport_pc ppdev lp parport drm ip_tables
> x_tables autofs4 hid_generic rtsx_usb_sdmmc usbhid rtsx_usb hid crc32_pclmul
> uas i2c_piix4 r8169 ahci realtek usb_storage libahci gpio_amdpt gpio_generic
> CPU: 9 PID: 0 Comm: swapper/9 Not tainted 4.19.186-rc1+ #24
> Hardware name: LENOVO 90Q30008US/3728, BIOS O4ZKT1CA 09/16/2020
> RIP: 0010:ath10k_htt_rx_pop_paddr+0xde/0x100 [ath10k_core]
> Code: 02 00 00 48 85 c9 74 30 4c 8b 49 28 4d 85 c9 74 1e 48 8b 30 45 31 c0
> b9 02 00 00 00 e8 9b 27 ca cc 4c 89 e0 4c 8b 65 f8 c9 c3 <0f> 0b 45 31 e4 4c
> 89 e0 4c 8b 65 f8 c9 c3 48 8b 0d 1d df 4c cd eb
> RSP: 0018:ffff8d81bf043da0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8d81927b2150 RCX: ffff8d81b8c01580
> RDX: 0000000000000008 RSI: 00000000ff708a80 RDI: ffff8d81b8c01e78
> RBP: ffff8d81bf043da8 R08: 0000000000200000 R09: 0000000000000000
> R10: ffffdd1f0f40f300 R11: 000ffffffffff000 R12: ffff8d81b8c02068
> R13: ffff8d81b8c01580 R14: ffff8d81927b2148 R15: ffff8d81b8c01580
> FS:  0000000000000000(0000) GS:ffff8d81bf040000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055a2c99a2000 CR3: 00000003de8d4000 CR4: 0000000000340ee0
> Call Trace:
>  <IRQ>
>  ath10k_htt_txrx_compl_task+0x58d/0xe70 [ath10k_core]
>  ath10k_pci_napi_poll+0x52/0x110 [ath10k_pci]
>  net_rx_action+0x13c/0x350
>  __do_softirq+0xd4/0x2ae
>  irq_exit+0x9c/0xe0
>  do_IRQ+0x86/0xe0
>  common_interrupt+0xf/0xf
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x10b/0x2c0
> Code: ff e8 f9 68 85 ff 80 7d c7 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f
> 85 97 01 00 00 31 ff e8 6c 5d 8b ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff
> f3 01 00 00 4c 2b 7d c8 ba ff ff ff 7f 49 39 c7
> RSP: 0018:ffffb11e01a77e50 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffda
> RAX: ffff8d81bf0626c0 RBX: ffff8d81b2690400 RCX: 00000006e8cb49d2
> RDX: 0000000000000689 RSI: 00000006e8cb49d2 RDI: 0000000000000000
> RBP: ffffb11e01a77e90 R08: 00000006e8cb505b R09: 0000000000000e29
> R10: 0000000000000f04 R11: ffff8d81bf061528 R12: 0000000000000003
> R13: ffffffff8df9e860 R14: ffffffff8df9e980 R15: 00000006e8cb505b
>  cpuidle_enter+0x17/0x20
> 

Odd, there's no ath10k changes in here, only one wireless core change.
Bisection would be great if you can do that, thanks!

greg k-h
