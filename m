Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2825741E059
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352829AbhI3Rvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 13:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352811AbhI3Rvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 13:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83A6B619F6;
        Thu, 30 Sep 2021 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633024204;
        bh=wmMWLvwhnbwHzx6QepxW0UDh7l7UL5DDPF2/tuPgT5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LpCNnl3cJrz51EecxYyNZfq8KhNrzg3NL8dyMt1Nri1eK8xVpIf/qcquEYQnPyFuZ
         fhsBSsoWLvakaRQPrctNiaEfSgPeJHF8Yo3n9lPtgINFvxQBRtsSeVCkRUnQWFyUkp
         GdJOnzBFFTR1cruWUv1qaiZ/+MTFuX8yg2LngKQ6fIurJfr9H9os4hZzY+7SIc0YcR
         oAmZIJOzZZDmL08ebCAsaCFMlEO9+T60Xkl5gV7asFfJ7kwwc8sZZ/j+eF6cFCwk1J
         nC5ekYAfn4N/WJqXsQ7nKhwdunIiO6FXZ8OWlIgeYpfy8NjFPre7QrhpZzFA6EWy9O
         oHgIxlDHRvr2A==
Date:   Thu, 30 Sep 2021 10:50:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        jose.souza@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Harry Pan <harry.pan@intel.com>
Subject: Re: [PATCH RFT v2] x86/hpet: Use another crystalball to evaluate
 HPET usability
Message-ID: <20210930105002.67c87396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87czoq6kt8.ffs@tglx>
References: <20210929160550.GA773748@bhelgaas>
        <87mtnu77mr.ffs@tglx>
        <87k0iy71rw.ffs@tglx>
        <CAJZ5v0hH_h9V0dACEMomqZbwpQUf6GB_8UK9+S1AGEdFQqvPLQ@mail.gmail.com>
        <87h7e26lh9.ffs@tglx>
        <87czoq6kt8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Sep 2021 19:21:39 +0200 Thomas Gleixner wrote:
> On recent Intel systems the HPET stops working when the system reaches PC10
> idle state.
> 
> The approach of adding PCI ids to the early quirks to disable HPET on
> these systems is a whack a mole game which makes no sense.
> 
> Check for PC10 instead and force disable HPET if supported. The check is
> overbroad as it does not take ACPI, intel_idle enablement and command
> line parameters into account. That's fine as long as there is at least
> PMTIMER available to calibrate the TSC frequency. The decision can be
> overruled by adding "hpet=force" on the kernel command line.
> 
> Remove the related early PCI quirks for affected Ice Cake and Coffin Lake
> systems as they are not longer required. That should also cover all
> other systems, i.e. Tiger Rag and newer generations, which are most
> likely affected by this as well.
> 
> Fixes: Yet another hardware trainwreck
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Not-yet-signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Tested-by: Jakub Kicinski <kuba@kernel.org>

$ dmesg | grep -i hpet
[    0.014755] ACPI: HPET 0x000000005DC0F000 000038
[    0.014854] ACPI: Reserving HPET table memory at [mem 0x5dc0f000-0x5dc0f037]
[    0.144457] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.296550] hpet: HPET dysfunctional in PC10. Force disabled.
[    0.912010] hpet_acpi_add: no address or irqs in _CRS
$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc acpi_pm 
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc
$ dmesg | grep RIP
$
