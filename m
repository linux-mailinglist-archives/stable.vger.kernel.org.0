Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112606CF0CE
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 19:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjC2ROb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 13:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjC2ROa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 13:14:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355FD4EC8
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:14:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54574d6204aso161259437b3.15
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680110066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QhPDqPWOP3GxbtGY8Yn03rtJ4XzWBIS5/u+ePVRvGmo=;
        b=rBpTeL1qTaNDVySpVYU0dlnLxBvmErVUiSRJDONze1J4bUZgZ3Ms/wv5f7RCoCHAW2
         m7am1E2TZ7q0msHh73AHN8t2eM0V8zrs2c9gVYDO0zqWTxsSz3XX0r3w1nOMAg8BFmIU
         N0c1wxWNbSzpo5EOEPMZJ6DEbY+Has6A+yEjS3QJfC2EvFB1FQplq7r5dRsn6P5CVY5Q
         0GEwF6+W6jMvCKlK2SBylFyzc/oiGdsiXiQKKJPH6xxelcpoaMGLUSQ6g8HGBGzPk5bT
         XSxNxBcUb0oiSbZ8T6ENd0AVG4Eq2RrswHJopvXqhPSQ03FWtvlQrtdCAUp4L4RmffLm
         vC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680110066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QhPDqPWOP3GxbtGY8Yn03rtJ4XzWBIS5/u+ePVRvGmo=;
        b=jCAIihlcrZ+ifblv9EUFpN5TyLIetvyv7NJO8yom7695rFzZGYxtp8oKGGB/okE8ey
         JX5GIaNaiCPfUPQVrudixe20eou414FGp10PRbqDXkt1xXqi1bjNUUCofQZf356vldWd
         UdeTTKhmxwsUiiYSjneUhbva9MzpS9GsGQDcpQ3XbNEIjx6qlYZ8fXdjGqMxIHWPiQbr
         0/v+FTZVLA6HLI4+abthTZe2VKBHX9+hoFrAeC1szT5RKXekKxN+ee+VKHX5/Ujwhw4q
         e+Mtvct+FzzKaK04ZNexpo6ygkn+dwDOHWNFym1UWBOd4+3FeRJtCWdlGPuEH3+ns+OC
         ruwg==
X-Gm-Message-State: AAQBX9ddKLoD648rHUwTIPXke6jux08sr1syhf0hKWCiCJCra2xDiJW7
        dDKipzpUQDs+SW5mDHxpKMHKQIZZuXc=
X-Google-Smtp-Source: AKy350Y7PZnUZph+CfU9c+CDVPYpup3kerpre7kXfelgwGXPq9wo0933PZUd9r4xnGhn4Ccbgk2zPEDAaSM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac64:0:b0:545:6106:5334 with SMTP id
 z36-20020a81ac64000000b0054561065334mr9859621ywj.8.1680110066439; Wed, 29 Mar
 2023 10:14:26 -0700 (PDT)
Date:   Wed, 29 Mar 2023 10:14:25 -0700
In-Reply-To: <3ff9f56c-479b-2dbd-9ee6-c7d00c7bd285@igalia.com>
Mime-Version: 1.0
References: <20221218234400.795055-1-gpiccoli@igalia.com> <Y6A6Q57/qz7w7cxM@kroah.com>
 <Y6BD9W7hk4CjhSdh@hirez.programming.kicks-ass.net> <3ff9f56c-479b-2dbd-9ee6-c7d00c7bd285@igalia.com>
Message-ID: <ZCRx8YaAt7ybDlLM@google.com>
Subject: Re: [PATCH 6.0.y / 6.1.y] x86/split_lock: Add sysctl to control the
 misery mode
From:   Sean Christopherson <seanjc@google.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net,
        kernel-dev@igalia.com, kernel@gpiccoli.net, fenghua.yu@intel.com,
        joshua@froggi.es, pgofman@codeweavers.com, pavel@denx.de,
        pgriffais@valvesoftware.com, zfigura@codeweavers.com,
        cristian.ciocaltea@collabora.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andre Almeida <andrealmeid@igalia.com>,
        Stas Sergeev <stsp@list.ru>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Stas

On Mon, Dec 19, 2022, Guilherme G. Piccoli wrote:
> On 19/12/2022 07:59, Peter Zijlstra wrote:
> > On Mon, Dec 19, 2022 at 11:17:39AM +0100, Greg KH wrote:
> > 
> >> What specific programs have this problem and what are the exact results
> >> of it?
> > 
> > IIRC it was God of War (2018) that triggered this initially. But it's
> > possible more games were found to tickle this specific thing. Since it's
> > binary only gunk that is unlikely to ever get fixed we need something to
> > allow for it.
> > 
> > (slow motion Kratos yelling B...o...y...)
> > 
> >> Also, this is really a new feature and not really a "fix", but one could
> >> argue a lot that this is a "resolve a performance problem" if you want
> >> to and have the numbers to back it up  {hint}
> > 
> > Right, there were some, they should indeed have been included.
> 
> Thanks Peter, that's exactly it - the current report is linked on commit
> message.
> 
> About performance numbers, the only "numbers" I have is: game is
> unplayable, according to the report "When I launch God of War through
> Steam or Lutris I get around 25 fps, on lowest settings and at 10%
> resolution scaling", FPS for for games is double of that usually.
> 
> I understand this is not a regular fix in which something is completely
> broken, but it does fix a behavior introduced on kernel that prevent
> some userspace binaries to properly run, in practice. Ofc some will
> argue that we already have the kernel parameter, but it's different -
> requires reboot and bootloader understanding.
> 
> If 6.0.y is too much, I'd ask we have it at least for 6.1, which is
> long-term, that will help a lot of people for sure.
> Thanks,

Resurrecting this thread with a concrete use case.

dosemu2, which uses KVM to accelerate DOS emulation (stating the obvious), ran
into a problem where the hardcoded (prior to this patch) behavior will effectively
hang userspace if the 10ms sleep is interrupted, e.g. by a periodic SIGALRM[*].

Alternatively, we could try to figure out a way to ensure forward progress without
letting userpace run an end-around on the enforced misery, but backporting this
patch to stable kernels seems easier.

Stas, do you happen to know what the oldest stable kernel your users use, i.e.
how far back this backport would need to go?

[*] https://github.com/dosemu2/dosemu2/issues/1968#issuecomment-1486709361
