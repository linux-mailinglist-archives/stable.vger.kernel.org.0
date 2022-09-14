Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5578C5B7DEE
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 02:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiINAqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 20:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiINAqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 20:46:31 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95507543CD;
        Tue, 13 Sep 2022 17:46:28 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3321c2a8d4cso161115707b3.5;
        Tue, 13 Sep 2022 17:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=ssjNpU+UnxocbCpKK/CIlUpi0g+9BuJEk9fqXvf4AYo=;
        b=C5y+wEAtXvYoj9pZEXzozjeDzYsFxx/JVHiDyxJUihyC+IYwvaj1lPt3JyI9wv3RCR
         a0wiv9Sc2EXbGZ1Xyaq3sH1XbQuJgv5Eje82wAHyCTIiHPYfYvsCP7C43EvM2FyhuiTH
         0dR+br2dA+KFEfpx6ZAS1IoFEAi++n6lKY3f06uQjnFhDJBNQjs3ipt7Ja3MCKhGxaUV
         6rJSyXCOIQXg6hEv/+qK5SOIiIScmWFXQQTL+9rho5nzovCAUjpKOX/T3y6L2mxssXg+
         TQvlzw703c3tklBE5vhCEv25vHHxisStux8MrCNlYPrCSwgcNU1fpYuKilgkkTNBcp12
         kL+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ssjNpU+UnxocbCpKK/CIlUpi0g+9BuJEk9fqXvf4AYo=;
        b=X8c8tkLJMvEopFWwehQLkDqer9bRAPoL1rAx/Mwb8dtfaWE6jsUgB09Zyvt+ZvDbZZ
         xhoD7HQlLrtknRwmQ9vRpkHlpLKIUMxSbj2BYci+NBTfCVtXl3rbY25T4EtL2wd2gtS5
         UPJyRhLshYC9WtdFPlfYXalmjprUdDJtQraHv9U8ZyJNpACAtSfuslY/x/xaPCOVQ6Zh
         TMRJKK5ZnbVvfZwpWmhXuRZh2nn38WtaS3Y4ZBRRzvxB0eusdX5vPksxePikG0yJnFjb
         lQqPF+ABvFtw4y98KmFDcNyy5F6JOuqyK/S6r1qLskyZoZPpU+Uz8ZuCrBV8jjGkT9bA
         Uf+g==
X-Gm-Message-State: ACgBeo04CeAIxzRZhoRjBA07S2iNLE7D1ZsguKffEguFuIscKDVWEDx4
        D30PSf3lwDgfgQn2BixFbaSJRTxJKKA/4xNxp0rkd87Cbe68+iTkLj8=
X-Google-Smtp-Source: AA6agR78bIE/YKlBCZYmV5r7rdhZN37mXh8Kf9k4WtOGEKRfFqMqe6ps0bqbDRSrLyPmFRkeVl5DJOJtObbCtfWQgW4=
X-Received: by 2002:a81:7756:0:b0:328:2dde:3336 with SMTP id
 s83-20020a817756000000b003282dde3336mr29336073ywc.81.1663116387853; Tue, 13
 Sep 2022 17:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <ab879545-d4b2-0cd8-3ae2-65f9f2baf2fe@gmail.com> <YyCLm0ws8qsiEcaJ@kroah.com>
In-Reply-To: <YyCLm0ws8qsiEcaJ@kroah.com>
From:   yong w <yongw.pur@gmail.com>
Date:   Wed, 14 Sep 2022 08:46:15 +0800
Message-ID: <CAOH5QeAUGBshLQdRCWLg9-Q3JvrqROLYW6uWr8a4TBKxwAOPaw@mail.gmail.com>
Subject: Re: [PATCH v4] page_alloc: consider highatomic reserve in watermark fast
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jaewon31.kim@samsung.com, mhocko@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        wang.yong12@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B49=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=BA=8C 21:54=E5=86=99=E9=81=93=EF=BC=9A

>
> On Tue, Sep 13, 2022 at 09:09:47PM +0800, yong wrote:
> > Hello,
> > This patch is required to be patched in linux-5.4.y and linux-4.19.y.
>
> What is "this patch"?  There is no context here :(
>
Sorry, I forgot to quote the original patch. the patch is as follows

    f27ce0e page_alloc: consider highatomic reserve in watermark fast

> > In addition to that, the following two patches are somewhat related:
> >
> >       3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
> >       9282012 page_alloc: fix invalid watermark check on a negative val=
ue
>
> In what way?  What should be done here by us?
>

I think these two patches should also be merged.

    The classzone_idx  parameter is used in the zone_watermark_fast
functionzone, and 3334a45 use ac->high_zoneidx for classzone_idx.
    "9282012 page_alloc: fix invalid watermark check on a negative
value"  fix f27ce0e introduced issues


> confused,
>
> greg k-h
