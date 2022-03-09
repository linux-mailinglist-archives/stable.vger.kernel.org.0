Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE04D30A9
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 14:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiCIN6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 08:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiCIN6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 08:58:38 -0500
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0966225C60;
        Wed,  9 Mar 2022 05:57:36 -0800 (PST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2db569555d6so23294647b3.12;
        Wed, 09 Mar 2022 05:57:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AojWMK2oif5MAyExBuztUEGgT5CpCBKkNqML2H53coE=;
        b=sCwdIhpSeg4AnnL214Id6GNkvdctQMg8DH11hp5m3beA89LDKmmGUluzpx58KFYIMV
         PT6OLX1MNTtCLFPTqM4VGmOxOtLB1a/OIifG2hzXUUT1aEzCqVA31sRvxOUvKx/dp7dK
         KyDhTWwllKdP79RZOBuoZ+uT+O+eOFqbjcXQU6SlfHIk+0Zo/nLjkHOFsTNPb56A7wxg
         bWjxIEygkIFye9dvznwdtKKG8Z6UzH6OaxEiDvSw8WW1VKaHOpbW9ZPj0Jl/cGNtsOct
         drPkI8ZKqJD72CMLO62i0u6F/nikrJ/MtwFVZH5y2lpnlKnLL5jRSligOBmFVTgGIeDh
         oeLw==
X-Gm-Message-State: AOAM531AK8IhK2qhEQvsID36+bWwhXXOjcebJxtIHqfhFtKOdHFaE9rH
        SefFW5k3oTVofmjV/bTmD8S4Gpf+87EltcioMK8=
X-Google-Smtp-Source: ABdhPJy7n3OjUBNLgTmstG3Xov+8NR0eRBe5znJEKbdWmv3iwTWKDLTnWT4gc3IAWOQ9IUlaDC1ZETidp/v/7aE69/I=
X-Received: by 2002:a81:bd0:0:b0:2dc:184b:e936 with SMTP id
 199-20020a810bd0000000b002dc184be936mr17044684ywl.7.1646834255177; Wed, 09
 Mar 2022 05:57:35 -0800 (PST)
MIME-Version: 1.0
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
In-Reply-To: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 9 Mar 2022 14:57:24 +0100
Message-ID: <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 2:44 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi Rafael,
>
> We (Fedora) have been receiving a whole bunch of bug reports about
> laptops getting hot/toasty while suspended with kernels >= 5.16.10
> and this seems to still happen with 5.17-rc7 too.
>
> The following are all bugzilla.redhat.com bug numbers:
>
>    1750910 - Laptop failed to suspend and completely drained the battery
>    2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
>    2053957 - Package c-states never go below C2
>    2056729 - No lid events when closing lid / laptop does not suspend
>    2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
>    2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
>    2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
>
> And one of the bugs has also been mirrored at bugzilla.kernel.org by
> the reporter:
>
>  bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
>
> The common denominator here (besides the kernel version) seems to
> be that these are all Ice or Tiger Lake systems (I did not do
> check this applies 100% to all bugs, but it does see, to be a pattern).
>
> A similar arch-linux report:
>
> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
>
> Suggest that reverting
> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
>
> which was cherry-picked into 5.16.10 fixes things.

Thanks for letting me know!

> If you want I can create Fedora kernel test-rpms of a recent
> 5.16.y with just that one commit reverted and ask users to
> confirm if that helps. Please let me know if doing that woulkd
> be useful ?

Yes, it would.

However, it follows from the arch-linux report linked above that
5.17-rc is fine, so it would be good to also check if reverting that
commit from 5.17-rc helps.
