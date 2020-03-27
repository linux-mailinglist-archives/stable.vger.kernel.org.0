Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBCC1956CE
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 13:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgC0MLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 08:11:04 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41670 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0MLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 08:11:04 -0400
Received: by mail-qk1-f194.google.com with SMTP id q188so10446044qke.8
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 05:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ae32xXO67Uei3DTimjBj1wlAZ/pkH/el6Qiul9IT/30=;
        b=Ex3D0PnD7gDl3aSUB2klXnKG6WqRJ7QfwnM6N9ZGFL92WovcOuAzEFRyYweVO4bxtE
         7Xg8gqSK2Z3BuI8TP9K0fdhDNWpdwzHD/JkAmE9cJPZ0tZrDsJOHhAbWsH+vjsmkuIY6
         uwK5871CUpjZLzSstezfN/aBg5CasNqsGxP8A9EfPWuZRYdJDyWQBXQ7ttS6IiSCsthL
         ifCas0C0YCZ3fC4iuuQORU9gg8EUmyeqhcf3rCO0NRXcZ2xj0HrGTKS3hd6SWnksKhsW
         VFFIjipCV/rNC4HQApb3Vkke+23D5s7p4BGXZmNMTKFYNFv1sR1pllPZ8YXvdvs0uPyV
         9Few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ae32xXO67Uei3DTimjBj1wlAZ/pkH/el6Qiul9IT/30=;
        b=XE9yPhmV9oyZn634LvRBlSV52RluDozmmQx7SMUjX41a/ZdDb4lZm4CAArcn7GCzaJ
         rknqHtNC+wbocqWdoqiEOzYSdOQYjXXF85Rxkzs1Hsgqdos+oSIr6Xi5mY556ozi0h28
         5ejOC5owu8mCpbF3KUAFzFj8kz6jRX9T5so1MvfIPugBDoJQGEOulg9ZD1BvL9jw0Oes
         BeiAFrVLHxrp9vsOSv6bIrMgShKwPqOB69J3e5nG1MtcVVpgqjzFV8VHlX4gv2AiA5U/
         Mhbuf+pzranNlOuKXdXgCKESj8n+vpTdTwTdu/Ommx3DTdccfrmvWz0+IuoEfAAFvA+n
         p7tg==
X-Gm-Message-State: ANhLgQ2RJC+WM15kWMBKhjEia0+eIl/z8DM7W78RRYrLaB+AxGmfYAlx
        qh4jAyzdEy5U4JOf7Ow0D0qBZA==
X-Google-Smtp-Source: ADFU+vu5etCsTsz6Y5TtfPSyk7GQigfbQaUBOkfH75rGPq30AeujH7DUKAa3E9WYmWw4syrKT0bbug==
X-Received: by 2002:a37:a746:: with SMTP id q67mr14014729qke.215.1585311063288;
        Fri, 27 Mar 2020 05:11:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t71sm3539359qke.55.2020.03.27.05.11.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Mar 2020 05:11:02 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jHnpE-0007MU-MC; Fri, 27 Mar 2020 09:11:00 -0300
Date:   Fri, 27 Mar 2020 09:11:00 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kvm@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kirill.shutemov@linux.intel.com,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset
Message-ID: <20200327121100.GR20941@ziepe.ca>
References: <20200327014007.1915-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327014007.1915-1-longpeng2@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 09:40:07AM +0800, Longpeng(Mike) wrote:
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index dd8737a..d4fab68 100644
> +++ b/mm/hugetlb.c
> @@ -4909,29 +4909,33 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
>  		       unsigned long addr, unsigned long sz)
>  {
>  	pgd_t *pgd;
> -	p4d_t *p4d;
> -	pud_t *pud;
> -	pmd_t *pmd;
> +	p4d_t *p4g, p4d_entry;
> +	pud_t *pud, pud_entry;
> +	pmd_t *pmd, pmd_entry;
>  
>  	pgd = pgd_offset(mm, addr);
>  	if (!pgd_present(*pgd))
>  		return NULL;
> -	p4d = p4d_offset(pgd, addr);
> -	if (!p4d_present(*p4d))
> +
> +	p4g = p4d_offset(pgd, addr);

Why p4g here? Shouldn't it be p4d?

Jason
