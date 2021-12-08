Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A73A46D8F8
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 17:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbhLHQ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 11:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbhLHQ5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 11:57:52 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9094DC0617A2
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 08:54:20 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q16so2531445pgq.10
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 08:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wDsVhbUZQwon98TZc0uQWii9L9HtueN7zt3xozWU+o0=;
        b=qjKkcDy2Vnd99F+FcvoO1bC64kXXPcSt3EJIU+wYN4wrB3WKm+GgpQkRK8vgG4EyIP
         yEmXVWLQikSBg2dl3KZBUVIO21pKCDAL5+UQcr/qWb8OA/qHpthYaB0XLGbQbVpSjdRd
         1w8aSVUXoZ9N/w2CCkBzUFjOi21cIX7FhfwEcc+0AFCTNu+XCFz29xYyQDRNWEI0UeOq
         XqLrgs12InSPFGTplPogvsmGvPMtB2wrVCg2Jd9H4ieohL+3kkioqBbLXbluWuW/sHMJ
         36Ex+MxfgiTF+1zUstFYEUZi+55M56v4UMTV4U8oV/cYOlOYYOW5nQz9JbJICVp6wGII
         Wylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wDsVhbUZQwon98TZc0uQWii9L9HtueN7zt3xozWU+o0=;
        b=il8DkBWYv9o5q4sWO1pBkZ0F65qITOKrlh9nEp3JyDTmcgf1Rb9fZ5IYMFhTIZSiKQ
         w2QRyxOwd6zkLHRaG3BIXeafQFC8xvxWrXttWAqjX48+lWMsa/LrvxaP/I2vjghZjuXL
         GfnAFhxf4jA8AvDZei3JvuA4mUeGlFU3oltgSQIQrzrBzpeB5QCT99bgzD97smamMelf
         YNriuDt1lsHXR9Vr+jVK7auKn4j3eSE6pFQABrKQbSIyvmTCQjIu4wCBMERs76SdaUbU
         xd+dt3qeNFe815UweP0NrsnSiDZRyxseP9a5jV/xybJ3fxSkIbpmcw9FXlsQxfxSQcvL
         E7mg==
X-Gm-Message-State: AOAM532FHfuVtCcLod+4wKcHQQek41KeI6qKB9V6yYs0DFdvTe3NRDio
        0gsbqvPKcJv07keXjlIWwdacw7ONgITTgg==
X-Google-Smtp-Source: ABdhPJxE3wYM+bIKVuUEjBr3ldRIzan4Rc3pmkStEhIojWk4Ag4lA1gCH7zbcEfstO/sqqo2+3iiiA==
X-Received: by 2002:a05:6a00:a14:b0:4a0:945:16fa with SMTP id p20-20020a056a000a1400b004a0094516famr6527927pfh.9.1638982459816;
        Wed, 08 Dec 2021 08:54:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f3sm3090411pgv.51.2021.12.08.08.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:54:19 -0800 (PST)
Date:   Wed, 8 Dec 2021 16:54:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] selftests: KVM: avoid failures due to reserved
 HyperTransport region
Message-ID: <YbDjN68ALDavh1WQ@google.com>
References: <20210805105423.412878-1-pbonzini@redhat.com>
 <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
 <5f3c13be-f65d-1793-bd91-7491d3e149b0@redhat.com>
 <bab67d1c-f9b7-0a91-2d4f-9881e3f47218@oracle.com>
 <ac72b77c-f633-923b-8019-69347db706be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac72b77c-f633-923b-8019-69347db706be@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021, Paolo Bonzini wrote:
> So this HyperTransport region is not related to this issue, but the errata
> does point out that FFFD_0000_0000h and upwards is special in guests.
> 
> The Xen folks also had to deal with it only a couple months ago
> (https://yhbt.net/lore/all/1eb16baa-6b1b-3b18-c712-4459bd83e1aa@citrix.com/):
> 
>   From "Open-Source Register Reference for AMD Family 17h Processors (PUB)":
>   https://developer.amd.com/wp-content/resources/56255_3_03.PDF
> 
>   "The processor defines a reserved memory address region starting at
>   FFFD_0000_0000h and extending up to FFFF_FFFF_FFFFh."
> 
>   It's still doesn't say that it's at the top of physical address space
>   although I understand that's how it's now implemented. The official
>   document doesn't confirm it will move along with physical address space
>   extension.
> 
>   [...]
> 
>   1) On parts with <40 bits, its fully hidden from software
>   2) Before Fam17h, it was always 12G just below 1T, even if there was
>   more RAM above this location
>   3) On Fam17h and later, it is variable based on SME, and is either
>   just below 2^48 (no encryption) or 2^43 (encryption)
> 
> > It's interesting that fn8000_000A EDX[28] is part of the reserved bits from
> > that CPUID leaf.
> 
> It's only been defined after AMD deemed that the errata was not fixable in
> current generation processors); it's X86_FEATURE_SVME_ADDR_CHK now.
> 
> I'll update the patch based on the findings from the Xen team.

So, about that update... :-)
