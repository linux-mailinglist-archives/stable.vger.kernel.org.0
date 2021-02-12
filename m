Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA42319FA5
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 14:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhBLNPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 08:15:51 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:46815 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhBLNP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 08:15:27 -0500
Date:   Fri, 12 Feb 2021 13:14:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1613135680;
        bh=3kzHPPEfw1Oh/I2MyZYvqJOoI3OUAOuTBbGYxZ6hJXU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=QJUxtEvMZXp/osU9H8/N9GbtIb0yBNvkFGeCOL83GaSoAQ4Y5uzywHWQ5KupwWfZZ
         dxXwtjq9n3nTzUsXXDQpC0e8gEpkSpIsFpQ+g+3LAMSPZmgku7VGXWKhBE9ICCCAdn
         gGM4UJQ1XQmA4LCV0sNYK7v3dwHFEZOYYryZbtwmFdKey+Sb8bPuM5v/mJs0VMSt5q
         SATj5yWIEkdvvnpW6dHFbUG3Qy9rcx6t3CLkgA8O6fUkpDg535qZLcMk2Tf4gh6Ysl
         Pk4V0rUV5z6hgP8HNxDAh1AjvCHYnxiqIqgPy4H8+FjxNRaA+NQi++RR4j6vymslB8
         7mfCBayLxA0xA==
To:     Emil Velikov <emil.l.velikov@gmail.com>
From:   Simon Ser <contact@emersion.fr>
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
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without CHECKPOINT_RESTORE
Message-ID: <pIyZ-Jj7O2MYk1vKeyghnFmiFWk_5ZWm-Ze1gUqdDaXzImOVjVdjPh2uyHa-sxOPovRk1ApSKk_5zKBvOrzoSwXeXUu0LbZ75Q1D3gIK2Kk=@emersion.fr>
In-Reply-To: <CACvgo52u1ASWXOuWuDwoXvbZhoq+RHn_GTxD5y9k+kO_dzmT7w@mail.gmail.com>
References: <20210205163752.11932-1-chris@chris-wilson.co.uk> <20210205220012.1983-1-chris@chris-wilson.co.uk> <CACvgo52u1ASWXOuWuDwoXvbZhoq+RHn_GTxD5y9k+kO_dzmT7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday, February 12th, 2021 at 1:57 PM, Emil Velikov <emil.l.velikov@gma=
il.com> wrote:

> On Fri, 5 Feb 2021 at 22:01, Chris Wilson <chris@chris-wilson.co.uk> wrot=
e:
> >
> > Userspace has discovered the functionality offered by SYS_kcmp and has
> > started to depend upon it. In particular, Mesa uses SYS_kcmp for
> > os_same_file_description() in order to identify when two fd (e.g. devic=
e
> > or dmabuf)
>
> As you rightfully point out, SYS_kcmp is a bit of a two edged sword.
> While you mention the CONFIG issue, there is also a portability aspect
> (mesa runs on more than just linux) and as well as sandbox filtering
> of the extra syscall.
>
> Last time I looked, the latter was still an issue and mesa was using
> SYS_kcmp to compare device node fds.
> A far shorter and more portable solution is possible, so let me
> prepare a Mesa patch.

Comparing two DMA-BUFs can be done with their inode number, I think.

Comparing two device FDs is more subtle, because of GEM handle
ref'counting. You sometimes really want to check whether two FDs are
backed by the same file *description*. See [1] for details.

[1]: https://gitlab.freedesktop.org/mesa/drm/-/merge_requests/110
