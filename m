Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9454A455193
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 01:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbhKRATx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 19:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241842AbhKRATv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 19:19:51 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D34C061764
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 16:16:52 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 200so3718824pga.1
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 16:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mT8YaEHx8aR9bEQOqvPUpWSDaz0H+2J/U1fky6P/mpI=;
        b=WuXJ0TAfIQpqY8KNeHmrvwYCqXsQxa+174sW+at3C4dchvdaiHm3TArb/LjsOdZAu1
         zu3DYGPFAMHvsMgxk+GC5ACI+kKYuipsrxRoy+I6JtQvxdR0nCrB6cnM7/cEAxWT0i9c
         mWrRaUisiFK6YSAZxn8KMx8khL5V6WgbFgHqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mT8YaEHx8aR9bEQOqvPUpWSDaz0H+2J/U1fky6P/mpI=;
        b=sbojNS8NeYjBSkzkKkvgGHrnn2P2jIXZ5wifd5y/FvZO61slaZh0wxY0mbjEKJmIFO
         fWcJqatwXDRqyv+HCXcYyEXUxr2SFDEwB5dRkTlga426wz+R1jySYuqJGXo9l1iNSHMn
         VrboBYhZqBmsL3RfKrQYJ2lCKnKAQMEuCZmYZpA/iF+Rki3VtJL1Lsiupmm2YWWjmfUa
         lA9MNf2rVzJRLLkLyBJhPmFZeJ2PfSNZ0JCAiw3GXLkVCdZ8w/t6L7nfKuqRTHbjGLsz
         91g+H+yGGCR9MxT/lbpUniWpfjWjlLAP0BUE3LFxmb98BIhrh0p1st+TnwLg/tBaway0
         h3Mg==
X-Gm-Message-State: AOAM532DspCZwY4YRmvubmPyMQ4cZlkLD7uStgy4anGKxSP82wv7C2Mo
        7nLzslIxcoA8p8y5lTOyPAWXI83Ldb3Y3Q==
X-Google-Smtp-Source: ABdhPJxmzHvh0AnOZkLtQXcHI3QpGC2XdqTEyuN3I0cMzzgNV8uikqXh0F+MlOZrnQ4SyTSFSksfGw==
X-Received: by 2002:aa7:8204:0:b0:494:68ea:ea89 with SMTP id k4-20020aa78204000000b0049468eaea89mr52431398pfi.74.1637194612142;
        Wed, 17 Nov 2021 16:16:52 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e11sm700992pjl.20.2021.11.17.16.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 16:16:51 -0800 (PST)
Date:   Wed, 17 Nov 2021 16:16:51 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Wang Yugui <wangyugui@e16-tech.com>,
        =?iso-8859-1?Q?Fran=E7ois?= Guerraz <kubrick@fgv6.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <202111171609.56F12BD@keescook>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> Sorry for top-posting and quoting this all, but the actual people
> involved with the wchan changes don't seem to be on the participant
> list.

Adding more folks from a private report and
https://bugzilla.kernel.org/show_bug.cgi?id=215031

and for the new people, here's a lore link for this thread:
https://lore.kernel.org/stable/YZV02RCRVHIa144u@fedora64.linuxtx.org/


FWIW, earlier bisection pointed to the stable backport of
5d1ceb3969b6b2e47e2df6d17790a7c5a20fcbb4 being the primary culprit.
At first glance it seems to me that the problem with -stable is that an
unvetted subset of the wchan refactoring series landed in -stable.

-Kees

-- 
Kees Cook
