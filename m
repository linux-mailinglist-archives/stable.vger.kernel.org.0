Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583C9E3A52
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 19:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392216AbfJXRpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 13:45:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:54897 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfJXRpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 13:45:55 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9OHjkAJ010080;
        Thu, 24 Oct 2019 12:45:46 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id x9OHjjCA010079;
        Thu, 24 Oct 2019 12:45:45 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 24 Oct 2019 12:45:45 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     "Oliver O'Halloran" <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/boot: Fix the initrd being overwritten under qemu
Message-ID: <20191024174545.GT28442@gate.crashing.org>
References: <20191023013635.2512-1-oohall@gmail.com> <20191023112102.GN28442@gate.crashing.org> <90a0f702-6891-cd14-f190-5682d7c3778e@ozlabs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90a0f702-6891-cd14-f190-5682d7c3778e@ozlabs.ru>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 12:31:24PM +1100, Alexey Kardashevskiy wrote:
> 
> 
> On 23/10/2019 22:21, Segher Boessenkool wrote:
> > On Wed, Oct 23, 2019 at 12:36:35PM +1100, Oliver O'Halloran wrote:
> >> When booting under OF the zImage expects the initrd address and size to be
> >> passed to it using registers r3 and r4. SLOF (guest firmware used by QEMU)
> >> currently doesn't do this so the zImage is not aware of the initrd
> >> location.  This can result in initrd corruption either though the zImage
> >> extracting the vmlinux over the initrd, or by the vmlinux overwriting the
> >> initrd when relocating itself.
> >>
> >> QEMU does put the linux,initrd-start and linux,initrd-end properties into
> >> the devicetree to vmlinux to find the initrd. We can work around the SLOF
> >> bug by also looking those properties in the zImage.
> > 
> > This is not a bug.  What boot protocol requires passing the initrd start
> > and size in GPR3, GPR4?
> 
> So far I was unable to identify it...

Maybe this comes from yaboot?
https://git.ozlabs.org/?p=yaboot.git;a=blob;f=second/yaboot.c;h=9b66ab44e1be0ee82b88e386a5d0358428766e73;hb=HEAD#l1186

> > The CHRP binding (what SLOF implements) requires passing two zeroes here.
> > And ePAPR requires passing the address of a device tree and a zero, plus
> > something in GPR6 to allow distinguishing what it does.
> > 
> > As Alexey says, initramfs works just fine, so please use that?  initrd was
> > deprecated when this code was written already.
> 
> I did not say about anything working fine :)

Yeah, I read that from your words, wrong it seems.  Sorry.  I often used
INITRAMFS_SOURCE for kernels for use with SLOF, it's just so convenient.

> In my case I was using a new QEMU which does full FDT on client-arch-support and that thing would put the original
> linux,initrd-start/end to the FDT even though the initrd was unpacked and the properties were changes in SLOF. With that
> fixed, this is an alternative fix for SLOF but I am not pushing it out as I have no idea about the bindings and this
> also breaks "vmlinux".
> 
> 
> diff --git a/slof/fs/client.fs b/slof/fs/client.fs
> index 8a7f6ac4326d..138177e4c2a3 100644
> --- a/slof/fs/client.fs
> +++ b/slof/fs/client.fs
> @@ -45,6 +45,17 @@ VARIABLE  client-callback \ Address of client's callback function
>    >r  ciregs >r7 !  ciregs >r6 !  client-entry-point @ ciregs >r5 !
>    \ Initialise client-stack-pointer
>    cistack ciregs >r1 !
> +
> +  s" linux,initrd-end" get-chosen IF decode-int -rot 2drop ELSE 0 THEN
> +  s" linux,initrd-start" get-chosen IF decode-int -rot 2drop ELSE 0 THEN
> +  2dup - dup IF
> +    ciregs >r4 !
> +    ciregs >r3 !
> +    drop
> +  ELSE
> +    3drop
> +  THEN

Something like that should work fine.  Do it in go-32 and go-64 though?
Or is that the wrong spot?


Segher
