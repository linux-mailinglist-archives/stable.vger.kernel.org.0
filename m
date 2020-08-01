Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D372352BC
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 16:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgHAOd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 10:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHAOd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Aug 2020 10:33:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2786E207BC;
        Sat,  1 Aug 2020 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596292405;
        bh=3hASn8Q08edza735DCqH9YFFJFq9TW19O89gdrFOYcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c0X4GKvHHB4B2K2BBwENThs8TtDUNT6YML2vG8IZTGp0OVH5ZlZY59z3wph8zdXjo
         lNjAIxt6++PZY6VZh0bcbP43ycD6pg2QBsm3PrlGIB3XlpRkhk54zQwdSdwTBKdvUm
         Y2gL0X+oOA7NA42+1yimR3Ccvb42gbH8HIXYg3kg=
Date:   Sat, 1 Aug 2020 16:33:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     stable@vger.kernel.org, linux-mips@vger.kernel.org,
        chenhc@lemote.com
Subject: Re: [PATCH stable] MIPS: Loongson: Introduce and use
 loongson_llsc_mb()
Message-ID: <20200801143309.GA2620594@kroah.com>
References: <20200801063443.1438289-1-jiaxun.yang@flygoat.com>
 <20200801102646.GA3046974@kroah.com>
 <5E555C31-EA38-456E-BB5D-263A54647873@flygoat.com>
 <20200801120459.GA506427@kroah.com>
 <1b535cbd-b4b9-68a2-5e85-8cbcfcdbcf9a@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b535cbd-b4b9-68a2-5e85-8cbcfcdbcf9a@flygoat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 01, 2020 at 10:11:24PM +0800, Jiaxun Yang wrote:
> 
> 
> 在 2020/8/1 下午8:04, Greg KH 写道:
> > On Sat, Aug 01, 2020 at 07:48:48PM +0800, Jiaxun Yang wrote:
> > > 
> > > 于 2020年8月1日 GMT+08:00 下午6:26:46, Greg KH <gregkh@linuxfoundation.org> 写到:
> > > > On Sat, Aug 01, 2020 at 02:34:43PM +0800, Jiaxun Yang wrote:
> > > > > From: Huacai Chen <chenhc@lemote.com>
> > > > > 
> > > > > commit e02e07e3127d8aec1f4bcdfb2fc52a2d99b4859e upstream.
> > > > > 
> > > > > On the Loongson-2G/2H/3A/3B there is a hardware flaw that ll/sc and
> > > > > lld/scd is very weak ordering. We should add sync instructions "before
> > > > > each ll/lld" and "at the branch-target between ll/sc" to workaround.
> > > > > Otherwise, this flaw will cause deadlock occasionally (e.g. when doing
> > > > > heavy load test with LTP).
> > > > > 
> > > > > Below is the explaination of CPU designer:
> > > > > 
> > > > > "For Loongson 3 family, when a memory access instruction (load, store,
> > > > > or prefetch)'s executing occurs between the execution of LL and SC, the
> > > > > success or failure of SC is not predictable. Although programmer would
> > > > > not insert memory access instructions between LL and SC, the memory
> > > > > instructions before LL in program-order, may dynamically executed
> > > > > between the execution of LL/SC, so a memory fence (SYNC) is needed
> > > > > before LL/LLD to avoid this situation.
> > > > > 
> > > > > Since Loongson-3A R2 (3A2000), we have improved our hardware design to
> > > > > handle this case. But we later deduce a rarely circumstance that some
> > > > > speculatively executed memory instructions due to branch misprediction
> > > > > between LL/SC still fall into the above case, so a memory fence (SYNC)
> > > > > at branch-target (if its target is not between LL/SC) is needed for
> > > > > Loongson 3A1000, 3B1500, 3A2000 and 3A3000.
> > > > > 
> > > > > Our processor is continually evolving and we aim to to remove all these
> > > > > workaround-SYNCs around LL/SC for new-come processor."
> > > > > 
> > > > > Here is an example:
> > > > > 
> > > > > Both cpu1 and cpu2 simutaneously run atomic_add by 1 on same atomic var,
> > > > > this bug cause both 'sc' run by two cpus (in atomic_add) succeed at same
> > > > > time('sc' return 1), and the variable is only *added by 1*, sometimes,
> > > > > which is wrong and unacceptable(it should be added by 2).
> > > > > 
> > > > > Why disable fix-loongson3-llsc in compiler?
> > > > > Because compiler fix will cause problems in kernel's __ex_table section.
> > > > > 
> > > > > This patch fix all the cases in kernel, but:
> > > > > 
> > > > > +. the fix at the end of futex_atomic_cmpxchg_inatomic is for branch-target
> > > > > of 'bne', there other cases which smp_mb__before_llsc() and smp_llsc_mb() fix
> > > > > the ll and branch-target coincidently such as atomic_sub_if_positive/
> > > > > cmpxchg/xchg, just like this one.
> > > > > 
> > > > > +. Loongson 3 does support CONFIG_EDAC_ATOMIC_SCRUB, so no need to touch
> > > > > edac.h
> > > > > 
> > > > > +. local_ops and cmpxchg_local should not be affected by this bug since
> > > > > only the owner can write.
> > > > > 
> > > > > +. mips_atomic_set for syscall.c is deprecated and rarely used, just let
> > > > > it go
> > > > > 
> > > > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > > > Signed-off-by: Huang Pei <huangpei@loongson.cn>
> > > > > [paul.burton@mips.com:
> > > > >    - Simplify the addition of -mno-fix-loongson3-llsc to cflags, and add
> > > > >      a comment describing why it's there.
> > > > >    - Make loongson_llsc_mb() a no-op when
> > > > >      CONFIG_CPU_LOONGSON3_WORKAROUNDS=n, rather than a compiler memory
> > > > >      barrier.
> > > > >    - Add a comment describing the bug & how loongson_llsc_mb() helps
> > > > >      in asm/barrier.h.]
> > > > > Signed-off-by: Paul Burton <paul.burton@mips.com>
> > > > > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > > Cc: Ralf Baechle <ralf@linux-mips.org>
> > > > > Cc: ambrosehua@gmail.com
> > > > > Cc: Steven J . Hill <Steven.Hill@cavium.com>
> > > > > Cc: linux-mips@linux-mips.org
> > > > > Cc: Fuxin Zhang <zhangfx@lemote.com>
> > > > > Cc: Zhangjin Wu <wuzhangjin@gmail.com>
> > > > > Cc: Li Xuefeng <lixuefeng@loongson.cn>
> > > > > Cc: Xu Chenghua <xuchenghua@loongson.cn>
> > > > > Cc: stable@vger.kernel.org # 4.19
> > > > > 
> > > > > ---
> > > > > Backport to stable according to request from Debian downstream.
> > > > What do you mean by "request"?
> > > Debian guys asked us to backport this to ensure the system stability on "buster" release if possible.
> > Who is "Debian guys"?  And why can't they just add this to their kernel?
> 
> Hmm I just got this request from #debian-mips channel, they're tracing a
> deadlock
> issue and thought this might be the root cause. So they thought deal with it
> in upstream
> stable version may benefit users.

Has anyone verified that this really is the "root cause" and this fixes
the problem for them?  If not, that would be good to have done :)

thanks,

greg k-h
