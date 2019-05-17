Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE721A4F
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfEQPIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:08:39 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35501 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbfEQPIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:08:39 -0400
Received: by mail-oi1-f194.google.com with SMTP id a132so5421286oib.2
        for <stable@vger.kernel.org>; Fri, 17 May 2019 08:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGIfXnKXpW5eMKxUMdzRkt44XId1MoiNVnAxGfKvpiQ=;
        b=NxNZPHkQ9m7afnPn+MzAQqWjc4b6NDowhfobUzGnErro91DDQhcbPCtV4yyPmQs5K/
         qHoNY3q3kg21Z1aKKfhVtA51efXEJSWMC+nqJfOqd/6Cxza+N0PESVDd5pxT7+8WWxJ8
         dZbrryqg4W1sKStoCFp33Wpzb60H7wUxxexYHFYmftwZiHvQx7ag+Qv71q7GSKVtf3Yv
         0YURKil61RhPfxk/xokqMuqcpKadv25cmmeCfUPGZVYy8ZS45CyPZ/lVBP6QJrWv4/nC
         v1/j1QVq4xm8msZpqCNnpxMl6+GJA9oIEyJXlJST7m7WnJ1/eAUMStAIB5yhR6N2QBgq
         J6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OGIfXnKXpW5eMKxUMdzRkt44XId1MoiNVnAxGfKvpiQ=;
        b=bGFZJFk8l8TB95PzPL+MnzyA6kWKhKE6T/+ikDs5lPZ0JJxFKYuO5z3t6WQWAi92cY
         C6I6aqkhpw4BDL3qlPTUcznO0b6Qy+ofXttDJTkpQ5g9E4rwtUsfBmUMqNbWdUibH1Lh
         bBvhM7nsltlxtZhJtQ5poFtHqFlGQfmL4oVG6Qk36vaHuMOh00mdz/S1gYglqyKpJsIN
         27iGFFyE28QVhn3FW7n6qcu/+MUgUYcsZCQ6mBEja9esN/qpw8XbHMOj517d9Zv6+w3B
         ABYZh0icbFypbnieBnBCaAshHQ0FWaDyGGzUl1bfJqTZ3lGJSPclsH0JyjBu3yJQMqY9
         kDeQ==
X-Gm-Message-State: APjAAAVHKOHxTOFRVsmel5go06eTG56PKyo8rany/1cta5E0QxXUwHHD
        VgxkaBtRmix3h2HAi8zhPOwe55HplMKf8E2gRjdU67OusGQ=
X-Google-Smtp-Source: APXvYqyTjO/s0rMdx1VgVCXo7bqh4zMktZXJwLahomPBvDpO+I4RjmmwQ75n8Xpfpye+mAWhmlTX6Dis4MloPOV9WcA=
X-Received: by 2002:aca:b641:: with SMTP id g62mr12196057oif.149.1558105718742;
 Fri, 17 May 2019 08:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
In-Reply-To: <20190517084739.GB20550@quack2.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 17 May 2019 08:08:27 -0700
Message-ID: <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
To:     Jan Kara <jack@suse.cz>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        stable <stable@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Smits <jeff.smits@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 1:47 AM Jan Kara <jack@suse.cz> wrote:
>
> Let's add Kees to CC for usercopy expertise...
>
> On Thu 16-05-19 17:33:38, Dan Williams wrote:
> > Jeff discovered that performance improves from ~375K iops to ~519K iops
> > on a simple psync-write fio workload when moving the location of 'struct
> > page' from the default PMEM location to DRAM. This result is surprising
> > because the expectation is that 'struct page' for dax is only needed for
> > third party references to dax mappings. For example, a dax-mapped buffer
> > passed to another system call for direct-I/O requires 'struct page' for
> > sending the request down the driver stack and pinning the page. There is
> > no usage of 'struct page' for first party access to a file via
> > read(2)/write(2) and friends.
> >
> > However, this "no page needed" expectation is violated by
> > CONFIG_HARDENED_USERCOPY and the check_copy_size() performed in
> > copy_from_iter_full_nocache() and copy_to_iter_mcsafe(). The
> > check_heap_object() helper routine assumes the buffer is backed by a
> > page-allocator DRAM page and applies some checks.  Those checks are
> > invalid, dax pages are not from the heap, and redundant,
> > dax_iomap_actor() has already validated that the I/O is within bounds.
>
> So this last paragraph is not obvious to me as check_copy_size() does a lot
> of various checks in CONFIG_HARDENED_USERCOPY case. I agree that some of
> those checks don't make sense for PMEM pages but I'd rather handle that by
> refining check_copy_size() and check_object_size() functions to detect and
> appropriately handle pmem pages rather that generally skip all the checks
> in pmem_copy_from/to_iter(). And yes, every check in such hot path is going
> to cost performance but that's what user asked for with
> CONFIG_HARDENED_USERCOPY... Kees?

As far as I can see it's mostly check_heap_object() that is the
problem, so I'm open to finding a way to just bypass that sub-routine.
However, as far as I can see none of the other block / filesystem user
copy implementations submit to the hardened checks, like
bio_copy_from_iter(), and iov_iter_copy_from_user_atomic() . So,
either those need to grow additional checks, or the hardened copy
implementation is targeting single object copy use cases, not
necessarily block-I/O. Yes, Kees, please advise.
