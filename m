Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908B93FD941
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243914AbhIAMKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:10:10 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:43714
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243873AbhIAMKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 08:10:09 -0400
Received: from mussarela (201-69-234-220.dial-up.telesp.net.br [201.69.234.220])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id EBA3F3F049;
        Wed,  1 Sep 2021 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630498151;
        bh=592zJBHPQ18BCV/B2vMAyBLKmPv4PHYtdUunpe+UzF8=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=BtRw0RX/bjpBRKQunQh9UHJ1CCSui+ZRuh7qeSWmyfJc7mt8sx+DxiNjXNaNblT00
         l96i8csW7GJyjhqIyuRRXdxrOcVdFYn8I970v9Gzpvc5eeXpuK84Fq63p8UOy96g9+
         DKb/W/CTtQ7cOSJBoewhdRLFPsZhmj8UW97E+QWZAyZkau7Jw1IVfEjpMjIgXQUESa
         kPrlwvaSsxm2XFvvWH9lGW7+nWwi+x6vEKnFNqecca5Hl85THYynlboFh+DbeAPrfJ
         CAmmUUj+wRQ/MAy613AGZ3A/C/ehuyXJK1DBdTjrKfYLTVmjxeFjjDceHXSmNs0j+J
         lWnnipKvKEGpA==
Date:   Wed, 1 Sep 2021 09:09:05 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH 4.14 1/4] bpf: Do not use ax register in interpreter on
 div/mod
Message-ID: <YS9tYezeg8EH6nk2@mussarela>
References: <20210830183211.339054-1-cascardo@canonical.com>
 <20210830183211.339054-2-cascardo@canonical.com>
 <YS9kXabJPWScxiHi@kroah.com>
 <YS9khsCFrPQ4PZDm@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YS9khsCFrPQ4PZDm@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 01:31:18PM +0200, Greg KH wrote:
> On Wed, Sep 01, 2021 at 01:30:37PM +0200, Greg KH wrote:
> > On Mon, Aug 30, 2021 at 03:32:08PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > From: Daniel Borkmann <daniel@iogearbox.net>
> > > 
> > > Partially undo old commit 144cd91c4c2b ("bpf: move tmp variable into ax
> > > register in interpreter"). The reason we need this here is because ax
> > > register will be used for holding temporary state for div/mod instruction
> > > which otherwise interpreter would corrupt. This will cause a small +8 byte
> > > stack increase for interpreter, but with the gain that we can use it from
> > > verifier rewrites as scratch register.
> > > 
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> > > [cascardo: This partial revert is needed in order to support using AX for
> > > the following two commits, as there is no JMP32 on 4.19.y]
> > > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > > ---
> > >  kernel/bpf/core.c | 32 +++++++++++++++-----------------
> > >  1 file changed, 15 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index e7211b0fa27c..30d871be9974 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -616,9 +616,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
> > >  	 * below.
> > >  	 *
> > >  	 * Constant blinding is only used by JITs, not in the interpreter.
> > > -	 * The interpreter uses AX in some occasions as a local temporary
> > > -	 * register e.g. in DIV or MOD instructions.
> > > -	 *
> > >  	 * In restricted circumstances, the verifier can also use the AX
> > >  	 * register for rewrites as long as they do not interfere with
> > >  	 * the above cases!
> > > @@ -951,6 +948,7 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
> > >  	u32 tail_call_cnt = 0;
> > >  	void *ptr;
> > >  	int off;
> > > +	u64 tmp;
> > >  
> > >  #define CONT	 ({ insn++; goto select_insn; })
> > >  #define CONT_JMP ({ insn++; goto select_insn; })
> > > @@ -1013,22 +1011,22 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
> > >  	ALU64_MOD_X:
> > >  		if (unlikely(SRC == 0))
> > >  			return 0;
> > > -		div64_u64_rem(DST, SRC, &AX);
> > > -		DST = AX;
> > > +		div64_u64_rem(DST, SRC, &tmp);
> > > +		DST = tmp;
> > >  		CONT;
> > >  	ALU_MOD_X:
> > >  		if (unlikely((u32)SRC == 0))
> > >  			return 0;
> > > -		AX = (u32) DST;
> > > -		DST = do_div(AX, (u32) SRC);
> > > +		tmp = (u32) DST;
> > > +		DST = do_div(tmp, (u32) SRC);
> > >  		CONT;
> > >  	ALU64_MOD_K:
> > > -		div64_u64_rem(DST, IMM, &AX);
> > > -		DST = AX;
> > > +		div64_u64_rem(DST, IMM, &tmp);
> > > +		DST = tmp;
> > >  		CONT;
> > >  	ALU_MOD_K:
> > > -		AX = (u32) DST;
> > > -		DST = do_div(AX, (u32) IMM);
> > > +		tmp = (u32) DST;
> > > +		DST = do_div(tmp, (u32) IMM);
> > >  		CONT;
> > >  	ALU64_DIV_X:
> > >  		if (unlikely(SRC == 0))
> > > @@ -1038,17 +1036,17 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
> > >  	ALU_DIV_X:
> > >  		if (unlikely((u32)SRC == 0))
> > >  			return 0;
> > > -		AX = (u32) DST;
> > > -		do_div(AX, (u32) SRC);
> > > -		DST = (u32) AX;
> > > +		tmp = (u32) DST;
> > > +		do_div(tmp, (u32) SRC);
> > > +		DST = (u32) tmp;
> > >  		CONT;
> > >  	ALU64_DIV_K:
> > >  		DST = div64_u64(DST, IMM);
> > >  		CONT;
> > >  	ALU_DIV_K:
> > > -		AX = (u32) DST;
> > > -		do_div(AX, (u32) IMM);
> > > -		DST = (u32) AX;
> > > +		tmp = (u32) DST;
> > > +		do_div(tmp, (u32) IMM);
> > > +		DST = (u32) tmp;
> > >  		CONT;
> > >  	ALU_END_TO_BE:
> > >  		switch (IMM) {
> > > -- 
> > > 2.30.2
> > > 
> > 
> > Oops, no, this patch causes build errors:
> > 
> > kernel/bpf/core.c: In function ‘___bpf_prog_run’:
> > kernel/bpf/core.c:951:13: error: redeclaration of ‘tmp’ with no linkage
> >   951 |         u64 tmp;
> >       |             ^~~
> > kernel/bpf/core.c:839:13: note: previous declaration of ‘tmp’ with type ‘u64’ {aka ‘long long unsigned int’}
> >   839 |         u64 tmp;
> >       |             ^~~
> > make[2]: *** [scripts/Makefile.build:329: kernel/bpf/core.o] Error 1
> > 
> > 
> > Please fix up and resend the whole series, as I will go drop these 3
> > patches from the 4.14.y queue now.
> 
> All _4_ patches I mean.  now dropped...

Ah... it seems I only built it with CONFIG_BPF_JIT_ALWAYS_ON. I will build with
both that option on and off and check the results.

Thanks for catching this.

Cascardo.
