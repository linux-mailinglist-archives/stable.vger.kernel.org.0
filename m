Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D88220B37C
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 16:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgFZOW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 10:22:27 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44116 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 10:22:27 -0400
Received: by mail-ot1-f67.google.com with SMTP id 5so6759668oty.11;
        Fri, 26 Jun 2020 07:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zylLUqnkdMrer9YoBeoJCoYKdCDB3D8ttj9vwr5OJtU=;
        b=Cw/i3qyk/q06UqwKOCrnqXpy9tpME4ZHEgVz7mSM5PPjOuUkz0xWxpH/NnEMVC8qPi
         sGHFmbNhswqIWlhzBWyNdXYv9D9FWZKCQCSMg3K3dfuDGq8q1vyp4R1K/n6qNAXS2Gnw
         pzZsO58wndSAVfXQ/7+1/fc14Q03jef1gieRoRjGO+3vRrdGG3ghKzVrvq9H5XJkEZ68
         AJbIYQXmE9jxtu6wIjkReW4wzBlwYwPz+zp53SZ8c7U9yAWJApLUNgQlku62RYaEIR1B
         jnVaThPVof3BYpqVdkD/qiMRSq5wYSoEfwOcEWRL6jqORUzq2dn2BItMqDNv+7iOgwsX
         xvHA==
X-Gm-Message-State: AOAM533nvyhgKjRiig1fvKPYeYUFUPGeZvXd6kEHQ2jdNGhKEB61CqXu
        aG7hbckhd58K+ty3CT2FPZ4oPxCA/LiMtvtb7vkb+g==
X-Google-Smtp-Source: ABdhPJwlqOmcvg/6oi2GQiPpb1emiKe3h/g+UPnIZRd8AgaCMf8EtxE5eGtW9wxjDO0n2al1FmoCDRJ0clqbo+lCNqY=
X-Received: by 2002:a9d:7d15:: with SMTP id v21mr2546864otn.118.1593181345873;
 Fri, 26 Jun 2020 07:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <159312902033.1850128.1712559453279208264.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159312902033.1850128.1712559453279208264.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 26 Jun 2020 16:22:14 +0200
Message-ID: <CAJZ5v0h8Eg5_FVxz0COLDMK8cy72xxDk_2nFnXDJNUY-MvdBEQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] ACPI/NVDIMM: Runtime Firmware Activation
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
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
        "Rafael J. Wysocki" <rafael@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 2:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Quoting the documentation:
>
>     Some persistent memory devices run a firmware locally on the device /
>     "DIMM" to perform tasks like media management, capacity provisioning,
>     and health monitoring. The process of updating that firmware typically
>     involves a reboot because it has implications for in-flight memory
>     transactions. However, reboots are disruptive and at least the Intel
>     persistent memory platform implementation, described by the Intel ACPI
>     DSM specification [1], has added support for activating firmware at
>     runtime.
>
>     [1]: https://docs.pmem.io/persistent-memory/
>
> The approach taken is to abstract the Intel platform specific mechanism
> behind a libnvdimm-generic sysfs interface. The interface could support
> runtime-firmware-activation on another architecture without need to
> change userspace tooling.
>
> The ACPI NFIT implementation involves a set of device-specific-methods
> (DSMs) to 'arm' individual devices for activation and bus-level
> 'trigger' method to execute the activation. Informational / enumeration
> methods are also provided at the bus and device level.
>
> One complicating aspect of the memory device firmware activation is that
> the memory controller may need to be quiesced, no memory cycles, during
> the activation. While the platform has mechanisms to support holding off
> in-flight DMA during the activation, the device response to that delay
> is potentially undefined. The platform may reject a runtime firmware
> update if, for example a PCI-E device does not support its completion
> timeout value being increased to meet the activation time. Outside of
> device timeouts the quiesce period may also violate application
> timeouts.
>
> Given the above device and application timeout considerations the
> implementation defaults to hooking into the suspend path to trigger the
> activation, i.e. that a suspend-resume cycle (at least up to the syscore
> suspend point) is required.

Well, that doesn't work if the suspend method for the system is set to
suspend-to-idle (for example, via /sys/power/mem_sleep), because the
syscore callbacks are not invoked in that case.

Also you probably don't need the device power state toggling that
happens during regular suspend/resume (you may not want it even for
some devices).

The hibernation freeze/thaw may be a better match and there is some
test support in there already that may be kind of co-opted for your
use case.

Cheers!
