Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAD6389730
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 22:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhESUC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 16:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbhESUC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 16:02:58 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D3CC06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 13:01:38 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r12so15291751wrp.1
        for <stable@vger.kernel.org>; Wed, 19 May 2021 13:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UqxJhROgCdHv2R4GLe0/Ml0AZb6NMN8WrjXihP3r7Y4=;
        b=CvjMiYNKGnT53f/Q6vnMnn1O+2AU6M1tt0sis8zOFEd0/NKO3J1QdtGv85iAF7tPTk
         EJ1I73kzCWkqxmEy4RrLUwIhnWHg5KhPDPaNNh8JEfjG8cXz8mrYZ8ZKjfKam+bUl/6z
         tGZTEZTFVENyWDqN/1MLtSlsi5c6yruxlAgQNGEyiP+e8XxChKDUiCm2Rh2GtvHf1AM5
         BLJHiTZHFQK2vemtMuWDtbIDfQBfSat6S5pPmj+YcTO2p8Ae4BpQheEfDDNH5d+R7dZM
         8g7SaGSTpSNedgx4P0SGXMakB7J3Zv6CAV7GdNW274C0EdJWiWNfMsuHWHySzXKWZTbj
         3Z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UqxJhROgCdHv2R4GLe0/Ml0AZb6NMN8WrjXihP3r7Y4=;
        b=gwlW1gc8chcOTyMI8+P0zju3RTSwtj06TPBONH8duAB2rLGMoiEOXVA1xz1chBrcLS
         KkRhwW4svICJl+nK8oz3XIT1PL79yB3EIXLiojQtuej8lETxMCT09Eme9ouP1xe8hKYm
         WplffxDFwKqukq3H1/H2jXOYN+ZxPofdUUQ6uUwjpXwd9mqoWnTlo+HvIhceLBYiZowg
         utbeUuUqycdTdNGbXQ/Bf9kM/Rz3hhZbpDx0Nu8NI8B9WrdNFf3cR/OIh5J/JvchlDL1
         wSnFonrcR4rPPGm8O1icNSEX1mZbCYzSdCsxBQ1utY1yQBG8GsmrhD+WVWphjkEnUZL3
         fljw==
X-Gm-Message-State: AOAM530veVY4akvMvJ2jlVRHliSOtRJPqAu22Kj5NxVadmrnWM5rFqoF
        QqdxCkwl455ZsgAQGp2mlgP9sh9+zoHcRPduFrL10w==
X-Google-Smtp-Source: ABdhPJynDv81R9Rci7tyRy/dcCW/y6XB+8vQUZ9R/2GQO8OJrSTJ8gHszbw9apj+A+LnE6EBATyWvKL+vAshVlDvHEs=
X-Received: by 2002:a5d:5052:: with SMTP id h18mr584914wrt.365.1621454496470;
 Wed, 19 May 2021 13:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com> <YKTIJsD2KmiV3mIb@kroah.com>
 <CAMGD6P1FBwYBnVPPSFtn0qgHbs+y=stZXhnYHjX82H+vqei+AQ@mail.gmail.com>
 <YKVE2kerpTzoeIL+@kroah.com> <CAA03e5E9ojmsVNcHK4MyuYKCCFLo-RTFa17dA5Ay5v9rCMH+kg@mail.gmail.com>
 <YKVJ7vjUmIUAmdC0@kroah.com>
In-Reply-To: <YKVJ7vjUmIUAmdC0@kroah.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 19 May 2021 13:01:25 -0700
Message-ID: <CAA03e5Fe7LZcQ3pwhaVCG-mMWeyfr1VyYjmM8tLkVbzOcAiECg@mail.gmail.com>
Subject: Re: [PATCH 5.4 v2 0/9] preserve DMA offsets when using swiotlb
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jianxiong Gao <jxgao@google.com>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 10:25 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, May 19, 2021 at 10:18:38AM -0700, Marc Orr wrote:
> > On Wed, May 19, 2021 at 10:03 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, May 19, 2021 at 09:42:42AM -0700, Jianxiong Gao wrote:
> > > > On Wed, May 19, 2021 at 1:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > I still fail to understand why you can not just use the 5.10.y kernel or
> > > > > newer.  What is preventing you from doing this if you wish to use this
> > > > > type of hardware?  This is not a "regression" in that the 5.4.y kernel
> > > > > has never worked with this hardware before, it feels like a new feature.
> > > > >
> > > > NVMe + SWIOTLB is not a new feature. From my understanding it should
> > > > be supported by 5.4.y kernel correctly. Currently without the patch, any
> > > > NVMe device (along with some other devices that relies on offset to
> > > > work correctly), could be broken if the SWIOTLB is used on a 5.4.y kernel.
> > >
> > > Then do not do that, as obviously it never worked without your fixes, so
> > > this isn't a "regression".
> >
> > NVMe + SWIOTLB works fine without this bug fix. By fine I mean that a
> > guest kernel using this configuration boots and runs stably for weeks
> > and months under general-purpose usage. The bug that this patch set
> > fixes was only encountered when a user tried to format an xfs
> > filesystem under a RHEL guest kernel.
> >
> > > And again, why can you not just use 5.10.y?
> >
> > For our use case, this fixes the guest kernel, not the host kernel.
> > The guest distros that we support use 5.4 kernels. We do not control
> > the kernel that the distros deploy for usage as a guest OS on cloud.
> > We only control the host kernel.
>
> And how are you going to get your guest kernels to update to these
> patches?  What specific ones are you concerned about?
>
> RHEL ignores stable kernel updates, so if you are worried about them,
> please just work with that company directly.

We support COS as a guest [1], which does base their kernel on 5.4
LTS. If these patches were accepted into 5.4 LTS, they would
automatically get picked up by COS.

[1] https://cloud.google.com/container-optimized-os

Thanks,
Marc
