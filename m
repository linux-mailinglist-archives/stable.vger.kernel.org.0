Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD4D46F70A
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhLIWwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbhLIWwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 17:52:39 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB58C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 14:49:05 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so8098220pja.1
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 14:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5fONBaGbybKzue2XLxxX2YbOEZ4qd2Ct4y/vd2xLsnE=;
        b=InhMOjllI4DbnszQLY3xVQ63doFnaeoe0Q/+sKFoJb6vsdHj2GcIhSFj6g05tFu/js
         CGAyzFz9fXv6NxqgGFDG+M3Ql+LmiUZ6jCgc0+6htVkFZAs/teRW+U0AGBPP7/ZvMStU
         Q6xE1KdLmHcyr5umpNYjBsHuuWuZMeua6B9t7HfBwfq9QmPeVKeo3GxKZYzdyzO2PoDV
         S8iF/xz7XXCGwLbe6lQ1OEx7KzeAdDyDrLHv2bq4ym48nw0uAYJoDf9TYaTKde6dSFe2
         Z0mtunH5c/9ngALvatt79/Sm9dk4yIFXqMyPaIJDfFYaewLnP4H6q9mCtF+KPsqhV9tV
         qOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5fONBaGbybKzue2XLxxX2YbOEZ4qd2Ct4y/vd2xLsnE=;
        b=DXmfBQGIeXB0hA2Bu52YY6+PzP65c9E5AJrxgyc9pyKW6hCnAaUP7W4UtX7dKI7Fa4
         eQhfLDaiay0/NaGrgL0YLgmjJ0gKdeCb3JaeyuZkZLJBMisrpsLYSnXqVqp4zHSU7Mbh
         rgJmITzNlMyP9TowZMWTXF0opWJwQklGUopYTsiMQmBZQtXn8U2jR93iZ9jvuzqCEYss
         QnU13R5nXJ1ri6g785Vd6/6knPFDEoGO7gpr4mC71CmPJFxn0jKpSC0W+hji9FrbOnkd
         X4fCa1r/DBYtOpx2ujrfO69JsZ2Q7oRMXR8PnmMM5b2RMMLQtM8rxM1tzxaV8tpUkpnM
         DPSw==
X-Gm-Message-State: AOAM531qyNLfCYvnyLWDChby5CHpNE5u672/bsAWWYCP//fc7kzqTsaJ
        An3ms/bOAbCaRTwF9PuosP8RxKNKF4MvKQ==
X-Google-Smtp-Source: ABdhPJwKOBdQgmR0CbWd5XTq4kCFuXtH1gjwpkBUNWr7EWTF2jPt74NBwDwk8HZtKlquvjizNA1qyQ==
X-Received: by 2002:a17:90a:3045:: with SMTP id q5mr19144057pjl.58.1639090145183;
        Thu, 09 Dec 2021 14:49:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z2sm721429pfh.188.2021.12.09.14.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 14:49:04 -0800 (PST)
Date:   Thu, 9 Dec 2021 22:49:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3] selftests: KVM: avoid failures due to reserved
 HyperTransport region
Message-ID: <YbKH3aMQ9R+fgFFG@google.com>
References: <20211209223040.304355-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209223040.304355-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021, Paolo Bonzini wrote:
> AMD proceessors define an address range that is reserved by HyperTransport
> and causes a failure if used for guest physical addresses.  Avoid
> selftests failures by reserving those guest physical addresses; the
> rules are:
> 
> - On parts with <40 bits, its fully hidden from software.
> 
> - Before Fam17h, it was always 12G just below 1T, even if there was more
> RAM above this location.  In this case we just not use any RAM above 1T.
> 
> - On Fam17h and later, it is variable based on SME, and is either just
> below 2^48 (no encryption) or 2^43 (encryption).
> 
> Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
> Cc: stable@vger.kernel.org
> Cc: David Matlack <dmatlack@google.com>
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20210805105423.412878-1-pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>

> +	/*
> +	 * Otherwise it's at the top of the physical address
> +	 * space, possibly reduced due to SME by bits 11:6 of
> +	 * CPUID[0x8000001f].EBX.  Use the old conservative
> +	 * value if MAXPHYADDR is not enumerated.

It'd be nice to run these out to 80 chars when you apply.
