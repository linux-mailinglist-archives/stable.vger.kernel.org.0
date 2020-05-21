Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42F1DC55A
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 04:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgEUCrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 22:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgEUCrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 22:47:45 -0400
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414332075F;
        Thu, 21 May 2020 02:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590029265;
        bh=b2qaZhDWuub/DIfryS6o+tqYInvj/LtFKeW0hqa6Us0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=olWdtJBIIbbZ+a3PAOmII6jLxrcAVNYAqT4qBVnjpX2wJR7tPO+dfN1Zl7eBp2hXC
         C2eQGeqVYeAJjaG37xSIICswMnMb6sh5/n4QUpOqcqWpJ1l3GXjujEcrC5fxz2IaXV
         FtA6Y5q/9Mzp8ap3aQLmqRbKxAJNv6jUeuqFKfbI=
Received: by mail-lj1-f173.google.com with SMTP id u15so6424594ljd.3;
        Wed, 20 May 2020 19:47:45 -0700 (PDT)
X-Gm-Message-State: AOAM533kt4Ls31BPlLIC/zqfDtIXhEP662IwjC89DGdN5Bdyh2usBSCc
        rs9cRllrootC5mWgHbfBxfLyJhI6CpKxCfu2hw8=
X-Google-Smtp-Source: ABdhPJyitI3a36aCNhRUeiD9xechDH7k8WloQw5lqEfZWuYuKPKujdCilgmgiBQMULx9GqqFzWMsE3oUrk/f4ibKaQM=
X-Received: by 2002:a2e:b609:: with SMTP id r9mr4082138ljn.125.1590029263392;
 Wed, 20 May 2020 19:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <lsq.1589984008.673931885@decadent.org.uk> <68f801f8-ceb2-13cf-ad29-b6404e2f1142@roeck-us.net>
In-Reply-To: <68f801f8-ceb2-13cf-ad29-b6404e2f1142@roeck-us.net>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Thu, 21 May 2020 10:47:33 +0800
X-Gmail-Original-Message-ID: <CAGb2v65AGb+4=+vRn2OdBx=fYXmZLFqASsyh-xh=ruCgbg92ng@mail.gmail.com>
Message-ID: <CAGb2v65AGb+4=+vRn2OdBx=fYXmZLFqASsyh-xh=ruCgbg92ng@mail.gmail.com>
Subject: Re: [PATCH 3.16 00/99] 3.16.84-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 5:23 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 5/20/20 7:13 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.84 release.
> > There are 99 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri May 22 20:00:00 UTC 2020.
> > Anything received after that time might be too late.
> >
> Build results:
>         total: 135 pass: 135 fail: 0
> Qemu test results:
>         total: 230 pass: 227 fail: 3
> Failed tests:
>         arm:cubieboard:multi_v7_defconfig:mem512:sun4i-a10-cubieboard:initrd
>         arm:cubieboard:multi_v7_defconfig:usb:mem512:sun4i-a10-cubieboard:rootfs
>         arm:cubieboard:multi_v7_defconfig:sata:mem512:sun4i-a10-cubieboard:rootfs
>
> The arm tests fail due to a compile error.
>
> drivers/clk/tegra/clk-tegra-periph.c:524:65: error: 'CLK_IS_CRITICAL' undeclared here (not in a function); did you mean 'CLK_IS_BASIC'?

This looks like a result of having

      clk: tegra: Mark fuse clock as critical
         [bf83b96f87ae2abb1e535306ea53608e8de5dfbb]

In which case you probably need to add

    32b9b1096186 clk: Allow clocks to be marked as CRITICAL

to the pile.


ChenYu
