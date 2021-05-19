Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058FE38948C
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 19:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347529AbhESRUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 13:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355588AbhESRUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 13:20:12 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03940C061761
        for <stable@vger.kernel.org>; Wed, 19 May 2021 10:18:51 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n2so14909755wrm.0
        for <stable@vger.kernel.org>; Wed, 19 May 2021 10:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDQCnbN9p8nGYFnP7zGzyPaYUIlASl3Vevk9KJVbp14=;
        b=Rl3byIPUtLg3jyGQF3DcL6td+txCitWUVztvYmvYIP7ENpAlL4aCeNCWRSaXJgPg94
         DrY6pl1jz3aA8L3wlj6mi3dt9heetbQgJjGrpuMMacMe5rmvy1J4iI1/aqZGvxLb4n8v
         epzbIXfLe4DVbiI4Ywvxxvb2BECPN4nFFjurqDtasS5gEDFPBTNfG2XEr8dJgnd0HGIy
         ezLAIJjU3rSew7IXqN9287Kv6EeF7a4rOs4cOfyYhc8JuOxD+q+pe6Al8wur9QXD75n2
         G1ZQtMd0YW2TILch7cAGCszpOEkBQNTFTaxMxV48TYlL8CUb4+FXbasTylowEb4Y5b7P
         9t9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDQCnbN9p8nGYFnP7zGzyPaYUIlASl3Vevk9KJVbp14=;
        b=jnX5XrDW51j52sxRyCWRcB7h+Gek2VfOKis8uod4YG8JsqclAHDqRoOJuciKZcnXB1
         9crFJAKHQ6jA3IpG6D7Tj5wO0GDUplAPxj1kEkvEumgquGJ1XC/SvVvhYYA/st0duksS
         mYG0JB8Q7f7RPowXvBpZeDPHUyMlmYcObIo9fSfMrRQlbJ9C0CsKp4/+WdWg7RcYydvm
         3qdE4BHeqVJPX1o8+h2fLij4FD01z6QvCAb9G4QwXnXk20wnd+pU3itFiee4ulu8bTty
         1SZtUIqse4ehzcgHL4K0r1LzzdPdwqjy/a+O2Syy2NGbQwh2+Rf9D0sEpjQ39V86QBb7
         SQEA==
X-Gm-Message-State: AOAM530U4uI0ydoLyVWuDLIqpM1qZcSA9WWVEXmc9GPOXquCuearKc0R
        vHfAs2RBcJlgt+57oW8MNFeOXssust+7jakd8cPhmbW/xzE=
X-Google-Smtp-Source: ABdhPJyK0HbGvdvu7FYxno4iWwDyWm6CgV5BTTd9jy8DgxSV7E3xpb6VP6nC01KSDid+xhBMDMUxvsLtwAdwEnNruVM=
X-Received: by 2002:adf:9069:: with SMTP id h96mr17071wrh.322.1621444729456;
 Wed, 19 May 2021 10:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com> <YKTIJsD2KmiV3mIb@kroah.com>
 <CAMGD6P1FBwYBnVPPSFtn0qgHbs+y=stZXhnYHjX82H+vqei+AQ@mail.gmail.com> <YKVE2kerpTzoeIL+@kroah.com>
In-Reply-To: <YKVE2kerpTzoeIL+@kroah.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 19 May 2021 10:18:38 -0700
Message-ID: <CAA03e5E9ojmsVNcHK4MyuYKCCFLo-RTFa17dA5Ay5v9rCMH+kg@mail.gmail.com>
Subject: Re: [PATCH 5.4 v2 0/9] preserve DMA offsets when using swiotlb
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jianxiong Gao <jxgao@google.com>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 10:03 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, May 19, 2021 at 09:42:42AM -0700, Jianxiong Gao wrote:
> > On Wed, May 19, 2021 at 1:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > I still fail to understand why you can not just use the 5.10.y kernel or
> > > newer.  What is preventing you from doing this if you wish to use this
> > > type of hardware?  This is not a "regression" in that the 5.4.y kernel
> > > has never worked with this hardware before, it feels like a new feature.
> > >
> > NVMe + SWIOTLB is not a new feature. From my understanding it should
> > be supported by 5.4.y kernel correctly. Currently without the patch, any
> > NVMe device (along with some other devices that relies on offset to
> > work correctly), could be broken if the SWIOTLB is used on a 5.4.y kernel.
>
> Then do not do that, as obviously it never worked without your fixes, so
> this isn't a "regression".

NVMe + SWIOTLB works fine without this bug fix. By fine I mean that a
guest kernel using this configuration boots and runs stably for weeks
and months under general-purpose usage. The bug that this patch set
fixes was only encountered when a user tried to format an xfs
filesystem under a RHEL guest kernel.

> And again, why can you not just use 5.10.y?

For our use case, this fixes the guest kernel, not the host kernel.
The guest distros that we support use 5.4 kernels. We do not control
the kernel that the distros deploy for usage as a guest OS on cloud.
We only control the host kernel.

Thanks,
Marc
