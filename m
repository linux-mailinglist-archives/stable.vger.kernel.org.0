Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98943D446
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 19:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406020AbfFKRd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 13:33:28 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34537 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405061AbfFKRd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 13:33:28 -0400
Received: by mail-ot1-f67.google.com with SMTP id z24so12712039oto.1
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 10:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8nzla2nhdrhp+/IZCs1+OTgK//WXZgK4kNyZnUr2Po=;
        b=YIOBu6r/nImhIKSwlRcFGhLbbEem2jjbzfIQXh2YW0B/MeYaZ9NEnCchaYX1ftEUP7
         WXu0ggkj2bWy6Wv8GeH6ZODRSthNZKVorXwVQJzuc0+Ta+11fr0FamnTgyc3a0tuqp+2
         LL9xs08ntR78279L5hwL/2t4knnvPcLASo9js=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8nzla2nhdrhp+/IZCs1+OTgK//WXZgK4kNyZnUr2Po=;
        b=c1GVPR4PVIh70aKlk4ibilRjc/okCVmHWfae6VsVOXK4JlaCOsRdZHJvXjFrnqSiLB
         v1MdcEvziFMUzjkQT9L0K79DNjjYtp9AUj/lLmJXsFbrY8BEDz993LOl0YoUzCAV/sWF
         Wbm2yUDIfUFJYdUBcAdE8dzpedmzTAy9aBmX9RMx8zk7vPcXi6Z2Ua0XJ8w6VyNFBxEA
         JIht+Fcyh6quDLP4AnudSgcqdKdcl+GPTIzDWylnANL2OIkHHaFS+G5jVnsz2rkcuEUc
         +v5nSbGhIOUWpdccx4ZkBg9EI7xHoeAmwk/IOwha0zX03P6+gYpcwvLFUMxAhtbJ6A2f
         1wCA==
X-Gm-Message-State: APjAAAWK7NCam95bqtAx3diSGz/NabVM1SpyXoXr99PMG/HqFIsVctSt
        QZjTSFdWCnlJOcLNDw/jxJ06lIRkKCjq60vXxWUcRQ==
X-Google-Smtp-Source: APXvYqxnz+b1dgfxUNemPnCVMNQTkUC3TiOTKiiZdSO87P9fj+aapXwt3TlYybkYT6OHd+4V0lFC7SthgjCLuoxomAs=
X-Received: by 2002:a9d:7451:: with SMTP id p17mr4008898otk.204.1560274407636;
 Tue, 11 Jun 2019 10:33:27 -0700 (PDT)
MIME-Version: 1.0
References: <87k1dsjkdo.fsf@turtle.gmx.de> <20190611153656.GA5084@kroah.com>
In-Reply-To: <20190611153656.GA5084@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 11 Jun 2019 19:33:16 +0200
Message-ID: <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
Subject: Re: Linux 5.1.9 build failure with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sven Joachim <svenjoac@gmx.de>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 5:37 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
> > Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
> > legacy contexts. (v3)") has caused a build failure for me when I
> > actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):
> >
> > ,----
> > | Kernel: arch/x86/boot/bzImage is ready  (#1)
> > |   Building modules, stage 2.
> > |   MODPOST 290 modules
> > | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
> > | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> > `----

Calling drm_legacy_mmap is definitely not a great idea. I think either
we need a custom patch to remove that out on older kernels, or maybe
even #ifdef if you want to be super paranoid about breaking stuff ...

> > Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
> > Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
> > drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
> > apply in 5.1.9.
> >
> > Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
> > them yet.
>
> They probably are.
>
> Should I just revert this patch in the stable tree, or add some other
> patch (like the one pointed out here, which seems an odd patch for
> stable...)

... or backport the above patch, that should be save to do too. Not
sure what stable folks prefer?
-Daniel

>
> thanks,
>
> greg k-h



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
