Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620B544DAFA
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 18:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhKKRLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 12:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbhKKRLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 12:11:41 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90AAC061767
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 09:08:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id o14so6261196plg.5
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 09:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MTeb7EwYQ6knt5Yt/ry55U3lnaRcmUX6EwlTrk8tx+c=;
        b=ds20VIcMFOGuKghW/bzjxNO+bNyDsiYY41bgx6wWI5aCSCnwss/Co3Ny6XzbTFQeMy
         yisAaMV+GRDylQ5IlXjZfRuEAPsgMR52HvS/aqqKnda7xSUt0Bh5+sunjV4Rv2gi9R1F
         nkjmxOed+c9gGz0fMM/h5IaqQ2w7k3of2ZHwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MTeb7EwYQ6knt5Yt/ry55U3lnaRcmUX6EwlTrk8tx+c=;
        b=kozx5F84zruxmvuZ0g3ICawpERKBxr6C23JtV0Ai+Ug5oRQyZGHJDsQUXOCLmf8u8P
         qvMr81HuwfitiAQ16w4nJp98imYAf6bRLg/kxjRKLTulGYlB5Q0v77oocrgBOEZxb+Ol
         GdznXBPHYqKQRXeb+oH/k+RzNYMk5pHp3NVkZ3BKnuqYNUMhUopd/bebsDk5rK4tiyQi
         RM+4aXwzr+HERPO90KxrXphLFEbGt5nwofqgp8GM6JtCH6e+swcALmFwnvcaUZ6TbiRk
         i/mPCIN7OENXsN416Bmnm8+RpVTsRZwj3NL8PugpYVMgC20OHtM9xscxTrBIx/C5PyiH
         YhFA==
X-Gm-Message-State: AOAM531yn0eOG0oKt615dwAFYOYYDJzJrDF/pSWymF7eM9TTMp6nCTF6
        r//mZPqB4SDzCxSxslBYySvGKQ==
X-Google-Smtp-Source: ABdhPJy+Wspr+wgSYV8eJ6xk+ftryfQPGFwP/r7UPzbjE2qFAC9uL0TIDG3ozkjbX8I7CNV0cO239g==
X-Received: by 2002:a17:903:1110:b0:13f:d25c:eac5 with SMTP id n16-20020a170903111000b0013fd25ceac5mr641394plh.5.1636650532110;
        Thu, 11 Nov 2021 09:08:52 -0800 (PST)
Received: from google.com ([2620:15c:202:201:8be6:66e1:e079:a091])
        by smtp.googlemail.com with ESMTPSA id i184sm2735100pgc.77.2021.11.11.09.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 09:08:51 -0800 (PST)
Date:   Thu, 11 Nov 2021 09:08:47 -0800
From:   Zubin Mithra <zsm@chromium.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4.19 01/16] block: introduce multi-page bvec helpers
Message-ID: <YY1OHxpimjKYgxGR@google.com>
References: <20211110182001.994215976@linuxfoundation.org>
 <20211110182002.041203616@linuxfoundation.org>
 <20211111164754.GA29545@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111164754.GA29545@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 05:47:54PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Ming Lei <ming.lei@redhat.com>
> > 
> > commit 3d75ca0adef4280650c6690a0c4702a74a6f3c95 upstream.
> > 
> > This patch introduces helpers of 'mp_bvec_iter_*' for multi-page bvec
> > support.
> > 
> > The introduced helpers treate one bvec as real multi-page segment,
> > which may include more than one pages.
> > 
> > The existed helpers of bvec_iter_* are interfaces for supporting current
> > bvec iterator which is thought as single-page by drivers, fs, dm and
> > etc. These introduced helpers will build single-page bvec in flight, so
> > this way won't break current bio/bvec users, which needn't any
> > change.
> 
> I don't understand why we have this in 4.19-stable. I don't see
> followup patches needing it, and it does not claim to fix a bug.


There is some more context on this at:
https://lore.kernel.org/linux-block/YXweJ00CVsDLCI7b@google.com/T/#u
and
https://lore.kernel.org/stable/YYVZBuDaWBKT3vOS@google.com/T/#u

Thanks,
- Zubin

> 
> > +#define mp_bvec_iter_bvec(bvec, iter)				\
> > +((struct bio_vec) {						\
> > +	.bv_page	= mp_bvec_iter_page((bvec), (iter)),	\
> > +	.bv_len		= mp_bvec_iter_len((bvec), (iter)),	\
> > +	.bv_offset	= mp_bvec_iter_offset((bvec), (iter)),	\
> > +})
> > +
> > +/* For building single-page bvec in flight */
> > + #define bvec_iter_offset(bvec, iter)				\
> > +	(mp_bvec_iter_offset((bvec), (iter)) % PAGE_SIZE)
> > +
> 
> Plus this one is strange. IIRC preprocessor directives have to put #
> in column zero?
> 
> Best regards,
> 								Pavel
> -- 
> http://www.livejournal.com/~pavelmachek


