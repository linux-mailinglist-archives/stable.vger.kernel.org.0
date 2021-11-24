Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50F645B0D0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 01:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhKXAnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 19:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhKXAnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 19:43:37 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D006C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 16:40:28 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o20so2356587eds.10
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 16:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ed+8AqhHF9LjEr/ddfnjb/lBhu42SN2dE9F+PFAVeQg=;
        b=Wjy9BYZ5+F1SRnk/hYqJ3NtmC+mUEmtMz4qmtTJQ+Ye6g4k5viv8imLHHlueIpW36O
         XhrHCg6JEMBQGwQQEFVZk3mYiJ8cZX8hAstxngm1XAbRnUha9uOMrMiod2zJ9Ly9IVLG
         //hBllSGIduKzKU+Hb+GdwLTqbl9CFkjl5hEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ed+8AqhHF9LjEr/ddfnjb/lBhu42SN2dE9F+PFAVeQg=;
        b=KUEm0avrmRmBYK5mXc9FEChhIVphmQtdgWIx1XPb14xAKAevMqeSD2XYmEH/tdQWZS
         YTE/MGDSID2+wQ3rLnCMcV0s7ZtviKX5JiBCXBjfvXL+Wd6/m9oiCkNQhFsE0J5iR2VT
         ecBc76EUqenbohh6A7MO39UeZARZ8VfWD/BlgK9AbsI84o0Q9MwLfng+HlIRgvbEVqSW
         tQ+LCmzK2A33RmN/DR5n9MqDxPN7CzSK+uPMMcMEzcoa8GfT9YT2PORUuzTxE6EI/HK8
         Iz8zgM13VzZK0wkDC42PQ8uwR/0IVxvy3ADLqcz3S2+C0G91ZBUiNd5yUiCc7yXK0aeQ
         6Krg==
X-Gm-Message-State: AOAM531rBliaGY340Qv35LyFTfXRntt1G9Y3i0RyUO0sZoEjQxYtNhu6
        iqIjRBivr0GtbF5zb3XbF6agpALvrBjoaPSICvvqyg==
X-Google-Smtp-Source: ABdhPJzHFWzgRzJHLlh6KVWQt8e26YwrEE7uC1O57pOjDKUKDxspr4TM+rmdsIxLCyMh+Tjh0FG2Ks3d6gpvlTC9gqU=
X-Received: by 2002:a05:6402:11c8:: with SMTP id j8mr17158976edw.33.1637714427186;
 Tue, 23 Nov 2021 16:40:27 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org> <20211115165430.669780058@linuxfoundation.org>
 <CAFxkdAqahwaN0u6u34d4CrMW7rYL=6TpWk1CcOn+uGQdEgkuTQ@mail.gmail.com> <CAOssrKd4gHrKNNttZZey9orZ=F+msx4Axa6Mi_XgZw-9M39h-Q@mail.gmail.com>
In-Reply-To: <CAOssrKd4gHrKNNttZZey9orZ=F+msx4Axa6Mi_XgZw-9M39h-Q@mail.gmail.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 23 Nov 2021 18:40:16 -0600
Message-ID: <CAFxkdAqU0peBNm_SB3En99bU+o=a+05t-Bwyds0AUFb+2W=CFw@mail.gmail.com>
Subject: Re: [PATCH 5.15 056/917] fuse: fix page stealing
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Frank Dinoff <fdinoff@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 1:22 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> On Tue, Nov 23, 2021 at 7:29 PM Justin Forbes <jmforbes@linuxtx.org> wrote:
> >
> > On Mon, Nov 15, 2021 at 7:04 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Miklos Szeredi <mszeredi@redhat.com>
> > >
> > > commit 712a951025c0667ff00b25afc360f74e639dfabe upstream.
> > >
> > > It is possible to trigger a crash by splicing anon pipe bufs to the fuse
> > > device.
> > >
> > > The reason for this is that anon_pipe_buf_release() will reuse buf->page if
> > > the refcount is 1, but that page might have already been stolen and its
> > > flags modified (e.g. PG_lru added).
> > >
> > > This happens in the unlikely case of fuse_dev_splice_write() getting around
> > > to calling pipe_buf_release() after a page has been stolen, added to the
> > > page cache and removed from the page cache.
> > >
> > > Fix by calling pipe_buf_release() right after the page was inserted into
> > > the page cache.  In this case the page has an elevated refcount so any
> > > release function will know that the page isn't reusable.
> > >
> > > Reported-by: Frank Dinoff <fdinoff@google.com>
> > > Link: https://lore.kernel.org/r/CAAmZXrsGg2xsP1CK+cbuEMumtrqdvD-NKnWzhNcvn71RV3c1yw@mail.gmail.com/
> > > Fixes: dd3bb14f44a6 ("fuse: support splice() writing to fuse device")
> > > Cc: <stable@vger.kernel.org> # v2.6.35
> > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > It appears this patch causes a rather serious regression in flatpacks
> > using portals to access files.  Reverting this patch restores expected
> > behavior. I have asked users in the Fedora bug to test with 5.16-rc2
> > to see if we are just missing a dependent patch in stable, or if this
> > is broken there as well, but no response yet.:
> >
> > https://bugzilla.redhat.com/show_bug.cgi?id=2025285
> > https://github.com/flatpak/flatpak/issues/4595
>
> Hi,
>
> Thanks for the report.  Can someone with the reproducer try the attached patch?
>
> I think the race there is unlikely but possible.
>

Thanks, did a scratch build for that and dropped it in the bug. Only
one user has reported back, but the report was that it did not fix the
issue.  I have also gotten confirmation now that the issue is occuring
with 5.16-rc2.

Thanks,
Justin
