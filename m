Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C1379AAF
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 23:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfG2VKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 17:10:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34082 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfG2VKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 17:10:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id p17so59983840ljg.1
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 14:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SLwaZEH25wNqGZTB2HC+4XfUpsEwrKsTiwJGEkrXZM0=;
        b=h0yQPRrjNKlXGfFBoWoylITmjbz4SK0JegbN37szOKfhSVCcgDFpmM6/f4t2Mu9tMG
         ZWd1EFVeGSDBJhC5biZ3ZtwATb2l99NNxnlGXA9y2m7IcmKrIXcPQs0AB2aVeLDcxgIp
         zH57jcOguVqz4e5oNCbnoYI9t15QxN/XOs5TE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SLwaZEH25wNqGZTB2HC+4XfUpsEwrKsTiwJGEkrXZM0=;
        b=C0Ns3w57J9PPyUM3hz7m+MhWSvFy5WpnI+29qmB3zxnvfAwrBE2IfOa7GQun0Akgu3
         kceKdWWh2dkfz5UfqAsrYJLtTCrC9KIdAkVif8l3movvq0T2dh+rn7uf22x6yTig6aob
         2Yb+b5jzV7gH0OEO+RSNec0yuy6KHTmhKwvnB1jlc3ire5JE69u91IcHwlWCM1xREhBH
         F3DqETlurHYo4PMh+sVJIGAEBZ1HZOYd8AgHzqLYySiGduU2J9A+Ky08RmRbfTARAoPT
         8btiUpP2/B0kr0k8DsPwgT75pinJwHv29JvrEKeTySdALWZ3j+okMhlGw70E26fCJV+f
         u/sw==
X-Gm-Message-State: APjAAAWbjkVup6A70UXfXD0PW8RLfcaroUE/dzWjKoYvsmhbfEtrTkiI
        2WEcQ6dKeaLBNhe6t5FWQ0EP8gredpI=
X-Google-Smtp-Source: APXvYqy/ILdtEilH/r1GiaKmsW/y41qdECxw/vDzlTBrO3Gyfafjoq0eF+dktMQzAvFDDyvkJqQg+Q==
X-Received: by 2002:a2e:959a:: with SMTP id w26mr47603390ljh.150.1564434652781;
        Mon, 29 Jul 2019 14:10:52 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id f24sm12174877lfk.72.2019.07.29.14.10.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 14:10:52 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id m8so26357625lji.7
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 14:10:52 -0700 (PDT)
X-Received: by 2002:a2e:80d6:: with SMTP id r22mr31685480ljg.83.1564434227544;
 Mon, 29 Jul 2019 14:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190729204954.25510-1-briannorris@chromium.org> <20190729205452.GA22785@archlinux-threadripper>
In-Reply-To: <20190729205452.GA22785@archlinux-threadripper>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 29 Jul 2019 14:03:35 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOOqOAWg9LnSPUs9d9Ai8G_4xkdUGC+CCduQQLBzC4kQA@mail.gmail.com>
Message-ID: <CA+ASDXOOqOAWg9LnSPUs9d9Ai8G_4xkdUGC+CCduQQLBzC4kQA@mail.gmail.com>
Subject: Re: [PATCH] driver core: platform: return -ENXIO for missing GpioInt
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Enrico Granata <egranata@chromium.org>,
        Enrico Granata <egranata@google.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 1:54 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
> On Mon, Jul 29, 2019 at 01:49:54PM -0700, Brian Norris wrote:
> > Side note: it might have helped alleviate some of this pain if there
> > were email notifications to the mailing list when a patch gets applied.
> > I didn't realize (and I'm not sure if Enrico did) that v2 was already
> > merged by the time I noted its mistakes. If I had known, I would have
> > suggested a follow-up patch, not a v3.
>
> I've found this to be fairly reliable for getting notified when
> something gets applied if it is a tree that shows up in -next.
>
> https://www.kernel.org/get-notifications-for-your-patches.html

I didn't send the original patch. I was only debugging/reviewing
someone else's patch, and jumped in after its authorship (as it hit
issues in our own CI system). So it was more of a "drive-by" scenario,
and it doesn't sound like that page addresses this situation.

Brian
