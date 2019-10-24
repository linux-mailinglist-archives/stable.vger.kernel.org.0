Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB98E3362
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbfJXNFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:05:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51158 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730937AbfJXNFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 09:05:11 -0400
Received: by mail-wm1-f66.google.com with SMTP id q13so2769170wmj.0;
        Thu, 24 Oct 2019 06:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sc0yPCVfEQ0pK0/NGjx6W8CYcehYA6aagiijMrOtEy4=;
        b=exxfDv/km68V7c4r9FPU52WfWb76KUvX5zkVz2NErtmjm6rlB8EFH1DOXat1A4mcph
         QrQmRA39YPKwmyIv9FZY5HvuzdDxYgN2hKhNVeKGcwF6sEGHcJmRAfxUIZ0Waw1vNTwa
         UhWNW9PZxwPi7HkiK0tkHEyAgl3vBf5FAIoDIXcgnI2fEA6Ypkkn+gu6+HTb46pm7kdP
         k+mgG2U9QwyI4Irzp6ZrLwwSoSarNb2IOVMc3OrAnkqz92JXiUW+SGV0z9VYnKXCw9dc
         4v/iWnH2NAA0ZSFqcmZ75TVo4toh5rl2X7Z4NXLep/HXAz/QDySZBThD4Nfzj1Bvl30t
         TbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sc0yPCVfEQ0pK0/NGjx6W8CYcehYA6aagiijMrOtEy4=;
        b=WU3uHJa8bbMFOap5m3Dp3myLlz3hOpeORlOeLp9F2xxa/SgPXctLI2cSrCa36nxYDu
         adi/0L8oBWxq45gL+p12h6SWXbj/cm2mNmoSmJ4jIwogl/0V+rabvXBbk7Tr8eSC3cYV
         KnOzR6jCscMe6LXiQwcYqLyFfDlKLqQTc9Bsd5oA4+bpjqiA1pWPKJBB62Duqj879Sgr
         wMR6XGdNyczWVTuNWbu3y3UFZ4NzraGFStDN2tw5xosQmgvR/Uby65LnUuTRphaHrbct
         7FSFPQ4iybuKnhYHXv62K9DCl6epgT8vrcskCMk9XOhdHmi6v02IR7+Qk6b1MbGG1HOo
         tI/Q==
X-Gm-Message-State: APjAAAX9s3XOavZ5EgGsL4PMw15mueT1EtXMXueQ0PcORhrUDUdOLxq5
        CAgdmwLxSmQZsuabp2ODOSU=
X-Google-Smtp-Source: APXvYqy3mBItBc7WBTEJWCzdSzT7R8VrpWyTlH9x1LISMYKss+/Eg/CcOUqTfkhwDq/TtrKFIpfAwg==
X-Received: by 2002:a7b:cb05:: with SMTP id u5mr4534526wmj.36.1571922308834;
        Thu, 24 Oct 2019 06:05:08 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1010:e187:86b0:69d4:5ba5])
        by smtp.gmail.com with ESMTPSA id l14sm10298010wrr.37.2019.10.24.06.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:05:07 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:05:02 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
Message-ID: <20191024130502.GA11335@andrea.guest.corp.microsoft.com>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com>
 <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 01:51:20PM +0200, Dmitry Vyukov wrote:
> On Thu, Oct 24, 2019 at 1:32 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> >
> > > How these later loads can be completely independent of the pointer
> > > value? They need to obtain the pointer value from somewhere. And this
> > > can only be done by loaded it. And if a thread loads a pointer and
> > > then dereferences that pointer, that's a data/address dependency and
> > > we assume this is now covered by READ_ONCE.
> >
> > The "dependency" I was considering here is a dependency _between the
> > load of sig->stats in taskstats_tgid_alloc() and the (program-order)
> > later loads of *(sig->stats) in taskstats_exit().  Roughly speaking,
> > such a dependency should correspond to a dependency chain at the asm
> > or registers level from the first load to the later loads; e.g., in:
> >
> >   Thread [register r0 contains the address of sig->stats]
> >
> >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> >      ...
> >   B: LOAD r2,[r0]       // LOAD *(sig->stats)
> >   C: LOAD r3,[r2]
> >
> > there would be no such dependency from A to C.  Compare, e.g., with:
> >
> >   Thread [register r0 contains the address of sig->stats]
> >
> >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> >      ...
> >   C: LOAD r3,[r1]       // LOAD *(sig->stats)
> >
> > AFAICT, there's no guarantee that the compilers will generate such a
> > dependency from the code under discussion.
> 
> Fixing this by making A ACQUIRE looks like somewhat weird code pattern
> to me (though correct). B is what loads the address used to read
> indirect data, so B ought to be ACQUIRE (or LOAD-DEPENDS which we get
> from READ_ONCE).
> 
> What you are suggesting is:
> 
> addr = ptr.load(memory_order_acquire);
> if (addr) {
>   addr = ptr.load(memory_order_relaxed);
>   data = *addr;
> }
> 
> whereas the canonical/non-convoluted form of this pattern is:
> 
> addr = ptr.load(memory_order_consume);
> if (addr)
>   data = *addr;

No, I'd rather be suggesting:

  addr = ptr.load(memory_order_acquire);
  if (addr)
    data = *addr;

since I'd not expect any form of encouragement to rely on "consume" or
on "READ_ONCE() + true-address-dependency" from myself.  ;-)

IAC, v6 looks more like:

  addr = ptr.load(memory_order_consume);
  if (!!addr)
    *ptr = 1;
  data = *ptr;

to me (hence my comments/questions ...).

Thanks,
  Andrea
