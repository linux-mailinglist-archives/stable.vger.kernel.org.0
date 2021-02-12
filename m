Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA1131A05B
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 15:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhBLOKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 09:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhBLOKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 09:10:03 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B8AC061574;
        Fri, 12 Feb 2021 06:09:23 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id 68so3347774vsk.11;
        Fri, 12 Feb 2021 06:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mGUEM8BkIgjUi3SKnHZuM7SaerLEeBlJ+h2BpANQXuQ=;
        b=tT++vyICTpA35K1XTNsUAg+swzDOMB9wHNUBqMN0s40RY7O6i+dGqR757jXFkttcG8
         Nh3EsNsBSyRUMLlsbSECySlXLkNgYWSlvl0P0i3hCBGnO8OP5H6ICL8QNHYB0Y08liJX
         stuXqWRcrGM5zfJ0jig3Aw3fyKY0MFmNs7Rg8V05ezn0VpRVpdm0scb9ZH0vwi7TkZ0e
         4eXJKfHz/a86PfrgJKI2GcpIGd0NhKzw2GuyGcsvJIOVY1iH7tO7srgw7mlXCstFyoJi
         1KDntNsVs3l2Ven6KMZSBbLmzR0e2YAwYszVUZE4qZT5g/qBrB9KhfCnX1OOxQQFC0ac
         4T3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mGUEM8BkIgjUi3SKnHZuM7SaerLEeBlJ+h2BpANQXuQ=;
        b=qTK5MdKnzo38qFA740Ym4MvQxxsg88A4M59eSLaXElIMljPVITOTWrlxX6sixmhOWH
         4wHaJSEHVLJd7ZwuLkBeAZDsQKrYetP9izfYmS46TYzXPFMmrYVjkWpfR4FbKn73YM4W
         K2eMibT8ZeTA13xpBRp3bVSgBjpPxLnhzrC9FZco/0wMlNWdQbFgPRAATHSldIb9cavs
         D7OJdiBG7XZ0SJrlN++fmnxCCJhbAImh2z8rCNihjR0R2luxH3TVP77G9/CO2Vb4mjM0
         SVIr+/Gya3sohsWuF/0rrpv6Etc8CgU/DnsnKd6lzUmpghePhO3QZLIjUawXknVhemeq
         ZREw==
X-Gm-Message-State: AOAM53219V72TKMegK08Y8USFYQ43twuxsJcA8TD1XOYpANSi8JGtJVg
        xoXlDE64zGZVB648ecAD9bwIZuOPIpQPYEm6uD0=
X-Google-Smtp-Source: ABdhPJzYPikYFqTmSgbjd45vsc7zqYpXlE1kFNbWMlv5LAZLJ1P/Ly0qtWligVBnGVuhCT90UJ5RIFuiYQc8pU0aOv0=
X-Received: by 2002:a67:cd18:: with SMTP id u24mr1342241vsl.19.1613138962980;
 Fri, 12 Feb 2021 06:09:22 -0800 (PST)
MIME-Version: 1.0
References: <20210205163752.11932-1-chris@chris-wilson.co.uk>
 <20210205220012.1983-1-chris@chris-wilson.co.uk> <CACvgo52u1ASWXOuWuDwoXvbZhoq+RHn_GTxD5y9k+kO_dzmT7w@mail.gmail.com>
 <3a2316b6-27a9-d56a-b488-ac15a402a0d2@daenzer.net>
In-Reply-To: <3a2316b6-27a9-d56a-b488-ac15a402a0d2@daenzer.net>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Fri, 12 Feb 2021 14:09:11 +0000
Message-ID: <CACvgo53tAe56fqpwmEpEvToWCqd=7bWs1DUv6aZM9JuPz7dQXg@mail.gmail.com>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without CHECKPOINT_RESTORE
To:     =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "# 3.13+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Feb 2021 at 14:01, Michel D=C3=A4nzer <michel@daenzer.net> wrote=
:
>
> On 2021-02-12 1:57 p.m., Emil Velikov wrote:
> > On Fri, 5 Feb 2021 at 22:01, Chris Wilson <chris@chris-wilson.co.uk> wr=
ote:
> >>
> >> Userspace has discovered the functionality offered by SYS_kcmp and has
> >> started to depend upon it. In particular, Mesa uses SYS_kcmp for
> >> os_same_file_description() in order to identify when two fd (e.g. devi=
ce
> >> or dmabuf)
> >
> > As you rightfully point out, SYS_kcmp is a bit of a two edged sword.
> > While you mention the CONFIG issue, there is also a portability aspect
> > (mesa runs on more than just linux) and as well as sandbox filtering
> > of the extra syscall.
> >
> > Last time I looked, the latter was still an issue and mesa was using
> > SYS_kcmp to compare device node fds.
> > A far shorter and more portable solution is possible, so let me
> > prepare a Mesa patch.
>
> Make sure to read my comments on
> https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/6881 first. :)
>
Much appreciated. I might have been "slightly" off - pardon for the noise o=
/

-Emil
