Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4E833C7E8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 21:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhCOUnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 16:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232741AbhCOUnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 16:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0806F64F01;
        Mon, 15 Mar 2021 20:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615840994;
        bh=IVYQn8WxFP9IQ+eQj6c/g9F2LLfY7Y7JElDpXVrfo6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MWDW3XIO9iLgI2lQzQe6gUHMIQmsWnYGiYRE8YogxZ6HphEjBn51WkN+JSDW85VNQ
         nTv4cjwt8/Hib7mqSajoAeJrvSZIpolXaz1wWqKkaRcYmr0Zpn7uLHuMTce+Qiyn9z
         ysUE9VLNbjM7edUm12/QAfrqB62h82EiWRu2gAfQ0HlGZLLGZvnWwJ0h0/L6BurXqs
         sPeDGrYOZ8+RGMZItfVrWEd0b2+yOp6wLBb4ASWTC6eU/9dlg+JyPpej263DhnCyoq
         zWU11jolHfq7Vyzk+MjXYgKJHeu+j5VOdIR3Ue1f4gGPkbJCAgOQ1eJDwlKkCuyD41
         iLr/EJRb4N0Mg==
Date:   Mon, 15 Mar 2021 16:43:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>, Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
Message-ID: <YE/G4ZGtFNDFw9ej@sashalap>
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com>
 <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
 <YEw6i39k6hqZJS8+@sashalap>
 <YE8kIbyWKSojC1SV@kroah.com>
 <YE8k/2WTPFGwMpHk@kroah.com>
 <YE8l2qhycaGPYdNn@kroah.com>
 <CAMj1kXGLrVXZPAoxTtMueB9toeoktuKza-mRpd4vZ0SLN6bSSQ@mail.gmail.com>
 <CAKwvOdmJm3v3sHfopWXrSPFn46qaSX9cna=Nd+FZiN=Nz9zmQQ@mail.gmail.com>
 <YE+wNS1iiVTU8YGb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YE+wNS1iiVTU8YGb@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 08:06:29PM +0100, Greg KH wrote:
>On Mon, Mar 15, 2021 at 10:43:26AM -0700, Nick Desaulniers wrote:
>> Then it should be possible for any patch
>> that itself is backported (contains "commit XXX upstream") to be fed
>> in when auto selected or submitted to stable (or before then) to check
>> for new fixes.  Probably would still need to be run periodically, as
>> Fixes: aren't necessarily available when AutoSel runs.  For the
>> toolchain, we have a bot that watches for reverts for example, but
>> non-standard commit messages denoting one patch fixes another makes
>> this far from perfect.  Would still need to be run periodically,
>> because if a Fixes: exists, but hasn't been merged yet, it could get
>> missed.
>
>I do re-run my script at times, it does require it to be run every once
>in a while.  But again, who is going to care about this except me and
>Sasha?

I actually run something like that often, there are tons of patches with
Fixes: that points to commits in the stable tree, but quite a few need a
less-than-trivial backport that no one did.

>> Though I'm curious how the machinery that picks up Fixes: tags works.
>> Does it run on a time based cadence?  Is it only run as part of
>> AutoSel, but not for manual backports sent to the list?  Would it have
>> picked up on f77ac2e378be at some point?
>
>Maybe it will, mine might have picked it up, who knows, I haven't run it
>in a while.  But as you say, because it fails to apply, that's a good
>reason for me to not backport it.

I run it on a weekly basis for *new* commits.

-- 
Thanks,
Sasha
