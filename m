Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FD24D41CA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 08:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbiCJHZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 02:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbiCJHZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 02:25:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A705BE58;
        Wed,  9 Mar 2022 23:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C1A61A77;
        Thu, 10 Mar 2022 07:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFCFC340F4;
        Thu, 10 Mar 2022 07:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646897046;
        bh=0dR5j3+EcREbZ1o24aNVXO1Osx0Zm0M3G6BE7Pv8CWU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Xj2ZeLtlgpEjPmFUreH/KvhAAdb9n/5iwZKOTgxDLf0f5vktkR7ObHefMutJ7r9Zg
         c7zs9fztT9MNhoWn1hUET25/NhdzSj/FornYMl6pcRnvrMzKiiUo+b468cDf4a5T20
         ib408aFa1NJZ/ZJ/4s/MDbaAjU0a1y/e5mSEkYnvlePuyXPzh81L8u3MfZ+jm/B121
         qvci5qfpEzeYyqjXsjNywLuSqt7bZDPkAz+aWNlRngRGfyi9lmNzcst04bPNWu1fcl
         HwZ3eW/7fumvEawTK7BmdaucZs6BblRK7kwYAd4oKAB1pPB0D9M7/ZuTZKytfuqoTo
         PnYfXABHlFlyw==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-2dc348dab52so48300467b3.6;
        Wed, 09 Mar 2022 23:24:06 -0800 (PST)
X-Gm-Message-State: AOAM533NsbLYK7DmVqeYekNaCQ8Ab9xyGuMdWCaDMbwyCDSentMUvjTh
        YoF1QLQjKqUjJ9IrVPVPEhQkKn4nbhI3oUL2Zeg=
X-Google-Smtp-Source: ABdhPJztivIHZt1LSO3ecDEw2cDyy356CA0q99j4RlDlUKbN9ZCM+GwvdeIlei4RJa4EIepcy2jt1q2WhLyP1vQMVVM=
X-Received: by 2002:a0d:fb45:0:b0:2d0:d09a:576c with SMTP id
 l66-20020a0dfb45000000b002d0d09a576cmr2923865ywf.447.1646897045359; Wed, 09
 Mar 2022 23:24:05 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <YimfLJoWLKnnhLfR@infradead.org>
In-Reply-To: <YimfLJoWLKnnhLfR@infradead.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 9 Mar 2022 23:23:54 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4DJbvH5QZ5YMC4Ms4bd66UOFsLL=-yK8tQKrwreCfKDQ@mail.gmail.com>
Message-ID: <CAPhsuW4DJbvH5QZ5YMC4Ms4bd66UOFsLL=-yK8tQKrwreCfKDQ@mail.gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 10:48 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Mar 08, 2022 at 10:42:09PM -0800, Song Liu wrote:
> > RAID arrays check/repair operations benefit a lot from merging requests.
> > If we only check the previous entry for merge attempt, many merge will be
> > missed. As a result, significant regression is observed for RAID check
> > and repair.
> >
> > Fix this by checking more than just the previous entry when
> > plug->multiple_queues == true.
>
> But this also means really significant CPU overhead for all other
> workloads.

Would the following check help with these workloads?

 if (!plug->multiple_queues)
              break;

>
> >
> > This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> > 103 MB/s.
>
> What driver uses multiple queues for HDDs?
>
> Can you explain the workload submitted by a md a bit better?  I wonder
> if we can easily do the right thing straight in the md driver.

It is the md sync_thread doing check and repair. Basically, the md
thread reads all
the disks and computes parity from data.

Maybe we should add a new flag to struct blk_plug for this special case?

Song
