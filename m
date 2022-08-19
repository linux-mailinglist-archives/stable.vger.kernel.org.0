Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E589A599519
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 08:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343513AbiHSGHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 02:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243302AbiHSGHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 02:07:48 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CB7C59EB
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 23:07:46 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z187so3459894pfb.12
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 23:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=HExoCPUxeh71DjLtXv6BaFguML8QWH5G+rMn+WNZF8s=;
        b=uf7IL7taIuB9bjT2atDVlm1soO+RXrYV47lDW/AP0k+uBT+4kPKOZ3qFHn19nag8Uo
         bNeS/VJvsCplmpHmvjj8aJZtGb36788sLlWhwb6c6rmwmQ241e0CotKIY9+eLcIfmqAU
         kS/+CbpXq0iZvH+q/3aQmDFLuKKEXhHaUNcTAwjsPGazUsQ0r+rQmYWA7GDTLh5cnbhF
         QsxCkEp9HWe1+GDJt3osOjOyH6/dvoYiGsF25/R/baVVFSGG48gDe+NuHcOOHgytJ83S
         SJB490T/lrz9qJujXWVwnCDusFkER6WCW593k0XcsZZ8bp33VV5OyceeL95lkuXqJKMf
         Sysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=HExoCPUxeh71DjLtXv6BaFguML8QWH5G+rMn+WNZF8s=;
        b=jW1Ev6s5M5eiNU2oC0Y/qcZvrDFOZqerszRGiRNbIshx/z/Dau4NHCmGAGBltdNICJ
         6h4t8XEY2NEoXbRTNyeUGFXQrbPpqM/ptMrVL+KGBnycz18FgPS3UKeHNFi9a1QvXOVF
         i39urUg1JCNvSw1vy1Cwo3yZQVEkD6ouXUncm2wD+GOFSGG7s6YYJdZGikDIrqs81ezX
         FDWvVE51Qo37bVVYxhjiudkcG5q0SGHit5Rtq7o2ZXZTgMbqrq80RGDG89Vi3KEg7mQn
         KkIvw4pEh6BC4XXEkBYtaDpodBIAyarIhsC28BObQccfCmP1ejrkb895eDVZjUjsqtew
         otWw==
X-Gm-Message-State: ACgBeo3KDScvj8QSy/MP+Xf/OpiZWciWZI9NwEVbeNqc1+QqvRKDXDFV
        zIqExUaMa0mqs9p4C6OwAEOoNgNHqeB3tHqz99rviQ==
X-Google-Smtp-Source: AA6agR4tuFbVtF+nfRvYd4MDq6Hbg9ZWnRKR/ESLWnF6avsgXmrHZbgLUs/7Y7iqWxIukoYLX8BKXfYIymfuz4gprVA=
X-Received: by 2002:a63:5809:0:b0:42a:3145:507d with SMTP id
 m9-20020a635809000000b0042a3145507dmr2727779pgb.428.1660889265831; Thu, 18
 Aug 2022 23:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220818110859.1918035-1-jens.wiklander@linaro.org> <CAHk-=wiEqhzrMskE=7_q4E+X+zPyxm6xvuADhaBxh8gD5p57kA@mail.gmail.com>
In-Reply-To: <CAHk-=wiEqhzrMskE=7_q4E+X+zPyxm6xvuADhaBxh8gD5p57kA@mail.gmail.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Fri, 19 Aug 2022 08:07:34 +0200
Message-ID: <CAHUa44Hm7VOb-qoi1N3pm6+wdS+zHTgsHG5C5GzrrvMOd+n6aQ@mail.gmail.com>
Subject: Re: [PATCH v2] tee: add overflow check in register_shm_helper()
To:     Linus Torvalds <torvalds@linuxfoundation.org>
Cc:     linux-arch <linux-arch@vger.kernel.org>,
        linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>, stable@vger.kernel.org,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Jerome Forissier <jerome.forissier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 6:38 PM Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> On Thu, Aug 18, 2022 at 4:09 AM Jens Wiklander
> <jens.wiklander@linaro.org> wrote:
> >
> > Fix this by adding an overflow check when calculating the end of the
> > memory range. Also add an explicit call to access_ok() in
> > tee_shm_register_user_buf() to catch an invalid user space address
> > early.
>
> I applied the access_ok() part of this which was clearly missing.
>
> The check_add_overflow() should be pointless with that.
>
> And the "roundup() overflows" check should just check for a zero
> result - if it is actually needed. Which I don't think it is on any
> relevant platform (the TEE subsystem only works on arm and x86).
>
> I do think it might be worth discussing whether
> ALTERNATE_USER_ADDRESS_SPACE (and no-MMU) architectures should still
> have access_ok() check that it doesn't actually wrap around in the
> address space, so I've added linux-arch here.
>
> That's m68k, PA-RISC, S390 and sparc.
>
> In fact, I wonder if some or all of those might want to have the
> TASK_SIZE limit anyway - they may have a separate user address space,
> but several ones have some limits even then, and probably should have
> access_ok() check them rather than depend on the hardware then giving
> page fault.
>
> For example, sparc32 has a user address space, but defines TASK_SIZE
> to 0xF0000000. m68k has several different case. parisc also has an
> actual limit.
>
> And s390 uses
>
>     #define TASK_SIZE_MAX         (-PAGE_SIZE)
>
> which is a good value and leaves a guard page at the top.
>
> So I think the "roundup overflows" would probably be best fixed by
> just admitting that every architecture in practice has a TASK_SIZE_MAX
> anyway, and we should just make access_ok() check it.

Thanks for the detailed clarifications. I'll remove the redundant
overflow checks.

Cheers,
Jens

>
>               Linus
