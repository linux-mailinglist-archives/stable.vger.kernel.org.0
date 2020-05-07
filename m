Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4191C9EFF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 01:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEGXNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 19:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgEGXNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 19:13:10 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA73C05BD09
        for <stable@vger.kernel.org>; Thu,  7 May 2020 16:13:09 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id r7so6893377edo.11
        for <stable@vger.kernel.org>; Thu, 07 May 2020 16:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hOgoGFfrQiuxoVLXtR6ns0cA7T4PnQXjD00h0lBOWe4=;
        b=hrgYnUmsGdoaS3xDvgxUWyQB+Y5ou6argIEx1l1Kr98VcT/PuZNB21w7VF4wNyOf3b
         ZTR3HijaDV+aYn7AVymILBM1HG6SsF3OBVQw+NaTDBW7yCAUHp+xDTo+d2HF2cWV62Kx
         J0RHUmvKSo3QkxABUHofYEIYdck5hZ1pQ6TIdTqfGuRxHAfc9lc9WoKNSXaf5jd4sGH6
         5zsj2CdRwbHBtEc5v/2QRCkRx3FkrQQQfcWJEBhPumdfcYetulcFpdZ2IUdvb+Ej1ldh
         tWc0dThiiOgWTKPjGS8u0xo8v7dsvuhAFMjWHTib/xrlps+UHajnDWMLelWRkA9TeCdP
         2JmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hOgoGFfrQiuxoVLXtR6ns0cA7T4PnQXjD00h0lBOWe4=;
        b=I+9O0SzR2OrmSvvamfeI8Qzrg5lIVBZL3F+TTt2pm0hUWaiJwvgINhA9Fb+tsGEJi3
         pP2iXhJboV/qWqIeI2ZLB4O2Ld8/J6d3Pqy2jAV5dw4Qh64tutOQ5GIRfWgm7399qZKK
         CZ2+4OJTH+PiC0bNFAdjGymmAsJB58O7OnjcCIsxImwIn9s2MU30hlRkCk8Ep4zuzRqB
         V0Gghn4WG7hVKDR7NJpAyFEEoEzf5YVWk+6tANap7+eOkG9Rpf5UPpH8VB3Fbo2aU0z7
         juUD8X74M3QyTlUo3UpSwWBuIUemLfXt3mbzHgmBF4r7fZyynAloY4O4GdVZdjTlTJxw
         nLkw==
X-Gm-Message-State: AGi0PuY6linBXf77Wp3Qf4WUfvk/1a5gVOAlBbDe7vH8xOBLRCSfDV0v
        PWg4pK9XZeTwMa1XGvk4zdDV6lZpt1Us680gvVY9nA==
X-Google-Smtp-Source: APiQypLKOsixtTx2ArZFZo5Vte0u7Uot4DdFVW14d0f8hZF71PsBU1ityGME4xeFTnZmsoCmyniMyBMwVkOsZylK9MA=
X-Received: by 2002:a05:6402:3136:: with SMTP id dd22mr13983824edb.165.1588893188370;
 Thu, 07 May 2020 16:13:08 -0700 (PDT)
MIME-Version: 1.0
References: <158880834905.2183490.15616329469420234017.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHp75Vf0zBnwHubK+C265M9nh3Y5K2K=8ck61HQtnW+021bgwQ@mail.gmail.com>
In-Reply-To: <CAHp75Vf0zBnwHubK+C265M9nh3Y5K2K=8ck61HQtnW+021bgwQ@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 7 May 2020 16:12:57 -0700
Message-ID: <CAPcyv4gOxrOZUKfA4cObKUaZRkkjRyQFkS+=Q9FXziK00CE8yA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Drop rcu usage for MMIO mappings
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stable <stable@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Ira Weiny <ira.weiny@intel.com>,
        James Morse <james.morse@arm.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 7, 2020 at 2:25 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Thu, May 7, 2020 at 3:21 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > Recently a performance problem was reported for a process invoking a
> > non-trival ASL program. The method call in this case ends up
> > repetitively triggering a call path like:
> >
> >     acpi_ex_store
> >     acpi_ex_store_object_to_node
> >     acpi_ex_write_data_to_field
> >     acpi_ex_insert_into_field
> >     acpi_ex_write_with_update_rule
> >     acpi_ex_field_datum_io
> >     acpi_ex_access_region
> >     acpi_ev_address_space_dispatch
> >     acpi_ex_system_memory_space_handler
> >     acpi_os_map_cleanup.part.14
> >     _synchronize_rcu_expedited.constprop.89
> >     schedule
> >
> > The end result of frequent synchronize_rcu_expedited() invocation is
> > tiny sub-millisecond spurts of execution where the scheduler freely
> > migrates this apparently sleepy task. The overhead of frequent scheduler
> > invocation multiplies the execution time by a factor of 2-3X.
> >
> > For example, performance improves from 16 minutes to 7 minutes for a
> > firmware update procedure across 24 devices.
> >
> > Perhaps the rcu usage was intended to allow for not taking a sleeping
> > lock in the acpi_os_{read,write}_memory() path which ostensibly could be
> > called from an APEI NMI error interrupt? Neither rcu_read_lock() nor
> > ioremap() are interrupt safe, so add a WARN_ONCE() to validate that rcu
> > was not serving as a mechanism to avoid direct calls to ioremap(). Even
> > the original implementation had a spin_lock_irqsave(), but that is not
> > NMI safe.
> >
> > APEI itself already has some concept of avoiding ioremap() from
> > interrupt context (see erst_exec_move_data()), if the new warning
> > triggers it means that APEI either needs more instrumentation like that
> > to pre-emptively fail, or more infrastructure to arrange for pre-mapping
> > the resources it needs in NMI context.
>
> ...
>
> > +static void __iomem *acpi_os_rw_map(acpi_physical_address phys_addr,
> > +                                   unsigned int size, bool *did_fallback)
> > +{
> > +       void __iomem *virt_addr = NULL;
>
> Assignment is not needed as far as I can see.

True, holdover from a previous version, will drop.

>
> > +       if (WARN_ONCE(in_interrupt(), "ioremap in interrupt context\n"))
> > +               return NULL;
> > +
> > +       /* Try to use a cached mapping and fallback otherwise */
> > +       *did_fallback = false;
> > +       mutex_lock(&acpi_ioremap_lock);
> > +       virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> > +       if (virt_addr)
> > +               return virt_addr;
> > +       mutex_unlock(&acpi_ioremap_lock);
> > +
> > +       virt_addr = acpi_os_ioremap(phys_addr, size);
> > +       *did_fallback = true;
> > +
> > +       return virt_addr;
> > +}
>
> I'm wondering if Sparse is okay with this...

Seems like it is:

$ sparse --version
v0.6.1-191-gc51a0382202e

$ cat out | grep osl\.c
  CHECK   drivers/acpi/osl.c
drivers/acpi/osl.c:373:17: warning: cast removes address space
'<asn:2>' of expression

...was the only warning I got.
