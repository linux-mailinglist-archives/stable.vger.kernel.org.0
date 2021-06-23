Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E003B23A8
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 00:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFWWtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 18:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhFWWtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 18:49:07 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C547C06175F
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 15:46:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x22so1912834pll.11
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 15:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8fAh4y0OB0EQHzmH30AhixLLr6acGSavXwUpuUJpLnM=;
        b=iQSYf2Ji1gQzTW1DUhkt++SYi4wMGXiE/j2gPcKWSSCpt60rrrH8tpnKOQ0TMUyNYd
         bF/8h2JGWRl78uOUwAU/3HQa3U7BSwTxH9J8b6g4Fo3m2YDBcw5UebKn+MuvQnpitYET
         +UtODHFed+1v20RqHIbAOeKryMpu1wbaCfqOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8fAh4y0OB0EQHzmH30AhixLLr6acGSavXwUpuUJpLnM=;
        b=JNAkME0ykyIOnExJTKgFilfdCQE3yd0BXUSL9pMQEXsmOQAg7MurNFMxCJJsvDdN5J
         UO4lEcXcs9ZyaEpyGajkTSnGiwNU6xd9jX1uKKDQbrhlHfomub6VTiSyaokJQUNHpObX
         cht+/AJeuFsDPdgKc1PpPArD81eluI39VC08NJh6DrqdDHy7FYuVKNU3Xt4HRpQNO7un
         VBhG8YuDahJ/wJFAQ6/6wi8ohX2t77h+8FCuJeRBMkjpOmohyttbXHy/omWr1t6oN1tB
         gM04Jwumfwn374si2svlUUNhW3yrjysL7FPvYJsOb0T1qTlEbz1sU6yUNJHtjPm+tjjt
         2XQQ==
X-Gm-Message-State: AOAM533bINZ9CQNGMKfhoboxNuN+1omqG2feaWz7ZRp7N5zzfyQA8JPv
        /YJycvhZO7hkIMr2q6zMf1/+tA==
X-Google-Smtp-Source: ABdhPJzy25leCoGZ4NdFhG2H5wygYPxzyBacPc567UpFgXJlT7k0vpTYbb62nDZiabtSUq35+B9GuA==
X-Received: by 2002:a17:902:fe0a:b029:11d:81c9:3adf with SMTP id g10-20020a170902fe0ab029011d81c93adfmr1559888plj.0.1624488408037;
        Wed, 23 Jun 2021 15:46:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u9sm130456pgp.90.2021.06.23.15.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 15:46:47 -0700 (PDT)
Date:   Wed, 23 Jun 2021 15:46:46 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Guillaume Tucker' <guillaume.tucker@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Message-ID: <202106231231.9B858B95A@keescook>
References: <20210619025834.2505201-1-keescook@chromium.org>
 <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
 <42f26361db6f481e980ac349bf0079ef@AcuMS.aculab.com>
 <202106230917.FE2F587@keescook>
 <76a575d1364a47458d27c76c65b673b6@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76a575d1364a47458d27c76c65b673b6@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 04:27:47PM +0000, David Laight wrote:
> From: Kees Cook
> > Sent: 23 June 2021 17:19
> > 
> > On Wed, Jun 23, 2021 at 01:43:04PM +0000, David Laight wrote:
> > > From: Guillaume Tucker
> > > > Sent: 23 June 2021 13:40
> > > ...
> > > > > diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
> > > > > index bb7a1775307b..0f9f22ac004b 100755
> > > > > --- a/tools/testing/selftests/lkdtm/run.sh
> > > > > +++ b/tools/testing/selftests/lkdtm/run.sh
> > > > > @@ -78,8 +78,9 @@ dmesg > "$DMESG"
> > > > >
> > > > >  # Most shells yell about signals and we're expecting the "cat" process
> > > > >  # to usually be killed by the kernel. So we have to run it in a sub-shell
> > > > > -# and silence errors.
> > > > > -($SHELL -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
> > > > > +# to avoid terminating this script. Leave stderr alone, just in case
> > > > > +# something _else_ happens.
> > > > > +(/bin/sh -c '(echo '"$test"') | cat >'"$TRIGGER") || true
> > >
> > > I was having trouble parsing that command - and I'm good
> > > at shell scripts.
> > > I think the extra subshell the 'echo' is in doesn't help.
> > > In fact, is either subshell needed?
> > > Surely:
> > > /bin/sh -c "echo '$test' | cat >$trigger" || true
> > > will work just as well?
> > 
> > Ah yeah, and I just tested it to double check, it can be even simpler:
> > 
> > echo "$test" | /bin/sh -c "cat >$TRIGGER" || true
> 
> You can probably even do:
> 
> echo "$test" | /bin/sh -c cat >$TRIGGER || true
> 
> (moving the redirect to the outer shell).

Actually, it looks like the "write" is already happening in the exec'd
process, so this can just be:

echo "$test" | cat >$TRIGGER || true

But it still can't be:

echo "$test" >$TRIGGER

which is what I had over-engineered a solution to. :)

-- 
Kees Cook
