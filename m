Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E647624F3A8
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgHXIKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgHXIKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:10:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1F022072D;
        Mon, 24 Aug 2020 08:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598256611;
        bh=7JOye7vDpDMYdETfHJcW3K54VhcBLd6sYJ9yFyD2qws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=De9LWZHuWsLAcFoeUCfSO2UzZfws0sz0zjqGLjdsYEXItkjQLUxIlc5tOCwguRfiD
         UAiMo4m4pDizuJz5VpAoarWQ0729h9azbBO8550Kpm6m33WgkBcAjZmbCMYKKokwJS
         iRnrKm9eqaWRbD3+/k4eHoH/Ed61UJZ1BT2h5Z6s=
Date:   Mon, 24 Aug 2020 10:10:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     peterx@redhat.com, aarcange@redhat.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: fix calculation of" failed to
 apply to 4.4-stable tree
Message-ID: <20200824081029.GA92813@kroah.com>
References: <1597839685158224@kroah.com>
 <ca0c6c8e-0d90-9614-d7e4-c5a8c3372352@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca0c6c8e-0d90-9614-d7e4-c5a8c3372352@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 01:04:24PM -0700, Mike Kravetz wrote:
> On 8/19/20 5:21 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> >From d43b8a81c7f921aa52d55817390384053cd7be21 Mon Sep 17 00:00:00 2001
> From: Peter Xu <peterx@redhat.com>
> Date: Thu, 20 Aug 2020 10:38:02 -0700
> Subject: [PATCH] mm/hugetlb: fix calculation of
>  adjust_range_if_pmd_sharing_possible
> 
> commit 75802ca66354a39ab8e35822747cd08b3384a99a upstream
> 
> This is found by code observation only.
> 
> Firstly, the worst case scenario should assume the whole range was covered
> by pmd sharing.  The old algorithm might not work as expected for ranges
> like (1g-2m, 1g+2m), where the adjusted range should be (0, 1g+2m) but the
> expected range should be (0, 2g).
> 
> Since at it, remove the loop since it should not be required.  With that,
> the new code should be faster too when the invalidating range is huge.
> 
> Mike said:
> 
> : With range (1g-2m, 1g+2m) within a vma (0, 2g) the existing code will only
> : adjust to (0, 1g+2m) which is incorrect.
> :
> : We should cc stable.  The original reason for adjusting the range was to
> : prevent data corruption (getting wrong page).  Since the range is not
> : always adjusted correctly, the potential for corruption still exists.
> :
> : However, I am fairly confident that adjust_range_if_pmd_sharing_possible
> : is only gong to be called in two cases:
> :
> : 1) for a single page
> : 2) for range == entire vma
> :
> : In those cases, the current code should produce the correct results.
> :
> : To be safe, let's just cc stable.
> 
> Fixes: 017b1660df89 ("mm: migration: fix migration of huge PMD shared pages")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: <stable@vger.kernel.org>
> Link: http://lkml.kernel.org/r/20200730201636.74778-1-peterx@redhat.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>  mm/hugetlb.c | 25 +++++++++++--------------

Thanks for all of the backports, now queued up.

greg k-h
