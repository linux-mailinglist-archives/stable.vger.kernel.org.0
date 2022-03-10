Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953504D4790
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 14:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242245AbiCJNCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 08:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbiCJNCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 08:02:17 -0500
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5C914A236;
        Thu, 10 Mar 2022 05:01:16 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id u61so10664613ybi.11;
        Thu, 10 Mar 2022 05:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ttvQJIHKftyORzr4Ocgp9jAs29yrH7fRAroWpNyJIzE=;
        b=YxKibSh4UuypWbi2yZPW7MK9tZ6LqqD/XniWr/7yJiwqvSd48NeCVOS9oT6jVDKUvc
         xDMSEW4thK+cdb8HXOHEW/Me8IiD8Gli8rh/0IeILR7Zyj34jZAGkP3Tyc5+kC2xXp6S
         9wdLKS1/DmOe/97fnE6PQRvFzkROn9D7DrGAfJfJRu4tAgWsyL/EUrH7gbJyeRbJq26Z
         bL1sbSA/XUSTqZAbuc6MgBxJhiWunV5Vnp1tlTaPogjB946UT5vudmj2FlJVjOb3kO/D
         y35rgc4FYptaMulDy0tfiYkI1G8FjfOQOXFmN+A4YGLadU71RkySPlptth6Fut2p+Sox
         WdgA==
X-Gm-Message-State: AOAM533xrH6GcrVT+7G+i5Qjb8scWbZX3CBwwWiCBXN4YADhyg/lO768
        KMJAdLRd4t71G5/WNulsGkQt2alrfLsFNnNE2cI=
X-Google-Smtp-Source: ABdhPJxKvEJtXw9uwgar1yUexvTXDKUrfRXURdanxoB/4+9VUTug+LmD02j6phOJu1/5jkphPh63paaXRZTRbpaimJA=
X-Received: by 2002:a25:24d7:0:b0:628:79dc:1250 with SMTP id
 k206-20020a2524d7000000b0062879dc1250mr3698757ybk.153.1646917275815; Thu, 10
 Mar 2022 05:01:15 -0800 (PST)
MIME-Version: 1.0
References: <CAJZ5v0gE52NT=4kN4MkhV3Gx=M5CeMGVHOF0jgTXDb5WwAMs_Q@mail.gmail.com>
 <YinyzxnSsty8BDKn@kroah.com>
In-Reply-To: <YinyzxnSsty8BDKn@kroah.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Mar 2022 14:01:04 +0100
Message-ID: <CAJZ5v0ghFyFG3aDRawoVFDvhXLkvjZqiaPeqbtFnRQvhd9T_rA@mail.gmail.com>
Subject: Re: Please revert commit 4287509b4d21e34dc492 from 5.16.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Thorsten Leemhuis (regressions address)" <regressions@leemhuis.info>
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

On Thu, Mar 10, 2022 at 1:45 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 10, 2022 at 01:26:16PM +0100, Rafael J. Wysocki wrote:
> > Hi Greg & Sasha,
> >
> > Commit 4287509b4d21e34dc492 that went into 5.16.y as a backport of
> > mainline commit dc0075ba7f38 ("ACPI: PM: s2idle: Cancel wakeup before
> > dispatching EC GPE") is causing trouble in 5.16.y, but 5.17-rc7
> > including the original commit is fine.
> >
> > This is most likely due to some other changes that commit dc0075ba7f38
> > turns out to depend on which have not been backported, but because it
> > is not an essential fix (and it was backported, because it carried a
> > Fixes tag and not because it was marked for backporting), IMV it is
> > better to revert it from 5.16.y than to try to pull all of the
> > dependencies in (and risk missing any of them), so please do that.
> >
> > Please see this thread:
> >
> > https://lore.kernel.org/linux-pm/31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com/
>
> Odd that this is only showing up in 5.16 as this commit also is in 5.4
> and 5.10 and 5.15.  Should I drop it from there as well?

It's better to do so, because these series are also likely to be
missing the mainline commits it depends on.
