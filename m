Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8BA21EF3E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 13:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgGNL2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 07:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgGNL2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 07:28:53 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078F3C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 04:28:53 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d18so16895778ion.0
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 04:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/oeflvzSREAUYMTpSSWqRsDBaMz2BBwNLJO1ttrAXlc=;
        b=BoQAA3oOA0y88J/Q0XSLJjnhdS47LS3eriWR2sCshDqMDdPvcneDcwHfBlPVig8wti
         54anA4ATe8/4X8otBNc9xC8Swzonn2+MTX62B0ZlIHWbpgG8aXybYSKmdY2kYuWm8T2v
         ZidTVRPkM/sr1AXSuBgNLQzNBNq3mFq7GKEUZyNSkjUtEsgjLZ6iQH1cXCoqGbWH6GDB
         bHK0lnk61eLzPFnGAM1N/Lpm9TMrFbTcTNs1qLZC7Z4WxSLrPLIPsTN+kQKzSlumMuC6
         U75MfLRt5StRND0L/X4hxyadaawgj00NiWXiaBxsXCMX5VJuQM8IcgXpbsxZ+S/5B095
         WUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/oeflvzSREAUYMTpSSWqRsDBaMz2BBwNLJO1ttrAXlc=;
        b=S/KCJcqhtCf1zqFNHQd8dIl/UeAVmjxRlZSPqZLddxRITPpYer30ojwXTWgXo4c0Rf
         jDatQxdpR7JLgzLKs2x/lWxR7x5NNmWMSJAFpA0wWl8hRwGlZPEAmL/FGHP5HqZjp/Uv
         LEorsI0YxjzoBcIiNJB31rLmyGeBLSPOHnpsyrAz5axml4STCvYf0aIkw3dJZLzE7vqg
         pKJYrPoSfXkICEiSjlBB7dtCR2qEGCEX1Cy96OklqITpKPtE21ahPN3M/6xv83NionQa
         TR3IWt18WW8T8zOxrCWtuS4wh/395ZqkH4+IPWBmiPAYewd5/f/9Yb0qgRWCNvUbfoeC
         U0Kg==
X-Gm-Message-State: AOAM532Cjy5dzXig2xOdWqU5HV5tvyuPzmxiFDaGltK1J5UIcqTFzhup
        moAsJMDWtt2jUprs02vpoyJ6Kg==
X-Google-Smtp-Source: ABdhPJwlST0/26MXPJEDg+XyoSZPPsf7Lcxc4EVdgXD99/lkx1GCClw5MT9zuOIlSOFKuJr3TjlhEA==
X-Received: by 2002:a02:cb59:: with SMTP id k25mr5333445jap.112.1594726132367;
        Tue, 14 Jul 2020 04:28:52 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id a5sm10013244ilt.71.2020.07.14.04.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 04:28:51 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jvJ7C-00A7R6-Mq; Tue, 14 Jul 2020 08:28:50 -0300
Date:   Tue, 14 Jul 2020 08:28:50 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, dledford@redhat.com
Subject: Re: [PATCH 4.19] IB/umem: fix reference count leak in
 ib_umem_odp_get()
Message-ID: <20200714112850.GD25301@ziepe.ca>
References: <20200714105748.1151138-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714105748.1151138-1-yangyingliang@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 10:57:48AM +0000, Yang Yingliang wrote:
> Add missing mmput() on error path to avoid ref-count leak.
> 
> This problem has already been resolved in mainline by
> f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
> 
> Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
> index eeafdc0beec7..08ef654ea9b8 100644
> --- a/drivers/infiniband/core/umem_odp.c
> +++ b/drivers/infiniband/core/umem_odp.c
> @@ -347,7 +347,8 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem,
>  		vma = find_vma(mm, ib_umem_start(umem));
>  		if (!vma || !is_vm_hugetlb_page(vma)) {
>  			up_read(&mm->mmap_sem);
> -			return -EINVAL;
> +			ret_val = -EINVAL;
> +			goto out_mm;
>  		}
>  		h = hstate_vma(vma);
>  		umem->page_shift = huge_page_shift(h);

This patch does look correct, please address Greg's remarks.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks,
Jason
