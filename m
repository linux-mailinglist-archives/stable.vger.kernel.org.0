Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D461504F7D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 13:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiDRLp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 07:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiDRLpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 07:45:55 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08D512AF6;
        Mon, 18 Apr 2022 04:43:14 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z99so17171399ede.5;
        Mon, 18 Apr 2022 04:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IUai0Spi7zlbWJJauW/yyVhMilMhUGODlc/UhrPP73s=;
        b=MLUEUAtt3AfKYiQOFi6osshzmcX/h9UaxBkiqDbRIZ2E9diYz7HqYszGdcBGDLDjr5
         CkCzqpCmvXkDzMzQO2qdfKKJBQJIr1zYL1LI/OSkk+RarOHskqvlWDfDo4pvxjUUyV5l
         1t9KFR2zXhTSmglAakGCE+SR5iXdwRdaX07dQwVicw5Gz7rSi+pDJzDoxoWR/jAz0QTs
         rtrTSQL/uibOT8MB0pt2aoJPkjYMmvY7Iv1J/IRhVTwN/n/q6wDwb3JYjH+0aRWnYhmZ
         OEFrxmBzGV9DP48VFjTuGDa15kMW++4sVmojyPPLvRh2T4UZK/bsyadojSRT79kRcr7I
         bkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IUai0Spi7zlbWJJauW/yyVhMilMhUGODlc/UhrPP73s=;
        b=cYuOSnTjVOk76JB0rdE2xqcwQVVDZxG2XaOLuPTy2P5US6XnS2yBPJhn3gOk/m+2wz
         zOs1QuUPp1MJB39cfRZgtClV6C52zvcO/gyJae7/QTzFHRbUWiCHwaaHv4ruWzIUwC9p
         O8X+S4hBDNvYR46wNqwbIt2XJFqILnEYyeI+g9qeBi4p82fkVTTVWmH4HDb+JnWQUHBH
         0yePwt7pJG2eRlCFdscUJgQf2nzlZBzeIaXPvRyHWx0ojulNYtz7+e7CVbYz9EkGr/SX
         JF+EtlzsbvZpyioRIVjSS7MQYuasbAYZ2B2U1LB/SaMX6wn37wJvki4EJ6fhd47ebraI
         gxNA==
X-Gm-Message-State: AOAM533cAsFvFa5nKFQbOiD4dXFxO6zB0ZQEbJi1Kg5yT6quaMRjhDEK
        hfPXoHeTBPhGCNghHFEP2zQuZTCP8ZGFtZg8ank=
X-Google-Smtp-Source: ABdhPJx3GZXSvcnDNz3un3VYBHitDF2IaMsMedvCofVFjPjXQ7ShUZ/rNCAfd47CLlg+dpp6abttta0gJTrBSZqEsr8=
X-Received: by 2002:a50:cc9e:0:b0:41d:7123:d3ba with SMTP id
 q30-20020a50cc9e000000b0041d7123d3bamr11800621edi.296.1650282193247; Mon, 18
 Apr 2022 04:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220414025705.598-1-mario.limonciello@amd.com>
 <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com> <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
In-Reply-To: <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 18 Apr 2022 14:42:37 +0300
Message-ID: <CAHp75VceVwAq68s_hnpXt8VvLBHVUMxFTJR+_Tnph_mvpxGVPw@mail.gmail.com>
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     firew4lker <firew4lker@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Richard.Gong@amd.com, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 7:34 AM Mario Limonciello
<mario.limonciello@amd.com> wrote:
> On 4/17/22 07:24, firew4lker wrote:

...

> Linus Walleij,
>
> As this is backported to 5.15.y, 5.16.y, 5.17.y and those all had point
> releases a bunch of people are hitting it now.  If you choose to adopt
> this patch instead of revert the broken one, you can add to the commit
> message too:
>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976

I prefer to explicitly tell that this is a link to a bug report, hence BugLink:.
But this is just my 2 cents.

-- 
With Best Regards,
Andy Shevchenko
