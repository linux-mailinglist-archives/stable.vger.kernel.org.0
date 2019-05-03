Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E13133B9
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfECStL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 14:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfECStL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 14:49:11 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B342075E;
        Fri,  3 May 2019 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556909350;
        bh=KGeziaPtUPNmb1W4HZA4UsYcNlgAPR6LLCaYja2jOI0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=a6WHutb8yyJeTowNbUA9CnGwkEfxZjeofA38FDIxS5Gg23KjOr4kO2SXW0CNomKEZ
         M50naF6JDjC5LIgJZnEZE1+wjTwURLekRH/z/YigcLqD8HqQV7pKueBxH2rZqMUMUk
         XFI83FcU348qcOtojOq6MG0+ML7p2H/cCB+EG8vo=
Date:   Fri, 3 May 2019 20:49:05 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc:     Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        stable@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
In-Reply-To: <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
Message-ID: <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org> <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 May 2019, Sebastian Andrzej Siewior wrote:

> Please don't start this. We have everything _GPL that is used for FPU
> related code and only a few functions are exported because KVM needs it.

That's not completely true. There are a lot of static inlines out there, 
which basically made it possible for external modules to use FPU (in some 
way) when they had kernel_fpu_[begin|end]() available.

I personally don't care about ZFS a tiny little bit; but in general, the 
current situation with _GPL and non-_GPL exports is simply not nice. It's 
not really about licensing (despite the name), it's about 'internal vs 
external', which noone is probably able to define properly.

If it would be strictly about license compatibility, that'd at least make 
us somewhat deterministic.

-- 
Jiri Kosina
SUSE Labs

