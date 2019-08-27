Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892339E957
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfH0Nav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 09:30:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43700 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfH0Nav (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 09:30:51 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2bYN-0006N9-RX; Tue, 27 Aug 2019 15:30:31 +0200
Date:   Tue, 27 Aug 2019 15:30:30 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Pavel Machek <pavel@denx.de>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chen Yu <yu.c.chen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4.19 72/98] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD
 family 15h/16h
In-Reply-To: <20190827113604.GB18218@amd>
Message-ID: <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
References: <20190827072718.142728620@linuxfoundation.org> <20190827072722.020603090@linuxfoundation.org> <20190827113604.GB18218@amd>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Aug 2019, Pavel Machek wrote:

> On Tue 2019-08-27 09:50:51, Greg Kroah-Hartman wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > commit c49a0a80137c7ca7d6ced4c812c9e07a949f6f24 upstream.
> > 
> > There have been reports of RDRAND issues after resuming from suspend on
> > some AMD family 15h and family 16h systems. This issue stems from a BIOS
> > not performing the proper steps during resume to ensure RDRAND continues
> > to function properly.
> 
> Yes. And instead of reinitializing the RDRAND on resume, this patch
> breaks support even for people with properly functioning BIOSes...

There is no way to reinitialize RDRAND from the kernel otherwise we would
have exactly done that. If you know how to do that please tell.

Also disabling it for every BIOS is the only way which can be done because
there is no way to know whether the BIOS is fixed or not at cold boot
time. And it has to be known there because applications cache the
availablity and continue using it after resume and because the valid bit is
set they wont notice.

There is a know to turn it back on for those who are sure that it works,
but the default has to be: OFF simply because we cannot endanger everyone
out there with a broken BIOS just to please you.

Thanks,

	tglx
