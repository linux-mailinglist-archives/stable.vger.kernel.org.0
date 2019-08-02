Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721397FF3F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 19:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404174AbfHBRGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 13:06:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43276 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731679AbfHBRGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 13:06:53 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so3357154wru.10
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 10:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQ6UiLJNkBhA+pMzkpxl1Gg80N0x8vKT2uUJ5BnurkA=;
        b=F6mgsXiIaV+4zMatwRElixhGQnYYrJW8E0VSXlK25VkqQAoooL8KVmNZo6UY41FgTn
         tR2Q2XWu9RM6bkkvIPQv2US/mf5zqOgT8jJ6gzXobSYcI2vlkwrADOmtvbh8MNp+jqIl
         awVXYh2kKRn+HyT9SbN7d8WCyi56kzK/PCKWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQ6UiLJNkBhA+pMzkpxl1Gg80N0x8vKT2uUJ5BnurkA=;
        b=oOxPwkewcJ53nKeXuZGbhCIQcmqMVDxBtMPzxleUc6G2Pwoshdmz7qM13k5lgnSMXp
         MCS9FcyMzZb2ywHXYp1eEWqY5ZWKo/9C37ODa1k6SobZQBcWJdLcdGcnvjhlbSgxpC//
         7avWhHe+ggfFrmjHqZbzUY+6dqf0pUP+6XvrJpWY9wy6xLUbyoUJv5eySClGTo8H289S
         JMaE16j3ir+9LnfvYqvPwqya1ddr5wi2ecDBHR1VNzwcIj72gvSZ9IQTyLHuc24jttLQ
         T9b5OLuPVpwL3Ld1SkdeIxzd75mRDoZqcnqFH+WTRcYPc3FgiEMP7NjyeCohsjm0n0aX
         2cQw==
X-Gm-Message-State: APjAAAXPUCQQOMj5tOqoLYwueynC13AkoBPQs8FEA6vxUbiaEfCxc/ix
        cPT3DZCsYdmreyIqBfeoZz6FsqhJzg+6/J+jFOU=
X-Google-Smtp-Source: APXvYqxDnRZt/bAltoIAxIEUXRq/0m1EsNo6erNwD8ZX3FFZV1MftZafSkTOe77oryx3TMx1p0400AlChZO06CkNeH0=
X-Received: by 2002:adf:ed41:: with SMTP id u1mr140780115wro.162.1564765610033;
 Fri, 02 Aug 2019 10:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191735.096702571@linuxfoundation.org> <20190724191743.977277445@linuxfoundation.org>
In-Reply-To: <20190724191743.977277445@linuxfoundation.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 2 Aug 2019 12:06:39 -0500
Message-ID: <CAFxkdApc6V=7qS+XEVSLy-v0AgqUQ8faKbjFXv18Px7VcxHgBw@mail.gmail.com>
Subject: Re: [PATCH 5.2 123/413] PCI: Add missing link delays required by the
 PCIe spec
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 3:31 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> [ Upstream commit c2bf1fc212f7e6f25ace1af8f0b3ac061ea48ba5 ]
>
> Currently Linux does not follow PCIe spec regarding the required delays
> after reset. A concrete example is a Thunderbolt add-in-card that
> consists of a PCIe switch and two PCIe endpoints:
>
>   +-1b.0-[01-6b]----00.0-[02-6b]--+-00.0-[03]----00.0 TBT controller
>                                   +-01.0-[04-36]-- DS hotplug port
>                                   +-02.0-[37]----00.0 xHCI controller
>                                   \-04.0-[38-6b]-- DS hotplug port
>
> The root port (1b.0) and the PCIe switch downstream ports are all PCIe
> gen3 so they support 8GT/s link speeds.
>
> We wait for the PCIe hierarchy to enter D3cold (runtime):
>
>   pcieport 0000:00:1b.0: power state changed by ACPI to D3cold
>
> When it wakes up from D3cold, according to the PCIe 4.0 section 5.8 the
> PCIe switch is put to reset and its power is re-applied. This means that
> we must follow the rules in PCIe 4.0 section 6.6.1.
>
> For the PCIe gen3 ports we are dealing with here, the following applies:
>
>   With a Downstream Port that supports Link speeds greater than 5.0
>   GT/s, software must wait a minimum of 100 ms after Link training
>   completes before sending a Configuration Request to the device
>   immediately below that Port. Software can determine when Link training
>   completes by polling the Data Link Layer Link Active bit or by setting
>   up an associated interrupt (see Section 6.7.3.3).
>
> Translating this into the above topology we would need to do this (DLLLA
> stands for Data Link Layer Link Active):
>
>   pcieport 0000:00:1b.0: wait for 100ms after DLLLA is set before access to 0000:01:00.0
>   pcieport 0000:02:00.0: wait for 100ms after DLLLA is set before access to 0000:03:00.0
>   pcieport 0000:02:02.0: wait for 100ms after DLLLA is set before access to 0000:37:00.0
>
> I've instrumented the kernel with additional logging so we can see the
> actual delays the kernel performs:
>
>   pcieport 0000:00:1b.0: power state changed by ACPI to D0
>   pcieport 0000:00:1b.0: waiting for D3cold delay of 100 ms
>   pcieport 0000:00:1b.0: waking up bus
>   pcieport 0000:00:1b.0: waiting for D3hot delay of 10 ms
>   pcieport 0000:00:1b.0: restoring config space at offset 0x2c (was 0x60, writing 0x60)
>   ...
>   pcieport 0000:00:1b.0: PME# disabled
>   pcieport 0000:01:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   ...
>   pcieport 0000:01:00.0: PME# disabled
>   pcieport 0000:02:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   ...
>   pcieport 0000:02:00.0: PME# disabled
>   pcieport 0000:02:01.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   ...
>   pcieport 0000:02:01.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
>   pcieport 0000:02:01.0: PME# disabled
>   pcieport 0000:02:02.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   ...
>   pcieport 0000:02:02.0: PME# disabled
>   pcieport 0000:02:04.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   ...
>   pcieport 0000:02:04.0: PME# disabled
>   pcieport 0000:02:01.0: PME# enabled
>   pcieport 0000:02:01.0: waiting for D3hot delay of 10 ms
>   pcieport 0000:02:04.0: PME# enabled
>   pcieport 0000:02:04.0: waiting for D3hot delay of 10 ms
>   thunderbolt 0000:03:00.0: restoring config space at offset 0x14 (was 0x0, writing 0x8a040000)
>   ...
>   thunderbolt 0000:03:00.0: PME# disabled
>   xhci_hcd 0000:37:00.0: restoring config space at offset 0x10 (was 0x0, writing 0x73f00000)
>   ...
>   xhci_hcd 0000:37:00.0: PME# disabled
>
> For the switch upstream port (01:00.0) we wait for 100ms but not taking
> into account the DLLLA requirement. We then wait 10ms for D3hot -> D0
> transition of the root port and the two downstream hotplug ports. This
> means that we deviate from what the spec requires.
>
> Performing the same check for system sleep (s2idle) transitions we can
> see following when resuming from s2idle:
>
>   pcieport 0000:00:1b.0: power state changed by ACPI to D0
>   pcieport 0000:00:1b.0: restoring config space at offset 0x2c (was 0x60, writing 0x60)
>   ...
>   pcieport 0000:01:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   ...
>   pcieport 0000:02:02.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   pcieport 0000:02:02.0: restoring config space at offset 0x2c (was 0x0, writing 0x0)
>   pcieport 0000:02:01.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   pcieport 0000:02:04.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   pcieport 0000:02:02.0: restoring config space at offset 0x28 (was 0x0, writing 0x0)
>   pcieport 0000:02:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
>   pcieport 0000:02:02.0: restoring config space at offset 0x24 (was 0x10001, writing 0x1fff1)
>   pcieport 0000:02:01.0: restoring config space at offset 0x2c (was 0x0, writing 0x60)
>   pcieport 0000:02:02.0: restoring config space at offset 0x20 (was 0x0, writing 0x73f073f0)
>   pcieport 0000:02:04.0: restoring config space at offset 0x2c (was 0x0, writing 0x60)
>   pcieport 0000:02:01.0: restoring config space at offset 0x28 (was 0x0, writing 0x60)
>   pcieport 0000:02:00.0: restoring config space at offset 0x2c (was 0x0, writing 0x0)
>   pcieport 0000:02:02.0: restoring config space at offset 0x1c (was 0x101, writing 0x1f1)
>   pcieport 0000:02:04.0: restoring config space at offset 0x28 (was 0x0, writing 0x60)
>   pcieport 0000:02:01.0: restoring config space at offset 0x24 (was 0x10001, writing 0x1ff10001)
>   pcieport 0000:02:00.0: restoring config space at offset 0x28 (was 0x0, writing 0x0)
>   pcieport 0000:02:02.0: restoring config space at offset 0x18 (was 0x0, writing 0x373702)
>   pcieport 0000:02:04.0: restoring config space at offset 0x24 (was 0x10001, writing 0x49f12001)
>   pcieport 0000:02:01.0: restoring config space at offset 0x20 (was 0x0, writing 0x73e05c00)
>   pcieport 0000:02:00.0: restoring config space at offset 0x24 (was 0x10001, writing 0x1fff1)
>   pcieport 0000:02:04.0: restoring config space at offset 0x20 (was 0x0, writing 0x89f07400)
>   pcieport 0000:02:01.0: restoring config space at offset 0x1c (was 0x101, writing 0x5151)
>   pcieport 0000:02:00.0: restoring config space at offset 0x20 (was 0x0, writing 0x8a008a00)
>   pcieport 0000:02:02.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
>   pcieport 0000:02:04.0: restoring config space at offset 0x1c (was 0x101, writing 0x6161)
>   pcieport 0000:02:01.0: restoring config space at offset 0x18 (was 0x0, writing 0x360402)
>   pcieport 0000:02:00.0: restoring config space at offset 0x1c (was 0x101, writing 0x1f1)
>   pcieport 0000:02:04.0: restoring config space at offset 0x18 (was 0x0, writing 0x6b3802)
>   pcieport 0000:02:02.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
>   pcieport 0000:02:00.0: restoring config space at offset 0x18 (was 0x0, writing 0x30302)
>   pcieport 0000:02:01.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
>   pcieport 0000:02:04.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
>   pcieport 0000:02:00.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
>   pcieport 0000:02:01.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
>   pcieport 0000:02:04.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
>   pcieport 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
>   xhci_hcd 0000:37:00.0: restoring config space at offset 0x10 (was 0x0, writing 0x73f00000)
>   ...
>   thunderbolt 0000:03:00.0: restoring config space at offset 0x14 (was 0x0, writing 0x8a040000)
>
> This is even worse. None of the mandatory delays are performed. If this
> would be S3 instead of s2idle then according to PCI FW spec 3.2 section
> 4.6.8.  there is a specific _DSM that allows the OS to skip the delays
> but this platform does not provide the _DSM and does not go to S3 anyway
> so no firmware is involved that could already handle these delays.
>
> In this particular Intel Coffee Lake platform these delays are not
> actually needed because there is an additional delay as part of the ACPI
> power resource that is used to turn on power to the hierarchy but since
> that additional delay is not required by any of standards (PCIe, ACPI)
> it is not present in the Intel Ice Lake, for example where missing the
> mandatory delays causes pciehp to start tearing down the stack too early
> (links are not yet trained).
>
> For this reason, change the PCIe portdrv PM resume hooks so that they
> perform the mandatory delays before the downstream component gets
> resumed. We perform the delays before port services are resumed because
> otherwise pciehp might find that the link is not up (even if it is just
> training) and tears-down the hierarchy.
>

We have gotten multiple reports in Fedora that this patch has broken
suspend for users of 5.1.20 and 5.2 stable kernels.

Justin
