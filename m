Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343596634B
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 03:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfGLBUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 21:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728973AbfGLBUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 21:20:08 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C84F21019;
        Fri, 12 Jul 2019 01:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562894403;
        bh=+sq2cZXnBxcRqUWRVVIP9zpWg9uQ8vXX5lA2Ew1UBSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R4h7JwRVFMQ3Yv1uTjLPBWes1X2fsmN8WCOke8y+u57VyP4kCE/HgaVIv8HyASiyC
         NEm8IhZwTbYwcfKq8NBs6uOyhPBQN+vGW+xi3G3IwAr+qEsU5oQq2Yp63+7Eh6L3+O
         x4z1p7S+jBwRLuLyE7TMbYjf2HEZ7NkbtkJMY/UU=
Date:   Thu, 11 Jul 2019 18:20:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "chenjianhong (A)" <chenjianhong2@huawei.com>
Cc:     Michel Lespinasse <walken@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "jannh@google.com" <jannh@google.com>,
        "steve.capper@arm.com" <steve.capper@arm.com>,
        "tiny.windzz@gmail.com" <tiny.windzz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>
Subject: Re: [PATCH] mm/mmap: fix the adjusted length error
Message-Id: <20190711182002.9bb943006da6b61ab66b95fd@linux-foundation.org>
In-Reply-To: <df001b6fbe2a4bdc86999c78933dab7f@huawei.com>
References: <1558073209-79549-1-git-send-email-chenjianhong2@huawei.com>
        <CANN689G6mGLSOkyj31ympGgnqxnJosPVc4EakW5gYGtA_45L7g@mail.gmail.com>
        <df001b6fbe2a4bdc86999c78933dab7f@huawei.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 18 May 2019 07:05:07 +0000 "chenjianhong (A)" <chenjianhong2@huawei.com> wrote:

> I explain my test code and the problem in detail. This problem is found in 
> 32-bit user process, because its virtual is limited, 3G or 4G. 
> 
> First, I explain the bug I found. Function unmapped_area and 
> unmapped_area_topdowns adjust search length to account for worst 
> case alignment overhead, the code is ' length = info->length + info->align_mask; '.
> The variable info->length is the length we allocate and the variable 
> info->align_mask accounts for the alignment, because the gap_start  or gap_end 
> value also should be an alignment address, but we can't know the alignment offset.
> So in the current algorithm, it uses the max alignment offset, this value maybe zero
> or other(0x1ff000 for shmat function). 
> Is it reasonable way? The required value is longer than what I allocate.
> What's more,  why for the first time I can allocate the memory successfully
> Via shmat, but after releasing the memory via shmdt and I want to attach
> again, it fails. This is not acceptable for many people.
> 
> Second, I explain my test code. The code I have sent an email. The following is
> the step. I don't think it's something unusual or unreasonable, because the virtual
> memory space is enough, but the process can allocate from it. And we can't pass
> explicit addresses to function mmap or shmat, the address is getting from the left
> vma gap.
>  1, we allocat large virtual memory;
>  2, we allocate hugepage memory via shmat, and release one
>  of the hugepage memory block;
>  3, we allocate hugepage memory by shmat again, this will fail.

How significant is this problem in real-world use cases?  How much
trouble is it causing?

> Third, I want to introduce my change in the current algorithm. I don't change the
> current algorithm. Also, I think there maybe a better way to fix this error. Nowadays,
> I can just adjust the gap_start value.

Have you looked further into this?  Michel is concerned about the
performance cost of the current solution.

