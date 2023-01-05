Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2637765F4B2
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 20:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbjAETkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 14:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236067AbjAETkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 14:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66A81DF0D;
        Thu,  5 Jan 2023 11:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A01FEB8111F;
        Thu,  5 Jan 2023 19:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BCFC433EF;
        Thu,  5 Jan 2023 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672947484;
        bh=KBdBzlc3g1iDGQnK6row4ab6NJe99uJpRoP/gxBZW28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YAKtTrpWtz7GX/i3gnravZDqno40s8qwhlWs/sCoVkRvfYMNu4YmgKOzVOlBbialJ
         GsicuuYOltbMgIhasLVbHL48gfQSkA0QxoWLNPlIKN6Fc7xog1pnO05IJjZ/3ANpd/
         zF1QwdDtk9ZqLxfj9a9cyXI4/sibc3/vle5KvFHE=
Date:   Thu, 5 Jan 2023 20:38:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] io_uring: Replace 0-length array with flexible array
Message-ID: <Y7cnGT0dK86BA4b7@kroah.com>
References: <20230105033743.never.628-kees@kernel.org>
 <Y7Z+xN+BDy5yoK5f@kroah.com>
 <202301051003.27CF3DC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202301051003.27CF3DC@keescook>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 10:04:19AM -0800, Kees Cook wrote:
> On Thu, Jan 05, 2023 at 08:39:48AM +0100, Greg KH wrote:
> > On Wed, Jan 04, 2023 at 07:37:48PM -0800, Kees Cook wrote:
> > > Zero-length arrays are deprecated[1]. Replace struct io_uring_buf_ring's
> > > "bufs" with a flexible array member. (How is the size of this array
> > > verified?) Detected with GCC 13, using -fstrict-flex-arrays=3:
> > > 
> > > In function 'io_ring_buffer_select',
> > >     inlined from 'io_buffer_select' at io_uring/kbuf.c:183:10:
> > > io_uring/kbuf.c:141:23: warning: array subscript 255 is outside the bounds of an interior zero-length array 'struct io_uring_buf[0]' [-Wzero-length-bounds]
> > >   141 |                 buf = &br->bufs[head];
> > >       |                       ^~~~~~~~~~~~~~~
> > > In file included from include/linux/io_uring.h:7,
> > >                  from io_uring/kbuf.c:10:
> > > include/uapi/linux/io_uring.h: In function 'io_buffer_select':
> > > include/uapi/linux/io_uring.h:628:41: note: while referencing 'bufs'
> > >   628 |                 struct io_uring_buf     bufs[0];
> > >       |                                         ^~~~
> > > 
> > > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> > > 
> > > Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> > > Cc: Jens Axboe <axboe@kernel.dk>
> > > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > > Cc: stable@vger.kernel.org
> > 
> > Build problem aside, why is this a stable kernel issue?
> 
> My thinking was that since this is technically a UAPI change, it'd be
> best to get it changed as widely as possible.

You can't break the uapi, so it should be the same with or without your
change right?

confused,

greg k-h
