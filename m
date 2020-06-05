Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457081EFD73
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgFEQVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:21:43 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34548 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgFEQVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:21:42 -0400
Received: by mail-ot1-f65.google.com with SMTP id b18so8061249oti.1;
        Fri, 05 Jun 2020 09:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNm/MEsuRiThlj0w2Ep6hniygV5tFbfb9SR7Z3GLj9Y=;
        b=YbkqS2xAQNP8YNDMayOSoXFruFdNzU6pLFsUOiZKSdsZZL3FM+8Wqb6AAeGLdsmALy
         1PicxwCxQIF+e7CJMPqTAKkVZySs+wchMe6cppRL94vAUOEF9+xUmOgqEWxzEKbJCeOv
         wP0g1h2BlTcQe/3vPYZ8+AM25UX8VsPCCKBTgbqvcUwzzyC5cgwb8rJoWyaW3KzGR+Ir
         gy5Jbe9YbjRfTm5q4NVKXytBdxK9gqQtRNXEGsZu/6/u677XXIc7jjxQH+6OKIgFXRc8
         6cdA/Ib/FFou+s4u7/PvCq6iEH5oUlBTEGB9bv/OKM2lFGGuEn98bWqhKvHydC2QUOAF
         k0MQ==
X-Gm-Message-State: AOAM532ZOfGX0J0IYOGZlVy7UJFUHXP51uO8WoBGkzESzkylvHplMCVo
        rqv0i064/mgK78sm/E5rkhASMb7eFpLysByHxeI=
X-Google-Smtp-Source: ABdhPJwGbBmx3OnMsin8+/tCfwolPcXpa3AYr4pgSORGQmWTl8u3ZgO7Zkxncv+YIFsOCyUUBnNaQR6wgbRYJGe3OY4=
X-Received: by 2002:a05:6830:20d1:: with SMTP id z17mr7872068otq.167.1591374101775;
 Fri, 05 Jun 2020 09:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAJZ5v0gq55A7880dOJD7skwx7mnjsqbCqEGFvEo552U9W2zH3Q@mail.gmail.com> <CAPcyv4gQNPNOmSVrp7epS5_10qLUuGbutQ2xz7LXnpEhkWeA_w@mail.gmail.com>
In-Reply-To: <CAPcyv4gQNPNOmSVrp7epS5_10qLUuGbutQ2xz7LXnpEhkWeA_w@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 5 Jun 2020 18:21:30 +0200
Message-ID: <CAJZ5v0g-TSk+7d-b0j5THeNtuSDeSJmKZHcG3mBesVZgkCyJOg@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: Drop rcu usage for MMIO mappings
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Stable <stable@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Ira Weiny <ira.weiny@intel.com>,
        James Morse <james.morse@arm.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 5, 2020 at 6:18 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Jun 5, 2020 at 6:32 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Fri, May 8, 2020 at 1:55 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > Recently a performance problem was reported for a process invoking a
> > > non-trival ASL program. The method call in this case ends up
> > > repetitively triggering a call path like:
> > >
> > >     acpi_ex_store
> > >     acpi_ex_store_object_to_node
> > >     acpi_ex_write_data_to_field
> > >     acpi_ex_insert_into_field
> > >     acpi_ex_write_with_update_rule
> > >     acpi_ex_field_datum_io
> > >     acpi_ex_access_region
> > >     acpi_ev_address_space_dispatch
> > >     acpi_ex_system_memory_space_handler
> > >     acpi_os_map_cleanup.part.14
> > >     _synchronize_rcu_expedited.constprop.89
> > >     schedule
> > >
> > > The end result of frequent synchronize_rcu_expedited() invocation is
> > > tiny sub-millisecond spurts of execution where the scheduler freely
> > > migrates this apparently sleepy task. The overhead of frequent scheduler
> > > invocation multiplies the execution time by a factor of 2-3X.
> > >
> > > For example, performance improves from 16 minutes to 7 minutes for a
> > > firmware update procedure across 24 devices.
> > >
> > > Perhaps the rcu usage was intended to allow for not taking a sleeping
> > > lock in the acpi_os_{read,write}_memory() path which ostensibly could be
> > > called from an APEI NMI error interrupt?
> >
> > Not really.
> >
> > acpi_os_{read|write}_memory() end up being called from non-NMI
> > interrupt context via acpi_hw_{read|write}(), respectively, and quite
> > obviously ioremap() cannot be run from there, but in those cases the
> > mappings in question are there in the list already in all cases and so
> > the ioremap() isn't used then.
> >
> > RCU is there to protect these users from walking the list while it is
> > being updated.
> >
> > > Neither rcu_read_lock() nor ioremap() are interrupt safe, so add a WARN_ONCE() to validate that rcu
> > > was not serving as a mechanism to avoid direct calls to ioremap().
> >
> > But it would produce false-positives if the IRQ context was not NMI,
> > wouldn't it?
> >
> > > Even the original implementation had a spin_lock_irqsave(), but that is not
> > > NMI safe.
> >
> > Which is not a problem (see above).
> >
> > > APEI itself already has some concept of avoiding ioremap() from
> > > interrupt context (see erst_exec_move_data()), if the new warning
> > > triggers it means that APEI either needs more instrumentation like that
> > > to pre-emptively fail, or more infrastructure to arrange for pre-mapping
> > > the resources it needs in NMI context.
> >
> > Well, I'm not sure about that.
>
> Right, this patch set is about 2-3 generations behind the architecture
> of the fix we are discussing internally, you might mention that.

Yes, sorry.

> The fix we are looking at now is to pre-map operation regions in a
> similar manner as the way APEI resources are pre-mapped. The
> pre-mapping would arrange for synchronize_rcu_expedited() to be elided
> on each dynamic mapping attempt. The other piece is to arrange for
> operation-regions to be mapped at their full size at once rather than
> a page at a time.

However, if the RCU usage in ACPI OSL can be replaced with an rwlock,
some of the ACPICA changes above may not be necessary anymore (even
though some of them may still be worth making).
