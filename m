Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0089A4C7E2C
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 00:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiB1XR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 18:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiB1XR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 18:17:26 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CFD53B6B
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 15:16:46 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id iq13-20020a17090afb4d00b001bc4437df2cso583076pjb.2
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 15:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qcyuF/rJ3v9adXS1wD5x79Nrhi3MVFgnMBiDVeVK628=;
        b=H84ukViLP1I1WQwJ555fTIX5iY07fF8mJhYhLLqFrxRU/v/5c13BT2oHieKtQ28QtB
         vTu/WJ1QzVGt7t0JrWP9EZxzFSuISG7rgQ18dkd1w1PdOvc/6kHgHln31L/hqrFgSqbN
         iT+TUK5ORx7x3+XzVmrBCQtrgm3FCzB0zo30Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qcyuF/rJ3v9adXS1wD5x79Nrhi3MVFgnMBiDVeVK628=;
        b=usnMclKCPx8mgAG0wtkLQrgFzUZuEiAf2qUYrQTcgxoUUzArfk3Gbjq3AzOaGSOJih
         JPg7H/4U+h7yDIodBLh2dQ77AY7MCICJnqgWATO8rkca5Omzlax/xJBKdiR9ctrghEqm
         prmMA5BqX7jibvNvbishTeaTEbRrn3WK7IEWzG9t6kcN2fSUpt/7XBQDFpRwJ7nwts+H
         of/BR7hRgID04j7vZlGZXQaZErYpD3oXsN4/xv/IemIYM7Lix/ULdZDx30h5J3x9sKU7
         I/hTu46dIl2Anf5RBqT6NKjzDxkh1y8ut9af87aijPxAdDiklI+6Ei5/9bln0zxrPt5R
         X48g==
X-Gm-Message-State: AOAM532L+96mPXVPMI2How6UfHIXR1KNjM+jgeJQwKZKG3HMTdIHLnZc
        Robp3AFd3vaMC6svaALMw7+bCA==
X-Google-Smtp-Source: ABdhPJyUO4WdPD4D+EwN7uSB3399f8EhL9c8HcIjeCpMcQrsQdmLfXFfXqDsDs2KAc/EYgd95j5zzQ==
X-Received: by 2002:a17:90a:6542:b0:1bd:149f:1c29 with SMTP id f2-20020a17090a654200b001bd149f1c29mr13946279pjs.240.1646090206307;
        Mon, 28 Feb 2022 15:16:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id np11-20020a17090b4c4b00b001bd4aa67bafsm774491pjb.3.2022.02.28.15.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 15:16:45 -0800 (PST)
Date:   Mon, 28 Feb 2022 15:16:45 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     llvm@lists.linux.dev, Marco Elver <elver@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
Message-ID: <202202251823.45E09CF@keescook>
References: <20220225221625.3531852-1-keescook@chromium.org>
 <20220225154518.0d1159fdc6f37ee38e39e90c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225154518.0d1159fdc6f37ee38e39e90c@linux-foundation.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 03:45:18PM -0800, Andrew Morton wrote:
> On Fri, 25 Feb 2022 14:16:25 -0800 Kees Cook <keescook@chromium.org> wrote:
> 
> > If ksize() is used on an allocation, the compiler cannot make any
> > assumptions about its size any more (as hinted by __alloc_size). Force
> > it to forget.
> > 
> > One caller was using a container_of() construction that needed to be
> > worked around.
> 
> Please, when fixing something do fully explain what that thing is.  I,
> for one, simply cannot understand why this change is being proposed.
> 
> Especially when proposing a -stable backport!  Tell readers what was
> the end-user impact of the bug.
> 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1599
> 
> Even that didn't tell me.  Is it just a clang warning?  Does the kernel
> post your private keys on reddit then scribble all over your disk
> drive?  I dunno.

Yup, sorry. I tend to get so deep changes like this that I forget to
give an appropriately detailed summary. As others have mentioned, this
is trying to fix a miscompilation issue, triggered by what can be
considered either a mis-application of __alloc_size, or a failure to
correctly disable compiler optimizations in the face of ksize().

-- 
Kees Cook
