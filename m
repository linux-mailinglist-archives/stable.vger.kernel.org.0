Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27D064FB1
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 02:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfGKArB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 20:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfGKArB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 20:47:01 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412F320872;
        Thu, 11 Jul 2019 00:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562806020;
        bh=NvN3UIAfMs62DjYHuxYacaeaVxpTiaNi/XfAtuERSeM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KhF8u16rxeRH9pS8l9u367xxpVi0SiaEolU+T4XcKSNjuPMz+8dbsZlSXAMyR5ZbJ
         S5dXcrSmile8IptZ+YeHUBw+P1V+N+qc/CXO76jDyL8cmApH8LSJuUyjFImpakvGzP
         D/8yh9Fw3hHegmnBbuY378lGmdES37xShz/xsfkE=
Date:   Wed, 10 Jul 2019 17:46:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Henry Burns <henryburns@google.com>,
        Jonathan Adams <jwadams@google.com>,
        mm-commits@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, Vitaly Vul <vitaly.vul@sony.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Xidong Wang <wangxidong_97@163.com>
Subject: Re: + mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
 added to -mm tree
Message-Id: <20190710174659.644a72bb36dd104d6c83c259@linux-foundation.org>
In-Reply-To: <CALvZod5H0DzzVJanoB0HV3M7g-7c9-nLUyv0S1USKU-VF_GS2Q@mail.gmail.com>
References: <20190704210640._1tth6_R-%akpm@linux-foundation.org>
        <CALvZod5H0DzzVJanoB0HV3M7g-7c9-nLUyv0S1USKU-VF_GS2Q@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Jul 2019 17:20:56 -0700 Shakeel Butt <shakeelb@google.com> wrote:

> > --- a/mm/z3fold.c~mm-z3foldc-lock-z3fold-page-before-__setpagemovable
> > +++ a/mm/z3fold.c
> > @@ -924,7 +924,16 @@ retry:
> >                 set_bit(PAGE_HEADLESS, &page->private);
> >                 goto headless;
> >         }
> > -       __SetPageMovable(page, pool->inode->i_mapping);
> > +       if (can_sleep) {
> > +               lock_page(page);
> > +               __SetPageMovable(page, pool->inode->i_mapping);
> > +               unlock_page(page);
> > +       } else {
> > +               if (!trylock_page(page)) {
> 
> Oops, the above should be just trylock_page() without the '!'.

Sigh.

--- a/include/linux/pagemap.h~a
+++ a/include/linux/pagemap.h
@@ -451,6 +451,9 @@ extern int __lock_page_or_retry(struct p
 				unsigned int flags);
 extern void unlock_page(struct page *page);
 
+/*
+ * Return true if the page was successfully locked
+ */
 static inline int trylock_page(struct page *page)
 {
 	page = compound_head(page);

> Andrew,
> can you please fix this in-place or do you want a new version to be
> posted.

Thanks, I'll fix.
