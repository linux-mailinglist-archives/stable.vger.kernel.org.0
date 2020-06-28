Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91F320C93C
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 19:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgF1RXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 13:23:08 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39196 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgF1RXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 13:23:07 -0400
Received: by mail-ot1-f67.google.com with SMTP id 18so13375160otv.6;
        Sun, 28 Jun 2020 10:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lJ/7Mwdioa+LkvwxDevBww4xCE/dU3bIOQYsqm3j9ng=;
        b=oSb8imbUlUT+MSUkhtwZwBrywq5pbdxjqJca3s8ZJomg+i8TFWb81E6lmQWyvZxQl6
         dXnsX/KtTBVgLlMmMH2+EAOirRL73tRm7PbdyrIiHHiVvg/Ku0LeTScNuQLz7Olu4gku
         qCaFu8DCIaw4akGTJs7L1Jz+ogw1Jj8/6Ct8fITjNsSkmysOcTxa8cYr2cH5rqewnlS5
         f82q3XxaGsIGOcHQbjMiJ/1Ogl9LoJWt0OzYrb1RLzT0xHvnUOGUsz1MWRe4BwTggMyZ
         w6sSzZauke828mN9/U6gI+r1L3sg7lIvjeVJxebUavfDZR80x7DFZS09tvkAxU2MR/jE
         aAHw==
X-Gm-Message-State: AOAM530GI+xI+JfioiQF0VJQXouRjgXGlibPKALH1lEKbkQgDfG7aFDT
        fkirhJ8JVhUBYAtGSqX1r2aVDOS+49PsVsaQD3c=
X-Google-Smtp-Source: ABdhPJxWeIRMAX90bePkgZ2eZsip3wobT0DgKId2QVtHye5EgsJU87W+GWkfAZOi33Iq2RFvZeSEGzQe1N1PGQe9zfE=
X-Received: by 2002:a05:6830:10ca:: with SMTP id z10mr10078158oto.167.1593364986761;
 Sun, 28 Jun 2020 10:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <159312902033.1850128.1712559453279208264.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAJZ5v0h8Eg5_FVxz0COLDMK8cy72xxDk_2nFnXDJNUY-MvdBEQ@mail.gmail.com> <CAPcyv4jqShnZr1b0-upwWf8L3JjKtHox_pCuu229630rXGuLkg@mail.gmail.com>
In-Reply-To: <CAPcyv4jqShnZr1b0-upwWf8L3JjKtHox_pCuu229630rXGuLkg@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Sun, 28 Jun 2020 19:22:55 +0200
Message-ID: <CAJZ5v0i=SkqtgcXzq0oYNEAuYA-FvBEG-bm6fyidzAsYSNcEdQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] ACPI/NVDIMM: Runtime Firmware Activation
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 8:43 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Jun 26, 2020 at 7:22 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Fri, Jun 26, 2020 at 2:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > Quoting the documentation:
> > >
> > >     Some persistent memory devices run a firmware locally on the device /
> > >     "DIMM" to perform tasks like media management, capacity provisioning,
> > >     and health monitoring. The process of updating that firmware typically
> > >     involves a reboot because it has implications for in-flight memory
> > >     transactions. However, reboots are disruptive and at least the Intel
> > >     persistent memory platform implementation, described by the Intel ACPI
> > >     DSM specification [1], has added support for activating firmware at
> > >     runtime.
> > >
> > >     [1]: https://docs.pmem.io/persistent-memory/
> > >
> > > The approach taken is to abstract the Intel platform specific mechanism
> > > behind a libnvdimm-generic sysfs interface. The interface could support
> > > runtime-firmware-activation on another architecture without need to
> > > change userspace tooling.
> > >
> > > The ACPI NFIT implementation involves a set of device-specific-methods
> > > (DSMs) to 'arm' individual devices for activation and bus-level
> > > 'trigger' method to execute the activation. Informational / enumeration
> > > methods are also provided at the bus and device level.
> > >
> > > One complicating aspect of the memory device firmware activation is that
> > > the memory controller may need to be quiesced, no memory cycles, during
> > > the activation. While the platform has mechanisms to support holding off
> > > in-flight DMA during the activation, the device response to that delay
> > > is potentially undefined. The platform may reject a runtime firmware
> > > update if, for example a PCI-E device does not support its completion
> > > timeout value being increased to meet the activation time. Outside of
> > > device timeouts the quiesce period may also violate application
> > > timeouts.
> > >
> > > Given the above device and application timeout considerations the
> > > implementation defaults to hooking into the suspend path to trigger the
> > > activation, i.e. that a suspend-resume cycle (at least up to the syscore
> > > suspend point) is required.
> >
> > Well, that doesn't work if the suspend method for the system is set to
> > suspend-to-idle (for example, via /sys/power/mem_sleep), because the
> > syscore callbacks are not invoked in that case.
> >
> > Also you probably don't need the device power state toggling that
> > happens during regular suspend/resume (you may not want it even for
> > some devices).
> >
> > The hibernation freeze/thaw may be a better match and there is some
> > test support in there already that may be kind of co-opted for your
> > use case.
>
> Hmm, yes I guess freeze should be sufficient to quiesce most
> device-DMA in the general case as applications will stop sending
> requests.

It is expected to be sufficient to quiesce all of them.

If that is not the case, the integrity of the hibernation image cannot
be guaranteed on the system in question.

> I do expect some RDMA devices will happily keep on
> transmitting, but that likely will need explicit mitigation. It also
> appears the suspend callback for at least one RDMA device
> mlx5_suspend() is rather violent as it appears to fully teardown the
> device context, not just suspend operations.
>
> To be clear, what debug interface were you thinking I could glom onto
> to just trigger firmware-activate at the end of the freeze phase?

Functionally, the same as for suspend, but using the hibernation
interface, so "echo platform > /sys/power/pm_test" followed by "echo
disk > /sys/power/state".

But it might be cleaner to introduce a special "hibernation mode", ie.
is one more item in /sys/power/disk, that will trigger what you need
(in analogy with "test_resume").
