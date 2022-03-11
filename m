Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E9A4D66F8
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 17:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350413AbiCKRAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 12:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350414AbiCKRAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 12:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7045694B8;
        Fri, 11 Mar 2022 08:59:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E63C61D85;
        Fri, 11 Mar 2022 16:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6251C340EE;
        Fri, 11 Mar 2022 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647017957;
        bh=TfUoDniLNAUWpN5c0ZvcL19CsqAGIJipVHp+JX8IZYU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IGNZyrBivI/tTqZCSj1SnNnLybgw7ILcz/GOPJIbv9s5TofQZKuRam1jdoh8quoAH
         RpfhJqKAOuD+BMhM98wO11QJaJCPGonkuOORU0/BvxI/Cm4Y/5+NLoASTIy1tIrCId
         1UPuuHbLLcwa7If6D3lkZj0Dc4vjDL0GPjeZzh1zASE22jHf5EfN2pv0ViRm52ePDk
         hF/Tt9Ob0GO16bmDuA7zZAWSdjYkAdFOVMpzzHJStzsoIqYVP/obqTM+ArqCqytbpd
         HAIxODjbQgivDWVj8xIhAc7chRx3TxvHcKeIdo6vSpQ8l2FFUkl0+pICp1EZYxF0TP
         euJFwelKIZxmw==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2dc348dab52so100167267b3.6;
        Fri, 11 Mar 2022 08:59:17 -0800 (PST)
X-Gm-Message-State: AOAM532Z4Mk9g0rl+RDeGxH38EjAA1flOcSiVIVwutt5yD1yF8lUS6Z2
        xNIUNh4nc3qoUljz2rKooBBuS2oQZJkWfmxP7ko=
X-Google-Smtp-Source: ABdhPJyjs53YNBDzki/gNd5IjlxDqN3gpH+kRPQ8Tg0rq78PB5ym7q5nPhRgFnuoO2cOP4YEesEHrF0VH/xjHrloqiw=
X-Received: by 2002:a81:23ce:0:b0:2dc:b20:cc73 with SMTP id
 j197-20020a8123ce000000b002dc0b20cc73mr9213650ywj.130.1647017956691; Fri, 11
 Mar 2022 08:59:16 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk> <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk> <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
In-Reply-To: <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Fri, 11 Mar 2022 08:59:05 -0800
X-Gmail-Original-Message-ID: <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
Message-ID: <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
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

Hi Jens,

On Fri, Mar 11, 2022 at 6:16 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/10/22 5:07 PM, Jens Axboe wrote:
> > In any case, just doing larger reads would likely help quite a bit, but
> > would still be nice to get to the bottom of why we're not seeing the
> > level of merging we expect.
>
> Song, can you try this one? It'll do the dispatch in a somewhat saner
> fashion, bundling identical queues. And we'll keep iterating the plug
> list for a merge if we have multiple disks, until we've seen a queue
> match and checked.

This one works great! We are seeing 99% read request merge and
500kB+ average read size. The original patch in this thread only got
88% and 34kB for these two metrics.

Thanks,
Song

[...]
