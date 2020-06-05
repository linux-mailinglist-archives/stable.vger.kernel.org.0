Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508731EFE82
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFERJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 13:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgFERJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 13:09:06 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508B6C08C5C3
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 10:09:06 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l1so8017207ede.11
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 10:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nXYAuD6cJqilYclvO4FvsMZJybvzN9VYDs0VzjdhPnY=;
        b=t5puf6jywvyNN+70hb28Pvg47DXUPXRfy9clfajsTCTEsz1DVvuvmucmrFXPN4Yera
         iX5tmSkGaAyNZayciyT3GMyFrOCN4SMWL8M84IxZWnMlNodshGHe66dJPL3M3KK6I7au
         +Gg13yxDpSJdJwDAO/u+oQ8sXaQeYhxw/MvP+CTILg91x4xdp1wBvSxfUYgpmnTt/Mh1
         ptUOCyR+L/3/QbN0ianVVqfl1yyY1EzbmpTorznVSk6wXtS5PLZ7NKDsgw4KvfvqTugO
         4eHoGho3ymydRboxbZbhxWUgmRgJ6CgGhcQB5t8qPVtxxju5siJRkecD5se6dBe/h2N6
         0LAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nXYAuD6cJqilYclvO4FvsMZJybvzN9VYDs0VzjdhPnY=;
        b=jEkC5vc4Qkt8MYaOKZZNG/d9pG0//ONsPDyadCwiE76A/VRWXwr2gHUNTblm1djmZZ
         ULE7PgPv+xQWFwkzzfPqO18EDFP1jMMPgfRUWUdYgpLyiaDngs86qx+sImkHRV/kBFGj
         1WBnIDbodyrX8rZ/68u21gfEBP1G7oY4V5t8kYSbXfXfoIkWRwsfzxPDXEWmReYVb0UO
         uuuAulQFtIoKecV+ekUysqX7t38XFO0QOYSV31QcuGQEl7LqowDUvTCAWb7afWz3GhIz
         Y+ANzlppeWRzQMGad4D5jLbO+ZRFvSm6gz6r/JmbxJ4KLCcuKp4FRLkhEfY/V3tsneHe
         vC3w==
X-Gm-Message-State: AOAM532EHcz8o6UFu/PrUXiOBleSSfvhhOlOBPk7mTKg6FRnocdHN9cC
        bP0NrYaqqE+JSxRvlH0O1xim/R1hBYLM/Jvx+N6OIw==
X-Google-Smtp-Source: ABdhPJxATfr/IFgw85Nm/0I0I4vMJ3s9Mbj4YTfektxdqlqB/pT+k/tztb3pG7J2zznxMo8KQcFTv2Q6AnRteS+UOLs=
X-Received: by 2002:aa7:c944:: with SMTP id h4mr10040096edt.383.1591376944978;
 Fri, 05 Jun 2020 10:09:04 -0700 (PDT)
MIME-Version: 1.0
References: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
 <2643462.teTRrieJB7@kreacher>
In-Reply-To: <2643462.teTRrieJB7@kreacher>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 5 Jun 2020 10:08:53 -0700
Message-ID: <CAPcyv4hWLKP7fdLhWLn8vxf5rJKvKyU0yLfDs0XMjW-9U9tM-g@mail.gmail.com>
Subject: Re: [RFT][PATCH] ACPI: OSL: Use rwlock instead of RCU for memory management
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Ira Weiny <ira.weiny@intel.com>,
        James Morse <james.morse@arm.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 5, 2020 at 7:06 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: [PATCH] ACPI: OSL: Use rwlock instead of RCU for memory management
>
> The ACPI OS layer uses RCU to protect the list of ACPI memory
> mappings from being walked while it is updated.  Among other
> situations, that list can be walked in non-NMI interrupt context,
> so using a sleeping lock to protect it is not an option.
>
> However, performance issues related to the RCU usage in there
> appear, as described by Dan Williams:
>
> "Recently a performance problem was reported for a process invoking
> a non-trival ASL program. The method call in this case ends up
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
> migrates this apparently sleepy task. The overhead of frequent
> scheduler invocation multiplies the execution time by a factor
> of 2-3X."
>
> In order to avoid these issues, replace the RCU in the ACPI OS
> layer by an rwlock.
>
> That rwlock should not be frequently contended, so the performance
> impact of it is not expected to be significant.
>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> Hi Dan,
>
> This is a possible fix for the ACPI OSL RCU-related performance issues, but
> can you please arrange for the testing of it on the affected systems?

Ugh, is it really this simple? I did not realize the read-side is NMI
safe. I'll take a look.
