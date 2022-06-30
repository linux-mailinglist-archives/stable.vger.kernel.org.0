Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241D356190D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiF3LZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiF3LZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA6E44743;
        Thu, 30 Jun 2022 04:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB9360C92;
        Thu, 30 Jun 2022 11:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD87C34115;
        Thu, 30 Jun 2022 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588305;
        bh=fawBZEr6HMFRxz6tNO3J78M9ESjEtdUV/9X+xOp/wpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uVPmKbLwIDXeaTG5aG2UF0IEzKft9Lc0Uyzqh2WJ6NWJ06v/H5NlrJmB8pMcVIT6b
         x6iNgV2Qk5l4etTZ6bzijrx7uMZ8TNQ1EBk2DcuCtSXD+zocaqexZ6e816nD69wFGq
         4Kb7+6gnkRSNy20lSO/rasdS/yE6gZJFHynTIZ5U=
Date:   Thu, 30 Jun 2022 13:25:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     peterz@infradead.org, RAJESH DASARI <raajeshdasari@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Reg: rseq selftests failed on 5.4.199
Message-ID: <Yr2IDyuBr7DkgvdI@kroah.com>
References: <CAPXMrf-_RGYBJNu51rq2mdzcpf7Sk_z3kRNL9pmLvf4xmUkmow@mail.gmail.com>
 <YrlbDgpIVFvh5L9O@kroah.com>
 <YrnKyKiNlsqkuI6k@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrnKyKiNlsqkuI6k@localhost>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 11:20:40AM -0400, Mathieu Desnoyers wrote:
> On 27-Jun-2022 09:23:58 AM, Greg KH wrote:
> > On Sun, Jun 26, 2022 at 10:01:20PM +0300, RAJESH DASARI wrote:
> > > Hi ,
> > > 
> > > We are running rseq selftests on 5.4.199 kernel with  glibc 2.34
> > > version  and we see that tests are failing to compile with invalid
> > > argument errors. When we took all the commits from
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/tools/testing/selftests/rseq
> > >  related to rseq locally , test cases have passed. I see that there are
> > > some adaptations to the latest glibc version done in those commits, is
> > > there any plan to backport them to 5.4.x versions. Could you please
> > > provide your inputs.
> > 
> > What commits specifically are you referring to please?  A list of them
> > would be great, and if you have tested them and verified that they can
> > be backported cleanly would also be very helpful.
> 
> Hi Greg,
> 
> Specifically related to rseq selftests, the following string of commits
> would be relevant on top of v5.4.199. Those are not all strictly only
> bugfixes, but they help applying the following commits without
> conflicts. I have validated that this string of commits cherry-picks on
> top of v5.4.199, and that the resulting selftests build fine.
> 
> ea366dd79c ("seq/selftests,x86_64: Add rseq_offset_deref_addv()")
> 07ad4f7629 ("selftests/rseq: remove ARRAY_SIZE define from individual tests")
> 5c105d55a9 ("selftests/rseq: introduce own copy of rseq uapi header")
> 930378d056 ("selftests/rseq: Remove useless assignment to cpu variable")
> 94b80a19eb ("selftests/rseq: Remove volatile from __rseq_abi")
> e546cd48cc ("selftests/rseq: Introduce rseq_get_abi() helper")
> 886ddfba93 ("selftests/rseq: Introduce thread pointer getters")
> 233e667e1a ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
> 24d1136a29 ("selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian")
> de6b52a214 ("selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store")
> 26dc8a6d8e ("selftests/rseq: Fix ppc32 offsets by using long rather than off_t")
> d7ed99ade3 ("selftests/rseq: Fix warnings about #if checks of undefined tokens")
> 94c5cf2a0e ("selftests/rseq: Remove arm/mips asm goto compiler work-around")
> b53823fb2e ("selftests/rseq: Fix: work-around asm goto compiler bugs")
> 4e15bb766b ("selftests/rseq: x86-64: use %fs segment selector for accessing rseq thread area")
> 127b6429d2 ("selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area")
> 889c5d60fb ("selftests/rseq: Change type of rseq_offset to ptrdiff_t")

As many of these are newer than 5.10, can you provide a series of
patches that should be applied to 5.4, 5.10, 5.15 and possibly 5.18 to
resolve this issue.  We do not want anyone moving from 5.4 to a newer
kernel and having regressions.

thanks,

greg k-h
