Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709B72A165
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 00:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404403AbfEXWnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 18:43:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50949 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404233AbfEXWnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 18:43:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so10825145wme.0
        for <stable@vger.kernel.org>; Fri, 24 May 2019 15:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oa7UbfYVeCwLKLU+I06sWF4eFZmxQELh4i0FDmnh2dw=;
        b=WPpYpf7o4RZ8f8KmX4IvSqkSjZTbwvrocJPBZL/ZT8ZlnguynubKFMS+wyADlMqKyp
         P2aNVOv1KlOxfWYz88Zu13fr4QESLRJj1ysjXD8IJ81/j1nwMEv46B812QsZyboGLrIB
         mtLipigrnwRgi4/v3SasJ/Hb0nTEgdf8pCNWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oa7UbfYVeCwLKLU+I06sWF4eFZmxQELh4i0FDmnh2dw=;
        b=kutfpqF1bI9J1BgfqUmMl58AvjJfSFLefQMyKRsqH5PoS0CIvSjE0wRpLRDlutVNjy
         awuAsLxK5LyZvGRR5dE/ez3MHpIKEu83jnrxvBaanFNDsaJOy+wLkuDA0keFEox+hDBF
         broocgZ5qMKN83fNVQV5Mj6xAtanTaX2tsiLGX69fXBAFvLNTQXJflPllDGj215A+G9S
         pQtGt2b4Pc3Jqj24gvYh1gJ9s33ysWu8E/zrSdFKT68AMyvyWZUaUTaBgGd1J+wWwYMv
         rlK5qtZ7OLaXK2bUm2hF8HdRX3umYkHHLC6WFdCga5k4y+S8WJJOEbgqCZG8e1kE5IG/
         IwMQ==
X-Gm-Message-State: APjAAAV4QO2gmOlBqnEyL0w/y0PpRJu4bpn+9AZy2SLHcFmd/OVq/swu
        DNmpqIYV/vVKOFkpirM8rHxY7Q==
X-Google-Smtp-Source: APXvYqyd6QA6iZV7i8EOaAlRjZp2fo6MhHvgm56Yv2NaB7/nzFb87nK+fcNkoY4m4wvJjCjU8J3kVw==
X-Received: by 2002:a1c:9e8e:: with SMTP id h136mr17073896wme.29.1558737830520;
        Fri, 24 May 2019 15:43:50 -0700 (PDT)
Received: from andrea ([89.22.71.151])
        by smtp.gmail.com with ESMTPSA id x9sm2574760wmf.27.2019.05.24.15.43.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 15:43:49 -0700 (PDT)
Date:   Sat, 25 May 2019 00:43:40 +0200
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, aou@eecs.berkeley.edu, arnd@arndb.de,
        bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        fenghua.yu@intel.com, heiko.carstens@de.ibm.com,
        herbert@gondor.apana.org.au, ink@jurassic.park.msu.ru,
        jhogan@kernel.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mingo@kernel.org, mpe@ellerman.id.au, palmer@sifive.com,
        paul.burton@mips.com, paulus@samba.org, ralf@linux-mips.org,
        rth@twiddle.net, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, vgupta@synopsys.com,
        gregkh@linuxfoundation.org, jhansen@vmware.com, vdasa@vmware.com,
        aditr@vmware.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190524224340.GA3792@andrea>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
 <20190524103731.GN2606@hirez.programming.kicks-ass.net>
 <20190524111807.GS2650@hirez.programming.kicks-ass.net>
 <20190524114220.GA4260@fuggles.cambridge.arm.com>
 <20190524115231.GN2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524115231.GN2623@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> ---
> Subject: Documentation/atomic_t.txt: Clarify pure non-rmw usage
> 
> Clarify that pure non-RMW usage of atomic_t is pointless, there is
> nothing 'magical' about atomic_set() / atomic_read().
> 
> This is something that seems to confuse people, because I happen upon it
> semi-regularly.
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  Documentation/atomic_t.txt | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
> index dca3fb0554db..89eae7f6b360 100644
> --- a/Documentation/atomic_t.txt
> +++ b/Documentation/atomic_t.txt
> @@ -81,9 +81,11 @@ SEMANTICS
>  
>  The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
>  implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
> -smp_store_release() respectively.
> +smp_store_release() respectively. Therefore, if you find yourself only using
> +the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
> +and are doing it wrong.

The counterargument (not so theoretic, just look around in the kernel!) is:
we all 'forget' to use READ_ONCE() and WRITE_ONCE(), it should be difficult
or more difficult to forget to use atomic_read() and atomic_set()...   IAC,
I wouldn't call any of them 'wrong'.

  Andrea


>  
> -The one detail to this is that atomic_set{}() should be observable to the RMW
> +A subtle detail of atomic_set{}() is that it should be observable to the RMW
>  ops. That is:
>  
>    C atomic-set
