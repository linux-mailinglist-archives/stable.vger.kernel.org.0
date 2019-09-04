Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECDCA77DC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 02:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfIDAYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 20:24:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55854 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfIDAYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 20:24:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id g207so1287281wmg.5;
        Tue, 03 Sep 2019 17:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+kGji0iEqvX2PbYbdW45C9GxA697L85/6dAAQKl+YqI=;
        b=s823D9jMikjUnE0COKWdQm/5U4/NnfIueifeneGq16e97vNfIELcg2uISDJC5H8Osu
         mkf7end+YfLLnME+nIbdTcGf8L3mr/WrKyX/l1DiTowgansH74ndS7WLYnhy0hQO9F0K
         N8xC0HX2mYKW+Mkv4YnyZkRNwM5jTY+He1FfAeVw6hAI+S1FcM/X1C3HuOz+V1yyGQu5
         HaphnnucdoJtfT4Ljfx7+pXTfb8COZztaEZ5RJ2wOavoaxjWqCx2lIYg/QA7gpTWlBYL
         s820/Lyd8uH5qB7MhN1eK/MGWtG3lExath8vlfPqIsMpi25nX3PJgc9sv/129uVc+1Ia
         tdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+kGji0iEqvX2PbYbdW45C9GxA697L85/6dAAQKl+YqI=;
        b=lxEJxRP7EiGueMwdk/mEJKDEWC2acTx1j8ORgpL56ozGCWv0bWK/FRXUyWYrG2V2fh
         NiL9ZKx6/yt195TiADTnz8RTcCK7iAacbPCT/qYxzXfEsPXP+gWS4E9TvQD3vC//tzud
         yIoG2weILq8wonUfcCVnGbsgtx/CacrJBDPWlKVO6T0WR6bpzvvTGDJDBtCOvwJzB5rN
         xZsSZuCzXqCXWl3XFdLDsSioiEGqpsLwDCXbGGfC2LBuW+HmSbgRHWmVlyVbpibk+ryH
         aNlcxy5O1fzLw2FdI0qgDCDHSEtGqi3lE3oWI/UJkPMKbIS6/Jvul49IuOlQLWUoP/7N
         iwWQ==
X-Gm-Message-State: APjAAAUeTS7GccTHNu9zH5iM2p3nuU8kiijASsYh4wAebkwWkrJnxStX
        48x0pFVl7TYoIekW9r+Sp1EdXe9u5g8WaA==
X-Google-Smtp-Source: APXvYqyRT9H5yO3lBr9uzkfqAogtNcUrdzoodQwtPgDJnVgYlLavOlowlxIb5ZUBH6+0p1L8IqP6Sg==
X-Received: by 2002:a1c:4c06:: with SMTP id z6mr1965649wmf.47.1567556643727;
        Tue, 03 Sep 2019 17:24:03 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id b26sm1242242wmj.14.2019.09.03.17.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 17:24:03 -0700 (PDT)
Date:   Tue, 3 Sep 2019 17:24:01 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190904002401.GA70635@archlinux-threadripper>
References: <20190812023214.107817-1-natechancellor@gmail.com>
 <878srdv206.fsf@mpe.ellerman.id.au>
 <20190828175322.GA121833@archlinux-threadripper>
 <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com>
 <20190828184529.GC127646@archlinux-threadripper>
 <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com>
 <20190903055553.GC60296@archlinux-threadripper>
 <20190903193128.GC9749@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903193128.GC9749@gate.crashing.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 02:31:28PM -0500, Segher Boessenkool wrote:
> On Mon, Sep 02, 2019 at 10:55:53PM -0700, Nathan Chancellor wrote:
> > On Thu, Aug 29, 2019 at 09:59:48AM +0000, David Laight wrote:
> > > From: Nathan Chancellor
> > > > Sent: 28 August 2019 19:45
> > > ...
> > > > However, I think that -fno-builtin-* would be appropriate here because
> > > > we are providing our own setjmp implementation, meaning clang should not
> > > > be trying to do anything with the builtin implementation like building a
> > > > declaration for it.
> > > 
> > > Isn't implementing setjmp impossible unless you tell the compiler that
> > > you function is 'setjmp-like' ?
> > 
> > No idea, PowerPC is the only architecture that does such a thing.
> 
> Since setjmp can return more than once, yes, exciting things can happen
> if you do not tell the compiler about this.
> 
> 
> Segher
> 

Fair enough so I guess we are back to just outright disabling the
warning.

Cheers,
Nathan
