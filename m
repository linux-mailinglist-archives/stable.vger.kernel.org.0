Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDDF33C424
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbhCOR2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbhCOR20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 13:28:26 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEC5C06175F
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:28:25 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id r16so5704741pfh.10
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5VwZiNoaOawmugGkW3BliGlJHY74MeBZt4r2sMGeVQQ=;
        b=l7HPfSehLhWpD22iEktgmCx0tfo9/0CXqzTE6AuX6c3/5225P6lXKuk1wJ6XO5mJGB
         j9LyL7+uH01vGynQcMUX/DSW3aPwjvKsnHDabzLeL8nPJ7VF7NQPm1XuwiOMzrWuKnoG
         LqkuIan1qCRQ55XWhGn9uzB0DXbKts3oUufc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5VwZiNoaOawmugGkW3BliGlJHY74MeBZt4r2sMGeVQQ=;
        b=R9VqsleiA8v0V8KIA6d+nJY1l0QVErxQ+HeMl7MopxNqFK+WfZ9eZndk1lh5At1kyc
         qFJ6Sbw/DPjYiFwZgmhJ+muCCwtXGzAlKweLzuV5OPjOPnUNxycn1mFdYS87bHJmnd3y
         5K71BqDxfcx/rEJt9hy2LyVvXMn6zE5YUuzmo8Uj1lWn306wcEnz2eEdnaEEBekn41xL
         RurujKQAKPDVeGABc+A4gKbKGC1mHn6sxO5PfmADreUQjvct4CHEFTl+l8auM8OfQf+I
         qhrf/wssMUqMzmYT23KbnX76lS4Benk5CfjUXb7rC03cXANxefrtUoINHU9191tXCMiB
         uzIw==
X-Gm-Message-State: AOAM533PbdW2BA1tL9Yz2iOGPXiVxSCX+7uAJuQ1leWe9Jshw5k/zuAM
        pT1wo+jpWiy+jnx0VmrTRQouwA==
X-Google-Smtp-Source: ABdhPJxjnHWrPSehNTyXbsunhO6js/f/y7LcLoTrzXtGC7Of1Nx7WsQ3+07t7nraq6yi5lTJdFnVmQ==
X-Received: by 2002:a62:3847:0:b029:202:ad05:4476 with SMTP id f68-20020a6238470000b0290202ad054476mr10941066pfa.67.1615829305471;
        Mon, 15 Mar 2021 10:28:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n9sm205492pjq.38.2021.03.15.10.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:28:24 -0700 (PDT)
Date:   Mon, 15 Mar 2021 10:28:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jann Horn <jannh@google.com>,
        kernel-hardening@lists.openwall.com,
        linux-hardening@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 1/7] mm: Restore init_on_* static branch defaults
Message-ID: <202103151027.88B63D0@keescook>
References: <20210309214301.678739-1-keescook@chromium.org>
 <20210309214301.678739-2-keescook@chromium.org>
 <20210310155602.e005171dbecbc0be442f8aad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310155602.e005171dbecbc0be442f8aad@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 03:56:02PM -0800, Andrew Morton wrote:
> On Tue,  9 Mar 2021 13:42:55 -0800 Kees Cook <keescook@chromium.org> wrote:
> 
> > Choosing the initial state of static branches changes the assembly layout
> > (if the condition is expected to be likely, inline, or unlikely, out of
> > line via a jump). The _TRUE/_FALSE defines for CONFIG_INIT_ON_*_DEFAULT_ON
> > were accidentally removed. These need to stay so that the CONFIG controls
> > the pessimization of the resulting static branch NOP/JMP locations.
> 
> Changelog doesn't really explain why anyone would want to apply this
> patch.  This is especially important for -stable patches.
> 
> IOW, what is the user visible effect of the bug?

Yeah, that's a good point, and in writing more details I decided this
wasn't actually worth a stable patch, and should just get folded into
later patches.

Thanks for the sanity-check!

-- 
Kees Cook
