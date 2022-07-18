Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD5F57870E
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 18:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiGRQMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 12:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiGRQMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 12:12:33 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D652A73D;
        Mon, 18 Jul 2022 09:12:33 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id z12-20020a056830128c00b0061c8168d3faso7764737otp.7;
        Mon, 18 Jul 2022 09:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E97tihP8HnbI/adEmvxCjiADzk+ycuYUVPz4eAZufX8=;
        b=lOi8HISE/WBi5tBpHSDKX3uf5I0ag7Z1hcOUqSfQsB8WgpjH3j8/f/QZYOmeGQkOhA
         lwozyxjT0ude+8GMBFlz/OfdEJ0fgqyxhc5hXKGWnU974ZRj8J3gJyIn088PRUPPMeli
         7u63BA9EauP4odKcKxI+kNwvnSIPUFZ6ojJlctIrDF5ENk9li+0VgBVZiFLBPInvIF4l
         mHbO0g96xEk1O69Jnuguv9jPFqcgl0VAJKMa+LmsLgfNCl2vh04RnUvC7SYd0Yoo46ff
         e95p9xsn6okMoIFy90b/PqkGyFsBOzYOtX+4dc77F+bA1hApG4OKsN86g7prXbyYJ8SI
         TpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E97tihP8HnbI/adEmvxCjiADzk+ycuYUVPz4eAZufX8=;
        b=RXW7Iz8A7oncaSuUdwMnvrHYQtvwg/QppaLcui+8h+yQE0azv3cjNNIvLtrwNQWQ2r
         Li2tKasRY9fZClAc48SFo8vTDpH1JfwdIJtEX0Ja510u35HLwx30e4zUe8zpl5mSKNVj
         DhpC6LK5D5bKa7g/ncTJUlDPRa6EjsqBgSRs/82G+CIdWoq3Vr5B7jy9+HJ073ejrYG2
         OI1N6dvCpvelcjDIwDLP+3if2SbfrBgwzjpnUQM1NUFasQ4+lmceVnoPSU0EEloNIg8x
         9UWg6d1/UP8yksqRoHqribdohu9l6lqcv4wjgH5Y7ZNbS4HxiL6xG9dvOLhPRlcBLfrg
         9cKw==
X-Gm-Message-State: AJIora93pTf8LDkyAw4r18lmsOUefOiRTZa5gEg989K8OCaGfMKuBEZ7
        +flQaA2kJ4cCbsQZMNVFB/bl7I/z4MBmh9BTznE=
X-Google-Smtp-Source: AGRyM1u8zj1bV71F06iwCAEO/iNocAMe7lhHQUtETzV61a63N8I6/58X5nFZOsMn33gIduBYquoztm6MVS22Txbp7qE=
X-Received: by 2002:a9d:7855:0:b0:61c:814f:a7e9 with SMTP id
 c21-20020a9d7855000000b0061c814fa7e9mr7458227otm.315.1658160752397; Mon, 18
 Jul 2022 09:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220715225108.193398-1-sj@kernel.org>
In-Reply-To: <20220715225108.193398-1-sj@kernel.org>
From:   Andrii Chepurnyi <andrii.chepurnyi82@gmail.com>
Date:   Mon, 18 Jul 2022 19:12:21 +0300
Message-ID: <CAJwUmVDFPV-cunSVQyLQ2Lk2_pXiAnW+cGSGFQBUaBcq=PxpBQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] xen-blk{back,front}: Fix two bugs in 'feature_persistent'
To:     SeongJae Park <sj@kernel.org>
Cc:     roger.pau@citrix.com, axboe@kernel.dk, boris.ostrovsky@oracle.com,
        jgross@suse.com, Oleksandr <olekstysh@gmail.com>, mheyne@amazon.de,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello SeongJae,

Thanks for the efforts.
I've tested backend patches(1,2) on my custom 5.10 kernel (since I
can't test on vanilla) and it works for me.

Best regards,
Andrii


On Sat, Jul 16, 2022 at 1:51 AM SeongJae Park <sj@kernel.org> wrote:
>
> Introduction of 'feature_persistent' made two bugs.  First one is wrong
> overwrite of 'vbd->feature_gnt_persistent' in 'blkback' due to wrong
> parameter value caching position, and the second one is unintended
> behavioral change that could break previous dynamic frontend/backend
> persistent feature support changes.  This patchset fixes the issues.
>
> Changes from v3
> (https://lore.kernel.org/xen-devel/20220715175521.126649-1-sj@kernel.org/)
> - Split 'blkback' patch for each of the two issues
> - Add 'Reported-by: Andrii Chepurnyi <andrii.chepurnyi82@gmail.com>'
>
> Changes from v2
> (https://lore.kernel.org/xen-devel/20220714224410.51147-1-sj@kernel.org/)
> - Keep the behavioral change of v1
> - Update blkfront's counterpart to follow the changed behavior
> - Update documents for the changed behavior
>
> Changes from v1
> (https://lore.kernel.org/xen-devel/20220106091013.126076-1-mheyne@amazon.de/)
> - Avoid the behavioral change
>   (https://lore.kernel.org/xen-devel/20220121102309.27802-1-sj@kernel.org/)
> - Rebase on latest xen/tip/linux-next
> - Re-work by SeongJae Park <sj@kernel.org>
> - Cc stable@
>
> Maximilian Heyne (1):
>   xen-blkback: Apply 'feature_persistent' parameter when connect
>
> SeongJae Park (2):
>   xen-blkback: fix persistent grants negotiation
>   xen-blkfront: Apply 'feature_persistent' parameter when connect
>
>  .../ABI/testing/sysfs-driver-xen-blkback      |  2 +-
>  .../ABI/testing/sysfs-driver-xen-blkfront     |  2 +-
>  drivers/block/xen-blkback/xenbus.c            | 20 ++++++++-----------
>  drivers/block/xen-blkfront.c                  |  4 +---
>  4 files changed, 11 insertions(+), 17 deletions(-)
>
> --
> 2.25.1
>
