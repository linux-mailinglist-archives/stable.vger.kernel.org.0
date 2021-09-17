Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B0D40F34F
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 09:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbhIQHdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 03:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230393AbhIQHdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 03:33:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB3660F51;
        Fri, 17 Sep 2021 07:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631863910;
        bh=HeuwKG3mbLHpdTH2uLeOlk6tLRJ0UBKEWNQbjKU9BEg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RyryCH3jgYDsY0Z/Ff4gdHiuMpqWW1ISx2ss2GqaQcuJm6tcbaUn2I4a2/9VRfpgS
         fJmogclEQD5wt8Vo2gwJ0ub5J4JXTH36YVAhUpV0ykFXR+BC8/uyaVcDcZC6Ns2KMX
         LpZusTcjjdJuvi87mjoZjPLF5Cw0HSdJKeU5X/vng4xiLfpSIOwQ1SaslO323iW/hZ
         BQJePqMZfCm47ZWCwfL1fWq+0TgCSn+2RkCIZbOfJ99swX7l/neLyfZrd8wv+3gCOg
         IgCiHJqbz2SKUmYGCjf8m6OOXKa9fqpvTroh1jWsT2kaGWsJtn/EjCmKS8tPUWop0d
         LozB5Z0I0SiYg==
Received: by mail-wm1-f41.google.com with SMTP id l18-20020a05600c4f1200b002f8cf606262so9199443wmq.1;
        Fri, 17 Sep 2021 00:31:50 -0700 (PDT)
X-Gm-Message-State: AOAM531aOrzZdCHmJuxeFGTaZ5B5qvRc41Ge/ibCZbSFNJCZi1geouzf
        0C7BYScmtOm+LhYBGtc3VKNcJmwXHe08Eou0wvA=
X-Google-Smtp-Source: ABdhPJyLRrkiTmVn9bZjnB6MDne5Z8kY9IKmsD4U7+1GSy0GiJb/cXr5E88hrEplypUjuPQzFlWTVPOiAQQqeTeGvD4=
X-Received: by 2002:a05:600c:896:: with SMTP id l22mr13581876wmp.173.1631863909527;
 Fri, 17 Sep 2021 00:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com> <874kak9moe.ffs@tglx>
In-Reply-To: <874kak9moe.ffs@tglx>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 17 Sep 2021 09:31:33 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0mAOgo_7xVfHr2YfeKa8xQPH6GfafB96NPvFAnQF_LBg@mail.gmail.com>
Message-ID: <CAK8P3a0mAOgo_7xVfHr2YfeKa8xQPH6GfafB96NPvFAnQF_LBg@mail.gmail.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in timespec64_to_ns()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 12:32 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, Sep 15 2021 at 21:00, Arnd Bergmann wrote:
>
> I have done the analysis. setitimer() does not have any problem with
> that simply because it already checks at the call site that the seconds
> value is > 0 and so do all the other user visible interfaces. See
> get_itimerval() ...

Right, I now came to the same conclusion after taking a closer look,
see my reply from yesterday.

> Granted  that the kernel internal interfaces do not have those checks,
> but they already have other safety nets in place to prevent this and I
> could not identify any callsite which has trouble with that change.
>
> If I failed to spot one then what the heck is the problem? It was broken
> before that change already!

My bad for the unfortunate timing. When only saw the patch when Greg
posted it during the stable review and wasn't completely sure about it
at the time, so I was hoping that he could just hold off until you had a chance
to reply either saying that you had already checked this case or that it
was dangerous, but now it's already reverted.

I agree we should put back the fix into all stable kernels.

        Arnd
