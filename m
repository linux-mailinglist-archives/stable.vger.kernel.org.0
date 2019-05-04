Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF7E136BA
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 02:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEDArx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 20:47:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55099 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbfEDArx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 20:47:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id b10so9018058wmj.4;
        Fri, 03 May 2019 17:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+RUUwZtfXQ6xT1Hl/GMU6GnIUFgYiZSHQrHKa24Cz/8=;
        b=e9jyjmpD8fiiYb49IxcHxpChjnbrt1GkXmGxwB1yqkxqqVlETUfPgyoZF8OLyj8Vlg
         TKU5W4H1geDqj7jHrt6evWTUgDGUX0won4Lwepx20VYfP/p8znKpo19B9ccdU4NqOfk4
         htvFT2oqzAo5G+bqmXBiY74Rq0y/8JgentxiMLcK5adNQH4wC/OzHa5bvQKENmpbrZR8
         DGpH5hMMBDSGlHqRwQCvasbq4AtHAsMqZpi9zeMET3SEXEDs8MZq3wgzcXRhzHSyGBpq
         Ov0xyP8imrn2hjPKGe1Tm3pUi3xozie3c/EKMviGvs94DdVAApEGMcs5QiSPBuVInWw5
         cUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+RUUwZtfXQ6xT1Hl/GMU6GnIUFgYiZSHQrHKa24Cz/8=;
        b=c/9a//Dj/6wyitwDni17HA1MpodR5f7D5TzRIA3Y+86q5AimLHPxIfZiUxvho3ZbeH
         MBpL//w8k4JM1xNCPnccZimXobPT6WJEWutk4+KSxItTOcQlKNB0HfKrihlzZiBcCSwX
         k+sB8epLo+/4yLQjCTWK6SJjcIjXumTx1Nmnq4S4bvGEPPTgeHZDE0C/Ov+oVG3b5mIs
         OLZ1h/K0Si1zmongVzwvYP47n/mYStYzwl2rnL+BoY9ro9JyjClCMcnEOZPfrE3nxuno
         P40fi6wklOBjm7eJO6dTp+RIqQQSt0g12AwhBcjMFYQIO6+aQ7U+iXAAGsnaZBqsvBSK
         99FA==
X-Gm-Message-State: APjAAAUDsaKij/9HaSF/WOxarqGm+mRdvt4/7VNqiw4/hS7YuyGMzLk0
        MUyX22d4jIAP7fqgEKSErUg=
X-Google-Smtp-Source: APXvYqz0+T8y6x0T9meXdQkJNwiqY/hDY+0VfBJ31nL1K7ogZV8XxypLDM0xmr9I9Hgakjqvgu4rng==
X-Received: by 2002:a7b:ce84:: with SMTP id q4mr8590958wmj.41.1556930870237;
        Fri, 03 May 2019 17:47:50 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id n17sm3078515wrw.77.2019.05.03.17.47.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 17:47:49 -0700 (PDT)
Date:   Sat, 4 May 2019 02:47:47 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
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
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        stable@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Message-ID: <20190504004747.GA107909@gmail.com>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Jiri Kosina <jikos@kernel.org> wrote:

> On Thu, 2 May 2019, Sebastian Andrzej Siewior wrote:
> 
> > Please don't start this. We have everything _GPL that is used for FPU
> > related code and only a few functions are exported because KVM needs it.
> 
> That's not completely true. There are a lot of static inlines out there, 
> which basically made it possible for external modules to use FPU (in some 
> way) when they had kernel_fpu_[begin|end]() available.
> 
> I personally don't care about ZFS a tiny little bit; but in general, the 
> current situation with _GPL and non-_GPL exports is simply not nice. It's 
> not really about licensing (despite the name), it's about 'internal vs 
> external', which noone is probably able to define properly.

But that's exactly what licensing *IS* about: the argument is that 
'internal' interfaces are clear proof that the binary module is actually 
a derived work of the kernel.

(Using regular exported symbols might still make a binary module derived 
work, but it's less clear-cut.)

So don't be complicit with binary module authors who try to circumvent 
the GPL by offloading the actual license violation to the end user ...

> If it would be strictly about license compatibility, that'd at least 
> make us somewhat deterministic.

License compatibility is rarely deterministic to begin with, there's a 
lot of grey area. Adding _GPL increases the likelihood that the module 
using it has to be covered by the GPL too. In fact behavior of binary 
modules seems to confirm that legal expectation: very few binary modules 
are trying to circumvent _GPL symbols by ignoring the _GPL attribute.

Anyway, in terms of _GPL exports the policy has always been that if a 
major author of the code asks for a symbol to be _GPL, then it should be 
so, even if other authors have a different judgement.

Thanks,

	Ingo
