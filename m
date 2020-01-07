Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02A71330E0
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgAGUsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:48:10 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:59202 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgAGUsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 15:48:09 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 99C1E72CCE9;
        Tue,  7 Jan 2020 23:48:04 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 69EC64A4AE7;
        Tue,  7 Jan 2020 23:48:04 +0300 (MSK)
Date:   Tue, 7 Jan 2020 23:48:04 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Arnaldo Carvalho de Melo' <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        Dmitry Levin <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        kbuild test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 20/20] tools lib: Fix builds when glibc contains strlcpy()
Message-ID: <20200107204803.yuunleopt7pnq5dw@altlinux.org>
Mail-Followup-To: David Laight <David.Laight@ACULAB.COM>,
        'Arnaldo Carvalho de Melo' <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        Dmitry Levin <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        kbuild test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20200106160705.10899-1-acme@kernel.org>
 <20200106160705.10899-21-acme@kernel.org>
 <bd755ddc840a485098f9e51d2692f39d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd755ddc840a485098f9e51d2692f39d@AcuMS.aculab.com>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David,

On Mon, Jan 06, 2020 at 05:03:26PM +0000, David Laight wrote:
> From: Arnaldo Carvalho de Melo
> > Sent: 06 January 2020 16:07
> > 
> > From: Vitaly Chikunov <vt@altlinux.org>
> > 
> > Disable a couple of compilation warnings (which are treated as errors)
> > on strlcpy() definition and declaration, allowing users to compile perf
> > and kernel (objtool) when:
> > 
> > 1. glibc have strlcpy() (such as in ALT Linux since 2004) objtool and
> >    perf build fails with this (in gcc):
> > 
> >   In file included from exec-cmd.c:3:
> >   tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
> >      20 | extern size_t strlcpy(char *dest, const char *src, size_t size);
> > 
> > 2. clang ignores `-Wredundant-decls', but produces another warning when
> >    building perf:
> > 
> >     CC       util/string.o
> >   ../lib/string.c:99:8: error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
> >   size_t __weak strlcpy(char *dest, const char *src, size_t size)
> >   ../../tools/include/linux/compiler.h:66:34: note: expanded from macro '__weak'
> >   # define __weak                 __attribute__((weak))
> >   /usr/include/bits/string_fortified.h:151:8: note: previous definition is here
> >   __NTH (strlcpy (char *__restrict __dest, const char *__restrict __src,
> 
> Why not just always use the local version by renaming it?

I believe that was the initial approach, which is changed some time ago
to using weak linking. Also, Dmitry Levin (as one of glibc maintainers)
claims that glibc implementation of strlcpy() is more correct and thus
better.

Thanks,

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
