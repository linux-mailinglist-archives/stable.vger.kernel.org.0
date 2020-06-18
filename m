Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C195C1FF2D5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgFRNRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 09:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbgFRNQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 09:16:59 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FFCC06174E;
        Thu, 18 Jun 2020 06:16:59 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id y6so4839954edi.3;
        Thu, 18 Jun 2020 06:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=48gB+FKpHGZivOJlNsg9by7jPEV/1dGczJbcHmuBME4=;
        b=Geh+g+f9ChaBf/gxuwgIH8IkAR58S9I0a0k9wYrv7U7Q1Q8vYUYy2X2pfXF1nQMBE5
         EfwQzcGke/qewUUjtLfbGftBSVKWohwJDphitmQ4atJ5ZXd+pUYUbM3WsJk6QN6fHMoE
         7eDl12g0YhfaKbBUAUm0AHqh4FicEnjWjMrD7hOCHSEz0SGZcShCw2beo7Us3l32TvPf
         g63h75qi+spKdRLjUTkdQvc9NM6viCOvbFBYledJzJXspd2+4g09a7pZHRUHAjCW0v93
         o996z5gN5fkSx+g+hYSv94xo+t44Y32Evta7w0WqD0zxGjfCEbn07wLZXgI/REOygrtE
         JWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=48gB+FKpHGZivOJlNsg9by7jPEV/1dGczJbcHmuBME4=;
        b=e3CStdF3OnVzxkodE4oC0HHh/rmG7u6nqvRL/off3IYYbmKpzSLWs3bzHJqRBqDMNd
         bQaEAeOrrtHdCgvWhe2gC/9RALyXU+vB3BpfaxSYxLukqLn7ZDXv3MR0IWNx952W4hwo
         t9dZAVi1cJnmMY1g85y/yyNaoJema3bi3CJ2hW/jwrRPiuXVYj0VKgBnpRdcZHCQlzM5
         Ud6oL7jORO6LB0nLPWv+XD/ENPzQ0vYi0Zqmwusiw2ONDv4UvGHjwf5OFmDbznvoqD/4
         PigmX+gYXGwHbt6ao8V7WfPxwncZBqSnpmt/eNfT3VNhqTX+HVPlad+qX7rxC77mb//H
         C7lA==
X-Gm-Message-State: AOAM531BQxhRxXx73QRLmea3El0UYbjYbPyqplRaIQxWkA8yPkPwWaX+
        ZW4/kooNmTx2WoqZY/UFaA==
X-Google-Smtp-Source: ABdhPJyGznE7ezxmDoITq/swZTW/ORC7BGRM2zzOvwu6Eazh7ADEURRz35DVgPF4yv5a7xm0AV5Daw==
X-Received: by 2002:a50:9b16:: with SMTP id o22mr3972554edi.130.1592486218015;
        Thu, 18 Jun 2020 06:16:58 -0700 (PDT)
Received: from localhost.localdomain ([46.53.250.254])
        by smtp.gmail.com with ESMTPSA id n3sm2310261ejd.82.2020.06.18.06.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 06:16:57 -0700 (PDT)
Date:   Thu, 18 Jun 2020 16:16:55 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Matt Fleming' <matt@codeblueprint.co.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Kumar, Venkataramanan" <Venkataramanan.Kumar@amd.com>,
        Jan Kara <jack@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/asm/64: Align start of __clear_user() loop to
 16-bytes
Message-ID: <20200618131655.GA24607@localhost.localdomain>
References: <20200618102002.30034-1-matt@codeblueprint.co.uk>
 <39f8304b75094f87a54ace7732708d30@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <39f8304b75094f87a54ace7732708d30@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 10:48:05AM +0000, David Laight wrote:
> From: Matt Fleming
> > Sent: 18 June 2020 11:20
> > x86 CPUs can suffer severe performance drops if a tight loop, such as
> > the ones in __clear_user(), straddles a 16-byte instruction fetch
> > window, or worse, a 64-byte cacheline. This issues was discovered in the
> > SUSE kernel with the following commit,
> > 
> >   1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")
> > 
> > which increased the code object size from 10 bytes to 15 bytes and
> > caused the 8-byte copy loop in __clear_user() to be split across a
> > 64-byte cacheline.
> > 
> > Aligning the start of the loop to 16-bytes makes this fit neatly inside
> > a single instruction fetch window again and restores the performance of
> > __clear_user() which is used heavily when reading from /dev/zero.
> > 
> > Here are some numbers from running libmicro's read_z* and pread_z*
> > microbenchmarks which read from /dev/zero:
> > 
> >   Zen 1 (Naples)
> > 
> >   libmicro-file
> >                                         5.7.0-rc6              5.7.0-rc6              5.7.0-rc6
> >                                                     revert-1153933703d9+               align16+
> >   Time mean95-pread_z100k       9.9195 (   0.00%)      5.9856 (  39.66%)      5.9938 (  39.58%)
> >   Time mean95-pread_z10k        1.1378 (   0.00%)      0.7450 (  34.52%)      0.7467 (  34.38%)
> >   Time mean95-pread_z1k         0.2623 (   0.00%)      0.2251 (  14.18%)      0.2252 (  14.15%)
> >   Time mean95-pread_zw100k      9.9974 (   0.00%)      6.0648 (  39.34%)      6.0756 (  39.23%)
> >   Time mean95-read_z100k        9.8940 (   0.00%)      5.9885 (  39.47%)      5.9994 (  39.36%)
> >   Time mean95-read_z10k         1.1394 (   0.00%)      0.7483 (  34.33%)      0.7482 (  34.33%)
> > 
> > Note that this doesn't affect Haswell or Broadwell microarchitectures
> > which seem to avoid the alignment issue by executing the loop straight
> > out of the Loop Stream Detector (verified using perf events).
> 
> Which cpu was affected?
> At least one source (www.agner.org/optimize) implies that both ivy
> bridge and sandy bridge have uop caches that mean (If I've read it
> correctly) the loop shouldn't be affected by the alignment).
> 
> > diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> > index fff28c6f73a2..b0dfac3d3df7 100644
> > --- a/arch/x86/lib/usercopy_64.c
> > +++ b/arch/x86/lib/usercopy_64.c
> > @@ -24,6 +24,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
> >  	asm volatile(
> >  		"	testq  %[size8],%[size8]\n"
> >  		"	jz     4f\n"
> > +		"	.align 16\n"
> >  		"0:	movq $0,(%[dst])\n"
> >  		"	addq   $8,%[dst]\n"
> >  		"	decl %%ecx ; jnz   0b\n"
> 
> You can do better that that loop.
> Change 'dst' to point to the end of the buffer, negate the count
> and divide by 8 and you get:
> 		"0:	movq $0,($[dst],%%ecx,8)\n"
> 		"	add $1,%%ecx"
> 		"	jnz 0b\n"
> which might run at one iteration per clock especially on cpu that pair
> the add and jnz into a single uop.
> (You need to use add not inc.)

/dev/zero should probably use REP STOSB etc just like everything else.
