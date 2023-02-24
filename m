Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB26A2237
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 20:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBXTRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 14:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjBXTRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 14:17:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CE06B14E
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 11:17:11 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i34so1289859eda.7
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 11:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HH0zAL0zwAD0TFUh4VaOGtbBT10Co7dyTSR8JSwAXuA=;
        b=GtNE3Ed1l5jwOVYSMAkytt7K/8+r0xcYErBg1jFJR5NuoG8BIRbsy2Au89zhNyAcQ5
         Qset4AKkaxqaU31Ahm2BzjHwj5/D3tZRCwbV3hv+mTG4u7BFAaWSjvrxeuWemjLrqLBl
         2/r5V3P+oRo0NvtuhmHFYeTsTmraiROQHo6n4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HH0zAL0zwAD0TFUh4VaOGtbBT10Co7dyTSR8JSwAXuA=;
        b=KI+/zfWkHCmg7LOXzVmelLrFkFiQ8DE/NuACFIpv9hHq1u9m2rVwmj8O/yhUBOhKwy
         AM72djpuqNMAmqsdtu0D5x/lQhOOZbxHQIbhDyKR3oC73ujV1piHffafx9jKEVV832HF
         aILK0P8d1lic7W7lPZluAdIPkRXpucAsB9gOcj12bR50Q66ItgvgEbx8gJTz+knXxJjc
         twbN0yuVNE3kk7e2gSZLrPbJ4+I7Clbm7OTtVwF8ViIz53XlHTRorFHVDl7y1jniVal1
         I8N3SWWYxuFLD7lRXX/ulEsaPNDQs5I5MYTPFusvmKHmwvw+xY+SqM93gvaWefM94nTD
         Q6Jg==
X-Gm-Message-State: AO0yUKUQsOfycAWJX407AsXkjizMv8Wa3BmAELuIQK48p5xQoMs3RxRg
        nARmRo0UDUXbeZ5a/gTsgfrmzsS/na4nUofQDOPryg==
X-Google-Smtp-Source: AK7set9IMEq0Q/PgP/zedfSRSVH3mX7j60qkm23/253hdcbtShv766mdeROxJOjbZDSlzLzkntnKHA==
X-Received: by 2002:a17:906:2488:b0:8af:7b80:82c5 with SMTP id e8-20020a170906248800b008af7b8082c5mr21033459ejb.75.1677266229873;
        Fri, 24 Feb 2023 11:17:09 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id v27-20020a1709063bdb00b008d5d721f8a4sm6352671ejf.197.2023.02.24.11.17.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 11:17:09 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id da10so1380512edb.3
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 11:17:09 -0800 (PST)
X-Received: by 2002:a17:907:60cd:b0:8f5:2e0e:6dc5 with SMTP id
 hv13-20020a17090760cd00b008f52e0e6dc5mr545864ejc.0.1677266228845; Fri, 24 Feb
 2023 11:17:08 -0800 (PST)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 11:16:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
Message-ID: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
Subject: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Jim Meyering <meyering@fb.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>, patches@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 8:55 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Ok, it's not quilt's fault, it's GNU diff's fault from what I can tell.
> quilt relies on diff to generate the patch, and I can't figure out how
> to get diff to notice file permissions at all.  Am I just missing
> an option to 'diff' somewhere that I can't find in the manual?

No, I think you're right.

GNU patch was updated long ago to understand and apply the extended
git patch data.

But as far as I can tell, GNU diffutils have never actually grown the
ability to generate those extensions, even though at least the mode
bit one should be fairly simple (the file rename/copy ones are rather
more complicated, but those are just a "make diffs more legible and
compact" convenience thing, unlike the executable bit thing that
allows for scripts to remain executable).

> Anyway, quilt can handle replacing what it uses for 'diff', so I'll just
> replace it with 'git diff' and that seems to solve the problem for me!

That does sound like the right solution.

I don't think the diffutils people really care, but let's cc Paul
Eggert and Jim Meyering anyway, just in case. Because looking at the
diffutils git tree, it's still actively maintained even if the patch
load seems quite low.

Maybe there's some patch floating around that would allow diffutils to
also add those mode change lines. A quick google didn't find anything,
but Paul and Jim would probably know (or can just say "yeah, not even
interested").

                Linus
