Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E400137D1
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 08:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfEDGkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 02:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfEDGkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 02:40:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C0420675;
        Sat,  4 May 2019 06:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556952043;
        bh=0Ftj/3PzhwV4/auuONbabTb56xCaipaSaiEBU3GT0Ww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1XC+EywlhZEUrQ5rCeT1HuWtfedf999QLIBYexcBC+WZlwj2k9RKcYB7DCbVsYutE
         E11X9CgGo/TQHcFOPnQDyh7Z+7ur4qbUm9ZSmIGtjCMm2QEG91ZiZ2ibv9CV4uS3AY
         OEQPREOquHyd1HDjV1y9lFcDO292VgIoZSJNIW5U=
Date:   Sat, 4 May 2019 08:40:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>
Cc:     Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
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
        stable@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Message-ID: <20190504064041.GB26311@kroah.com>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
 <20190504004747.GA107909@gmail.com>
 <2238f6ed-9338-903c-760c-6200e73b1599@newmedia-net.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2238f6ed-9338-903c-760c-6200e73b1599@newmedia-net.de>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 04, 2019 at 04:28:17AM +0200, Sebastian Gottschall wrote:
> 
> Am 04.05.2019 um 02:47 schrieb Ingo Molnar:
> > * Jiri Kosina <jikos@kernel.org> wrote:
> > 
> > > On Thu, 2 May 2019, Sebastian Andrzej Siewior wrote:
> > > 
> > > > Please don't start this. We have everything _GPL that is used for FPU
> > > > related code and only a few functions are exported because KVM needs it.
> > > That's not completely true. There are a lot of static inlines out there,
> > > which basically made it possible for external modules to use FPU (in some
> > > way) when they had kernel_fpu_[begin|end]() available.
> > > 
> > > I personally don't care about ZFS a tiny little bit; but in general, the
> > > current situation with _GPL and non-_GPL exports is simply not nice. It's
> > > not really about licensing (despite the name), it's about 'internal vs
> > > external', which noone is probably able to define properly.
> > But that's exactly what licensing *IS* about: the argument is that
> > 'internal' interfaces are clear proof that the binary module is actually
> > a derived work of the kernel.
> Using fpu code in kernel space in a kernel module is a derived work of the
> kernel itself?
> dont get me wrong, but this is absurd. i mean you limit the use of cpu
> instructions. the use
> of cpu instructions should be free of any licensing issue. i would even
> argument you are violating
> the license of the cpu ower given to the kernel by executing it, by
> restricting its use for no reason

Now you are just being crazy, please go talk to a lawyer about how the
GPL actually works.

If Andy wants to change the symbol of what he wrote from
EXPORT_SYMBOL_GPL() to EXPORT_SYMBOL(), that's fine, it's his option.
Any loony discussion about if this is actually a licensing issue or not
needs to just go to /dev/null

As homework, everyone please go read this:
	http://softwarefreedom.org/resources/2014/SFLC-Guide_to_GPL_Compliance_2d_ed.pdf
and remember that the license of the Linux kernel is GPLv2.

Now where's the "kill this thread" option on mutt so I don't have to see
any more of this nonsense...

greg k-h
