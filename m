Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9B4373AF4
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhEEMSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233318AbhEEMSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 08:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620217044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hrmCA/J3sB6HOBms8xIZgNMww4dgcHpRb4C4wTEbSKQ=;
        b=PN3+jA1g0VIGFsMnBhWLmSgGTMIdfPDaWbAm7k9W/1dVjyAPE+XVR+QogY34F724NZcZZc
        kasfPNdqeuxaOGVR0Nr5iMhJIYUIk2NHqU3mw7BrjtJBfjOUTut0FMeeK74Iu+SicXjsrL
        FA/gUmliRfO06vkEPJaW+9ADUmDBV0k=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-0imvWuyEOrqvT1-L6kFU2A-1; Wed, 05 May 2021 08:17:22 -0400
X-MC-Unique: 0imvWuyEOrqvT1-L6kFU2A-1
Received: by mail-yb1-f198.google.com with SMTP id m1-20020a2526010000b02904f4d04c0f14so2030370ybm.19
        for <stable@vger.kernel.org>; Wed, 05 May 2021 05:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hrmCA/J3sB6HOBms8xIZgNMww4dgcHpRb4C4wTEbSKQ=;
        b=ZJ+21wX/Zha4yD1EBZewnzTFTvRt3b4FhQ2wGi1i5MyH9he4zVInVTQX18yI6G9zL3
         IPmW5eMlk5AP+DoNk+jjgrumgmHtpMzhgkbPQ1bm4/0Ac5XLnAyfeIlDC8wVeBVYeVlI
         JnPGabHjyPYzM1E9JCa203evUBBAniY2PPbKHsLYAQNgzaoMLu9Q/vZC7bsXpOEqKkBi
         0teMt9V/mMusEwLgr3lFNE9Uuau0UbUKsZjxe7gXcQQFXtVDvbiboZIDJo4N1WGuRkEr
         7nOhyNRBCH7ELOpzVaFBns2rb0LE33EXFofdjCKMZGoVnGBhyacD+vxkua870t8N1kCk
         BlXQ==
X-Gm-Message-State: AOAM530q8/+SeKo+x2gj+9IFtQgmE1Ctcrl/DjCbHb2SiNA1Ol9h2QVS
        he9c6p/pxyMa8i2WU2hYM/az0P6Hg2uOEb/VBvqcF4EHkC54Yrwhsskv0G0xyWyjR3KvwEqlWrA
        ICK1rr9MY7sKjtiw+yADVdF1ZsPMfjE/S
X-Received: by 2002:a25:6983:: with SMTP id e125mr32862082ybc.81.1620217042295;
        Wed, 05 May 2021 05:17:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyXeBR96lH3iVFbY/+rJ0h396WwWdih4nDRG+1jiXjzn6xS5pJGc1DuzsshMbTJtAoPECXuDvPkoN8bT4VL4s=
X-Received: by 2002:a25:6983:: with SMTP id e125mr32862061ybc.81.1620217042093;
 Wed, 05 May 2021 05:17:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAFqZXNvt-ezC2hwLC1zOVfgkRwd4483=dXw3k2ALkuRYfR4okA@mail.gmail.com>
 <YJJ8g0IKSz1UkZ/Q@kroah.com>
In-Reply-To: <YJJ8g0IKSz1UkZ/Q@kroah.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 5 May 2021 14:17:08 +0200
Message-ID: <CAFqZXNvrYW+oqBez6wUxWPbMiMSPBbNnvVNpDXST47-i0qS6ZQ@mail.gmail.com>
Subject: Re: Stable backport request - perf/core: Fix unconditional
 security_locked_down() call
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 5, 2021 at 1:07 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, May 05, 2021 at 12:58:24PM +0200, Ondrej Mosnacek wrote:
> > Hello,
> >
> > please consider backporting commit 08ef1af4de5f ("perf/core: Fix
> > unconditional security_locked_down() call") to stable kernels, as
> > without it SELinux requires an extraneous permission for
> > perf_event_open(2) calls with PERF_SAMPLE_REGS_INTR unset.
> >
> > The range of target kernel versions is implied by the Fixes: tag.
>
> Now queued up, thanks.
>
> greg k-h
>

Wow, that was fast :) Thanks, Greg!

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

