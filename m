Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FF04D6098
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348247AbiCKLbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348241AbiCKLbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:31:48 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9532F1BAF25;
        Fri, 11 Mar 2022 03:30:45 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so5147529wmp.5;
        Fri, 11 Mar 2022 03:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=xcObS0WVWrfqu8mNkyOQ0nV3EjvWd6c1AXYqGZ5XTGM=;
        b=G/ovJ8o7B7A6xufyjF5fvop2+MiKH68Hunofh0IQfHdgYx4O+S94ydSYTJseJpB8OD
         cj9xnP1RWxH4tLPfxF9MxMj7LuQGo61/OZyEn1WESP0humM8CNpS2pP/4yE9fD46vXDO
         2OVp8jMshWPMhFL2JNKiN7rlvL9k0+r8vaVjfrdWQUgEjRAus1lmU62pX//j59Um/JRc
         ixQolU7Y0vu+7Ogj5zWgV/tiC5OQ2N/f5pSUIGsYrP7wxN1aTMMDJDWtIEAMpbWGuxu7
         2ApuYCH3GXJHQX0qLVO9aWBeiggL+MKdbAjNqXN4lap6vaSvHOhZLMrQz0r2+ksxaC7u
         meoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=xcObS0WVWrfqu8mNkyOQ0nV3EjvWd6c1AXYqGZ5XTGM=;
        b=qvZL9aBLScjaXH9krPgiXdfV/ciiPIJgreJ0Z0dqgho6NAUAA4OGNodkF7G1cXg/uh
         JGNCmIEwqymVCyic4HlziAYPIuljFgBWosL/EMdq3HJCtg8kJ6t1NerLwFLjmiGfePO2
         4lrCorBXBeDKVfTzwQu0xN5SpP89MEYGKnJukXxxWanN/gdnp+CAtL1lPOEEkBw9vTJq
         haswhjlENQzQahs4ub0arLrmkgNM9IAuLhP+WCpDSTClv0/u9dLefXK69H+appVxhbjW
         NQqjWriZn7vP3oShxBu1usvBn+GqxhuRHdzlLf82vwoC72BOH/C7jDnALI9dYd4JmFxZ
         1U1g==
X-Gm-Message-State: AOAM533OSBQ6bTDKXuoe2PFKQQ5zeozwcqFLmBtqTK+G30TKNy5VbhvF
        0dECFbYm+zdt8cPr/t7W6yUOTu9S9cjfTQ==
X-Google-Smtp-Source: ABdhPJyIkAGEaqTeLRriLCxzh1Z2kjz7sQFDGRATMQMjTWLvzHz86P5OrYTJ/hfKD/DVkMdc4SQNAQ==
X-Received: by 2002:a7b:c4c9:0:b0:389:9348:9ade with SMTP id g9-20020a7bc4c9000000b0038993489ademr15144015wmk.70.1646998243913;
        Fri, 11 Mar 2022 03:30:43 -0800 (PST)
Received: from www.Debian-Testing-WilsonJTR4 ([213.31.80.52])
        by smtp.gmail.com with ESMTPSA id i8-20020a7bc948000000b003898dfd7990sm7589712wml.29.2022.03.11.03.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 03:30:43 -0800 (PST)
Message-ID: <0d4088b987437788846b7d69879189f4870b90c6.camel@gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
From:   Wilson Jonathan <i400sjon@gmail.com>
To:     Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 11 Mar 2022 11:30:42 +0000
In-Reply-To: <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
         <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
         <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.43.2-2 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-03-10 at 14:37 -0800, Song Liu wrote:
> On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> >=20
> > On 3/8/22 11:42 PM, Song Liu wrote:
> > > RAID arrays check/repair operations benefit a lot from merging
> > > requests.
> > > If we only check the previous entry for merge attempt, many merge
> > > will be
> > > missed. As a result, significant regression is observed for RAID
> > > check
> > > and repair.
> > >=20
> > > Fix this by checking more than just the previous entry when
> > > plug->multiple_queues =3D=3D true.
> > >=20
> > > This improves the check/repair speed of a 20-HDD raid6 from 19
> > > MB/s to
> > > 103 MB/s.
> >=20
> > Do the underlying disks not have an IO scheduler attached? Curious
> > why
> > the merges aren't being done there, would be trivial when the list
> > is
> > flushed out. Because if the perf difference is that big, then other
> > workloads would be suffering they are that sensitive to being
> > within a
> > plug worth of IO.
>=20
> The disks have mq-deadline by default. I also tried kyber, the result
> is the
> same. Raid repair work sends IOs to all the HDDs in a round-robin
> manner.
> If we only check the previous request, there isn't much opportunity
> for
> merge. I guess other workloads may have different behavior?
>=20
> > Between your two approaches, I do greatly prefer the first one
> > though.
>=20
> I also like the first one better. But I am not sure whether it will
> slow down
> other workloads. We can probably also make the second one cleaner
> with a new variation of blk_start_plug.

As a matter of note and purely anecdotal: Before the raid "check" slow
down/regression my system would be responsive but delayed (opening a
program or opening the xface application menu or switching a file in
VLC would take longer than normal, fractions of seconds to a second but
slugish and notacable) and with the regression that slow down went from
annoying to unbearable.=C2=A0

The slowdowns (in programs and menus and file changes) also *seems* to
get worse (in both pre & post regression) the longer the check has been
running and the slower a run naturally gets (I assume as the check
moves from the outer portion of the disk to the inner portion?) and the
lower the KB's reported in cat /proc/mdstat/.

In the post regression situation it wasn't just that the check was
taking much longer and was much slower it was also that it slowed down
everything else to the point that it was painful to try and use the
computer as it was so much less responsive (multiple seconds for
anything to load/run/swtch; even web pages). A laggy annoyance had
become an actual hindrance.=C2=A0

I have no idea why the speed of the "check" would seemingly affect the
apparent responsiveness of the computer and why it would appear that
the slower the check the slower the responsiveness.=20

>=20
> Thanks,
> Song

