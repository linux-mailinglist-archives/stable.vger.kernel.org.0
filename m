Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6679939FC9E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 18:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhFHQhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 12:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhFHQhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 12:37:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8D2961278;
        Tue,  8 Jun 2021 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623170112;
        bh=zbnpE7/Q5cMOsDw3GJsHSLLDWjFozXMPKZtTRNSaUJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fg3YQtUq/3+OgHmM8KwnbNWppYDdXEYP9EXKFOrcwYzrrlzbfmjCrHyEEY+icFljg
         +IiLL78f8FhdLcp5opAtze6vH5NcX9xue8p6o0LFsQgPAtiNIyFIupJAfG2ROLdYwT
         Q41Zs7isikVgn3OjeRpZ7xvuqzJzH7VvlUrOzDpc=
Date:   Tue, 8 Jun 2021 18:35:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     stable@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,
        Miao Xie <miaoxie@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Li Guifu <bluce.liguifu@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for-5.10.y] lib/lz4: explicitly support in-place
 decompression
Message-ID: <YL+cPrR7ARC1WdnA@kroah.com>
References: <1622562405-63431-1-git-send-email-hsiangkao@linux.alibaba.com>
 <1622562405-63431-2-git-send-email-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622562405-63431-2-git-send-email-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 11:46:45PM +0800, Gao Xiang wrote:
> commit 89b158635ad79574bde8e94d45dad33f8cf09549 upstream.
> 
> LZ4 final literal copy could be overlapped when doing
> in-place decompression, so it's unsafe to just use memcpy()
> on an optimized memcpy approach but memmove() instead.
> 
> Upstream LZ4 has updated this years ago [1] (and the impact
> is non-sensible [2] plus only a few bytes remain), this commit
> just synchronizes LZ4 upstream code to the kernel side as well.
> 
> It can be observed as EROFS in-place decompression failure
> on specific files when X86_FEATURE_ERMS is unsupported,
> memcpy() optimization of commit 59daa706fbec ("x86, mem:
> Optimize memcpy by avoiding memory false dependece") will
> be enabled then.
> 
> Currently most modern x86-CPUs support ERMS, these CPUs just
> use "rep movsb" approach so no problem at all. However, it can
> still be verified with forcely disabling ERMS feature...
> 
> arch/x86/lib/memcpy_64.S:
>         ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
> -                     "jmp memcpy_erms", X86_FEATURE_ERMS
> +                     "jmp memcpy_orig", X86_FEATURE_ERMS
> 
> We didn't observe any strange on arm64/arm/x86 platform before
> since most memcpy() would behave in an increasing address order
> ("copy upwards" [3]) and it's the correct order of in-place
> decompression but it really needs an update to memmove() for sure
> considering it's an undefined behavior according to the standard
> and some unique optimization already exists in the kernel.
> 
> [1] https://github.com/lz4/lz4/commit/33cb8518ac385835cc17be9a770b27b40cd0e15b
> [2] https://github.com/lz4/lz4/pull/717#issuecomment-497818921
> [3] https://sourceware.org/bugzilla/show_bug.cgi?id=12518
> 
> Link: https://lkml.kernel.org/r/20201122030749.2698994-1-hsiangkao@redhat.com
> Reviewed-by: Nick Terrell <terrelln@fb.com>
> Cc: Yann Collet <yann.collet.73@gmail.com>
> Cc: Miao Xie <miaoxie@huawei.com>
> Cc: Chao Yu <yuchao0@huawei.com>
> Cc: Li Guifu <bluce.liguifu@huawei.com>
> Cc: Guo Xuenan <guoxuenan@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> Hi,
> 
> Please kindly consider these two backports to 5.4.y and 5.10.y LTS
> kernels, and the reason shown as above (it could cause lz4 in-place
> decompression (mainly EROFS) failure due to the different designed
> memcpy overlapped behavior on x86 if ERMS is unsupported.) The lz4
> upstream commit itself has been merged for 2 years. And the linux
> upstream commit is also merged for months without any other
> regression.
> 
> And in principle, it won't have any real impact at all, so I think
> it's now safe to backport this to LTS kernels for unsupported ERMS
> x86s.

Both now queued up, thanks!

greg k-h
