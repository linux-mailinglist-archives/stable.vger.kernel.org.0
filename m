Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21B228C2CF
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 22:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgJLUnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 16:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgJLUnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 16:43:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777FBC0613D2
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 13:43:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w11so1583841pll.8
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 13:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A6mr2GZ0DBJINQQpjmdYC2+OXujmO1pjxp1POyMlL2Y=;
        b=nkPnEYk/TLpBpiZhbw9Co0vkESAqfDQdMLbvHaLr/5IjpIdqevfPju7kohqgEo7ksk
         j9P4eHXHwHse0/oE9MbGn0/vvREbCk0OI8mhvlDRWvcZK/YTrWdc7u0RFoY/0Xiq7owD
         nfZ04P9MBRZDiskcE9fB7lgt/sSthpVDBiOtE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A6mr2GZ0DBJINQQpjmdYC2+OXujmO1pjxp1POyMlL2Y=;
        b=ul8HOXUcA1ZyQxuhAZEb+W1yt52Cv9X3gB5Sis3wH8F4Nxo79wpxnW7a1jZCqXtlSr
         ufL4/nGMTvVes8Xh/xJPCw9HC6g7pxV68Ri5cheOeVo/thsG1fIKYA6R/66XZpv3aOGb
         06zM8gtZLMpIbiAsCKk9rB+sQM27KVsfBr7Bw98T2iUkqlkJQ39dOn0gdtJT3EG6yECF
         /h7C7w8fj8zq3pcC8x9y3Zxi9Fua8HLLqsczBCpG9w4Bfuwj9wiQolSs+DHcXQdYGM75
         lOfTf3vsf2DnE2utqvHT31ugXQ5qv476Cobej6OTlu5P6TjaVzj3D9MH2u1ZjpoQklsG
         aonA==
X-Gm-Message-State: AOAM531oKXCA9LK2VbELA3VgCs/CyNz7UH4f/V3SVxVXpiywnKZ8UyUr
        eSiBo48fMFJDk5FrSUxGY1gJbg==
X-Google-Smtp-Source: ABdhPJy1Hfs3WCk1tNDDRBB108LnSHEMkiQWQrCzfTBIswhUfzDcCcfAA0yjxRQniPbRDHSo0ZL6TQ==
X-Received: by 2002:a17:902:8f82:b029:d4:bf4f:13da with SMTP id z2-20020a1709028f82b02900d4bf4f13damr16441277plo.40.1602535412935;
        Mon, 12 Oct 2020 13:43:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w5sm21123501pgf.61.2020.10.12.13.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 13:43:32 -0700 (PDT)
Date:   Mon, 12 Oct 2020 13:43:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christopher Lameter <cl@linux.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        Marco Elver <elver@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] mm/slub: Fix redzoning for small allocations
Message-ID: <202010121342.836D3C26CF@keescook>
References: <20201009195411.4018141-1-keescook@chromium.org>
 <20201009195411.4018141-3-keescook@chromium.org>
 <alpine.DEB.2.22.394.2010120754010.150059@www.lameter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2010120754010.150059@www.lameter.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 08:01:04AM +0000, Christopher Lameter wrote:
> On Fri, 9 Oct 2020, Kees Cook wrote:
> 
> > Store the freelist pointer out of line when object_size is smaller than
> > sizeof(void *) and redzoning is enabled.
> >
> > (Note that no caches with such a size are known to exist in the kernel
> > currently.)
> 
> Ummm... The smallest allowable cache size is sizeof(void *) as I recall.
> 
> 
> mm/slab_common.c::kmem_sanity_check() checks the sizes when caches are
> created.

Ah thank you! Yes, I really thought there was a place where that
happened, but I missed it. This patch can be dropped.

-- 
Kees Cook
