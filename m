Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B3A65E4AD
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 05:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjAEEdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 23:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjAEEdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 23:33:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4665A4087D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 20:33:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso905682pjt.0
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 20:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3P/yf/Hljx0yUONKxZmR3tzsFqGPhmtDq2uLfC/DAPI=;
        b=jauRVyhKIwkNePvpGC4NUNVr92nnvtr8JS2ouuCWzXeaLOGh4HNJWTDlqhB1fPEBDV
         CKAakJCtuzSw2WwlMb8mjBT4Ql4egtwlwjAUkWQ6As5W+O+JPKK80CvniYz3/0KselA6
         5xGKalkLRCFgU0Kc7OVV064La+CRnv7IXB5DU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3P/yf/Hljx0yUONKxZmR3tzsFqGPhmtDq2uLfC/DAPI=;
        b=be/cnEnpUznzIn33eaP3bRIZcfZGFQwRAxoTNxRWk6JwSakOjefgFDUuO1+TRB5pxC
         RBapkyFecoK5CSRxv4h2fths+rQpfJWKbjoQTtniuvyJxSRfxsJqHz674YXl/17DtVAU
         3OLUWrzPL8YRdyq/aMQj7q4Z+uPHnS2jM7iglhFYLznC36D2xPVBz+yojheU28BzEmY4
         5PbaGw1LptbQvlKK72d8qo4nlqlTW9AVGji/x72NgIm+neeivCpP1qw4HmjJu7B3yM91
         auets5nF2v+pLlMADY0wCi7I7ebWgcw74la9GkTWCun2DxiLdQQdFYmw09vtlosZp7qn
         dAeA==
X-Gm-Message-State: AFqh2kpJ63xh63221CKTYqW90l8Ju/hZUuEt5lRv93WY6sdz8SuMNzXl
        uRZtyxv/9gld+CHjyHw81eyQ8Q==
X-Google-Smtp-Source: AMrXdXs4aVvEZrtENUtxRpzVzMYSsjc5m1KZqdaufmQcznMSfcXfv+Q0wulk6C3zb5AZpsfz33RUwA==
X-Received: by 2002:a17:902:a513:b0:192:fe0a:11d4 with SMTP id s19-20020a170902a51300b00192fe0a11d4mr584152plq.64.1672893197721;
        Wed, 04 Jan 2023 20:33:17 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709027e4d00b00183c6784704sm24771489pln.291.2023.01.04.20.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 20:33:17 -0800 (PST)
Date:   Wed, 4 Jan 2023 20:33:16 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] io_uring: Replace 0-length array with flexible array
Message-ID: <202301042032.C293ACB95@keescook>
References: <20230105033743.never.628-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105033743.never.628-kees@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 07:37:48PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct io_uring_buf_ring's
> "bufs" with a flexible array member. (How is the size of this array
> verified?) Detected with GCC 13, using -fstrict-flex-arrays=3:
> 
> In function 'io_ring_buffer_select',
>     inlined from 'io_buffer_select' at io_uring/kbuf.c:183:10:
> io_uring/kbuf.c:141:23: warning: array subscript 255 is outside the bounds of an interior zero-length array 'struct io_uring_buf[0]' [-Wzero-length-bounds]
>   141 |                 buf = &br->bufs[head];
>       |                       ^~~~~~~~~~~~~~~
> In file included from include/linux/io_uring.h:7,
>                  from io_uring/kbuf.c:10:
> include/uapi/linux/io_uring.h: In function 'io_buffer_select':
> include/uapi/linux/io_uring.h:628:41: note: while referencing 'bufs'
>   628 |                 struct io_uring_buf     bufs[0];
>       |                                         ^~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: io-uring@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/uapi/linux/io_uring.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 2780bce62faf..9d8861899cde 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -625,7 +625,7 @@ struct io_uring_buf_ring {
>  			__u16	resv3;
>  			__u16	tail;
>  		};
> -		struct io_uring_buf	bufs[0];
> +		struct io_uring_buf	bufs[];
>  	};
>  };

Oops, please ignore. My test build misfired...

>  
> -- 
> 2.34.1
> 

-- 
Kees Cook
