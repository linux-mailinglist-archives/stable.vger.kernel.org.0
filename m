Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424341E6C70
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 22:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407005AbgE1UZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 16:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407174AbgE1UZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 16:25:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC53C08C5C9
        for <stable@vger.kernel.org>; Thu, 28 May 2020 13:25:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so125692pgn.5
        for <stable@vger.kernel.org>; Thu, 28 May 2020 13:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3jEHb7o98C7LTydu7uW3451vfLZG6eEw40N/JKdaSjg=;
        b=hFQtq2Z/UkexUJS87ZXMK5dd/I/61tAxxU1YqXREhFrJ6CQLI+Oiq2KvJWPM4AcVga
         pq/Xzk2fGahlqcUQTUmZPtMsZtxMZtbXNBqs4I/bmIcdGW/kplEMxsqqV8jZpUkL3LPQ
         vxe8xlt4/lDvYm9ucASaaP1IfnlIToCEXzKtbDae0BuzgI1b6NHVNOUCNBaP4Jiwqwnq
         J0i1CzReH3lwCpwSDq8xygbEzj4VlzMTTLL8/EbnZPBaz3bI6cjYs2mzwiZP/1ZwaD3d
         tgIAJ1JGTX0PfSLd/pF9uqp3cRFa4EYFHPfqLB/ZViDskZBrjzNEzh7A9SVYcQmoMPjN
         7Nuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3jEHb7o98C7LTydu7uW3451vfLZG6eEw40N/JKdaSjg=;
        b=MmlLk+Ro9RZiYd+LV2E1fngb6lFCnoytmBy0RSnjM9LMatW2OjqM6TydoDX8ueWFPj
         IeU8EIXhN4TboIF/DMfG+p17tqNh/ANcA26Bhfk7513Trz+yHw0S/lk57LWHmfq4wSMV
         b8/+Gn9qXYx5+e0weBlmvBuAz1VWAdwU7gk2ohlcexLbcCBEeJ1rEOt+NxcCqLMExeFx
         0Wfe3oUECDP4Zz+Mia0Tm3I1Fm4Twqc5PJX8/xFUcOKqeHYGWGZL9U9v+byk+hHK4RTS
         uoZRDNpf9VzK/qQsC9RLKUeSblIweJNO3xKfBx35TfqoL06ADWt+nb5QIFuaq+48Kres
         V/CQ==
X-Gm-Message-State: AOAM531kgnZ9OSj/fSyjzQQ0Ta+s7TfCaDIRV8ZqcGP0dv5bX7r4Z41F
        hNgnMb9lXr5YA3bpWfRZdAgxeLAQ0cU1kSCQhDeCLA==
X-Google-Smtp-Source: ABdhPJw764Ssi01594KZzzLA4OtCp+IzpMdl6N6pdx/zUmHna7Zf+b7Og+jP/IpOd66J086hTbZTWNc6A47FHKkJIUs=
X-Received: by 2002:a63:d04b:: with SMTP id s11mr4561837pgi.384.1590697521912;
 Thu, 28 May 2020 13:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200524153041.2361-1-gregkh@linuxfoundation.org>
In-Reply-To: <20200524153041.2361-1-gregkh@linuxfoundation.org>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Thu, 28 May 2020 13:25:10 -0700
Message-ID: <CAFd5g45xJMgQ6AWgVxw0qQZw7g=jbfqNfUKpzbQre1rNYVZ5YQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] software node: implement software_node_unregister()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 24, 2020 at 8:31 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Sometimes it is better to unregister individual nodes instead of trying
> to do them all at once with software_node_unregister_nodes(), so create
> software_node_unregister() so that you can unregister them one at a
> time.
>
> This is especially important when creating nodes in a hierarchy, with
> parent -> children representations.  Children always need to be removed
> before a parent is, as the swnode logic assumes this is going to be the
> case.
>
> Fix up the lib/test_printf.c fwnode_pointer() test which to use this new
> function as it had the problem of tearing things down in the backwards
> order.
>
> Fixes: f1ce39df508d ("lib/test_printf: Add tests for %pfw printk modifier")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Cc: stable <stable@vger.kernel.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Sorry, I was on vacation.

Seems like this has already been sufficiently reviewed and applied.
Nevertheless,

Tested-by: Brendan Higgins <brendanhiggins@google.com>
