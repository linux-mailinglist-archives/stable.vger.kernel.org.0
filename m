Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5DA2EEAA5
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbhAHBBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbhAHBBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:01:49 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEA2C0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 17:01:09 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id j17so7876151ybt.9
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 17:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/P7ZZM4ofuWIA4Z9kNDbpxnZxWc1UDny2fHMN28PyvY=;
        b=jddN2onR7BwhOKfW+091rXuUnJ89PUpYp7/2+ZPpNP8AaUVGtW3n7+x09XxtOHjttr
         9lAJ7+M5+DJ3LMBu4At8gjg+AlMjfdDW8KUlLDci4MXW4jtQFkj3GOlGCsGZVnrFGWMZ
         y9P4dHW/6638+DaTAr3pI3GHaJAhNep+OGROVha4MpymTGURySrn7O38e8f9MXWcGTHm
         A8Jy56AsO3lVu0UstCH9qqwB9YUmVWVY13+NvL2gFssqXYrAeIlo5LUCOiefiByV6GBF
         zUgz3fwD2ymO8kxUDNUIk3cnHT0kqDWr8etfTIk6cpG8GRy1HFcwC94sN+V8/auYllSc
         DhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/P7ZZM4ofuWIA4Z9kNDbpxnZxWc1UDny2fHMN28PyvY=;
        b=N2U6Igcd3ZGMkE7xFyXNzfzRoBkWPF4dNZoCUCzlq4rA5xAoMkrmGlgu1FpNXioe93
         auAaMOQ2Hka6OdsP3w9owtnPctre0qNQOhjUXsOuPyTQgq/gFvWslEgvt3MMtbaOBLZ1
         MA+BWyjLeJCPxF/zr2Fmjv/nt9IJkiz0a4hx+O/K9JjW11NgUx0Xp4aUPId3tjayF0wT
         sQNGrUAH5vqp6fgdukVUaCwrRKzeit1rpARp64CZMiPzHqKKUoB3VychGArB+pLKSr6x
         pbYx3jIgA2GYpZni/0O5tW/8pLYJI5rZRhW08FWqddK4ijQCkNdCyGbsnDMH7OSSLtWE
         LjEw==
X-Gm-Message-State: AOAM533Os99uEl1DEYVR3f/w5l/P8wdxjxzcFtKj1gdrwaBcRiI04jtZ
        z0hT4AbU91XMVW2W5prd+ijpcAgRhmnidEBpHyHleQ==
X-Google-Smtp-Source: ABdhPJyIkIJWAnqL2BZraYNLirI9O5lRPwlYEJv/lE3m0NMPYkRFYVCGb3QcRUzeu4soEsiPrjwhM5bC+7FP8wapRG4=
X-Received: by 2002:a25:6604:: with SMTP id a4mr2394920ybc.412.1610067668778;
 Thu, 07 Jan 2021 17:01:08 -0800 (PST)
MIME-Version: 1.0
References: <20210107234136.740371-1-saravanak@google.com> <b3cda25a3e3911a12a8766f141c9e300@walle.cc>
 <CAGETcx-q04E0TW6LMoyoRC64xH25Uogk7twSNEbT411ciZPfUw@mail.gmail.com>
In-Reply-To: <CAGETcx-q04E0TW6LMoyoRC64xH25Uogk7twSNEbT411ciZPfUw@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 7 Jan 2021 17:00:32 -0800
Message-ID: <CAGETcx_CJjOxim+CEptLRSgfYAKHBbP8rHW7BY+U7-X+L2eObg@mail.gmail.com>
Subject: Re: [PATCH v2] driver core: Fix device link device name collision
To:     Michael Walle <michael@walle.cc>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 7, 2021 at 4:43 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Thu, Jan 7, 2021 at 4:14 PM Michael Walle <michael@walle.cc> wrote:
> >
> > Am 2021-01-08 00:41, schrieb Saravana Kannan:
> > > The device link device's name was of the form:
> > > <supplier-dev-name>--<consumer-dev-name>
> > >
> > > This can cause name collision as reported here [1] as device names are
> > > not globally unique. Since device names have to be unique within the
> > > bus/class, add the bus/class name as a prefix to the device names used
> > > to
> > > construct the device link device name.
> > >
> > > So the devuce link device's name will be of the form:
> > > <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> > >
> > > [1] -
> > > https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 287905e68dd2 ("driver core: Expose device link details in
> > > sysfs")
> > > Reported-by: Michael Walle <michael@walle.cc>
> > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > > ---
> >
> > This makes it even worse. Please see below for a full bootlog with the
> > dev_dbg() converted to dev_info() and initcall_debug enabled.
>
> Sorry if I'm missing something obvious (been a long day), but how is
> it worse? I don't see any warnings in this log. I'll reply to your
> other emails separately.
>

Nevermind, I see it now. Also, in the future, if you can dump the logs
in some kind of pastebin site, that'd be nice. Avoid the emails
becoming unwieldy and also avoids the log lines from wrapping.

-Saravana
