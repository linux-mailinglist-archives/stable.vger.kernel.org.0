Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F947401A2D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 12:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhIFKx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 06:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhIFKx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 06:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46AF60BD3;
        Mon,  6 Sep 2021 10:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630925543;
        bh=7aB6HfPdr5Yl8Nnnfur1GuUry6u6BYdCQEqDbhYDueE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TQ4dC4sUY+wPs5mbHvpU3f5ki/gIUIrHjxzHsNAZOi3eRMR+Wo295abanu0l4e9od
         u0ORDGzVdaowGZAJpMwc77qciLVXFWBJ/6o2zb2GLtz8J4RBoHo2SWvbyoUNYBi0kw
         0olCigQ/27Ztn6KxLkeaaKshkgyKLE1akkZ5ALBQ=
Date:   Mon, 6 Sep 2021 12:52:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wim <wim@djo.tudelft.nl>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel-4.9.270 crash
Message-ID: <YTXy5BmzQpY0SprA@kroah.com>
References: <20210904235231.GA31607@djo.tudelft.nl>
 <20210905190045.GA10991@djo.tudelft.nl>
 <YTWgKo4idyocDuCD@kroah.com>
 <20210906093611.GA20123@djo.tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906093611.GA20123@djo.tudelft.nl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 11:36:11AM +0200, wim wrote:
> On Mon, Sep 06, 2021 at 06:59:22AM +0200, Greg KH wrote:
> > On Sun, Sep 05, 2021 at 09:00:45PM +0200, wim wrote:
> > > On Sun, Sep 05, 2021 at 01:52:31AM +0200, wim wrote:
> > > > 
> > > > Hello Greg,
> > > > 
> > > > from kernel-4.9.270 up until now (4.9.282) I experience kernel crashes upon
> > > > loading a GPU module.
> > > > It happens on two out of at least six different machines.
> > > > I can't believe that I'm the only one where that happens, but since the bug
> > > > is still there twelve versions later, I need to report this.
> > > > ...
> > 
> > Do you have any kernel log messages when these crashes happen?
> 
> On the AMD machine:
> 
> Aug  1 20:51:24 djo kernel: [drm] Initialized
> Aug  1 20:51:24 djo kernel: checking generic (a0000 10000) vs hw (e0000000 8000000)
> Aug  1 20:51:24 djo kernel: checking generic (a0000 10000) vs hw (ea000000 1000000)
> Aug  1 20:51:24 djo kernel: fb: switching to nouveaufb from VGA16 VGA
> Aug  1 20:51:24 djo kernel: divide error: 0000 [#1] SMP
> Aug  1 20:51:24 djo kernel: Modules linked in: nouveau(+) video drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm agpgart i2c_algo_bit tun lirc_serial(C) lirc_dev arc4 binfmt_misc snd_pcm_oss snd_mixer_oss fbcon bitblit softcursor font tileblit ath9k_htc ath9k_common ath9k_hw ath mac80211 cfg80211 uvcvideo rfkill firmware_class snd_usb_audio sr9700 videobuf2_vmalloc videobuf2_memops snd_usbmidi_lib videobuf2_v4l2 dm9601 videobuf2_core usbnet snd_rawmidi mii usb_storage snd_hda_codec_generic kvm snd_hda_intel irqbypass snd_hda_codec gpio_ich ppdev snd_hwdep pcspkr snd_hda_core snd_pcm uhci_hcd ohci_pci snd_timer ohci_hcd lpc_ich ehci_pci snd ehci_hcd wmi mfd_core usbcore soundcore parport_pc floppy usb_common parport acpi_cpufreq button processor
> Aug  1 20:51:24 djo kernel: CPU: 0 PID: 2791 Comm: modprobe Tainted: G         C      4.9.277 #1
> Aug  1 20:51:24 djo kernel: Hardware name: Hewlett-Packard HP xw4300 Workstation/0A00h, BIOS 786D3 v01.08 03/10/2006
> Aug  1 20:51:24 djo kernel: task: f6317080 task.stack: f4058000
> Aug  1 20:51:24 djo kernel: EIP: 0060:[<c02f789d>] EFLAGS: 00010206 CPU: 0
> Aug  1 20:51:24 djo kernel: EAX: 00000190 EBX: ffffffea ECX: 00000019 EDX: 00000000
> Aug  1 20:51:24 djo kernel: ESI: f52db800 EDI: 00000050 EBP: c02f7838 ESP: f4059c10
> Aug  1 20:51:24 djo kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Aug  1 20:51:24 djo kernel: CR0: 80050033 CR2: 080a1a54 CR3: 35234000 CR4: 00000690
> Aug  1 20:51:24 djo kernel: Stack:
> Aug  1 20:51:24 djo kernel:  00000050 f52db800 00000019 c0340732 00000000 000000a0 000000a0 00000fa0
> Aug  1 20:51:24 djo kernel:  f62f4000 0000001e 00000000 00000000 f5a63800 00000000 00000000 00000000
> Aug  1 20:51:24 djo kernel:  00000000 00000000 f6024000 00000000 f52db800 00000001 00000000 00000000
> Aug  1 20:51:24 djo kernel: Call Trace:
> Aug  1 20:51:24 djo kernel:  [<c0340732>] ? 0xc0340732
> Aug  1 20:51:24 djo kernel:  [<c0340988>] ? 0xc0340988
> Aug  1 20:51:24 djo kernel:  [<c02f734a>] ? 0xc02f734a
> Aug  1 20:51:24 djo kernel:  [<c033f780>] ? 0xc033f780
> Aug  1 20:51:24 djo kernel:  [<c0340b32>] ? 0xc0340b32
> Aug  1 20:51:24 djo kernel:  [<c0340d20>] ? 0xc0340d20
> Aug  1 20:51:24 djo kernel:  [<f8bc4ef7>] ? 0xf8bc4ef7
> Aug  1 20:51:24 djo kernel:  [<c0163715>] ? 0xc0163715

<snip>

These aren't going to help us much, can you turn on debugging symbols
for these crashes for us to see the symbol names?

<snip>

> > Can you use 'git bisect' to track down the offending commit?
> 
> If I would know how to do that

'man git bisect' should provide a tutorial on how to do this.

> > And why are you stuck on 4.9.y for these machines?  Why not use 5.10 or
> > newer?
> 
> Because in 4.10 they dropped lirc-serial and I need that. The new ir-serial
> is no replacement. (The last working version of LIRC is 0.9.6. After that
> they destroyed transmitter support.)
> 
> (I believe irda support got dropped too, which I need for my old nokia.)

If the new functionality is not working properly, please work with those
developers to fix that up.  Sticking with the 4.4.x kernel isn't going
to be a good long-term solution for you.

thanks,

greg k-h
