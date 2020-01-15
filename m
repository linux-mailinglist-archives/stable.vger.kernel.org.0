Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015D013CD6F
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 20:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgAOTuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 14:50:02 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33049 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAOTuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 14:50:02 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so19949349lji.0
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 11:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5YJji0qsgvZEhJKmEybkUMk9F7tRfYQ2btF70jS2bQ=;
        b=Q3dtBuyAAYaVR6kphmaXQdQwAqXGs7+IXkxkA97uPulSCLsjbwLbDIpcd20aDV8CNF
         h6zeg+gwF07nqSczDspewMKk/CFEcITv26d5UJTH0S6cCJwGyeQ1fLw049up9t2GG2tL
         F/iGyp8+dSJcV2e9mBFerylantrs7S6j5879U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5YJji0qsgvZEhJKmEybkUMk9F7tRfYQ2btF70jS2bQ=;
        b=Ijn6gpl8N66kGcgEVmR47gt1IYbbNZ9P36IOU7xX5mU1/7aiL2T+paDmxNxJaOBT4z
         nvzsJJzfzPrKqhOOaqf4u0hIfLeEBBOTeNPI69h8f+yKzD/x7Pt9nhZwUxjnz94KEWDP
         sJ7cxxFjRS/+eQoAXVp+dF9stU4H6bgKn/ZjqXIV0XnZ/wz+PEeEmq/CbOYTGO49q/9A
         03FnGueE5ROFB/gn7WI2TnjlRsAL9MxpoOyGYD2eTpGk5znafnfx2YCeyv/7M6Ep9/Tf
         Nw50xw7WLXx0Yep1U2kbDgHO08RsFHDe+LddblnW65ENsCJjFm/BzSgMewtK6Uzfifgu
         oB5Q==
X-Gm-Message-State: APjAAAUQ1z4iVTbIlrIUhWaveLyXXihBE4YJWEdvo29ekHX8uYhFtveW
        cNu3IhEV8HuRJq8eMx3KFo/ACh2p4NM=
X-Google-Smtp-Source: APXvYqypQwyPSGWiKtPPqpoE26/Tn8rTBX78BiloKSv3f7aLcblT+x4OQwHz+1vp9i9SkrC6hUkBig==
X-Received: by 2002:a2e:9ad0:: with SMTP id p16mr33567ljj.111.1579117799890;
        Wed, 15 Jan 2020 11:49:59 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id u18sm9928918lje.69.2020.01.15.11.49.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 11:49:58 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id j1so19902739lja.2
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 11:49:58 -0800 (PST)
X-Received: by 2002:a05:651c:282:: with SMTP id b2mr37224ljo.41.1579117798263;
 Wed, 15 Jan 2020 11:49:58 -0800 (PST)
MIME-Version: 1.0
References: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
 <5C216684-6FDF-41B5-9F51-89DC295F6DDC@amacapital.net> <CACMCwJLogOH-nG7QEMzrXK-iJPOdzCrL05y0a6yAbtPsfdRjsQ@mail.gmail.com>
In-Reply-To: <CACMCwJLogOH-nG7QEMzrXK-iJPOdzCrL05y0a6yAbtPsfdRjsQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Jan 2020 11:49:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiqPHc=BzSYO4N=awucq0td3s9VuBkct=m-B_xZVCgzBg@mail.gmail.com>
Message-ID: <CAHk-=wiqPHc=BzSYO4N=awucq0td3s9VuBkct=m-B_xZVCgzBg@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     Jari Ruusu <jari.ruusu@gmail.com>, Ashok Raj <ashok.raj@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>, johannes.berg@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 11:15 AM Jari Ruusu <jari.ruusu@gmail.com> wrote:
>
> No problem at microcode load time.
> Hard lockup after 1-2 days of use.

That is "interesting".

However, the most likely cause is that you have a borderline dodgy
system, and the microcode update then just triggers a pre-existing
problem.

Possibly because of how newer microcode will have things like "VERW
now flushes CPU buffers" etc.

But it might be worth it if the intel people could check up with their
microcode people on this anyway - if there is _one_ report of "my
system locks up with newer ucode", that's one thing. But if Jari isn't
alone...

I don't know who the right intel person would be. There's a couple of
Intel people on the cc (and I added one more at random), can you try
to see if somebody would be aware of or interested in that "ucode
problems with i5-7200U (fam 6 model 142 step 9 pf 0x80)"

               Linus
