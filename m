Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93C6226E95
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 20:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgGTSzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 14:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGTSzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 14:55:54 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DADC061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 11:55:54 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id e18so14238435ilr.7
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 11:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FlzIBOC64fwM6IZTzOMQZVXjakvnkez1SRmk/mqAZb8=;
        b=uK1fPqsTDsXtxyQAcmH3LFricfO/N5csbRJtisfSNyVv5LU35FtnPgVQSWo5mS+wR5
         /ziDzA2dZmKZBQQbzKbb7t9LFHODzW1lJWQelwii0DidY8vKAJecbEH7htVhsR/CsiRD
         zhjx3Nrnf+9u9mQNtAKgPUluDqdLqKXsM9s7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FlzIBOC64fwM6IZTzOMQZVXjakvnkez1SRmk/mqAZb8=;
        b=ae5LykMy8Ghkvm4+sL9mglsyXONtgKPIOdHg2RZIxYMOzq4pWB3Nyzu3ju8mfH1d9h
         oAXiijpVBPGBDxG0YQ9b9ZCl750wQB0n3boxpSyUyv+hNCP0lc9+NrMYBcOA8STSUS08
         n7KyNTgev7z+byzWoJcDm9Gb8YdEUvuUQCAkiV3Dx0/AKyKDaI4Ye7+04/peogw5xpLQ
         2iCiu3jgJTD4YW3B1ROn9uai81+BM4EnY9cdF0AmUmy3rJv8QtXheAckCJbXoWVeO8D5
         /R9sTGe6rzKha5SYdRh2s7hXYCalmSQK9KHRqgzv+KTfs/K8F6vD1xTS53cP5qTLMHGE
         ljOw==
X-Gm-Message-State: AOAM5326eecJtayVq8rqa6R2uz6w+VYnCZu7SmGVQEvGEwD3jGvy5R5I
        Rkj9zlRNSJKCPjiRNh1K0r7xbK7x8WCPDxdPNbYPgbJFpYK3dw==
X-Google-Smtp-Source: ABdhPJx5b/BDLb+4gQ/xgW/0XyifxMyqE8yIKeMG0cLy2dTbP/W31SQE54F4cN7PPNeOrBzfbdBrQ9ArVGRsa0r01A4=
X-Received: by 2002:a05:6e02:4c6:: with SMTP id f6mr23615757ils.98.1595271353891;
 Mon, 20 Jul 2020 11:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200720152820.122442056@linuxfoundation.org> <20200720152822.437100100@linuxfoundation.org>
 <613577badc9937049d40ff14d11646f64b3dac36.camel@perches.com>
In-Reply-To: <613577badc9937049d40ff14d11646f64b3dac36.camel@perches.com>
From:   Matt Ranostay <matt.ranostay@konsulko.com>
Date:   Mon, 20 Jul 2020 11:55:43 -0700
Message-ID: <CAJCx=gmxHDm2Qhi8kXhSkpgrGc2-AKb7ymuU5oK+fcBqmQaROQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 047/215] iio:humidity:hdc100x Fix alignment and data
 leak issues
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Alison Schofield <amsfield22@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 9:50 AM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2020-07-20 at 17:35 +0200, Greg Kroah-Hartman wrote:
> > From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >
> > commit ea5e7a7bb6205d24371373cd80325db1bc15eded upstream.
> >
> > One of a class of bugs pointed out by Lars in a recent review.
> > iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
> > to the size of the timestamp (8 bytes).  This is not guaranteed in
> > this driver which uses an array of smaller elements on the stack.
> > As Lars also noted this anti pattern can involve a leak of data to
> > userspace and that indeed can happen here.  We close both issues by
> > moving to a suitable structure in the iio_priv() data.
> > This data is allocated with kzalloc so no data can leak apart
> > from previous readings.
> []
> > +++ b/drivers/iio/humidity/hdc100x.c
> > @@ -38,6 +38,11 @@ struct hdc100x_data {
> >
> >       /* integration time of the sensor */
> >       int adc_int_us[2];
> > +     /* Ensure natural alignment of timestamp */
> > +     struct {
> > +             __be16 channels[2];
> > +             s64 ts __aligned(8);
>
> Why does an s64 need __aligned(8) ?

This is due to on 32-bit x86 it is aligned to 4 bytes by default.

- Matt

> This seems needlessly redundant.
>
> Isn't this naturally aligned by the compiler?
>
> The struct isn't packed.
>
