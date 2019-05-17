Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A6B21C77
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 19:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfEQR3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 13:29:00 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41213 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfEQR3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 13:29:00 -0400
Received: by mail-oi1-f196.google.com with SMTP id y10so5716469oia.8
        for <stable@vger.kernel.org>; Fri, 17 May 2019 10:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DZg+iPjy57Sau/2Fv2Pd7vOTOxQm9eqfYjNJZeyrWIs=;
        b=dJsV4x6IxLCgdPBEdcoEAdj7Zz5cN+2SMQigBpwwLCEnytqZSwk8zS1uvReMjOe4cj
         Q24WakyMkK56lXo3uuygO/fpLNaDFdlHZ4HKZ89RdkRYdy7710qGfvhjYW0h2qLXROj5
         Udi0Ja8h/Gn5ceLVB/Dd8MsMGQWpESB4ureyJ+HPhXQP+qv0PLzcH82NXB6OZOpHv/ol
         jiw0rT7qOiQrtpVx/2IyOEEJ4tL4ltdsslvJg/tILl3oaaWcaKU303I9MpGYmzHslK2g
         CI3AyFD5/HFMxWLbDcHtj5KFQRpwpFleoORC+4GRdyjxHEFM2eK+lztKXJz8ctBDuLma
         Vs0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DZg+iPjy57Sau/2Fv2Pd7vOTOxQm9eqfYjNJZeyrWIs=;
        b=soXtsxeeE3U5LhmuW+GvLYfHqZod+KzehF80QoUkeKwBiLpK2o/eruwzzKHoIQ8aja
         1JQ9tITZ14C95AS8fxMZ5DX+i4T4W/hRDECx9F89mzrxxys1KHi0KidNasfP/sG3t0Kn
         4chnBENlzcCkDNnZgGPAdIiW0FLzPdob37jlLHZo3KovzWBpQcpakK1iajjcFzZN/zUr
         +9Vqm6c8gH3THTAixT/KtFptPjzajAeHtI1yd/+PDtaXu+XdSMyNuQ9caHG87F3YaSfc
         cLzIT6jdvU+XHA9gPwG47OdYoHrPANAIgIPGKELWYz3Ehsr8oUQBgdszXusd1VitvBjL
         M8rA==
X-Gm-Message-State: APjAAAUsUnGRyikadNqy3rLAggUox74XjJrVh7YxrvZq3MB6qzSRIVfq
        sPmjfYsZrjJBuWfO6EZWEbbu7Yrnvb3sr1ixpYtprg==
X-Google-Smtp-Source: APXvYqyypz+lE+RFowzVzsoRyDPIn100uvW4JTOwzRg1F63adltFZC2q4xwOBjZ3OZAsNEKxmDVZopC2u4kD8gMpRhg=
X-Received: by 2002:aca:4208:: with SMTP id p8mr16013695oia.105.1558114139313;
 Fri, 17 May 2019 10:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz> <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
 <201905170855.8E2E1AC616@keescook>
In-Reply-To: <201905170855.8E2E1AC616@keescook>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 17 May 2019 10:28:48 -0700
Message-ID: <CAPcyv4g9HpMaifC+Qe2RVbgL_qq9vQvjwr-Jw813xhxcviehYQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
To:     Kees Cook <keescook@chromium.org>
Cc:     Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>,
        stable <stable@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Smits <jeff.smits@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 8:57 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, May 17, 2019 at 08:08:27AM -0700, Dan Williams wrote:
> > As far as I can see it's mostly check_heap_object() that is the
> > problem, so I'm open to finding a way to just bypass that sub-routine.
> > However, as far as I can see none of the other block / filesystem user
> > copy implementations submit to the hardened checks, like
> > bio_copy_from_iter(), and iov_iter_copy_from_user_atomic() . So,
> > either those need to grow additional checks, or the hardened copy
> > implementation is targeting single object copy use cases, not
> > necessarily block-I/O. Yes, Kees, please advise.
>
> The intention is mainly for copies that haven't had explicit bounds
> checking already performed on them, yes. Is there something getting
> checked out of the slab, or is it literally just the overhead of doing
> the "is this slab?" check that you're seeing?

It's literally the overhead of "is this slab?" since it needs to go
retrieve the struct page and read that potentially cold cacheline. In
the case where that page is on memory media that is higher latency
than DRAM we get the ~37% performance loss that Jeff measured.

The path is via the filesystem ->write_iter() file operation. In the
DAX case the filesystem traps that path early, before submitting block
I/O, and routes it to the dax_iomap_actor() routine. That routine
validates that the logical file offset is within bounds of the file,
then it does a sector-to-pfn translation which validates that the
physical mapping is within bounds of the block device.

It seems dax_iomap_actor() is not a path where we'd be worried about
needing hardened user copy checks.
