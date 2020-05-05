Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8291C5698
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgEENTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 09:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbgEENTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 09:19:18 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674F2C061A0F;
        Tue,  5 May 2020 06:19:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r4so1019107pgg.4;
        Tue, 05 May 2020 06:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nP+h9rY3+UG7ZYxe1kNna18+qrm6TYtkYOmTToZPCDE=;
        b=nfvbpWwH9vuDUkcdFjxQdJU0pMZPtshr09ot9N82zDb4eOMMsz6BXTIi7HSLwc1ks/
         IIJxEgb/TGiMlhHoPRE+MvOVJ5fX2OQnFUhD0rzVH0pJMqfk9apjvmjjX89ZgAplApLO
         jWgHhatAid0eNGJHm4QhfyHrZfeEgDY6MpKmYHWz4jXSIsLWYGw8JG95JTDDUHh7/JT8
         klXw5qoGl9c9bbC7kQB5sWU56B9JtPXf5hhDFcdDLqIAUPM39+EYWUDY4IdHdPjX30fV
         AgFvYcDSNlP2DUNM2xJ1NR+wboxqohxovk9dkiBY7wfoyl9E/nD+uffjXxaJvfqR9h2M
         pgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nP+h9rY3+UG7ZYxe1kNna18+qrm6TYtkYOmTToZPCDE=;
        b=hxEG9go9wSa6zc59EY89ajxr3aUY3iHmr0NnkuacHktqvMIGSnU5W2+k5UM7SxJRde
         tiHRF8e4XgwGay7b4CpARbH9AEV4s9Gx14ATvXtwCsvOHUbs/VTeP9p42sZXpVMqhLGn
         YPFF5C7jGrWnuo3bhHkM/4q4WhgFnEuvzXsdGorlHeeHZ8My+b3cNbbePQGYrEFB+0Hh
         jD9IUXQ6V+JhNZ2tWTohBVF9IGJo8R1Rly63uU3nO4kBL4HxU4ovbaoV5Z0zDQG3qo2u
         7noypvLh3n4FZs/U2M4R1lNj+mLMvR5apGeB0hvFIYg380P4HGzgBr8Q+XqsfvXAAVU/
         lCTA==
X-Gm-Message-State: AGi0PubfSo/L1OWw/oLLjwv+oWV9qZfL7NlciQuFZwivNsShxHEMpAwn
        rSD3D7QLZIobAXlWnm/XJ65Dlu45SBxTIm2RzCfGZ3VI
X-Google-Smtp-Source: APiQypL8Bm0VqoCM4pLnLqGVc88hkFYgTJ4LK51MTY1l2+cMHuLiSHywjAV9S5SjtU06WA1ltRKVmh1oVoTrNfiiCgc=
X-Received: by 2002:a62:5ec7:: with SMTP id s190mr3045321pfb.130.1588684757877;
 Tue, 05 May 2020 06:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165448.264746645@linuxfoundation.org> <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd> <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
 <20200505125818.GA31126@amd>
In-Reply-To: <20200505125818.GA31126@amd>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 5 May 2020 16:19:11 +0300
Message-ID: <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 28/37] dmaengine: dmatest: Fix iteration non-stop logic
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 5, 2020 at 3:58 PM Pavel Machek <pavel@denx.de> wrote:
> On Tue 2020-05-05 15:51:16, Andy Shevchenko wrote:
> > On Tue, May 5, 2020 at 3:37 PM Pavel Machek <pavel@denx.de> wrote:
> > > > So, to the point, the conditional of checking the thread to be stopped being
> > > > first part of conjunction logic prevents to check iterations. Thus, we have to
> > > > always check both conditions to be able to stop after given
> > > > iterations.
> > >
> > > I ... don't understand. AFAICT the code is equivalent. Both && and ||
> > > operators permit "short" execution... but second part of expression
> > > has no sideeffects, so...
> >
> > ..
> >
> > > You are changing !a & !b into !(a | b). But that's equivalent
> > > expression. I hate to admit, but I had to draw truth table to prove
> > > that.
> ...
> > > What am I missing?
> >
> > Basic stuff. Compiler doesn't consider second part of conjunction when
> > first one (see operator precedence) is already false, so, it means:
> >
> > a & b
> > 0   x -> false
> > 1   0 -> false
> > 1   1 -> true
> >
> > x is not being considered at all. So, logically it's equivalent,
> > run-time it's not.
>
> Yeah, I pointed that out above. Both && and || permit short
> execution. But that does not matter, as neither "params->iterations"
> nor "total_tests >= params->iterations" have side effects.
>
> Where is the runtime difference?

We have to check *both* conditions. If we don't check iterations, we
just wait indefinitely until somebody tells us to stop.
Everything in the commit message and mentioned there commit IDs which
you may check.

> -       while (!kthread_should_stop()
> -              && !(params->iterations && total_tests >=
> -              params->iterations)) {
> +       while (!(kthread_should_stop() ||
> +              (params->iterations && total_tests >= params->iterations))) {

-- 
With Best Regards,
Andy Shevchenko
