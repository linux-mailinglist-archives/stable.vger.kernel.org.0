Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2925731AC0C
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 15:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBMOJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 09:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhBMOJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 09:09:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D315264DEB;
        Sat, 13 Feb 2021 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613225345;
        bh=pTRlgXkyhIUDcjvu3VK/6FMuyvV971qckI4/kaJRXvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6LKUDOl0e+B22x558Jcdkhmwp7xy8eK5tJ+wGVckiBrI1+DSzXRFbH22Oy8rmglZ
         Kmqfygd8myp8NyLSIz0FSTsTi5zm5xUXj38DGahvvY13nCzgyEyaIGB8PltPvGNPzJ
         7UE0nQTWVFEiaPuKLYwgiW14X8TQ5Z9r8CGaAPiA=
Date:   Sat, 13 Feb 2021 15:09:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
Message-ID: <YCfdfkoeh8i0baCj@kroah.com>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
 <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
 <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
 <YCU3Vdoqd+EI+zpv@kroah.com>
 <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
 <YCafKVSTX9MxDBMd@kroah.com>
 <20210212170750.y7xtitigfqzpchqd@treble>
 <20210212124547.1dcf067e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212124547.1dcf067e@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 12:45:47PM -0500, Steven Rostedt wrote:
> On Fri, 12 Feb 2021 11:07:50 -0600
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> 
> > > Any ideas are appreciated.  
> > 
> > [ Adding Steve Rostedt ]
> > 
> > This error message comes from recordmcount.  It probably can't handle
> > the missing STT_SECTION symbols which are getting stripped by the new
> > binutils.  (Objtool also had trouble with that.)
> > 
> > No idea why you only see this on 4.4 though.
> > 
> 
> Just taking a quick look, but would something like this work?
> 
> I created this against v4.4.257.
> 
> -- Steve
> 
> diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
> index 04151ede8043..698404f092d0 100644
> --- a/scripts/recordmcount.h
> +++ b/scripts/recordmcount.h
> @@ -437,6 +437,8 @@ static unsigned find_secsym_ndx(unsigned const txtndx,
>  			if (w2(ehdr->e_machine) == EM_ARM
>  			    && ELF_ST_TYPE(symp->st_info) == STT_FUNC)
>  				continue;
> +			if (ELF_ST_TYPE(symp->st_info) == STT_SECTION)
> +				continue;
>  
>  			*recvalp = _w(symp->st_value);
>  			return symp - sym0;
> 


Thanks for the patch, but no, still fails with:

Cannot find symbol for section 8: .text.unlikely.
kernel/kexec_file.o: failed
make[1]: *** [scripts/Makefile.build:277: kernel/kexec_file.o] Error 1
make[1]: *** Deleting file 'kernel/kexec_file.o'

