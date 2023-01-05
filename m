Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459BA65F368
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 19:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbjAESFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 13:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbjAESFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 13:05:08 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6025F499
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 10:04:28 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so2783436pjj.2
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 10:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0P8fWNB9uGiIbEBnadT8SZ/GnrLR3KrMQPnTu697WXU=;
        b=eHv012K+wdORG+6g8TCLO+HUDJknB406VNyrXM/nfxeii7+a+W90WE6MNBjWm9opwo
         o39UmpFAl4/rtjmDyklQwDOEssFsvXqIJlyiC2LmEuFeSBgQ+AfkMng0eSvfskSVOUtr
         M3AyqpJmHpbEX9I97056RTdRgpsxknXpyWyoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0P8fWNB9uGiIbEBnadT8SZ/GnrLR3KrMQPnTu697WXU=;
        b=qKCc3O0iJNHt1V+YFdnVJuOBw5A4jqLg9Ar7uWpFR9pLvBTPpJ9L+KpV/JUGEm52ep
         EolrR3KWfh86b265BbmGp2eTG4WUz5DaixLPw/GQ5arEapgRsOe1yhPHy8h7k8zocZCu
         YaW9lZTincLxfZMRM+ULOGZsvk2Xk0V98x+2G3KQwlpfjv0PV+M+YgaDxPTLNIHUgbvd
         875DATrzHzTAXUlhoi+Sxs4Va71X8MVJDDAvLVtIi3vFxR6mlXhav4l72g54UNBeIIUJ
         Qy6pbE1+Zh3NljBUCmdm8S/7fqD7HIAEOINk9NwmyBEYruNczozV6IaUendo3hxiLaqv
         KQGg==
X-Gm-Message-State: AFqh2kpPqvusGwSL6FF3rd6o5mLJOTWdk2BCch42Kzk49Z+2ME7paFTc
        zAl4+S7aBy3iv8/vsAX1KBsHOA==
X-Google-Smtp-Source: AMrXdXufN+/oh/UGgwRcTi2k/DtAOkHqn7zTKMSm+wdkn8ikP+9NewxMGZWcNYnDPdJxmVHjDyGi4Q==
X-Received: by 2002:a17:903:2312:b0:192:8c7f:2654 with SMTP id d18-20020a170903231200b001928c7f2654mr43094188plh.0.1672941864581;
        Thu, 05 Jan 2023 10:04:24 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f54a00b0017f592a7eccsm26349263plf.298.2023.01.05.10.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 10:04:22 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:04:19 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] io_uring: Replace 0-length array with flexible array
Message-ID: <202301051003.27CF3DC@keescook>
References: <20230105033743.never.628-kees@kernel.org>
 <Y7Z+xN+BDy5yoK5f@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7Z+xN+BDy5yoK5f@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 08:39:48AM +0100, Greg KH wrote:
> On Wed, Jan 04, 2023 at 07:37:48PM -0800, Kees Cook wrote:
> > Zero-length arrays are deprecated[1]. Replace struct io_uring_buf_ring's
> > "bufs" with a flexible array member. (How is the size of this array
> > verified?) Detected with GCC 13, using -fstrict-flex-arrays=3:
> > 
> > In function 'io_ring_buffer_select',
> >     inlined from 'io_buffer_select' at io_uring/kbuf.c:183:10:
> > io_uring/kbuf.c:141:23: warning: array subscript 255 is outside the bounds of an interior zero-length array 'struct io_uring_buf[0]' [-Wzero-length-bounds]
> >   141 |                 buf = &br->bufs[head];
> >       |                       ^~~~~~~~~~~~~~~
> > In file included from include/linux/io_uring.h:7,
> >                  from io_uring/kbuf.c:10:
> > include/uapi/linux/io_uring.h: In function 'io_buffer_select':
> > include/uapi/linux/io_uring.h:628:41: note: while referencing 'bufs'
> >   628 |                 struct io_uring_buf     bufs[0];
> >       |                                         ^~~~
> > 
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> > 
> > Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > Cc: stable@vger.kernel.org
> 
> Build problem aside, why is this a stable kernel issue?

My thinking was that since this is technically a UAPI change, it'd be
best to get it changed as widely as possible.

-- 
Kees Cook
