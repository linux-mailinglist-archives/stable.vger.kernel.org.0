Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7635779A
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 00:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhDGW0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 18:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhDGW0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 18:26:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7965861245;
        Wed,  7 Apr 2021 22:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617834382;
        bh=ntxkGEATiH0rQC7t9uR0Mpm44wLWaECdQOQgbePh6qg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v9spXbJrD3jgXYAir83CkcC1/9yVQeh8ENVfqYJr5V2vzjny6uhjgvak37lfu+Qy8
         qgvk7EBU04FAyEMN0FxC6RzOpd63WdlkSFqjnWmVCHKGnJwBkgNxsi0ZNBlLUkcOtP
         R/eXdyDalX4BdNXiJjTGbteZsMViBl5DDCS02Vgs=
Date:   Wed, 7 Apr 2021 15:26:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Prasad Sodagudi <psodagud@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] gcov: re-fix clang-11+ support
Message-Id: <20210407152621.3826f93e893c0cf9b327071f@linux-foundation.org>
In-Reply-To: <CAKwvOdnSRsUj9dvKP_1Dd9+WwLJwaK0mC-T9mL+jsQvRfwLZmg@mail.gmail.com>
References: <20210407185456.41943-1-ndesaulniers@google.com>
        <20210407185456.41943-2-ndesaulniers@google.com>
        <20210407142121.677e971e9e5dc85643441811@linux-foundation.org>
        <CAKwvOdnSRsUj9dvKP_1Dd9+WwLJwaK0mC-T9mL+jsQvRfwLZmg@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 7 Apr 2021 14:28:21 -0700 Nick Desaulniers <ndesaulniers@google.com> wrote:

> On Wed, Apr 7, 2021 at 2:21 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed,  7 Apr 2021 11:54:55 -0700 Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > > LLVM changed the expected function signature for
> > > llvm_gcda_emit_function() in the clang-11 release.  Users of clang-11 or
> > > newer may have noticed their kernels producing invalid coverage
> > > information:
> > >
> > > $ llvm-cov gcov -a -c -u -f -b <input>.gcda -- gcno=<input>.gcno
> > > 1 <func>: checksum mismatch, \
> > >   (<lineno chksum A>, <cfg chksum B>) != (<lineno chksum A>, <cfg chksum C>)
> > > 2 Invalid .gcda File!
> > > ...
> > >
> > > Fix up the function signatures so calling this function interprets its
> > > parameters correctly and computes the correct cfg checksum. In
> > > particular, in clang-11, the additional checksum is no longer optional.
> >
> > Which tree is this against?  I'm seeing quite a lot of rejects against
> > Linus's current.
> 
> Today's linux-next; the only recent changes to this single source file
> since my last patches were:
> 
> commit b3c4e66c908b ("gcov: combine common code")
> commit 17d0508a080d ("gcov: use kvmalloc()")
> 
> both have your sign off, so I assume those are in your tree?

Yes, I presently have

gcov-clang-drop-support-for-clang-10-and-older.patch
gcov-combine-common-code.patch
gcov-simplify-buffer-allocation.patch
gcov-use-kvmalloc.patch

But this patch ("gcov: re-fix clang-11+ support") has cc:stable, so it
should be against Linus's tree, to give the -stable trees something
more mergeable.

