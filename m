Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4676883D44
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfHFWSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:18:20 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38630 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfHFWSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 18:18:20 -0400
Received: by mail-lj1-f195.google.com with SMTP id r9so83561908ljg.5
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 15:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bgewXXxxhY/dAfBGFMPvrzGizAhrJK4ewhsHFFY/ZXc=;
        b=S7Xmi1DIjpcc1NyZ1euHM9kbzVqM1CVov4LeTusvdshoFAvVWX2NW0xhDTbpTxPMrD
         F7/LCPShWklAmxPw+ZcI2kxGXmv9K9+L08AoQI9dFlQYVFnOYSub7m4UKm1+siM0tYEg
         QVqSH1iJP+cLOAbmK71a2wYQT7CyhUoE2UeVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bgewXXxxhY/dAfBGFMPvrzGizAhrJK4ewhsHFFY/ZXc=;
        b=H6Y1CVXT72CsKkWFb9l1+sizAY0DcO7GqHwk6qcweJ+w+rrp86o3r39GOeRs+Kw6/5
         qTnQjpYD4HnZp3/1qYAtCMI93HJwLvHpKk5hrNe+BCz4bgk+aWh6vqhlBxcZ7+ebqXnm
         hPaDciudUlJvWHV0/dyi9KPf+/cQJaVbEY+PZVKuduia4n2ZOj5sV83lQwN3qCXwK0ol
         Nmg6UUc96fu2sSXoSrnAPAC9wYXhcLwKuURoF8yR1KNLbNldFxJ9jiWPu/KDpjsOLm+t
         ALImHTjtiPTNbKH1VnQOfgqv0Whx0ifh10aoaX4tO08XoaZrQpV1qVg+Aqvux5ut5Bzg
         w7wQ==
X-Gm-Message-State: APjAAAWYKIgLetZKv0N42A0I/tZNW8HObyuz/Sn7cYvEsDi5Ipfzpby9
        7tRH7vF1Bop9DIOqpHq9SlOSygUn5g8=
X-Google-Smtp-Source: APXvYqxCgqpwJcLQA5EXLPnLWfUgom3dEycn/gPBmEMe9SYmLLRs+/6/+cQB0oklyi93JS73P4vOug==
X-Received: by 2002:a2e:9ac6:: with SMTP id p6mr3031745ljj.100.1565129898276;
        Tue, 06 Aug 2019 15:18:18 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id p13sm18081087ljc.39.2019.08.06.15.18.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 15:18:18 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id y17so59015981ljk.10
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 15:18:18 -0700 (PDT)
X-Received: by 2002:a2e:3602:: with SMTP id d2mr3006585lja.112.1565129417010;
 Tue, 06 Aug 2019 15:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190729204954.25510-1-briannorris@chromium.org>
In-Reply-To: <20190729204954.25510-1-briannorris@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 6 Aug 2019 15:10:05 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPZxD6D2P_7vucseZS=Fe8KDEyNGvNQySvJYu_-fGxk5A@mail.gmail.com>
Message-ID: <CA+ASDXPZxD6D2P_7vucseZS=Fe8KDEyNGvNQySvJYu_-fGxk5A@mail.gmail.com>
Subject: Re: [PATCH] driver core: platform: return -ENXIO for missing GpioInt
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
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

On Mon, Jul 29, 2019 at 1:50 PM Brian Norris <briannorris@chromium.org> wrote:
> Side note: it might have helped alleviate some of this pain if there
> were email notifications to the mailing list when a patch gets applied.
> I didn't realize (and I'm not sure if Enrico did) that v2 was already
> merged by the time I noted its mistakes. If I had known, I would have
> suggested a follow-up patch, not a v3.

I guess I'll be the bot this time: 'twas applied by Greg on Tuesday,
July 30 UTC-07:00.

Thanks,
Brian
