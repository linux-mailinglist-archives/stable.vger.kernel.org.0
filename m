Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13DC45334D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbhKPN5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 08:57:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236902AbhKPN5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 08:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637070867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L0l8U98gykrEb+6mbIddDuP0F41+6lCqLlmJs6JdFso=;
        b=RalssH3ko3BRaiYuNwdwUSDlXcUC8vStNyluN7H9afgyjcRmykcpQ47ZPjSH+hX2/F7rVp
        1PsUVIYEP0CgjxF/tsRIMNfwka0OymTIrcMJPWXSFv1DUtk1rrj00zFT3bLYPd5DD6aUj4
        gCugTsKfL+GO9ANTiPnwXgT4K6DwSbU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-fYlSrEgNMaSDSeozMgDZAQ-1; Tue, 16 Nov 2021 08:54:23 -0500
X-MC-Unique: fYlSrEgNMaSDSeozMgDZAQ-1
Received: by mail-wm1-f70.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so1498912wmq.9
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 05:54:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0l8U98gykrEb+6mbIddDuP0F41+6lCqLlmJs6JdFso=;
        b=TsXz1ivduVNaWPVob6ElJksiJEUVZbopKgpT/fos3XkaY/aeH7xI6UZsn+Czfh/8rs
         UAjhJKgnm6DDqWVOMKk6eZKeRSFtccUzagRSP6//BHRsXpf0MmJ3QWh71sJBw2nkJsW/
         IEQTCwYlxvdnQ2T0kmhuSL5DylfQIIaJoePnLkK+bVW7x6djjjQ8pidezHaAJRfA3yi7
         Hml3SUkmIXgOp8iHvMB0INDbT5JHc12Lmv6a43fMw/dOhScJUMRRTVmmf+Dv9eh4nsKo
         xPpDctULEImmZdiok3idc+WxFjz4MCjBsdG3mz67KDoN8sw+ZqXjVJYqwV6ceC3ZULlc
         uXmg==
X-Gm-Message-State: AOAM530GAf0bVXO5y1TG4Hx0YBRDpQhXEbsJQPN+B9Alot4wWqhxCVgH
        NCFy4zG1fUt/q1+DG1Vi7GowXZCIhyrCnZrIQWWL+qErfmEZqWvL2bY3kT/8UKLaRhl6DbFKzqb
        LjgXfWQdLiv4lIZaUEGdgnFilWDwueMRz
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr8157156wms.74.1637070861956;
        Tue, 16 Nov 2021 05:54:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkE0ZUdhTupcolHEn3mZwOjI5RxolJG8TsOzucbh8Kv+FGnxDoIbqJ9yNpgl/Dl6oTuf5XlMzsyqFNl9LN+Zk=
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr8157134wms.74.1637070861810;
 Tue, 16 Nov 2021 05:54:21 -0800 (PST)
MIME-Version: 1.0
References: <20211115165313.549179499@linuxfoundation.org> <20211115165315.847107930@linuxfoundation.org>
 <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com> <YZMBVdDZzjE6Pziq@sashalap>
In-Reply-To: <YZMBVdDZzjE6Pziq@sashalap>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Tue, 16 Nov 2021 14:54:10 +0100
Message-ID: <CAHc6FU4cgAXc2GxYw+N=RACPG0xc=urrrqw8Gc3X1Rpr4255pg@mail.gmail.com>
Subject: Re: [PATCH 5.4 063/355] powerpc/kvm: Fix kvm_use_magic_page
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathieu Malaterre <malat@debian.org>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 1:54 AM Sasha Levin <sashal@kernel.org> wrote:
> On Mon, Nov 15, 2021 at 06:47:41PM +0100, Andreas Gruenbacher wrote:
> >Greg,
> >
> >On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> wrote:
> >> From: Andreas Gruenbacher <agruenba@redhat.com>
> >>
> >> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
> >>
> >> When switching from __get_user to fault_in_pages_readable, commit
> >> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
> >> fault_in_pages_readable returns 0 on success.
> >
> >I've not heard back from the maintainers about this patch so far, so
> >it would probably be safer to leave it out of stable for now.
>
> What do you mean exactly? It's upstream.

Mathieu Malaterre broke this test in 2018 (commit 9f9eae5ce717) but
that wasn't noticed until now (commit 0c8eb2884a42). This means that
this fix probably isn't critical, so I shouldn't be backported.

Thanks,
Andreas

