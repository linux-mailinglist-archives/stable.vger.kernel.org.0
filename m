Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88E832BC2F
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242108AbhCCNnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842911AbhCCKW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:22:26 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D4DC08ED86
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 02:18:18 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id z126so25367690oiz.6
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 02:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tizoAoxj1MkSbHFp7V2+QcWvWzsNKthubw4LeYpfuqI=;
        b=jxIUAfJ3U4ZH+UI3+YAb5ouL3zRfORY+g1i2znUqOgAQFlcRT6fkHhFuyPimU0bSgd
         5fY7NR+Tpxpa4XPzHRklpoOFqdHh/9qbI89Ym39gbhw6CMUTsKGDGC8jsQ4oensYFBub
         aGP5hHiXsGeRG+4ZLvbrGn5pwknc+1BuWtbJEEcbfYIK4yzzdx+WCn0jnJIKb2+uL5WK
         +iNOKwxcPc2hS94atEabN1H+4VWjFcxvZvo8gYZgay6Wmu28G2YfC1JI5+S7qCC7Qfn6
         SKZ2FZ3dX9HRdBmH/yuxrEH8l63ReiOwVoVtQqeRHThkH2wJJBcVR3f9t095Zed86tsy
         ztuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tizoAoxj1MkSbHFp7V2+QcWvWzsNKthubw4LeYpfuqI=;
        b=BmB5oTTxR76JL7nKPurSDYoZkPwCLVYGkTF5CrdOPITNjQBSR4ZUybz49ZWr5vKkRg
         ooJdk5RoeyzUqWbWdgJ+GAabU1ZnCouOTBQ9LwqJGCnI9Mt2ig6ZQtG3HQKH8j8AYVnl
         1m5nIHkU6phZVbTdjZcozQ9ExsvDVth02F42ScKkCzHQX285EXd+wWACg8n+8akNarYH
         nO0HjGo6HVjHjTz9q1Buq5mYAqmxLsOe9Gn6lNwjn0OGg8sRMdIHqWwRNP0DiPwJO7nd
         rWGzCHn844ddjOgN37AVscsf94MbP86eTdr5bnhH0OBJa+zPUH4hdKVJJURWiCepD6e7
         qpeQ==
X-Gm-Message-State: AOAM533kGGAGo8IO7feXF20joGRrCSPI7GzPLAHiWanhA+ID0FgZ1h3N
        xrfFstEVj26JPPUYalLZdTU2BeMEqfSSzDn6googDw==
X-Google-Smtp-Source: ABdhPJzdmqr3s1PdsFaTVC5h0Mz4OupyGWT58ZE5Juec8iUCfkOdYJUhF0QINsNBRXqkk0CJ57WTzoEpqRacWa5abMo=
X-Received: by 2002:aca:d515:: with SMTP id m21mr6810808oig.172.1614766697628;
 Wed, 03 Mar 2021 02:18:17 -0800 (PST)
MIME-Version: 1.0
References: <20210303093845.2743309-1-elver@google.com> <YD9dld26cz0RWHg7@kroah.com>
In-Reply-To: <YD9dld26cz0RWHg7@kroah.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 3 Mar 2021 11:18:06 +0100
Message-ID: <CANpmjNMxuj23ryjDCr+ShcNy_oZ=t3MrxFa=pVBXjODBopEAnw@mail.gmail.com>
Subject: Re: [PATCH] kcsan, debugfs: Move debugfs file creation out of early init
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     rafael@kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Mar 2021 at 10:57, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 03, 2021 at 10:38:45AM +0100, Marco Elver wrote:
> > Commit 56348560d495 ("debugfs: do not attempt to create a new file
> > before the filesystem is initalized") forbids creating new debugfs files
> > until debugfs is fully initialized. This breaks KCSAN's debugfs file
> > creation, which happened at the end of __init().
>
> How did it "break" it?  The files shouldn't have actually been created,
> right?

Right, with 56348560d495 the debugfs file isn't created anymore, which
is the problem. Before 56348560d495 the file exists (syzbot wants the
file to exist.)

> > There is no reason to create the debugfs file during early
> > initialization. Therefore, move it into a late_initcall() callback.
> >
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: stable <stable@vger.kernel.org>
> > Fixes: 56348560d495 ("debugfs: do not attempt to create a new file before the filesystem is initalized")
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> > I've marked this for 'stable', since 56348560d495 is also intended for
> > stable, and would subsequently break KCSAN in all stable kernels where
> > KCSAN is available (since 5.8).
>
> No objection from me, just odd that this actually fixes anything :)

56348560d495 causes the file to just not be created if we try to
create at the end of __init(). Having it created as late as
late_initcall() gets us the file back.

When you say "fixes anything", should the file be created even though
it's at the end of __init()? Perhaps I misunderstood what 56348560d495
changes, but I verified it to be the problem by reverting (upon which
the file exists as expected).

> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks! Would it be possible to get this into 5.12?

-- Marco
