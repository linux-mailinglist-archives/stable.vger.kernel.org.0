Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8FD1C55EF
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 14:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgEEMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 08:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbgEEMvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 08:51:23 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3F5C061A0F;
        Tue,  5 May 2020 05:51:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so820400pfc.12;
        Tue, 05 May 2020 05:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lSfeT63MC/gs3V+g1CjQ0JOSRIqBRdXdQHMgMPX1u4E=;
        b=aFdRPSi7EEU10wxMF5PfN/eJElVbBvzS1f6B69dZIo6lelKZ7OdpoGg90JJgBsUSbo
         QCwQqE+AA7qC+Z511hfqeDmKvUUPdCiHcrCCJFYamVBTzHu/PVxgDsepmd1nITWTQY1U
         8UkN+5nxDye81BI/2hist7rlsro/5c2L4RPzfuv/C+FjtR7B1cQZ3L8+rA4qw0cnMNqH
         2jsBDrzWPCnE/hctB+qzeEAUPv86dj73UA6lFxSE8+WKALD8nyFxHmvyBcv0zgLbi5U9
         czvBr5kNYcKFUySotaVYevmNo50NM+NbuqHlG55xvjkWBpGPDcsFL6GkXPpkjF/H/2Nv
         2yEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lSfeT63MC/gs3V+g1CjQ0JOSRIqBRdXdQHMgMPX1u4E=;
        b=JtjfeamI53fDZVALnn52hbkR9238Bwt9+SmEJ/o+0l854FvdRuxIgg0JIX6lvBWFxt
         J7MlQc8H1QpJAI3yg8jTAoO2vhOyUaTdimQ+EJZHz1GEdjU0qCK9pDejyOBVBPzApjGG
         TyqtD61Dh3L/tMs3h5Jpp5Vm2xZ7ZOzmDQfWTI+Gxut8Tk83pUpCM+zmbIzLJgVh7fap
         nKmu3VAvzMb+VsxXtucrac/fWNGWC+1T6HVZQ9yu4ZmheojTpgkAk+MRBoKOPN1q8qA3
         fsL6a5rxiN8QviDsf/Csv3IL/w1E1DHZF9pK3EjNgWLo4xbQhDLMvnGDVC3teVPH0imW
         FdAg==
X-Gm-Message-State: AGi0PuY8SnJFKEDtCSMKv985/GRJLKD6G/m97ebMGgsp25EwPrwmBELW
        pK0osN7Lu39tE79vmrvArpY+5yyGNdANo46ol48=
X-Google-Smtp-Source: APiQypLelTCwQ+rUAENh5dyXbbhD2unEnP5i1gqdrM5NFBPB3WEZEwRZM0CjzwTAQBrflXmBfS7bWQCGzaPDu1m2hTI=
X-Received: by 2002:a65:6251:: with SMTP id q17mr2764353pgv.4.1588683082822;
 Tue, 05 May 2020 05:51:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165448.264746645@linuxfoundation.org> <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd>
In-Reply-To: <20200505123159.GC28722@amd>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 5 May 2020 15:51:16 +0300
Message-ID: <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
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

On Tue, May 5, 2020 at 3:37 PM Pavel Machek <pavel@denx.de> wrote:
> > So, to the point, the conditional of checking the thread to be stopped being
> > first part of conjunction logic prevents to check iterations. Thus, we have to
> > always check both conditions to be able to stop after given
> > iterations.
>
> I ... don't understand. AFAICT the code is equivalent. Both && and ||
> operators permit "short" execution... but second part of expression
> has no sideeffects, so...

..

> You are changing !a & !b into !(a | b). But that's equivalent
> expression. I hate to admit, but I had to draw truth table to prove
> that.
>
> !a & !b   0 0 -> 1
>           else -> 0
>
> !(a | b)  0 0 -> 1
>            else -> 0
>
> What am I missing?

Basic stuff. Compiler doesn't consider second part of conjunction when
first one (see operator precedence) is already false, so, it means:

a & b
0   x -> false
1   0 -> false
1   1 -> true

x is not being considered at all. So, logically it's equivalent,
run-time it's not.

-- 
With Best Regards,
Andy Shevchenko
