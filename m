Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F585386DA7
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243398AbhEQX2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:28:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55934 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbhEQX2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:28:21 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621294023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o1uB9QtPenPr6TAPimIlnSz22cHSphlYyyuDv8n5vns=;
        b=KV6xNF9bc6gkFF0B1a4EINc469/fWs0giQRDPreaShpNYlaXQ0aQu3KdHMPvk1rNVQR/sV
        3X1kntSeHo6D60eXm1UjnNyy4t39FcQXtC/gBoichXv5cm0PFWlJQfcescyBM+1n5Nk1DF
        8+6vSVpxrsjATDvS0j1peHqqOnJh2ZSmJFiqBwQDdRvl0LGaaICalIAk1eP1QAdOhnRGNW
        oV9LrwSw+tT2O5e/xo9mPow0otSp1P5mrV35MYqCpxnyGgZtJOTw1lBNBryJDMbyFDjXVP
        Zs43P6qYPS1zXRDN8vVO+pqu2I+pPk+owmVJ+dKb/TVqdIon0GI6k9+Fz9i1sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621294023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o1uB9QtPenPr6TAPimIlnSz22cHSphlYyyuDv8n5vns=;
        b=L/VKAsznb/XEYy/QPeQygiKB4CfM+Ver5HYSHu2BBW0Z+Xzr5hYm1J9ewwU68Gtlp2ctrd
        PSvj76yg2n8m2lAA==
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
In-Reply-To: <b509418f-9fff-ab27-b460-ecbe6fdea09a@gmail.com>
References: <87a6otfblh.ffs@nanos.tec.linutronix.de> <b509418f-9fff-ab27-b460-ecbe6fdea09a@gmail.com>
Date:   Tue, 18 May 2021 01:27:02 +0200
Message-ID: <87lf8ddjqx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17 2021 at 21:25, Maximilian Luz wrote:
> On 5/17/21 8:40 PM, Thomas Gleixner wrote:
>> Can you please add "apic=verbose" to the kernel command line and provide
>> full dmesg output for a kernel w/o your patch and one with your patch
>> applied?
>
> I don't actually own an affected device, but I'm sure Sachi can provide
> you with that.

Ok.

> As far as we can tell, due to the NULL PIC being chosen nr_legacy_irqs()
> returns 0. That in turn causes mp_check_pin_attr() to return false
> because is_level and active_low don't seem to match the expected
> values.

Ok.

> That check is essentially ignored if nr_legacy_irqs() returns a high
> enough value.

Close enough.

> I guess that might also be a firmware bug here? Not sure where the
> expected values come from.

They come from the interrupt override ACPI table and if not supplied
then irq 0-15 is preset with default values, which are type=edge and
polarity=high, i.e.  the opposite of what the failing driver wants.

The ACPI table lacks an override entry for IRQ7. I looked at one of the
dmesg files in that github thread and that has overrides:

[    0.111674] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.111681] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.111688] ACPI: IRQ0 used by override.
[    0.111692] ACPI: IRQ9 used by override.

IRQ7 should have a corresponding entry as IRQ9 has:

https://github.com/linux-surface/acpidumps/blob/4da0148744164cea0c924dab92f45842fde03177/surface_laptop_4_amd/apic.dsl#L178

          Subtable Type : 02 [Interrupt Source Override]
                 Length : 0A
                    Bus : 00
                 Source : 07
              Interrupt : 00000007
  Flags (decoded below) : 000F
               Polarity : 3
           Trigger Mode : 3

> Sachi can probably walk you through this a bit better as she's the one
> who tracked this down. See also [1, 2] and following comments.

Impressive detective work!

Sachi, can you please try the hack below to confirm the above?

It's not meant to be a solution, but it's the most trivial way to
validate this.

I'm pretty sure that Windows on Surface does not care about the PIC at
all. Whether that's on purpose to safe power or just because Windows
ignores the PIC completely by now does not matter at all. No idea how
that repeated poking on the PIC makes it come alive either and TBH, I
don't care too much about it simply because Linux is able to cope with a
missing PIC as long as the ACPI tables are correct.

I'm way too tired to think about a proper solution for that problem and
I noticed another related issue in that dmesg output:

[    0.272448] Failed to register legacy timer interrupt

It's not a problem which causes failures, but it's related to the
missing PIC.

Needs some more thoughts with brain awake...

Thanks,

        tglx
---
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -21,6 +21,7 @@
 #include <linux/efi-bgrt.h>
 #include <linux/serial_core.h>
 #include <linux/pgtable.h>
+#include <linux/dmi.h>
 
 #include <asm/e820/api.h>
 #include <asm/irqdomain.h>
@@ -1155,6 +1156,17 @@ static void __init mp_config_acpi_legacy
 	}
 }
 
+static const struct dmi_system_id surface_quirk[] __initconst = {
+	{
+		.ident = "Microsoft Surface Laptop 4 (AMD)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "Surface_Laptop_4_1952:1953")
+		},
+	},
+	{}
+};
+
 /*
  * Parse IOAPIC related entries in MADT
  * returns 0 on success, < 0 on error
@@ -1212,6 +1224,11 @@ static int __init acpi_parse_madt_ioapic
 		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0,
 				      acpi_gbl_FADT.sci_interrupt);
 
+	if (dmi_check_system(surface_quirk)) {
+		pr_warn("Surface hack: Override irq 7\n");
+		mp_override_legacy_irq(7, 3, 3, 7);
+	}
+
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
 


