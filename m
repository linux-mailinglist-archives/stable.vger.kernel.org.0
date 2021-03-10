Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764E13332D3
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 02:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhCJBmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 20:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhCJBmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 20:42:09 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C4AC06174A;
        Tue,  9 Mar 2021 17:42:09 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id j12so10824619pfj.12;
        Tue, 09 Mar 2021 17:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZDI+zqz/gmKV7eFJ/IUB2NDdlfLMPKP1roKLG1D9fzo=;
        b=sYbkeuGXVxQ51NlG9TEIyxkd7N8rYYcBTIoV5eiNDhKDDAUTt2LSbXWcZZktQF6eWa
         R0mKtNO8tTHr68v3ieJVcPbGm/8GV34By1MXeV59LTpxfvVHyfk6DPkc9FlEuhF+lVci
         Fd8GexxCz0LrwsK44NJunKLzgQa9aFRCauSKLdHggkWKuEp1T2JGQ7FuUyHQMt4NRfWJ
         V6J4GctGsbcJY6DtwUuo5C7C6MmtCQY1i1Da0j46bt2CjSDCdM4bKV/usEQqnQ3muj1n
         UIojIB0dTPEzzGmM4yMykSrxLEreAOXOvM4uuFRoKkL9zm5yFzt2v8h5q9VhEi/BaMvk
         WXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZDI+zqz/gmKV7eFJ/IUB2NDdlfLMPKP1roKLG1D9fzo=;
        b=T02cbdA0dj9Lc/5zxLBY+bYF8kX9tgMtzufIZY9ukQ4EpzDGpGClTwRjZqPIAWm1Jx
         0o8vtPNCouRqKjA8DBs+/eXsZ3emxi2Qe01vPIgLbbpzvW2/Kijzc955LWs+LwpsL/QK
         X2bZCQZu+ZHw2Ah0iVxoXp6+mq0yE8KvjKt9LX7gtOMTLS+f779YagMhO9jjhJqvQ3kq
         ZNyNYAcWawyiDZW23zCuJVvBKzo7HQ41VvCHHcjAUv+CdfxXM2z7hK++UYeJIOLxRz2N
         7CcsZcATLDXsSvnWPzQxi9KYDNcxhQ4zsWifN9vhlVge7DE7ItD+EZo1dnEJ/v8duwkK
         wtuA==
X-Gm-Message-State: AOAM5336pU71qiY9Y7cylszPVufv1EDadBlMVA7KwgqG/K+ZG0F7NNKx
        Puwr6TaTilXtzdTFU8OhlFA=
X-Google-Smtp-Source: ABdhPJxMvFYOtWPkwwQOOsV2kI0StOthXy7kGxL53gB2dwSpf4FDyJ7YaOhwctBxJ625mAtBkd1V4w==
X-Received: by 2002:a62:78d4:0:b029:1f1:595b:dfdf with SMTP id t203-20020a6278d40000b02901f1595bdfdfmr619146pfc.81.1615340529136;
        Tue, 09 Mar 2021 17:42:09 -0800 (PST)
Received: from google.com ([2409:10:2e40:5100:30c3:e7ed:8b0a:7f01])
        by smtp.gmail.com with ESMTPSA id n9sm721799pjq.38.2021.03.09.17.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 17:42:08 -0800 (PST)
Date:   Wed, 10 Mar 2021 10:42:03 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in allocation
Message-ID: <YEgj61iAt4Avnp6d@google.com>
References: <20210309234317.1021588-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309234317.1021588-1-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (21/03/10 00:43), Ricardo Ribalda wrote:
> The plane_length is an unsigned integer. So, if we have a size of
> 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.

Hi Ricardo,

> @@ -223,8 +223,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  	 * NOTE: mmapped areas should be page aligned
>  	 */
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		unsigned long size = vb->planes[plane].length;
> +
>  		/* Memops alloc requires size to be page aligned. */
> -		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> +		size = PAGE_ALIGN(size);
>  
>  		/* Did it wrap around? */
>  		if (size < vb->planes[plane].length)

Shouldn't the same be done in vb2_mmap()?

	-ss
