Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F258E3FB63D
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhH3Mlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbhH3Mlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 08:41:44 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501ACC06175F
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:40:51 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id g11so8172831qvd.2
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T0GjF5w0oMuRtLInC2hBs3sq1EKkXCp946NJQvmrNNA=;
        b=YJz06bSaVp5ajqLNrj0z3k7B2zNq9W3juYAjTRacLX1OTnWl+Y2TCuZRXrDpNev5ES
         LI9vF8Ek/BlSVqhQxxZNTzpA5FUjX/13eTlFBMEzsXx19XkdMbZPqCBpO+RkihfEnj0l
         J5p6+wZXhw44KfNzMBWBNzDL/r8IzJMq1PUz9AGeK1i6zpPFRaQj7/uzkd9BXt9TCJfc
         W42wzWo2iZS4pWlUgqlA7jUlEn0stzTigVCRnRBofn3VEjYosxE04T10wIyEgIow15e4
         4JqWV2i7dl5xXX5bp87lKznKwdqX/+WO93wXw52VHRAZmCWLEEbhZctMAempuTEerRIF
         bm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T0GjF5w0oMuRtLInC2hBs3sq1EKkXCp946NJQvmrNNA=;
        b=KMXGWFPNcwh3fKBsaSi2jI0UR+aAe8aHgKI3nyavI/W7lqdJohIOlhjynRuGWaQRS2
         f74wBvVuqXu8HMcoNmkUtLrN0nQGwixUordECgEHTVx7UGMu0KYCJZiIHstrj864ffI6
         yqlmR9obZUSy7lwFSs81RCZMNTAK9S5RefB9cRP/jvdAdg47vRaDzbJRDJdm8tJ+1E3Y
         47psHp4dwA4Jl61Gyw/4f5fJ8zcbRWN1kHXCKKiGhQPzSahX4UcxkJSOH8aCW7Sqh2oG
         8KAE+tMDOWERYQ4NzrD6hi+u5XUzwrCvCh6xXdpMTift0eklQkaG5p1lZFPWSR1tast7
         /IDA==
X-Gm-Message-State: AOAM533h1HB9fp7yQFv1w1fwn6dAR2FV/1u2LUZ9bigXe/lpiI6ytbbe
        nLdPal1hqKyWnJyIMd6gCMWiOwB3WbpFcw==
X-Google-Smtp-Source: ABdhPJyaf6VQxCJ00UbLfwPFp16U/tNv3663ulooWB0/urnMOTvjl6SDaLLUsNSISMLXKOIbvLqaHA==
X-Received: by 2002:a0c:e70f:: with SMTP id d15mr22462454qvn.47.1630327250483;
        Mon, 30 Aug 2021 05:40:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id c10sm8262652qtb.20.2021.08.30.05.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 05:40:49 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mKgan-0070tA-0m; Mon, 30 Aug 2021 09:40:49 -0300
Date:   Mon, 30 Aug 2021 09:40:49 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-rdma@vger.kernel.org, jglisse@redhat.com,
        hch@infradead.org, yishaih@nvidia.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/hmm: bypass devmap pte when all pfn requested
 flags are fulfilled
Message-ID: <20210830124049.GN1200268@ziepe.ca>
References: <20210830094232.203029-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830094232.203029-1-lizhijian@cn.fujitsu.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 05:42:32PM +0800, Li Zhijian wrote:
> Previously, we noticed the one rpma example was failed[1] since 36f30e486d,
> where it will use ODP feature to do RDMA WRITE between fsdax files.
> 
> After digging into the code, we found hmm_vma_handle_pte() will still
> return EFAULT even though all the its requesting flags has been
> fulfilled. That's because a DAX page will be marked as
> (_PAGE_SPECIAL | PAGE_DEVMAP) by pte_mkdevmap().
> 
> [1]: https://github.com/pmem/rpma/issues/1142
> 
> CC: stable@vger.kernel.org
> Fixes: 405506274922 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
> 
> ---
> V3: adjust the checking order
> ---
>  mm/hmm.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Andrew, can you grab this please?

Thanks,
Jason
