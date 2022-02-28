Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0222C4C7002
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 15:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiB1Otg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 09:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiB1Otg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 09:49:36 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE743BA56;
        Mon, 28 Feb 2022 06:48:57 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id ay7so13376976oib.8;
        Mon, 28 Feb 2022 06:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VlG4fI6bBYkPpFcbAcTm6hy8fXOzxdf1xdGq3BMqoYc=;
        b=IW8WA+AHr1t9GtRiZH0kfoy7+BwA7nt0t5LtGYYh6UC7qVANOORD8+NYp2VDFEaLih
         69yLwp5vFOImHYnnHKAJmqMXiOYpYu5K40FCN6EVsxs4NDhi/NAR/kMTupV72PHmZj8/
         s27FvOXqNvosbqWAjlfjIbTZCj7XHNIYPS+keTAhKiZKucS6GFOq3Td2UarGICuQcZSE
         vqSzUttCvRBlCk/2ueOnGTzX4Ij7/hC0cHKg2S1zkjYzwbz8VRaOZ+6asW17dU8XAoxZ
         vE0GBKMiItHZd6MXyzf1WiDykJme8psjV0JdWoqGlPVDq4XSWEeLUmH3g6knc+e9oczC
         JmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VlG4fI6bBYkPpFcbAcTm6hy8fXOzxdf1xdGq3BMqoYc=;
        b=ahKdvqfFwi8ByCEP3GL5SFSFUoHtq4KH+ezV9hRcydoUpoNONF2lKUJ5O2vcAhVywK
         Y2xs5b5Fuiqtve+7UOGlsWCaOjqpZXQVK7MEcxgArooZcq+q1pJBz7RfrkLTFiqJmamJ
         tXMODDwNVKzELfHCs+EInLT8pZatHJPKxe2p68pzPkpCaiatuXbVT9jLWig9yj1qC/cN
         Cid8a/gAUmd7cG9ZjttBia6LOjMoMbSEz5ntYcZg9RlB2/1v+V9w62jJ0VqgI2B0gA8x
         tQKtZBtpNJMd5beqraC1yYi4RB0aSiyVguD84NvOJzV8RLOSVtwV34uAhz9YJZD8JxTC
         YMzQ==
X-Gm-Message-State: AOAM531gATUR0IFi3zNjBQ94VtG/HTa2hbQTPHMT20ZAlzDJSmnyDi6l
        isvVFjnhhZjPp0/LUyg2HiP0yWaHb1Ve+ZCGk9M=
X-Google-Smtp-Source: ABdhPJxyeCNuUoc7Rc3If7ObB7hMpxFXHG9BXhesgjQMW03kyvafsvGo0AMIsg//K2PlG2nzgM4LsOSq+L/xbj8gEgI=
X-Received: by 2002:a05:6808:124d:b0:2d7:f6e:74b0 with SMTP id
 o13-20020a056808124d00b002d70f6e74b0mr10939977oiv.141.1646059737002; Mon, 28
 Feb 2022 06:48:57 -0800 (PST)
MIME-Version: 1.0
References: <20220225221625.3531852-1-keescook@chromium.org> <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com>
In-Reply-To: <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com>
From:   Daniel Micay <danielmicay@gmail.com>
Date:   Mon, 28 Feb 2022 09:48:41 -0500
Message-ID: <CA+DvKQ+PYtDyejaUoBj51D_Y7muYaR1_FhQGWGWvgQawCbp31Q@mail.gmail.com>
Subject: Re: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
To:     Marco Elver <elver@google.com>
Cc:     Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There aren't many calls to ksize in the entire Linux kernel source
tree. Most use cases are using the memory as some kind of (chunked)
dynamic array, where they either need to realloc or kmalloc a new
chunk when it runs out of space. Changing the approach to this API
would be both more efficient and fully compatible with alloc_size
since it would simply not be added to these functions:

    kmalloc_size(size, &result_size)
    krealloc_size(p, new_size, &result_size)

Nearly every use of ksize could be easily phased out this way. There
are probably a few which are harder to remove. It can be gradually
phased out by keeping around ksize temporarily but documenting that
it's only correct to use it on memory allocated with
kmalloc_size/krealloc_size. I think it can be phased out quite quickly
though. Look at how many calls there are to it. It's really not a lot,
especially if you filter out the uses of the identifier 'ksize' for
variables rather than calls to that function.

I brought this up when I originally submitted CONFIG_FORTIFY_SOURCE.
It's the main reason that I didn't bother trying to submit the
alloc_size attributes myself. The most important ones are for kmalloc
and it isn't technically correct to use it.
