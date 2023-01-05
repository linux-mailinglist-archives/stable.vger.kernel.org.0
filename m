Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9665E62B
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjAEHjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjAEHjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:39:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3511950F48;
        Wed,  4 Jan 2023 23:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF54761372;
        Thu,  5 Jan 2023 07:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CF4C433EF;
        Thu,  5 Jan 2023 07:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672904392;
        bh=zf1ommYA9XCcZGXu46zSz4UxOF9Hdi8SgrdQ6JKVFpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MoTRcJT+qw+lpdmLxureeznMjdMUHlRXiW0+yjtomc5F1V3tfvFV2gSQ6jjGbZe5x
         sHGDWE0Bg+0bTECcUqOGHDoTJaiR8WR7Zb5y7VEobG0g4vMVyX0ya2rSGjhQV1r3+m
         nwKjDH7rYO9WyyBS/iC9nCdnb/xLUmHmWaeh5pJg=
Date:   Thu, 5 Jan 2023 08:39:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] io_uring: Replace 0-length array with flexible array
Message-ID: <Y7Z+xN+BDy5yoK5f@kroah.com>
References: <20230105033743.never.628-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105033743.never.628-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Build problem aside, why is this a stable kernel issue?

thanks,

greg k-h
