Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CFA55158F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240933AbiFTKPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240869AbiFTKPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:15:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D1FD13F5B
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 03:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655720151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=17O633cxkzhtVlsw20bhFnYAwMJzxi4yxd1FxbpHmHk=;
        b=KxDTHlZgmAr40jCFsE1HUT4TB2QGQVaPEf8NzUkAJhS9GNeqSWMitOzrxlZbwlgcIh/ZsJ
        EYoP/sJ0YFRKNiPiAeKw1F93cc0Tr2GbjCHOldXy8GAkh6epfIIYaf6bv6sAa/ZAB8Ab1/
        FIR8QUJNN53Lvi1apXJRZNyGPpNYpf4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-lXhh4cZaMHemOip9pVxA0w-1; Mon, 20 Jun 2022 06:15:50 -0400
X-MC-Unique: lXhh4cZaMHemOip9pVxA0w-1
Received: by mail-qk1-f197.google.com with SMTP id i10-20020a05620a404a00b006a7609f54c6so12589650qko.7
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 03:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=17O633cxkzhtVlsw20bhFnYAwMJzxi4yxd1FxbpHmHk=;
        b=mSKEbPluK9+r/VCO4gFcYSjr0F+WcbXyFbwq8DHgA4ezLUxQzxri7KPnmzlzeNGc+a
         0fbGhEAdVC0EJuH5sbOwKIoFFNpOSFKt3LzLr5zaQOwnFe6UR5TlQtA7La5Z+AQANaRd
         kDeCJot0cFFeIABQr+1FRalLrMARtShOvpaSY3rxeUUfwSVAZO+TTqhsQverEfo06Bx+
         sB2w5vrkQycgj0kgTjQJ/dRi7hQjmVa1QPKqcT/lA6iX4Mv/utFPRJQrmao2N00ru7Lz
         ItTbtvhzY/BO0KsgmS2QqdaZ2HNlO0pjBFF/O01dofXXIFFO3cKnBuXAjsXMAzlu1n4H
         AcFw==
X-Gm-Message-State: AJIora8/WSx0EExTLzk2/MGTZ/Cw1RXkKw4H6nHlnvYy5jI7rMMo/nJo
        z+U4VGsoOCwVRP+jkQZG9kOs96Kl4fLWky5brRuIfpkurLVgMuPE97K0rOvvLxWLhM+7jUt13N3
        24FwMVdD9RFAnnAdY
X-Received: by 2002:ac8:5dce:0:b0:305:300e:146d with SMTP id e14-20020ac85dce000000b00305300e146dmr19314577qtx.546.1655720149399;
        Mon, 20 Jun 2022 03:15:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v/cEaNjKfBuKp+ZYEkUM0VlKRqhV9w3cgTc7c6P2YubjKi1eY5Etkh4aXJe37nZysORywQIw==
X-Received: by 2002:ac8:5dce:0:b0:305:300e:146d with SMTP id e14-20020ac85dce000000b00305300e146dmr19314558qtx.546.1655720149125;
        Mon, 20 Jun 2022 03:15:49 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bm12-20020a05620a198c00b006a7284e5741sm12065536qkb.54.2022.06.20.03.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 03:15:48 -0700 (PDT)
Date:   Mon, 20 Jun 2022 06:15:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] filemap: Handle sibling entries in
 filemap_get_read_batch()
Message-ID: <YrBI0jIzeyksEVyp@bfoster>
References: <20220619151143.1054746-1-willy@infradead.org>
 <20220619151143.1054746-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220619151143.1054746-3-willy@infradead.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 19, 2022 at 04:11:42PM +0100, Matthew Wilcox (Oracle) wrote:
> If a read races with an invalidation followed by another read, it is
> possible for a folio to be replaced with a higher-order folio.  If that
> happens, we'll see a sibling entry for the new folio in the next iteration
> of the loop.  This manifests as a NULL pointer dereference while holding
> the RCU read lock.
> 
> Handle this by simply returning.  The next call will find the new folio
> and handle it correctly.  The other ways of handling this rare race are
> more complex and it's just not worth it.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Reported-by: Brian Foster <bfoster@redhat.com>
> Debugged-by: Brian Foster <bfoster@redhat.com>
> Tested-by: Brian Foster <bfoster@redhat.com>
> Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

This has survived my testing for several days now. I think I grok the
fix and analysis that lead to it, so FWIW:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  mm/filemap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 577068868449..ffdfbc8b0e3c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2385,6 +2385,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
>  			continue;
>  		if (xas.xa_index > max || xa_is_value(folio))
>  			break;
> +		if (xa_is_sibling(folio))
> +			break;
>  		if (!folio_try_get_rcu(folio))
>  			goto retry;
>  
> -- 
> 2.35.1
> 

