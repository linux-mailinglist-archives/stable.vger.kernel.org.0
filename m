Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620F93214C8
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhBVLI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 06:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhBVLI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 06:08:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BC4864E00;
        Mon, 22 Feb 2021 11:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613992095;
        bh=Gt0x8QOkAQPqnY1fGhFu2p/Oyaw0NHvv+Ng2Hl5YfzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SiPRHL5v0401gMt0GAu2PsMoc2Cv7DFCkAgiORJr5EEJymtaaovHG9FRk1K58JZ1V
         RKHlTcQdDD5rd7rqEr8RU4l52sO3Ju6wyl1bm3/SuRVY22bGRqFgeKKIPFybHoBZ4q
         LLKCMiBG0fkoS0XXFwzm0ytNTe/33JY072ix+GtY=
Date:   Mon, 22 Feb 2021 12:08:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] media: pwc: Use correct device for DMA
Message-ID: <YDOQm7KOy06anuVj@kroah.com>
References: <20210117110523.26757-1-matwey@sai.msu.ru>
 <YAQz9LkI7H/DiQmy@kroah.com>
 <CAJs94EaX-aP0Fz+wABti5Hj9j3=b7UQ+SFLK_TOn8XDNbmPLiA@mail.gmail.com>
 <YAQ5mEWweMwRO1z4@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YAQ5mEWweMwRO1z4@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 17, 2021 at 02:20:24PM +0100, Greg KH wrote:
> On Sun, Jan 17, 2021 at 04:02:53PM +0300, Matwey V. Kornilov wrote:
> > вс, 17 янв. 2021 г. в 15:56, Greg KH <gregkh@linuxfoundation.org>:
> > 
> > > On Sun, Jan 17, 2021 at 02:05:23PM +0300, Matwey V. Kornilov wrote:
> > > > This fixes the following newly introduced warning:
> > > >
> > > > [   15.518253] ------------[ cut here ]------------
> > > > [   15.518941] WARNING: CPU: 0 PID: 246 at kernel/dma/mapping.c:149
> > > dma_map_page_attrs+0x1a8/0x1d0
> > > > [   15.520634] Modules linked in: pwc videobuf2_vmalloc videobuf2_memops
> > > videobuf2_v4l2 videobuf2_common videodev mc efivarfs
> > > > [   15.522335] CPU: 0 PID: 246 Comm: v4l2-test Not tainted 5.11.0-rc1+ #1
> > > > [   15.523281] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> > > 0.0.0 02/06/2015
> > > > [   15.524438] RIP: 0010:dma_map_page_attrs+0x1a8/0x1d0
> > > > [   15.525135] Code: 10 5b 5d 41 5c 41 5d c3 4d 89 d0 eb d7 4d 89 c8 89
> > > e9 48 89 da e8 68 29 00 00 eb d1 48 89 f2 48 2b 50 18 48 89 d0 eb 83 0f 0b
> > > <0f> 0b 48 c7 c0 ff ff ff ff eb b8 48 89 d9 48 8b 40 40 e8 61 69 d2
> > > > [   15.527938] RSP: 0018:ffffa2694047bca8 EFLAGS: 00010246
> > > > [   15.528716] RAX: 0000000000000000 RBX: 0000000000002580 RCX:
> > > 0000000000000000
> > > > [   15.529782] RDX: 0000000000000000 RSI: ffffcdce000ecc00 RDI:
> > > ffffa0b4bdb888a0
> > > > [   15.530849] RBP: 0000000000000002 R08: 0000000000000002 R09:
> > > 0000000000000000
> > > > [   15.531881] R10: 0000000000000004 R11: 000000000002d8c0 R12:
> > > 0000000000000000
> > > > [   15.532911] R13: ffffa0b4bdb88800 R14: ffffa0b483820000 R15:
> > > ffffa0b4bdb888a0
> > > > [   15.533942] FS:  00007fc5fbb5e4c0(0000) GS:ffffa0b4fc000000(0000)
> > > knlGS:0000000000000000
> > > > [   15.535141] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [   15.535988] CR2: 00007fc5fb6ea138 CR3: 0000000003812000 CR4:
> > > 00000000001506f0
> > > > [   15.537025] Call Trace:
> > > > [   15.537425]  start_streaming+0x2e9/0x4b0 [pwc]
> > > > [   15.538143]  vb2_start_streaming+0x5e/0x110 [videobuf2_common]
> > > > [   15.538989]  vb2_core_streamon+0x107/0x140 [videobuf2_common]
> > > > [   15.539831]  __video_do_ioctl+0x18f/0x4a0 [videodev]
> > > > [   15.540670]  video_usercopy+0x13a/0x5b0 [videodev]
> > > > [   15.541349]  ? video_put_user+0x230/0x230 [videodev]
> > > > [   15.542096]  ? selinux_file_ioctl+0x143/0x200
> > > > [   15.542752]  v4l2_ioctl+0x40/0x50 [videodev]
> > > > [   15.543360]  __x64_sys_ioctl+0x89/0xc0
> > > > [   15.543930]  do_syscall_64+0x33/0x40
> > > > [   15.544448]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > [   15.545236] RIP: 0033:0x7fc5fb671587
> > > > [   15.545780] Code: b3 66 90 48 8b 05 11 49 2c 00 64 c7 00 26 00 00 00
> > > 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05
> > > <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 48 2c 00 f7 d8 64 89 01 48
> > > > [   15.548486] RSP: 002b:00007fff0f71f038 EFLAGS: 00000246 ORIG_RAX:
> > > 0000000000000010
> > > > [   15.549578] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
> > > 00007fc5fb671587
> > > > [   15.550664] RDX: 00007fff0f71f060 RSI: 0000000040045612 RDI:
> > > 0000000000000003
> > > > [   15.551706] RBP: 0000000000000000 R08: 0000000000000000 R09:
> > > 0000000000000000
> > > > [   15.552738] R10: 0000000000000000 R11: 0000000000000246 R12:
> > > 00007fff0f71f060
> > > > [   15.553817] R13: 00007fff0f71f1d0 R14: 0000000000de1270 R15:
> > > 0000000000000000
> > > > [   15.554914] ---[ end trace 7be03122966c2486 ]---
> > > >
> > > > Fixes: 1161db6776bd ("media: usb: pwc: Don't use coherent DMA buffers
> > > for ISO transfer")
> > > > Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> > > > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210777
> > > > Cc: stable@vger.kernel.org # v5.10+
> > > > Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> > > > ---
> > > >  drivers/media/usb/pwc/pwc-if.c | 22 +++++++++++++---------
> > > >  1 file changed, 13 insertions(+), 9 deletions(-)
> > >
> > > What is the git commit id of this commit in Linus's tree?
> > >
> > 
> > 
> > It is 69c9e825e812ec6d663e64ebf14bd3bc7f37e2c7 in next/linux-next.git
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 
> We can't do anything with a patch that is not in Linus's tree, sorry.
> Please wait for it to show up there before asking us to backport
> something that is not already tagged with a "cc: stable" mark.

Now queued up.

thanks,

greg k-h
