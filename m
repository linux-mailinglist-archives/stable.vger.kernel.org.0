Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5D2A3608
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 22:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgKBVeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 16:34:21 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:49525 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgKBVeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 16:34:21 -0500
Received: from 'smile.earth' ([95.89.3.76]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MAOeB-1kTsaM0jEJ-00Bw3Y; Mon, 02 Nov 2020 22:34:13 +0100
X-Virus-Scanned: amavisd at 'smile.earth'
From:   Hans-Peter Jansen <hpj@urpla.net>
To:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.9 24/74] x86,
 powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
Date:   Mon, 02 Nov 2020 22:34:08 +0100
Message-ID: <5149714.arhZky3dcl@xrated>
In-Reply-To: <20201031113501.207349375@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
 <20201031113501.207349375@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:fCln/6GVs0RmP5szWXiMyIMh1DBFBsohmVL/zpZTQM0hYf4jycU
 f2QX/ujtwzDaXvcyQC+5uA203zV6yUUETEDkhP1wCYllCUaBlFpzVajOmnoLkG0uf5bU3Xy
 PAKtk8lFgcFO2ymtXn7W0/CEeHEdMhIQ4IjyMplDEZC1T115EUhsFDDhehvQaJeyoiB1slY
 /C+BUeK2leL1c/HXdBB0A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d2FUqD3q9Hw=:xvbzKxSdAoL6yiS1afqNG1
 VHpKnHiYaz0gQ8LQr4tZ3HTmJeE+ZOH7KQZ1nSwo70wLLFvFID70qW73yF0J0mAqMimdWJCa8
 TTQ88zjRHRPBrRDRj6X2XyTMho2wk4xV10r9lkid79UIXm23gcqPLKZxfVY940Ujg3tIMov6k
 xf8a9zggGvJQdHcj6L8mv2XabAyD9Zo6auKaaGk5LyYwT4nyAKpebccjm9jPGDcJtq6o9yUpp
 v20NnZJssP0zTnogjvIWM8TQ0wX5zIoZ1vZUmn9iMgTftQ9BYilJlZgvZ/PVr+Yvjbk7MxyA9
 puV6XI3DHNCylamsE2Ln0Au35bnxqaqFh2InuKzq46xwpkCNR6CTmeXFBC8ym592Q9B5aaEDH
 NQ0EFxnOIgZunM47J15makMSkwLIjhKjcpa3ywTxEXppBw9EFPfkU4rFyLuS3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, hi Dan,

Am Samstag, 31. Oktober 2020, 12:36:06 CET schrieb Greg Kroah-Hartman:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> commit ec6347bb43395cb92126788a1a5b25302543f815 upstream.
> 
> In reaction to a proposal to introduce a memcpy_mcsafe_fast()
> implementation Linus points out that memcpy_mcsafe() is poorly named
> relative to communicating the scope of the interface. Specifically what
> addresses are valid to pass as source, destination, and what faults /
> exceptions are handled.
> 
> 
> Introduce an x86 copy_mc_fragile() name as the rename for the
> low-level x86 implementation formerly named memcpy_mcsafe(). It is used
> as the slow / careful backend that is supplanted by a fast
> copy_mc_generic() in a follow-on patch.
> 
> One side-effect of this reorganization is that separating copy_mc_64.S
> to its own file means that perf no longer needs to track dependencies
> for its memcpy_64.S benchmarks.
> 
> ---
> arch/powerpc/lib/copy_mc_64.S                          |  242 +++++++++++++++++
> arch/powerpc/lib/memcpy_mcsafe_64.S                    |  242 -----------------

> tools/testing/selftests/powerpc/copyloops/copy_mc_64.S |  242 +++++++++++++++++ 

This change leaves a dangling symlink in 
tools/testing/selftests/powerpc/copyloops behind. At least, this is, what I 
could track down, when building 5.9.3 within an environment, that bails out 
on this:

[ 2908s] calling /usr/lib/rpm/brp-suse.d/brp-25-symlink
[ 2908s] ERROR: link target doesn't exist (neither in build root nor in installed system):
[ 2908s]   /usr/src/linux-5.9.3-lp152.3-vanilla/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S -> /usr/src/linux-5.9.3-lp152.3-vanilla/arch/powerpc/lib/memcpy_mcsafe_64.S
[ 2908s] Add the package providing the target to BuildRequires and Requires
[ 2909s] INFO: relinking /usr/src/linux-5.9.3-lp152.3-vanilla/tools/testing/selftests/powerpc/primitives/asm/asm-compat.h -> ../../../../../../arch/powerpc/include/asm/asm-compat.h (was ../.././../../../../arch/powerpc/include/asm/asm-compat.h)

Linus` tree seems to not suffer from this, though.

Cheers,
Pete


