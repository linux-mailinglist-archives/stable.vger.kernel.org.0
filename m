Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D411EDE
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfEBPlh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 2 May 2019 11:41:37 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:54788 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbfEBPlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 11:41:36 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hMDpD-0003Af-Oh; Thu, 02 May 2019 17:40:44 +0200
Date:   Thu, 2 May 2019 17:40:43 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Message-ID: <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-05-02 07:42:14 [-0700], Andy Lutomirski wrote:
> The FPU is not a super-Linuxy internal detail, so remove the _GPL
> from its export.  Without something like this patch, it's impossible
> for even highly license-respecting non-GPL modules to use the FPU,
> which seems silly to me.  After all, the FPU is a CPU feature, not
> really a kernel feature at all.
> 
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc:: Borislav Petkov <bp@suse.de>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Nicolai Stange <nstange@suse.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 12209993e98c ("x86/fpu: Don't export __kernel_fpu_{begin,end}()")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
> 
> This fixes a genuine annoyance for ZFS on Linux.  Regardless of what
> one may think about the people who distribute ZFS on Linux
> *binaries*, as far as I know, the source and the users who build it
> themselves are entirely respectful of everyone's license.  I have no
> problem with EXPORT_SYMBOL_GPL() in general, but let's please avoid
> using it for things that aren't fundamentally Linux internals.

Please don't start this. We have everything _GPL that is used for FPU
related code and only a few functions are exported because KVM needs it.
Also with the recent FPU rework it is much easier to get this wrong so I
would not want for any OOT code to mess with it.

And again: It does not change whether or not ZFS can be used on Linux
(excluding the license issue). They simply can't use crc32 with their
SSE assembly and this is it.

Sebastian
