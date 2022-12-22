Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E80653CC4
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 09:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLVIH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 03:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiLVIHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 03:07:25 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B1D18B2E;
        Thu, 22 Dec 2022 00:07:24 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p8Gbq-0005kI-JY; Thu, 22 Dec 2022 09:07:22 +0100
Message-ID: <918e41dd-e5ea-9dc5-e6d4-5d524f317d18@leemhuis.info>
Date:   Thu, 22 Dec 2022 09:07:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Content-Language: en-US, de-DE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, Vlastimil Babka <vbabka@suse.cz>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Jiri Slaby <jirislaby@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
References: <20221219182943.395169070@linuxfoundation.org>
 <20221220150049.GE3748047@roeck-us.net> <Y6HQfwEnw75iajYr@kroah.com>
 <20221220161135.GA1983195@roeck-us.net>
 <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1671696445;fb6d1a39;
X-HE-SMSGID: 1p8Gbq-0005kI-JY
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.12.22 07:34, Jiri Slaby wrote:
> On 20. 12. 22, 17:11, Guenter Roeck wrote:
>> You probably didn't see any reports on mainline because I didn't report
>> the issue there yet. There are so many failures in mainline that it is
>> a bit difficult to keep up.
> 
> Just heads up, these are breakages in 6.1 known to me:
> 
> an io_uring 32bit test crashes the kernel:
> https://lore.kernel.org/all/c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com/
> 
> Fixed in io_uring tree.

Just BTW: afaics the fix is now in mainline as 990a4de57e44

> bind() of previously bound port no longer fails:
> https://lore.kernel.org/all/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> 
> No fix available and revert close to impossible.

Also just BTW: fix posted yesterday.

> And most important, mremap() is broken in 6.1, so mostly everything
> fails in some random way:
> https://lore.kernel.org/all/20221216163227.24648-1-vbabka@suse.cz/T/#u
> 
> Fixed in -mm.

That one seems to fix an annoying issue many people might run into (at
least it looks like it to my untrained eyes), which is the reason why I
write this mail.

Andrew moved that fix from mm-hotfixes-unstable to mm-hotfixes-stable
yesterday and I assume he'll send it to Linus pretty soon now to ensure
it makes it into -rc1, so that the stable team can pick it up. It might
be a bad season to ask this, but that made me wonder:

Should that patch have progressed quicker? And if so: how to make that
happen when a similar situation arises in the future? Should somebody
(the developer of the patch? me?) kindly ask the maintainer in question
to sent the fix straight to Linus once it spend 1 or 2 days in next?

It's not the first time that I see something like this, that's why I'm
wondering if I should do something in such situations.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
