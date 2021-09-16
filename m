Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613CF40DD91
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbhIPPI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 11:08:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhIPPI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 11:08:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B5661108;
        Thu, 16 Sep 2021 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631804828;
        bh=6FCGFwmA2m5coqWi4R81zVen0a3OhC1F5541uwYoGLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cYV+8oVEkRu8jnZ9UqfCvJ8RyP/lO1f4Hjl1Ulq3/WFy761RQZfF5VpJ7QA4RFhwl
         j62o0muv3zOCy4TUT7zFm+sL5SrtWaUnOImSTCrLADVS0zz1f5ts+z6Ig4VPrdP4I6
         9aAcxX6cIz/YpHb/x1/JWASP+dZNqgcXI/MHq0K7LG28R7ApH4FzD5PJKjuEZzB3dz
         83QdqmJu+utIzjBA1VFwIv8+O7+MceUnr/Q0zk3xURtvJhGlfZqChBehfh80CqvjrV
         p06kolRfeuVaQvUC4fi3p0Mg0EpKOxaMQSH+AkaCIi8Bv7c9r8Ay7Ng0Matbu5GfA1
         bBTGJc4YHIuDw==
Date:   Thu, 16 Sep 2021 10:07:07 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210916150707.GA1611532@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916131739.1260552-1-kuba@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 06:17:39AM -0700, Jakub Kicinski wrote:
> My Lenovo T490s with i7-8665U had been marking TSC as unstable
> since v5.13, resulting in very sluggish desktop experience...

Including the actual dmesg log line here might help others locate this
fix.

> I have a 8086:3e34 bridge, also known as "Host bridge: Intel
> Corporation Coffee Lake HOST and DRAM Controller (rev 0c)".
> Add it to the list.
> 
> We should perhaps consider applying this quirk more widely.
> The Intel documentation does not list my device [1], but
> linuxhw [2] does, and it seems to list a few more bridges
> we do not currently cover (3e31, 3ecc, 3e35, 3e0f).

In the fine tradition of:

  e0748539e3d5 ("x86/intel: Disable HPET on Intel Ice Lake platforms")
  f8edbde885bb ("x86/intel: Disable HPET on Intel Coffee Lake H platforms")
  fc5db58539b4 ("x86/quirks: Disable HPET on Intel Coffe Lake platforms")
  62187910b0fc ("x86/intel: Add quirk to disable HPET for the Baytrail plat
form")

This seems to be an ongoing issue, not just a point defect in a single
product, and I really hate the onesy-twosy nature of this.  Is there
really no way to detect this issue automatically or fix whatever Linux
bug makes us trip over this?  I am no clock expert, so I have
absolutely no idea whether this is possible.

> [1] https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/8th-gen-core-family-datasheet-vol-2.pdf
> [2] https://github.com/linuxhw/DevicePopulation/blob/master/README.md
> 
> Cc: stable@vger.kernel.org # v5.13+

How did you pick v5.13?  force_disable_hpet() was added by
62187910b0fc ("x86/intel: Add quirk to disable HPET for the Baytrail
platform"), which appeared in v3.15.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
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
> -- 
> 2.31.1
> 
