Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770D920032B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgFSIEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:04:10 -0400
Received: from winnie.ispras.ru ([83.149.199.91]:29992 "EHLO smtp.ispras.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730921AbgFSIDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 04:03:20 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2020 04:03:19 EDT
Received: from monopod.intra.ispras.ru (monopod.intra.ispras.ru [10.10.3.121])
        by smtp.ispras.ru (Postfix) with ESMTP id 5A38E203C1;
        Fri, 19 Jun 2020 10:56:42 +0300 (MSK)
Date:   Fri, 19 Jun 2020 10:56:42 +0300 (MSK)
From:   Alexander Monakov <amonakov@ispras.ru>
To:     Sasha Levin <sashal@kernel.org>
cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "x86/amd_nb: Add AMD family 17h model 60h PCI IDs" has
 been added to the 5.7-stable tree
In-Reply-To: <20200618211421.CDE7820890@mail.kernel.org>
Message-ID: <alpine.LNX.2.20.13.2006191051350.31660@monopod.intra.ispras.ru>
References: <20200618211421.CDE7820890@mail.kernel.org>
User-Agent: Alpine 2.20.13 (LNX 116 2015-12-14)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Jun 2020, Sasha Levin wrote:

> This is a note to let you know that I've just added the patch titled
> 
>     x86/amd_nb: Add AMD family 17h model 60h PCI IDs
> 
> to the 5.7-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      x86-amd_nb-add-amd-family-17h-model-60h-pci-ids.patch
> and it can be found in the queue-5.7 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

It's not good to pick this patch alone into stable. Either all 3 patches
from https://lore.kernel.org/lkml/20200510204842.2603-1-amonakov@ispras.ru/
should be taken, or none of those.

In particular, the edac module will warn on load without the third patch.

Likewise for 5.4-stable (should I send a separate mail for that?)

Alexander

> commit 2adc45163a51ed6f0a0e776ee5c13639dfe22a8e
> Author: Alexander Monakov <amonakov@ispras.ru>
> Date:   Sun May 10 20:48:40 2020 +0000
> 
>     x86/amd_nb: Add AMD family 17h model 60h PCI IDs
>     
>     [ Upstream commit a4e91825d7e1252f7cba005f1451e5464b23c15d ]
>     
>     Add PCI IDs for AMD Renoir (4000-series Ryzen CPUs). This is necessary
>     to enable support for temperature sensors via the k10temp module.
>     
>     Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
>     Signed-off-by: Borislav Petkov <bp@suse.de>
>     Acked-by: Yazen Ghannam <yazen.ghannam@amd.com>
>     Acked-by: Guenter Roeck <linux@roeck-us.net>
>     Link: https://lkml.kernel.org/r/20200510204842.2603-2-amonakov@ispras.ru
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
> index b6b3297851f3..18f6b7c4bd79 100644
> --- a/arch/x86/kernel/amd_nb.c
> +++ b/arch/x86/kernel/amd_nb.c
> @@ -18,9 +18,11 @@
>  #define PCI_DEVICE_ID_AMD_17H_ROOT	0x1450
>  #define PCI_DEVICE_ID_AMD_17H_M10H_ROOT	0x15d0
>  #define PCI_DEVICE_ID_AMD_17H_M30H_ROOT	0x1480
> +#define PCI_DEVICE_ID_AMD_17H_M60H_ROOT	0x1630
>  #define PCI_DEVICE_ID_AMD_17H_DF_F4	0x1464
>  #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F4 0x15ec
>  #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F4 0x1494
> +#define PCI_DEVICE_ID_AMD_17H_M60H_DF_F4 0x144c
>  #define PCI_DEVICE_ID_AMD_17H_M70H_DF_F4 0x1444
>  #define PCI_DEVICE_ID_AMD_19H_DF_F4	0x1654
>  
> @@ -33,6 +35,7 @@ static const struct pci_device_id amd_root_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_ROOT) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M10H_ROOT) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M30H_ROOT) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M60H_ROOT) },
>  	{}
>  };
>  
> @@ -50,6 +53,7 @@ static const struct pci_device_id amd_nb_misc_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_DF_F3) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M10H_DF_F3) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F3) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M60H_DF_F3) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F3) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_DF_F3) },
> @@ -65,6 +69,7 @@ static const struct pci_device_id amd_nb_link_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_DF_F4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M10H_DF_F4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F4) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M60H_DF_F4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_DF_F4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F4) },
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 9a57e6717e5c..0ad57693f392 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -550,6 +550,7 @@
>  #define PCI_DEVICE_ID_AMD_17H_DF_F3	0x1463
>  #define PCI_DEVICE_ID_AMD_17H_M10H_DF_F3 0x15eb
>  #define PCI_DEVICE_ID_AMD_17H_M30H_DF_F3 0x1493
> +#define PCI_DEVICE_ID_AMD_17H_M60H_DF_F3 0x144b
>  #define PCI_DEVICE_ID_AMD_17H_M70H_DF_F3 0x1443
>  #define PCI_DEVICE_ID_AMD_19H_DF_F3	0x1653
>  #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
> 
