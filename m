Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E821F46BC
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 21:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgFITD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 15:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729806AbgFITDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 15:03:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEC642068D;
        Tue,  9 Jun 2020 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591729403;
        bh=Vfyj+NMf8T/7CXC12HCXGIpKKfBA7HOZ+MDv198zK9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pxu1syBzHoL2J5cnIy7N/PAPPSbc4BdrkkQHcs1hT4yP8W7PbeAF1yOPCraK5p0Im
         h8LDblfbB+M4MWbEO1PeRBNmSlsTtVvX4+yyVmPZRqkX3FdPMwS5ViXdGuQnvAMdSs
         JPyIGOYHvSRzf3kfpUavxXOzx2hUYs/vTXODdywQ=
Date:   Tue, 9 Jun 2020 21:03:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 24/25] uprobes: ensure that uprobe->offset and
 ->ref_ctr_offset are properly aligned
Message-ID: <20200609190321.GA1046130@kroah.com>
References: <20200609174048.576094775@linuxfoundation.org>
 <20200609174051.488794266@linuxfoundation.org>
 <CA+G9fYukN5V1z3g6Qwe9K5xnnXEuFafWdqGfDA1Wj2iVstoxfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYukN5V1z3g6Qwe9K5xnnXEuFafWdqGfDA1Wj2iVstoxfw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 12:25:56AM +0530, Naresh Kamboju wrote:
> On Tue, 9 Jun 2020 at 23:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Oleg Nesterov <oleg@redhat.com>
> >
> > commit 013b2deba9a6b80ca02f4fafd7dedf875e9b4450 upstream.
> >
> > uprobe_write_opcode() must not cross page boundary; prepare_uprobe()
> > relies on arch_uprobe_analyze_insn() which should validate "vaddr" but
> > some architectures (csky, s390, and sparc) don't do this.
> >
> > We can remove the BUG_ON() check in prepare_uprobe() and validate the
> > offset early in __uprobe_register(). The new IS_ALIGNED() check matches
> > the alignment check in arch_prepare_kprobe() on supported architectures,
> > so I think that all insns must be aligned to UPROBE_SWBP_INSN_SIZE.
> >
> > Another problem is __update_ref_ctr() which was wrong from the very
> > beginning, it can read/write outside of kmap'ed page unless "vaddr" is
> > aligned to sizeof(short), __uprobe_register() should check this too.
> >
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Tested-by: Sven Schnelle <svens@linux.ibm.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  kernel/events/uprobes.c |   16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -612,10 +612,6 @@ static int prepare_uprobe(struct uprobe
> >         if (ret)
> >                 goto out;
> >
> > -       /* uprobe_write_opcode() assumes we don't cross page boundary */
> > -       BUG_ON((uprobe->offset & ~PAGE_MASK) +
> > -                       UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
> > -
> >         smp_wmb(); /* pairs with the smp_rmb() in handle_swbp() */
> >         set_bit(UPROBE_COPY_INSN, &uprobe->flags);
> >
> > @@ -911,6 +907,15 @@ static int __uprobe_register(struct inod
> >         if (offset > i_size_read(inode))
> >                 return -EINVAL;
> >
> > +       /*
> > +        * This ensures that copy_from_page(), copy_to_page() and
> > +        * __update_ref_ctr() can't cross page boundary.
> > +        */
> > +       if (!IS_ALIGNED(offset, UPROBE_SWBP_INSN_SIZE))
> > +               return -EINVAL;
> > +       if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> 
> stable-rc 4.19 build failure for x86_64, i386 and arm.
> make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=x86 HOSTCC=gcc
> CC="sccache gcc" O=build
> 
> 75 #
> 76 In file included from ../kernel/events/uprobes.c:25:
> 77 ../kernel/events/uprobes.c: In function ‘__uprobe_register’:
> 78 ../kernel/events/uprobes.c:916:18: error: ‘ref_ctr_offset’
> undeclared (first use in this function); did you mean
> ‘per_cpu_offset’?
> 79  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> 80  | ^~~~~~~~~~~~~~
> 81 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> 82  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> 83  | ^
> 84 ../kernel/events/uprobes.c:916:18: note: each undeclared identifier
> is reported only once for each function it appears in
> 85  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> 86  | ^~~~~~~~~~~~~~
> 87 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> 88  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> 89  | ^
> 90 make[3]: *** [../scripts/Makefile.build:304: kernel/events/uprobes.o] Error 1
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

Good catch, my builders just caught it too :(

4.19, 4.14, 4.9, and 4.4 are all broken, I have a fix will test it and
push out -rc2 for all of those with it in a bit, thanks.

greg k-h
