Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4525459CA
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 04:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiFJCAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 22:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238877AbiFJCAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 22:00:15 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E872228CB
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 19:00:12 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-313a8a8b95aso25082037b3.5
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 19:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dmbg46JYZrgSYxwq4RgBDQ2S4++EWkppgXn1YVWC8s8=;
        b=HT+hzCE9LAXnfR4JCEnNOrDcYVHqYOMv0iYfrARHXXl9mCoW6bzDHCN0uZ2f5EoO67
         r3p0/AMpudMoicJWVyERG39dSIOHAzxyJSDPL0/ErpiIYwwFAPIlENjaWwn2iXzjAkVk
         SiNcPP8XzJD8LrJ2yEX8mgH6Qz75fnLRVjc3kaJ7ft5sUwoVxTNY1KSUiNaxom+R9znJ
         KkZDJRQUbZ2+ZaLVeINmo0P/Pg7MxpzXEymYAniWh6gmujmxg6VtsBpDJ/cl6nL2I5WS
         f8134U4ZPlDSoxCbIHv0iunjfnYWM8rZv7qXkES/DRedOpEqNzXQWRtPDIGCrPvq81pq
         P6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dmbg46JYZrgSYxwq4RgBDQ2S4++EWkppgXn1YVWC8s8=;
        b=Vko4M8lFEwJ0vL0ojCKrv6HhAXfNpQc2m71bkzIiH+93W2pbIxtA6XAvo1wEuGOKFX
         XyRQBa5bxSLQxubtMuiNfgPIeQk0FJzbDnH/hqtJ7I56QGiQvtit5OceJbVydo/LHXpa
         i48g1FkGjmhpKwpX+CNZZKGcZJ0jcfL01Xn0WrRw725s/p4ULp32HmYo/kK+G4s6lB1+
         RWA89HKg4QpjJV+eZYmWsrAm1y18/KDmNcCMpCW6wwkdC4Bd4q7TmuyNOnfA+l6EpWuB
         ObGFopwBFwH765EzLwf7NYy0W9EwqrnpM3QP2a4rqPSpN/TOvEQaWGeU5xGaPzzn0GnW
         9aEw==
X-Gm-Message-State: AOAM531OVMdjXSHn4gjOFc7xokmbs5oNdObVqELEdhK+QkJvpSf1RQQu
        NqggifMjh8jl84udEZZC2rLZNpv/GwL+eA+odWMWPtoH0wc=
X-Google-Smtp-Source: ABdhPJyhgtnxz5GFW4yOiLCV/WDZVcBGtaiCHEsS4iV/miZivlVdr+EeIrP1HNSviJYWopXtZS9GIHLcF9y/Jzc3Ou8=
X-Received: by 2002:a81:7b86:0:b0:310:e75:3abb with SMTP id
 w128-20020a817b86000000b003100e753abbmr40288723ywc.332.1654826411030; Thu, 09
 Jun 2022 19:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220610000555.GA2492906@roeck-us.net>
In-Reply-To: <20220610000555.GA2492906@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Jun 2022 18:59:59 -0700
Message-ID: <CANn89iKZqfKQrJLZbjnngHjSx_AoyUHMmOwK5aek4jDVNyj77g@mail.gmail.com>
Subject: Re: Boot stalls in v4.9.y to v5.4.y stable queues
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 9, 2022 at 5:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Hi,
>
> all stable release queues from v4.9.y up to v5.4.y have boot stall
> problems. The culprit is the backport of commit d7ea0d9df2a6 ("net:
> remove two BUG() from skb_checksum_help()"), specifically the following
> code.
>

Not sure why this patch has been backported.

It had no Fixes: tag, and was not a stable candidate.

> While that works fine in the upstream kernel since ret is subsequently
> always overwritten, that is not the case in older kernels. In those,
> the function now always returns -EINVAL.
