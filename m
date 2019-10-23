Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87CEE18BD
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 13:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404798AbfJWLVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 07:21:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:44017 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404560AbfJWLVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 07:21:15 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9NBL4kp032285;
        Wed, 23 Oct 2019 06:21:04 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id x9NBL27C032274;
        Wed, 23 Oct 2019 06:21:02 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 23 Oct 2019 06:21:02 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     "Oliver O'Halloran" <oohall@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/boot: Fix the initrd being overwritten under qemu
Message-ID: <20191023112102.GN28442@gate.crashing.org>
References: <20191023013635.2512-1-oohall@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023013635.2512-1-oohall@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 12:36:35PM +1100, Oliver O'Halloran wrote:
> When booting under OF the zImage expects the initrd address and size to be
> passed to it using registers r3 and r4. SLOF (guest firmware used by QEMU)
> currently doesn't do this so the zImage is not aware of the initrd
> location.  This can result in initrd corruption either though the zImage
> extracting the vmlinux over the initrd, or by the vmlinux overwriting the
> initrd when relocating itself.
> 
> QEMU does put the linux,initrd-start and linux,initrd-end properties into
> the devicetree to vmlinux to find the initrd. We can work around the SLOF
> bug by also looking those properties in the zImage.

This is not a bug.  What boot protocol requires passing the initrd start
and size in GPR3, GPR4?

The CHRP binding (what SLOF implements) requires passing two zeroes here.
And ePAPR requires passing the address of a device tree and a zero, plus
something in GPR6 to allow distinguishing what it does.

As Alexey says, initramfs works just fine, so please use that?  initrd was
deprecated when this code was written already.


Segher
