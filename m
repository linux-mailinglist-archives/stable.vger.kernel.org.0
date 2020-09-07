Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F4C25F218
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 05:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgIGDfm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 6 Sep 2020 23:35:42 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:41450 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgIGDfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Sep 2020 23:35:40 -0400
Received: by mail-ej1-f67.google.com with SMTP id lo4so16273869ejb.8;
        Sun, 06 Sep 2020 20:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nMTwZ+Li11GDtkKJOTkb9oea+Prun/Hf62+vO8ipsII=;
        b=PDSCqsz0uYCrWcnD4IqVa2AvWJ4Y1dxpQgf6mHsxQxxFojUxemw6gUrNEMZlFHlLSI
         S+/dxd9TEKPguJwz3u6iHKPeTY/2UPaS7GCn4OOx4vTU+VQaL3rMw6IRwbnc5+34VQW/
         6iCLOtdU8Zpcmv4LarnWTioA9WO68Lxl6+1iNZZTdZiSFuxGtYau52bU6zkFk3H6GyLd
         a1SrAMbZaqNb1ofQNZFv/3b0bVWPWmjUUNDCPXw9Jdq26bvE9MAEMIbaFet5GyhQrsOx
         wu6ZBw8EfCKHu/Ru9ekuuomnZCDOCxXCMUS4PYgS5xo3JtAvhEgAn8FLvoyKrlU/2dRS
         OWbQ==
X-Gm-Message-State: AOAM531DbMs/4FqMSYiDGrW6MjBapuYSbjRVZOU7nSu902aIRxUcvrsJ
        NXMHdHyg1wZtTo0cvH7ZQ1SNj2KbF8wHR1MtV8g=
X-Google-Smtp-Source: ABdhPJyAMlbkMn8iebAa2zLz97/J3SbgJpItd8qMZ+Mj9E7iiT1O1ohkKk0Nn5AzTfhpxtlGE1SoG9Qq1b0YIxFqpKU=
X-Received: by 2002:a17:906:724b:: with SMTP id n11mr13401178ejk.328.1599449738257;
 Sun, 06 Sep 2020 20:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191016214805.727399379@linuxfoundation.org> <20191016214845.344235056@linuxfoundation.org>
 <20200826210628.GA173536@roeck-us.net> <20200903092621.GB2220117@kroah.com>
In-Reply-To: <20200903092621.GB2220117@kroah.com>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Mon, 7 Sep 2020 05:35:26 +0200
Message-ID: <CAAdtpL5ZPh4dBTVg57iF+PzOGFujvaNFxN4F_nEtAbB+=OGvhg@mail.gmail.com>
Subject: Re: [PATCH 4.19 66/81] MIPS: Disable Loongson MMI instructions for
 kernel build
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 3, 2020 at 11:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 26, 2020 at 02:06:28PM -0700, Guenter Roeck wrote:
> > Hi,
> >
> > On Wed, Oct 16, 2019 at 02:51:17PM -0700, Greg Kroah-Hartman wrote:
> > > From: Paul Burton <paul.burton@mips.com>
> > >
> > > commit 2f2b4fd674cadd8c6b40eb629e140a14db4068fd upstream.
> > >
> > > GCC 9.x automatically enables support for Loongson MMI instructions when
> > > using some -march= flags, and then errors out when -msoft-float is
> > > specified with:
> > >
> > >   cc1: error: ‘-mloongson-mmi’ must be used with ‘-mhard-float’
> > >
> > > The kernel shouldn't be using these MMI instructions anyway, just as it
> > > doesn't use floating point instructions. Explicitly disable them in
> > > order to fix the build with GCC 9.x.
> > >
> >
> > I still see this problem when trying to compile fuloong2e_defconfig with
> > gcc 9.x or later. Reason seems to be that the patch was applied to
> > arch/mips/loongson64/Platform, but fuloong2e_defconfig uses
> > arch/mips/loongson2ef/Platform.
> >
> > Am I missing something ?
>
> I don't know, sorry, that would be something that Paul understands.
>
> Paul?

Cc'ing Thomas who now maintains this.
