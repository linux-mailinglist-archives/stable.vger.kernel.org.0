Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AF4181A0F
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgCKNnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgCKNnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:43:20 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C458122464
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583934200;
        bh=gNzZd+j72gePWmbyxah3BW9W182jo3x0E2sGNNtTIc8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TplORw08IqFWEgK3AnZIOyXQ7pqWteCCPUhtZF32ONA3cQBZIRwmYQcMS2kPsP5F7
         yKp8kUhNml4BXCmsY3bm4T4H0meLn4aQH4nueJ80/1pwl2ZWzi24+Vxkspm6epxMn6
         fi7SaKFkrez7zS+x1Zxe0t2dFZdCe7jVJ2DRitn8=
Received: by mail-wm1-f51.google.com with SMTP id 11so2150795wmo.2
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 06:43:19 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2x/ECR4PXrYqcfPvyxt9t2W5oK23r6RJ4gp5eXVh8SFnj9NbZy
        NCfyGGL2U8Jh++cMjViY4cqMeCM9rG96i7YRZhZzrQ==
X-Google-Smtp-Source: ADFU+vvrJVxZ+Wi3m98AeFKOvIhIt38hptalbmNoiJj0xYwDRjDAl8dyVCIHSN8/hkVsE8CyLcTvE98AIbOg067m4aU=
X-Received: by 2002:a05:600c:24b:: with SMTP id 11mr3844796wmj.1.1583934198087;
 Wed, 11 Mar 2020 06:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200310124530.808338541@linuxfoundation.org> <20200310124535.409134291@linuxfoundation.org>
 <20200311130106.GB7285@duo.ucw.cz> <20200311131311.GA3858095@kroah.com> <20200311132845.GA24349@duo.ucw.cz>
In-Reply-To: <20200311132845.GA24349@duo.ucw.cz>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 11 Mar 2020 09:43:06 -0400
X-Gmail-Original-Message-ID: <CAKv+Gu9efurx3WT6AviURhgro8x4EjkvcQs6eiz-M-R6wGTp4w@mail.gmail.com>
Message-ID: <CAKv+Gu9efurx3WT6AviURhgro8x4EjkvcQs6eiz-M-R6wGTp4w@mail.gmail.com>
Subject: Re: [PATCH 4.19 84/86] efi/x86: Handle by-ref arguments covering
 multiple pages in mixed mode
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 11 Mar 2020 at 09:28, Pavel Machek <pavel@denx.de> wrote:
>
> On Wed 2020-03-11 14:13:11, Greg Kroah-Hartman wrote:
> > On Wed, Mar 11, 2020 at 02:01:07PM +0100, Pavel Machek wrote:
> > > Hi!
> > >
> > > > Currently, the mixed mode runtime service wrappers require that all by-ref
> > > > arguments that live in the vmalloc space have a size that is a power of 2,
> > > > and are aligned to that same value. While this is a sensible way to
> > > > construct an object that is guaranteed not to cross a page boundary, it is
> > > > overly strict when it comes to checking whether a given object violates
> > > > this requirement, as we can simply take the physical address of the first
> > > > and the last byte, and verify that they point into the same physical
> > > > page.
> > >
> > > Dunno. If start passing buffers that _sometime_ cross page boundaries,
> > > we'll get hard to debug failures. Maybe original code is better
> > > buecause it catches problems earlier?
> > >
> > > Furthermore, all existing code should pass aligned, 2^n size buffers,
> > > so we should not need this in stable?
> >
> > For some crazy reason you cut out the reason I applied this patch to the
> > stable tree.  From the changelog text:
> >       Fixes: f6697df36bdf0bf7 ("x86/efi: Prevent mixed mode boot
> >corruption with CONFIG_VMAP_STACK=y")
>
> I did not notice that, but reviewing f669 does not really help. If
> there is some known code that passes unaligned (but guaranteed
> not-to-cross-page) buffers here, then yes, but is it? Having
> not-page-crossing guarantees is kind of hard without alignment.
>
> People seem to be adding Fixes: tags even if it is not a bugfix, just
> as reminder that this has relation to some other commit...
>

If you read the commit log until the end, you will find a paragraph
that describes how the old code warns about, but then ignores the
error condition, and proceeds in a way that may cause data corruption.
Also, on x86, the stack alignment is only 8 bytes, so with the
introduction of vmapped stacks, most guarantees about alignment of
objects in the vmalloc space went out the window, potentially
triggering this condition in unanticipated ways.

It is not very constructive to comment on 'what people seem to be
doing' if you have no clue what the context of the change is. Opinions
are welcome but informed ones are preferred.


>
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
