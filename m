Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39FD1C859D
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 11:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgEGJZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 05:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgEGJZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 05:25:02 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF64CC061A10;
        Thu,  7 May 2020 02:25:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z6so1838853plk.10;
        Thu, 07 May 2020 02:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GySnMOCjEwjmYKLw1ybYlhgVtoYAht9uSjW2oEXIKIo=;
        b=AfOowyx/OkmjNQUa65VECiO/+/o4o6RBP4CsdAGU1pv7F5oGZguv4qpvECbO2DsLRm
         /s+Bawlqy3JPH7s9dsf8VqDxrucmGUm+2Kyf8MK45fdwAfHl9v1UM8gil57A6xVFFZ/1
         74/V0q4KY50NRk/mssMxuQM4RWJ5NkkymbfmzPa7uvMJ2kVpyC5JjC0qNfEJ5G4AujYo
         uY1Dlv7PsEC5GoglrLdQucCkcXNh80X3UDShw6LeDf1nEBzbfIVPMkI2kMq+l/JQ8Azq
         gA3FCW4SWsn8juJT+7kj68gwXc4uP+CFPTHLZR+OmCl6soyeziW+7XyxLKo/CXURipft
         DmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GySnMOCjEwjmYKLw1ybYlhgVtoYAht9uSjW2oEXIKIo=;
        b=ADsx8JvuuU/MJOaYD8V+6qGKl3JmDj1hz7agYhT6JVDYzJ2GHlnkL3lt2Ebz8V7AYr
         0ElsFocJLnfZ0AS4MHnwE/+6XimOSkbfpjquVasiqaP0xZBaMoorPkcAzCN3OTZV1elY
         ySQEHBrBarI9QOqCEi+G+6eHTsynHx4ZX2d4S9VtR/szoQCsNEJ5Iam44XANEaOHMD7v
         F0B183MD+jvVnNaQxx3v4xdu4QqwFSSrPo166Nno5rG3aD+yHtg3X4VurJ4Pdr0ERNJv
         w+MyZxA/qkZjDaoDOhJbelx2MkGVpMlGkOfPtIPZusKFl85+x54CVvnShTdC9AqarGvC
         ZLPA==
X-Gm-Message-State: AGi0PuZ3Nt8Yf1PcB62x//iTPHW2jOMzkjfPL1asixer7d+1wmDUzvTQ
        JLQEfHLSlytDn8BciNQgq6uL9Nzpl+92Oe6MEGY=
X-Google-Smtp-Source: APiQypLCo11VtyxLxVipMJet+Uc/jH+bliGdPTuMeaMs+hQVOZgfSQlXQ/Vm47iIhfVrJzInVwy52114mBZs8kv8eGk=
X-Received: by 2002:a17:90a:fa81:: with SMTP id cu1mr14771332pjb.25.1588843501300;
 Thu, 07 May 2020 02:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <158880834905.2183490.15616329469420234017.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <158880834905.2183490.15616329469420234017.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 7 May 2020 12:24:49 +0300
Message-ID: <CAHp75Vf0zBnwHubK+C265M9nh3Y5K2K=8ck61HQtnW+021bgwQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Drop rcu usage for MMIO mappings
To:     Dan Williams <dan.j.williams@intel.com>
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
        linux-nvdimm@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 7, 2020 at 3:21 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Recently a performance problem was reported for a process invoking a
> non-trival ASL program. The method call in this case ends up
> repetitively triggering a call path like:
>
>     acpi_ex_store
>     acpi_ex_store_object_to_node
>     acpi_ex_write_data_to_field
>     acpi_ex_insert_into_field
>     acpi_ex_write_with_update_rule
>     acpi_ex_field_datum_io
>     acpi_ex_access_region
>     acpi_ev_address_space_dispatch
>     acpi_ex_system_memory_space_handler
>     acpi_os_map_cleanup.part.14
>     _synchronize_rcu_expedited.constprop.89
>     schedule
>
> The end result of frequent synchronize_rcu_expedited() invocation is
> tiny sub-millisecond spurts of execution where the scheduler freely
> migrates this apparently sleepy task. The overhead of frequent scheduler
> invocation multiplies the execution time by a factor of 2-3X.
>
> For example, performance improves from 16 minutes to 7 minutes for a
> firmware update procedure across 24 devices.
>
> Perhaps the rcu usage was intended to allow for not taking a sleeping
> lock in the acpi_os_{read,write}_memory() path which ostensibly could be
> called from an APEI NMI error interrupt? Neither rcu_read_lock() nor
> ioremap() are interrupt safe, so add a WARN_ONCE() to validate that rcu
> was not serving as a mechanism to avoid direct calls to ioremap(). Even
> the original implementation had a spin_lock_irqsave(), but that is not
> NMI safe.
>
> APEI itself already has some concept of avoiding ioremap() from
> interrupt context (see erst_exec_move_data()), if the new warning
> triggers it means that APEI either needs more instrumentation like that
> to pre-emptively fail, or more infrastructure to arrange for pre-mapping
> the resources it needs in NMI context.

...

> +static void __iomem *acpi_os_rw_map(acpi_physical_address phys_addr,
> +                                   unsigned int size, bool *did_fallback)
> +{
> +       void __iomem *virt_addr = NULL;

Assignment is not needed as far as I can see.

> +       if (WARN_ONCE(in_interrupt(), "ioremap in interrupt context\n"))
> +               return NULL;
> +
> +       /* Try to use a cached mapping and fallback otherwise */
> +       *did_fallback = false;
> +       mutex_lock(&acpi_ioremap_lock);
> +       virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> +       if (virt_addr)
> +               return virt_addr;
> +       mutex_unlock(&acpi_ioremap_lock);
> +
> +       virt_addr = acpi_os_ioremap(phys_addr, size);
> +       *did_fallback = true;
> +
> +       return virt_addr;
> +}

I'm wondering if Sparse is okay with this...

> +static void acpi_os_rw_unmap(void __iomem *virt_addr, bool did_fallback)
> +{
> +       if (did_fallback) {
> +               /* in the fallback case no lock is held */
> +               iounmap(virt_addr);
> +               return;
> +       }
> +
> +       mutex_unlock(&acpi_ioremap_lock);
> +}

...and this functions from locking perspective.

-- 
With Best Regards,
Andy Shevchenko
