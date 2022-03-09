Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8BB4D3596
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiCIQoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbiCIQlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:41:32 -0500
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A14E18FAD0;
        Wed,  9 Mar 2022 08:35:10 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id e186so5527052ybc.7;
        Wed, 09 Mar 2022 08:35:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/5MaujMz6TfkcZ1KvOA3nvp+vZpIOa/uaJnkWsfgtMg=;
        b=P4xDx92mxKerRb79iNZXmGUF2G/ZXLf4MF30j+Cc0ErsUbDO7chXsytUYvWqNohAbf
         t1Loj5J/6Bt65RXnIg/nnyjC/AYAeOXheuGP02ou49RWXUnVeUqsegztDiSoeVUaSL1b
         0v8KfjZ0APmIXWE0ualgleOjseRHs4p7LhSfTwL1oF2tA+Ef9iMqgybWDIe+gx5CHq3K
         +39ZSUSglY1ITd3LEbAncETbfRTDI82qbzKABlTjwf9k4CxN0fZHNENaiPp+ONEN8kql
         bqGbJZSJmxyzC0/bxWMbfElfn3bQI3tzuZcZ9zfAxeowpkJ/5Zwzeop5u5StHnXs5CZj
         aUHQ==
X-Gm-Message-State: AOAM530mDpMYLIBnV8pWvWkJDoIP+35uAA2CNPJj03XnRPggnxSu9DJi
        Zb21z3Egw2uFqJ/CKkT/CSqilmus3y4duc8Nnag=
X-Google-Smtp-Source: ABdhPJxAfyFWJnFtkHvypezIfISgUpnq79aDX7Iqseje3o8RJaKTkV0hHRvPWxTe1HMIJZ8ilDR9NPJ6VzXRLfaeuao=
X-Received: by 2002:a25:4052:0:b0:628:cdca:afb7 with SMTP id
 n79-20020a254052000000b00628cdcaafb7mr446986yba.81.1646843698434; Wed, 09 Mar
 2022 08:34:58 -0800 (PST)
MIME-Version: 1.0
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com> <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com>
In-Reply-To: <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 9 Mar 2022 17:34:47 +0100
Message-ID: <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 5:33 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 3/9/22 14:57, Rafael J. Wysocki wrote:
> > On Wed, Mar 9, 2022 at 2:44 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >>
> >> Hi Rafael,
> >>
> >> We (Fedora) have been receiving a whole bunch of bug reports about
> >> laptops getting hot/toasty while suspended with kernels >= 5.16.10
> >> and this seems to still happen with 5.17-rc7 too.
> >>
> >> The following are all bugzilla.redhat.com bug numbers:
> >>
> >>    1750910 - Laptop failed to suspend and completely drained the battery
> >>    2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
> >>    2053957 - Package c-states never go below C2
> >>    2056729 - No lid events when closing lid / laptop does not suspend
> >>    2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
> >>    2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
> >>    2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> >>
> >> And one of the bugs has also been mirrored at bugzilla.kernel.org by
> >> the reporter:
> >>
> >>  bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> >>
> >> The common denominator here (besides the kernel version) seems to
> >> be that these are all Ice or Tiger Lake systems (I did not do
> >> check this applies 100% to all bugs, but it does see, to be a pattern).
> >>
> >> A similar arch-linux report:
> >>
> >> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
> >>
> >> Suggest that reverting
> >> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
> >>
> >> which was cherry-picked into 5.16.10 fixes things.
> >
> > Thanks for letting me know!
> >
> >> If you want I can create Fedora kernel test-rpms of a recent
> >> 5.16.y with just that one commit reverted and ask users to
> >> confirm if that helps. Please let me know if doing that woulkd
> >> be useful ?
> >
> > Yes, it would.
> >
> > However, it follows from the arch-linux report linked above that
> > 5.17-rc is fine, so it would be good to also check if reverting that
> > commit from 5.17-rc helps.
>
> Ok, I've done Fedora kernel builds of both 5.16.13 and 5.17-rc7 with
> the patch reverted and asked the bug-reporters to test both.

Thanks!
