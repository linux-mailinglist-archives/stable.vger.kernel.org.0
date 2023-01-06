Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F8B6603BC
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 16:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbjAFPx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 10:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjAFPxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 10:53:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238E5809A4;
        Fri,  6 Jan 2023 07:53:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9683B81DA7;
        Fri,  6 Jan 2023 15:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F198C433D2;
        Fri,  6 Jan 2023 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673020400;
        bh=ozokV6pT8SVbzlyCUBZ1GdL2Q6oCef7CdvW7wB8pYIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hqnYqccDRPe4zfjFlZlGq9bMi1QK1K/ENv4FdpwXxTFpOni3HtRWSJbgGb2Y8pzB7
         yXA630rU76YOWSRSXCN4o6T+ZbnSn7QtzfV3S28bz19GlBWQuPzbUxKo8dkSt4vE+C
         5jVMF5S/TsAezCXVjg9o74v/H6ZKIYtLF0KKsiYWhUiyHgDUS61mqKlLPYKGwThD3k
         kdJLlvgA2c6DNe6DTPTSZEiWVpMr/ePm8XBVVkt1FVtJUOh+AeioKGe0oxf4TO02Nv
         SLOE0zta+l4LUtsqgIITFqD+OCEfPF04GI79Ur80y0moYs2CtCGxhbAaiEZIJwzs4+
         77/N4m6dMlQ7w==
Date:   Fri, 6 Jan 2023 09:53:25 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: Replace 0-length array with flexible array
Message-ID: <Y7hD9XNAsNZ1zIcS@work>
References: <20230105190507.gonna.131-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105190507.gonna.131-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 11:05:11AM -0800, Kees Cook wrote:
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

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
> v2: use helper since these flex arrays are in a union.
> v1: https://lore.kernel.org/lkml/20230105033743.never.628-kees@kernel.org
> ---
>  include/uapi/linux/io_uring.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 2780bce62faf..434f62e0fb72 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -625,7 +625,7 @@ struct io_uring_buf_ring {
>  			__u16	resv3;
>  			__u16	tail;
>  		};
> -		struct io_uring_buf	bufs[0];
> +		__DECLARE_FLEX_ARRAY(struct io_uring_buf, bufs);
>  	};
>  };
>  
> -- 
> 2.34.1
> 
