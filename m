Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC58665F4E6
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 21:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbjAEUBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 15:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbjAEUBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 15:01:34 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FFF1AA37
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:01:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v23so40988864pju.3
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 12:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pVxwqNbug9kzVKOL3oZqGnvdYf9glDYyhFwWJ28UE9c=;
        b=GHsPtBur+p4pVrDOJtCpuXZtHd6ZyxGvlJhmjJ6qN6fHChX0vhJ2s8WI5qTqrb51LT
         oGX+F4kCNJMT0IlQzaus2qSDSSZAH140BEMq76BpoNGFZn8LedpF6Khmidi1poaMxB7m
         t/JU+z/2udLVgHEnc/WhZy8MsbfhX6DNst8pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pVxwqNbug9kzVKOL3oZqGnvdYf9glDYyhFwWJ28UE9c=;
        b=zHEWxI73O1mxthUpMFgX78sVjGPHEU5kAAtFJaaapKuAzAhbCWX4hFPFM5tBmjywzf
         h7MrIdRZkZs9vvuUiRNw6xCmRP2L2D4fDfd8lqtYb7+3NGDDKfPGw6+fkbHHZcbBpws9
         LgyArHR9Yq4Jrc1ZQcli4swVXg4CmjNOwIzp7s6tCVpdR356H+SFPRLPCD3QDaL4viuK
         wzd2zCsKuuFX06TwijODFA6Do9jKWhQTxzGrvbgboLgg4Tu1CDQCOGd5D98dUD515eTz
         hu2s48yaIKo2UJHSQhNoHxHFOI0bicy/HF3EjJRhPeWlxyYnYx2oUeflMSDrxuS/btw/
         q65A==
X-Gm-Message-State: AFqh2kpXqz/5D/5JC+IP49sQZ4rKPCDR7EGZwxvuUEw2a8ka8rL0CEJy
        6Ru2jXp9ilTYqoklsc5a4Ch4ZQ==
X-Google-Smtp-Source: AMrXdXtiSYCndt8IrAXOQDq9FZ2AmUK0DrLHAa9LWFBHa5cn4ItMrAiA2RYWW90jFvgtGv8uMgl+YQ==
X-Received: by 2002:a17:90a:acf:b0:226:ddf6:b7da with SMTP id r15-20020a17090a0acf00b00226ddf6b7damr370799pje.41.1672948884061;
        Thu, 05 Jan 2023 12:01:24 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g6-20020a17090a640600b00225ffb9c43dsm1728484pjj.5.2023.01.05.12.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 12:01:23 -0800 (PST)
Date:   Thu, 5 Jan 2023 12:01:22 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] io_uring: Replace 0-length array with flexible array
Message-ID: <202301051159.9CBE8DE09@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7cnGT0dK86BA4b7@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[resend -- I failed to CC the thread]

On Thu, Jan 05, 2023 at 08:38:01PM +0100, Greg KH wrote:
> On Thu, Jan 05, 2023 at 10:04:19AM -0800, Kees Cook wrote:
> > On Thu, Jan 05, 2023 at 08:39:48AM +0100, Greg KH wrote:
> > > On Wed, Jan 04, 2023 at 07:37:48PM -0800, Kees Cook wrote:
> > > > Zero-length arrays are deprecated[1]. Replace struct io_uring_buf_ring's
> > > > "bufs" with a flexible array member. (How is the size of this array
> > > > verified?) Detected with GCC 13, using -fstrict-flex-arrays=3:
> > > > 
> > > > In function 'io_ring_buffer_select',
> > > >     inlined from 'io_buffer_select' at io_uring/kbuf.c:183:10:
> > > > io_uring/kbuf.c:141:23: warning: array subscript 255 is outside the bounds of an interior zero-length array 'struct io_uring_buf[0]' [-Wzero-length-bounds]
> > > >   141 |                 buf = &br->bufs[head];
> > > >       |                       ^~~~~~~~~~~~~~~
> > > > In file included from include/linux/io_uring.h:7,
> > > >                  from io_uring/kbuf.c:10:
> > > > include/uapi/linux/io_uring.h: In function 'io_buffer_select':
> > > > include/uapi/linux/io_uring.h:628:41: note: while referencing 'bufs'
> > > >   628 |                 struct io_uring_buf     bufs[0];
> > > >       |                                         ^~~~
> > > > 
> > > > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> > > > 
> > > > Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
> > > > Cc: Jens Axboe <axboe@kernel.dk>
> > > > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > > > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > > > Cc: stable@vger.kernel.org
> > > 
> > > Build problem aside, why is this a stable kernel issue?
> > 
> > My thinking was that since this is technically a UAPI change, it'd be
> > best to get it changed as widely as possible.
> 
> You can't break the uapi, so it should be the same with or without your
> change right?
> 
> confused,

Correct -- but we've had a hard time finding breakages (with extremely
weird stuff like non-C .h file scrapers) due to the lag between making
UAPI changes like this.

Anyway, I can drop the CC stable if it's more sensible.

-- 
Kees Cook
