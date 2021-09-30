Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C510441DFC2
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 19:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351164AbhI3RI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 13:08:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51430 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349614AbhI3RI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 13:08:58 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633021634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LPr7/T/rWcJwssj7Csqjd9LQAoR0LbS0++w2zDmkKyI=;
        b=2LLroHCNp5+mkq+qW/QBbtaLNBY57VQJVJumrb5dTZGJvhQrIOrVqozYI2KKbbBgdMNkrN
        0DUzWIOpsCX9BXu/xai9R+S/F6XLqpLT4BMXSKAOGbUDxn5aFDsBmq/z9MWCSk1Vc0TEtm
        HEUq0j95Sn+A3strkq2FejgVWnj+9PFiWYNmI/evi/ZjQ/sOuWD3qLHFJMa+F4SvT+20ao
        UGb8d28pRT7Z7JpT1lPwL0vawMrmjXS3LhWrFdsyUEcY/qAGk5jBvLR6UeYm8EHki+PBMH
        2S0wqnTz5fKCE0rJDbnNqFqQN+icXNuQgrAF1kwiPZ6kQJT3OwMrT/3xIY1lIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633021634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LPr7/T/rWcJwssj7Csqjd9LQAoR0LbS0++w2zDmkKyI=;
        b=/YRRHYQDWItKGoXgJplNGK9pUcSwd2GzCNxKrvM2Z8mupJ3LZF9ptOEJJsmQU2A1JvENpp
        RgqN7ZoHL4wcC2DQ==
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        jose.souza@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Harry Pan <harry.pan@intel.com>
Subject: Re: [PATCH RFT] x86/hpet: Use another crystalball to evaluate HPET
 usability
In-Reply-To: <CAJZ5v0hH_h9V0dACEMomqZbwpQUf6GB_8UK9+S1AGEdFQqvPLQ@mail.gmail.com>
References: <20210929160550.GA773748@bhelgaas> <87mtnu77mr.ffs@tglx>
 <87k0iy71rw.ffs@tglx>
 <CAJZ5v0hH_h9V0dACEMomqZbwpQUf6GB_8UK9+S1AGEdFQqvPLQ@mail.gmail.com>
Date:   Thu, 30 Sep 2021 19:07:14 +0200
Message-ID: <87h7e26lh9.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30 2021 at 13:38, Rafael J. Wysocki wrote:
>> +static bool __init get_mwait_substates(unsigned int *mwait_substates)
>> +{
>> +       unsigned int eax, ebx, ecx;
>> +
>> +       if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
>> +               return false;
>> +
>> +       if (!boot_cpu_has(X86_FEATURE_MWAIT))
>> +               return false;
>> +
>> +       if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
>> +               return false;
>> +
>> +       cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, mwait_substates);
>> +
>> +       if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
>> +           !(ecx & CPUID5_ECX_INTERRUPT_BREAK) ||
>> +           !*mwait_substates)
>> +               return false;
>
> I would do
>
> return (ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) && (ecx &
> CPUID5_ECX_INTERRUPT_BREAK) && *mwait_substates;
>
> And this function could just return the mwait_substates value proper,
> because returning 0 then would be equivalent to returning 'false' from
> it as is.

Let me move that substates check into the function which makes it even simpler.

Thanks,

        tglx
