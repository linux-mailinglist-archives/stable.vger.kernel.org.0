Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC8240B5F0
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhINRdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 13:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhINRdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 13:33:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E45C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:32:20 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m21-20020a17090a859500b00197688449c4so165949pjn.0
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lGQPOZkcxJYyUXUleLi9Zwk719LVyNjgeAiv8SMK7EE=;
        b=MCnQbCloxmeH7Hw7Xng3chEP0PXsPdGJFyPolDTBZOFtYBLVl3Y19PN507MI2tw2q4
         fGB9Ma01HNQn24yoOZPO87ldIbLaa1Rahjv0ppulJbCAHGk4dDRVkRkhNNDAJwi6bax+
         VvbG7uXCYofa8AXh/uXKje4EvdUWuqAyA8rOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lGQPOZkcxJYyUXUleLi9Zwk719LVyNjgeAiv8SMK7EE=;
        b=uJiVKuG77DwHfI+qRAl5DzzKPhSFpvgUUn2pKXMXV8N7mEBcBOZXC1Fuo+6kLOpZrU
         mo9geRokUH0dt80HyCTvP3oUvEQOaHJt39zjlyMY1nl2U3rPpBH0iuiECB66EcJw4agx
         MGI8jEjeuNem0Z+KTGglaxYw6WbeLk37cS0nTXE8EaUnNqCWDCL1s0pu21yAHZ2fy4D5
         A9kwMH3PsWjzZ6po36/+iLcHaB8E3SA0o3KkJ7AJv9mJIAsANC9MehXsRLIlbqRw2GZ6
         g61LObeqWlqa3SizFySNf7u6D95dkNTleckcJEEs9AOPM5hK5xQmAPjZZVOhSk/Jxt2v
         qo2Q==
X-Gm-Message-State: AOAM5300YzQ1YjRzJ4eFRC1Tsf40yPJ+JxVicV1Qh3UMACVV5UyC7FX6
        eFcGo2P89fkuQfM+qjicvaDKfQ==
X-Google-Smtp-Source: ABdhPJy+CJJXqJenCMdB2jSxidWRwjfrmOvpTyDwbr7lf4YslWGbm1jb8PmddKQejVO8HL20rilq1w==
X-Received: by 2002:a17:902:760b:b0:13b:122:5ff0 with SMTP id k11-20020a170902760b00b0013b01225ff0mr15825064pll.22.1631640740042;
        Tue, 14 Sep 2021 10:32:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x22sm10994631pfm.102.2021.09.14.10.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 10:32:19 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:32:18 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
Message-ID: <202109141031.AEFD06F03F@keescook>
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 11:05:02PM +0200, Rasmus Villemoes wrote:
> So, I'd sleep a little better if we got the 64 bit tests commented back
> in in test_overflow.c, and [assuming that the above would actually make
> that file build with gcc 4.9] that patch also backported to 5.10, so we
> had some confidence that the whole house of cards is actually solid.

Yeah, I'm all for that too.

-- 
Kees Cook
