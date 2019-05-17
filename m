Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A851121E2C
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 21:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfEQTZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 15:25:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:47075 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfEQTZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 15:25:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id r18so3756874pls.13
        for <stable@vger.kernel.org>; Fri, 17 May 2019 12:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6m950k0wpGbiOzwRM0Zmf6vFeYvepUmTaDILG4jsOaE=;
        b=MRIUWXTdcwy3u1sW6nKHueYTSpb0gJ7fF8cYZVlfUuPds94ETgvDpGDxvTp+t1DlXI
         4AS+i7KmUjpAsXiZRYObHC7OVDJTf5O0aN4echqrlAa/dV2kkHUWDEIBh4xDmFPN2mZI
         OV8PFvr7njJVJaL9n7a1Kz3M75K/90YxuX/n0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6m950k0wpGbiOzwRM0Zmf6vFeYvepUmTaDILG4jsOaE=;
        b=jzrIVp22dJtX8xv77KN3KXl2W/HPMhY0xldrehNINoNy52UocvXHunMHoLQNCfhszF
         rJYpWhRHUZ7Vy76sbqpqm9Q0RIo8B00M92FH2SPEGCD3HLCpvK0jxn+JlVI+17EmxiRN
         hCrD9i+DhL0KhEhGQWOPsk0VGlDxRxGa6JlgtPfcu1EZQfbDNyciGAA13K5yNSIkquBZ
         N5YxKRwKJxyOHWQQcts2kirzVtlI1qWXnYgju4BYipUfnanRTw8JPfoQ2md9pSoZ506g
         qhiCTmklc1NozCqmtCg0K+jJi4Uv50DTxT+b+yPrySWAzdF9Y16PWUxKOvReP7xXkHHF
         TT+Q==
X-Gm-Message-State: APjAAAWKJA1oom8P/aYJcjo9KSpwPfHA0R+79jfY54DlLTOUNBlWEyr0
        rD6YMPRfYUeKIokh0+eqw/sV2g==
X-Google-Smtp-Source: APXvYqx1H180sw6ugMRwdB57GS4R9rz+Su7MJuu5k1RoAAIBbeI3A+RJSaekWJWtXdGn9n8Fk40Phg==
X-Received: by 2002:a17:902:2d03:: with SMTP id o3mr23240811plb.309.1558121156947;
        Fri, 17 May 2019 12:25:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g22sm11186901pfo.28.2019.05.17.12.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 12:25:55 -0700 (PDT)
Date:   Fri, 17 May 2019 12:25:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>,
        stable <stable@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Smits <jeff.smits@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Message-ID: <201905171225.29F9564BA2@keescook>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
 <201905170855.8E2E1AC616@keescook>
 <CAPcyv4g9HpMaifC+Qe2RVbgL_qq9vQvjwr-Jw813xhxcviehYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g9HpMaifC+Qe2RVbgL_qq9vQvjwr-Jw813xhxcviehYQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 10:28:48AM -0700, Dan Williams wrote:
> On Fri, May 17, 2019 at 8:57 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, May 17, 2019 at 08:08:27AM -0700, Dan Williams wrote:
> > > As far as I can see it's mostly check_heap_object() that is the
> > > problem, so I'm open to finding a way to just bypass that sub-routine.
> > > However, as far as I can see none of the other block / filesystem user
> > > copy implementations submit to the hardened checks, like
> > > bio_copy_from_iter(), and iov_iter_copy_from_user_atomic() . So,
> > > either those need to grow additional checks, or the hardened copy
> > > implementation is targeting single object copy use cases, not
> > > necessarily block-I/O. Yes, Kees, please advise.
> >
> > The intention is mainly for copies that haven't had explicit bounds
> > checking already performed on them, yes. Is there something getting
> > checked out of the slab, or is it literally just the overhead of doing
> > the "is this slab?" check that you're seeing?
> 
> It's literally the overhead of "is this slab?" since it needs to go
> retrieve the struct page and read that potentially cold cacheline. In
> the case where that page is on memory media that is higher latency
> than DRAM we get the ~37% performance loss that Jeff measured.

Ah-ha! Okay, I understand now; thanks!

> The path is via the filesystem ->write_iter() file operation. In the
> DAX case the filesystem traps that path early, before submitting block
> I/O, and routes it to the dax_iomap_actor() routine. That routine
> validates that the logical file offset is within bounds of the file,
> then it does a sector-to-pfn translation which validates that the
> physical mapping is within bounds of the block device.
> 
> It seems dax_iomap_actor() is not a path where we'd be worried about
> needing hardened user copy checks.

I would agree: I think the proposed patch makes sense. :)

-- 
Kees Cook
