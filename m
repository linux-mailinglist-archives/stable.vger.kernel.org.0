Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A7C32BC38
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383273AbhCCNpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241315AbhCCK2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:28:08 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C258C061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 02:27:28 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id w69so25425797oif.1
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 02:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=94FU4aImSyveb72Fh42pjQwrSbJ+f3XzeivB4wSoR78=;
        b=TPsmqF4DiwneZsBqICYdPOa29BGt70SR8yCZLys0WXRd8rFZIw1GUvfX7iMCLGVxQB
         C5MxaiTdM2gnMZNd72rNUuRZReFaYDvCJjfAct7n3kaMDZiPbvkoIcgD51I7edBYM3uZ
         G50f5hmZYM9BO0FHhjNfGoty7zvsPgda8dQcV/T0vY3cDDJEgTR12X+zUTJvY6dy6IUS
         k35maJzmrft8jBKaRug9SJYxosur19yPY8DQpYLY3c4AqAmhEMOKX/mxPqj7+H0EQV7i
         6FQgEmBjjdmvMIMRpbNJV+phC4qgeQ4OJ2usuyXDHwugttb/emwZ5rh53RsQyOm+P2TY
         84fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=94FU4aImSyveb72Fh42pjQwrSbJ+f3XzeivB4wSoR78=;
        b=WXKV+8eNOh5F/+zrmDJhGlGYgTjV3xv7pe9X4xQAOBiHyEyQ4GuATpuCI8OSgCiQXK
         77rFjqUw1LCxZuBYanVNDHm6+w1tzMOOvQyc94FPlL6Ye+WNT4kljEfBzl4YUKycwGmW
         jwAZLuxu6fKIBtQCVi3A3B892XjIBGVwcVF39fEhFoehVV5yASGqhkbnrtpTl0VfvQbc
         aa+czyeA6DWufocWvpUwmvW7EWAET+7ZWmcsD7AAezfb5p5M07qBHNs2rW0pmx1tGICu
         0UeHp/fV+ANgKaRxdbuKFAylXgiVrnKDE2Vf2djQTyYZJTVuLxtzkdmLjBbCnNBfRk+z
         lyyg==
X-Gm-Message-State: AOAM531TJANAW7nf1z3q4DxzXWWLG8Cc4qfhASb+uCjz19nVyJYbldZc
        1wTd2TANPuwPKfMoTz8/6FF5d8JT6DpnqUXiJhUzXQ==
X-Google-Smtp-Source: ABdhPJzEjJBfP0+b5HSHdvaVlTjhK7j0sIV85vmNsnUkZyxcXT8JIFBTCSPTghfDv0QK1R9PoCFNQ75GdZzfRjZD7II=
X-Received: by 2002:aca:5fd4:: with SMTP id t203mr6668726oib.121.1614767247769;
 Wed, 03 Mar 2021 02:27:27 -0800 (PST)
MIME-Version: 1.0
References: <20210303093845.2743309-1-elver@google.com> <YD9dld26cz0RWHg7@kroah.com>
 <CANpmjNMxuj23ryjDCr+ShcNy_oZ=t3MrxFa=pVBXjODBopEAnw@mail.gmail.com> <YD9jujCYGnjwOMoP@kroah.com>
In-Reply-To: <YD9jujCYGnjwOMoP@kroah.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 3 Mar 2021 11:27:16 +0100
Message-ID: <CANpmjNPS7BXepA=G-Fbc_PEjeBhyc8PYEhzEO+TbWApGO7tL-g@mail.gmail.com>
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

On Wed, 3 Mar 2021 at 11:24, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 03, 2021 at 11:18:06AM +0100, Marco Elver wrote:
> > On Wed, 3 Mar 2021 at 10:57, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Mar 03, 2021 at 10:38:45AM +0100, Marco Elver wrote:
> > > > Commit 56348560d495 ("debugfs: do not attempt to create a new file
> > > > before the filesystem is initalized") forbids creating new debugfs files
> > > > until debugfs is fully initialized. This breaks KCSAN's debugfs file
> > > > creation, which happened at the end of __init().
> > >
> > > How did it "break" it?  The files shouldn't have actually been created,
> > > right?
> >
> > Right, with 56348560d495 the debugfs file isn't created anymore, which
> > is the problem. Before 56348560d495 the file exists (syzbot wants the
> > file to exist.)
> >
> > > > There is no reason to create the debugfs file during early
> > > > initialization. Therefore, move it into a late_initcall() callback.
> > > >
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > > Cc: stable <stable@vger.kernel.org>
> > > > Fixes: 56348560d495 ("debugfs: do not attempt to create a new file before the filesystem is initalized")
> > > > Signed-off-by: Marco Elver <elver@google.com>
> > > > ---
> > > > I've marked this for 'stable', since 56348560d495 is also intended for
> > > > stable, and would subsequently break KCSAN in all stable kernels where
> > > > KCSAN is available (since 5.8).
> > >
> > > No objection from me, just odd that this actually fixes anything :)
> >
> > 56348560d495 causes the file to just not be created if we try to
> > create at the end of __init(). Having it created as late as
> > late_initcall() gets us the file back.
> >
> > When you say "fixes anything", should the file be created even though
> > it's at the end of __init()? Perhaps I misunderstood what 56348560d495
> > changes, but I verified it to be the problem by reverting (upon which
> > the file exists as expected).
>
> All my change did is explicitly not allow you to create a file if
> debugfs had not been initialized.  If you tried to do that before, you
> should have gotten an error from the vfs layer that the file was not
> created, as otherwise how would it have succeeded?
>
> I just moved the check up higher in the "stack" to the debugfs code, and
> not relied on the vfs layer to do a lot of work only to reject things
> later on.
>
> So there "should" not have been any functional change with this patch.
> If there was, then something is really odd as how can the vfs layer
> create a file for a filesystem _before_ that filesystem has been
> registered with the vfs layer?

Ah, I see. I do confirm that the file has been created until
56348560d495, without any errors.

Thanks,
-- Marco
