Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DAF41A32A
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 00:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbhI0Wih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 18:38:37 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:40647 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237903AbhI0Wid (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 18:38:33 -0400
Received: by mail-pg1-f176.google.com with SMTP id h3so19147386pgb.7;
        Mon, 27 Sep 2021 15:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nzF/B7ILPyCd+zjDaXEGUUuUM5/DgwfucVYeNWVHPMU=;
        b=pJqFtf4TEXaZy1zxc7zhhn8eMVHTZN2FKuXZT+ujBO6Qsm0bhY9f3HKZtOQ0DIpCTG
         d7Dsc17BQh2lQPT/1ysin9Q/eVY249vaQk/29np30P4s/TcraafT+3AjuUWA22EgyKW5
         0LjF1sgqkZl/rx+8lFF4cYT9KG0Mk9q2k93py3LNvEEyWC/Xp8TNft9L3QwSwgvtt+o6
         IO4AvWd7YtXbGVv6gK/OOv8FgUh72VFumY9JAyX8HCyEPYYPQTvKnKJMa/eoZi3UUrdp
         lm9lqCS4htizOreXhM4h0wGSNSF4jHPx4L4BWCszrSroJvG7t10oeHDl0q2CCRXrrN+A
         4AcQ==
X-Gm-Message-State: AOAM5316QkGfzlF+Fn0gN+flHdSDuqajItn9NMUw4jZzb6ms/dRyUrNz
        ZBHA/l0Wo7pHl3ntS+k+BzA=
X-Google-Smtp-Source: ABdhPJzPH45DsClKFQOwVCl+TO6J9UwhjhFCZkQV1/k2xmFfPmFQ/2JurdFj7VCXY/l7NBKc4kwWDA==
X-Received: by 2002:a62:1a09:0:b0:435:61bd:2d09 with SMTP id a9-20020a621a09000000b0043561bd2d09mr2235693pfa.71.1632782214516;
        Mon, 27 Sep 2021 15:36:54 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id k22sm18405129pfi.149.2021.09.27.15.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 15:36:54 -0700 (PDT)
Date:   Tue, 28 Sep 2021 00:36:40 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, paulmck@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <YVJHeHKwTg1G+pbE@rocinante>
References: <20210917024648.1383476-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210917024648.1383476-1-kuba@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jakub,

> My Lenovo T490s with i7-8665U had been marking TSC as unstable
> since v5.13, resulting in very sluggish desktop experience...
> 
> Kernel logs show:
> 
>   clocksource: timekeeping watchdog on CPU3: hpet read-back delay of 316000ns, attempt 4, marking unstable
>   tsc: Marking TSC unstable due to clocksource watchdog
>   TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
>   sched_clock: Marking unstable (14539801827657, -530891666)<-(14539319241737, -48307500)
>   clocksource: Checking clocksource tsc synchronization from CPU 3 to CPUs 0-2,6-7.
>   clocksource: Switched to clocksource hpet
> 
> I have a 8086:3e34 bridge, also known as "Host bridge: Intel
> Corporation Coffee Lake HOST and DRAM Controller (rev 0c)".
> Add it to the list.
> 
> We should perhaps consider applying this quirk more widely.
> The Intel documentation does not list my device [1], but
> linuxhw [2] does, and it seems to list a few more bridges
> we do not currently cover (3e31, 3ecc, 3e35, 3e0f).

I wish someone from Intel would be a little more forthcoming and chimed in
about the other devices.  I guess, we will cross that bridge when we get to
it, so to speak.

> [1] https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/8th-gen-core-family-datasheet-vol-2.pdf
> [2] https://github.com/linuxhw/DevicePopulation/blob/master/README.md
> 
> Cc: stable@vger.kernel.org # v5.13+
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: - add the dmesg output
> ---
>  arch/x86/kernel/early-quirks.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 38837dad46e6..7d2de04f8750 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -716,6 +716,8 @@ static struct chipset early_qrk[] __initdata = {
>  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>  	{ PCI_VENDOR_ID_INTEL, 0x3e20,
>  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> +	{ PCI_VENDOR_ID_INTEL, 0x3e34,
> +		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>  	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
>  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>  	{ PCI_VENDOR_ID_INTEL, 0x8a12,

Thank you!

Acked-by: Krzysztof Wilczyński <kw@linux.com>

	Krzysztof
