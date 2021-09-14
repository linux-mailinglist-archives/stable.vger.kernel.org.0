Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AFA40B724
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhINStT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhINStS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:49:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE699C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:48:00 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q22so275864pfu.0
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u4/hZa5X5iiSrh9aM4nYzcLFV48vDhJpzjaofNxmELM=;
        b=kSvmUyBn95LRNcM6llDwG3+F1VjOFofJWmaLRoyYvU7KNVN9l1Iz9OnfHYkKJD0Hi3
         CeJMoI5ctnU4Eba9OSWo+Phxe4/M/L+6RCYSi+YbNYGMEQBESgR1WFZMdoQ0QtrjvL8s
         DAbA37Pk5B9BaRHzasmS4ixeYYG7w5I4N3bs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4/hZa5X5iiSrh9aM4nYzcLFV48vDhJpzjaofNxmELM=;
        b=OT7mHU2OXTdiYtN0LuaHaqLKianykygwkDuqDRVs6DsNsMWjtuafhM0WOFyYVzPrsF
         kGqnL2rvpYtvlsfvYSCrekf3D84mPkMJM45OV9q7kHZdzJhvL7EJ0MmowGiRaXex16C7
         z6S8B/Ihb/M4lpSb21bs7/mUERcZaklbMY5QagiLd4D8SDfAxlb4ATNuTAihphAf91bX
         xm/NaozECmD1LYewVFcV+hYf/3zgeJy7eOszN7JDbMn19yiVmFjwVRt7ew8QgFBPnss1
         VlvyqlvMw3E+9F5BDOumBO7gHv9ACdpdSriMitny0tc79b+RLfNgDuRyEE/GZSc6zFxH
         PYSw==
X-Gm-Message-State: AOAM532oPUbbbcsnTjlh21DMiRgeY9pn5KrpglZzXxDCZl5/Ez3LGZ7t
        mGCkMNGbngNcBF7rtcv5G3lTZPVSS9My7w==
X-Google-Smtp-Source: ABdhPJxqbjG40g/47sryBDttm98oA7oQ4YOMO2XbIxC6H1EYNMN/YQ+DyO1bMFlOyEBbn2QKfqFtfQ==
X-Received: by 2002:a05:6a00:170d:b0:3f3:bcdb:4883 with SMTP id h13-20020a056a00170d00b003f3bcdb4883mr6284406pfc.68.1631645280482;
        Tue, 14 Sep 2021 11:48:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k190sm11477706pfd.211.2021.09.14.11.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 11:47:59 -0700 (PDT)
Date:   Tue, 14 Sep 2021 11:47:58 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
Message-ID: <202109141144.1AE2DDB@keescook>
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
 <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 11:30:03AM -0700, Linus Torvalds wrote:
>  	case NBD_SET_SIZE_BLOCKS:
> -		if (check_mul_overflow((loff_t)arg, config->blksize, &bytesize))
> +		bytesize = arg << config->blksize_bits;
> +		if (bytesize >> config->blksize_bits != arg)
>  			return -EINVAL;

FWIW, it's probably better to avoid open-coding the check. There are
helpers for shift-left too. :)

+		if (check_shl_overflow(arg, config->blksize_bits, &bytesize))

-- 
Kees Cook
