Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6FC546C1F
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiFJSGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 14:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347141AbiFJSGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 14:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EA9FB1FF
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 11:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654884363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+YSOp7OVxLF72vh/zJwUtYoBADG1yurDFuxv9zOncC8=;
        b=SU7BAqfE1XNeOzcQt/d6GStXNeJqo1mv1pap3dmJ1gB5dqm1q3XdU+9xuAI8VKfyft8nMm
        m49gRf/XQ9d6fUGFBUBZB5hPCkVSNIRaRAsLcqzVG3DMlcdR5kjE8P93+GN/K49vopoecR
        qIQSFp83yY6oISU4RSrhBecQ8uibZYU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-3GxbfLCrNcO-t4-bZeZJtA-1; Fri, 10 Jun 2022 14:05:58 -0400
X-MC-Unique: 3GxbfLCrNcO-t4-bZeZJtA-1
Received: by mail-io1-f69.google.com with SMTP id l3-20020a05660227c300b0065a8c141580so13647727ios.19
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 11:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+YSOp7OVxLF72vh/zJwUtYoBADG1yurDFuxv9zOncC8=;
        b=5IjY2uC6VFyaMTEtmGA1eSXcQwtZSNsVYpZpL/Sd+8wJ+wjLD0YwNNsnmwGMqaJGwm
         UCSzzBVEu+Gn2japhV4/keNGzaP8Jh8PQXAxJwmaZZTz5tnM8a44RG+GLGSkGaAJkC50
         8SsZi8zQJ+fsWvFQ1dqr8bvJe9QCqg+2u0kc+Xd75Wh+u2Gwo5tOHdUfFM8ZGDs1Txtq
         3gT6Ue+vDlufQDHmXoqEoC7b2m6EHhJomQyvDljWrUDtiO1g+olfmXOTBLCgAgq7254w
         wwbvCt7ynw02XYco5TQ10E7VoRe9inW893A+BdX/cVnO19oGArjyEv2so+OTNxQMJHV+
         C2+g==
X-Gm-Message-State: AOAM532R6RRU8M5k0VOtulWGCBZS5anAZk6/D5askHKY5nypFr4C7iVP
        0Wqob0B35ccZdvnHU6CPHroMSG2tpp80bcR7z+DqULEEKaEE+ZCTHk03GIsc963lV9pnY2RtFbV
        1qe3ktMmkuU/E9BC9
X-Received: by 2002:a05:6e02:552:b0:2d1:db28:5434 with SMTP id i18-20020a056e02055200b002d1db285434mr26259379ils.115.1654884358026;
        Fri, 10 Jun 2022 11:05:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweN9LCXIbV5RCAndNmWIQkh4tD+Sg78vRKNfgWb1sUjYk+ID4hSP1WDUwkF+/PbrZ6jYMBNw==
X-Received: by 2002:a05:6e02:552:b0:2d1:db28:5434 with SMTP id i18-20020a056e02055200b002d1db285434mr26259369ils.115.1654884357736;
        Fri, 10 Jun 2022 11:05:57 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a21-20020a056638059500b0032e0a9d63e6sm11104941jar.118.2022.06.10.11.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 11:05:57 -0700 (PDT)
Date:   Fri, 10 Jun 2022 14:05:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated
 shmem pages
Message-ID: <YqOIA05ihTsQbMoG@xz-m1.local>
References: <20220610173812.1768919-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220610173812.1768919-1-axelrasmussen@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 10:38:12AM -0700, Axel Rasmussen wrote:
> When fallocate() is used on a shmem file, the pages we allocate can end
> up with !PageUptodate.
> 
> Since UFFDIO_CONTINUE tries to find the existing page the user wants to
> map with SGP_READ, we would fail to find such a page, since
> shmem_getpage_gfp returns with a "NULL" pagep for SGP_READ if it
> discovers !PageUptodate. As a result, UFFDIO_CONTINUE returns -EFAULT,
> as it would do if the page wasn't found in the page cache at all.
> 
> This isn't the intended behavior. UFFDIO_CONTINUE is just trying to find
> if a page exists, and doesn't care whether it still needs to be cleared
> or not. So, instead of SGP_READ, pass in SGP_NOALLOC. This is the same,
> except for one critical difference: in the !PageUptodate case,
> SGP_NOALLOC will clear the page and then return it. With this change,
> UFFDIO_CONTINUE works properly (succeeds) on a shmem file which has been
> fallocated, but otherwise not modified.
> 
> Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  mm/userfaultfd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 4f4892a5f767..07d3befc80e4 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -246,7 +246,10 @@ static int mcontinue_atomic_pte(struct mm_struct *dst_mm,
>  	struct page *page;
>  	int ret;
>  
> -	ret = shmem_getpage(inode, pgoff, &page, SGP_READ);
> +	ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
> +	/* Our caller expects us to return -EFAULT if we failed to find page. */
> +	if (ret == -ENOENT)
> +		ret = -EFAULT;

I checked shmem_getpage_gfp() and it only returns -ENOENT in one place
where is the missing case for SGP_NOALLOC, then this looks correct to me.

Acked-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

