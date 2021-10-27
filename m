Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC48243D33B
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 22:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244086AbhJ0Uz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 16:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244084AbhJ0Uz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 16:55:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA91D6109E;
        Wed, 27 Oct 2021 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635368011;
        bh=zdJMv/mcj2CSAz9FcD1BLV11LsawzqVlhl6XTfTo+yU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aBN6tBRiJHK7zgB6g4Onng7fU3uF0uidbUnpgzP53zxq/tXivVzJgRl1j62oYPSGf
         Jrod8DKfnHR6VnSJdnrG96os3vY9iXIilyp305YLdHGhmw4CoxpU002qA6DabhnZfm
         SXz5GWAOKHoIq144LxnUYWzEGZ+KseHoHI2W29fk=
Date:   Wed, 27 Oct 2021 13:53:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>, Hugh Dickins <hughd@google.com>,
        "sunhao.th@gmail.com" <sunhao.th@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andrea.righi@canonical.com" <andrea.righi@canonical.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: khugepaged: skip huge page collapse for special
 files
Message-Id: <20211027135328.001e4582a9535e8e4be785bb@linux-foundation.org>
In-Reply-To: <CAHbLzkqTW9U3VvTu1Ki5v_cLRC9gHW+znBukg_ycergE0JWj-A@mail.gmail.com>
References: <20211027195221.3825-1-shy828301@gmail.com>
        <C8C6E50C-D300-40D4-AA5C-490F673BADFE@fb.com>
        <CAHbLzkqTW9U3VvTu1Ki5v_cLRC9gHW+znBukg_ycergE0JWj-A@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021 13:44:37 -0700 Yang Shi <shy828301@gmail.com> wrote:

> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
> > >       if (!transhuge_vma_enabled(vma, vm_flags))
> > >               return false;
> > >
> > > -     /* Enabled via shmem mount options or sysfs settings. */
> > > -     if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
> > > +     if (vma->vm_file)
> > >               return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
> > >                               HPAGE_PMD_NR);
> >
> > Am I misreading this? If we return here for vma->vm_file, the following
> > logic (shmem_file(), etc.) would be skipped, no?
> 
> Oh, yes, you are right. My mistake.
> 
> Andrew,
> 
> Could you please apply the below fix?

um, how well tested are these changes?
