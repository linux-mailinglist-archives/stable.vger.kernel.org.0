Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3740B381A5E
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhEOSB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 14:01:59 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:33384 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhEOSB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 14:01:57 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 593D592009C; Sat, 15 May 2021 20:00:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4E5BB92009B;
        Sat, 15 May 2021 20:00:42 +0200 (CEST)
Date:   Sat, 15 May 2021 20:00:42 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] FDDI: defxx: Make MMIO the configuration
 default except for" failed to apply to 5.10-stable tree
In-Reply-To: <162081180118299@kroah.com>
Message-ID: <alpine.DEB.2.21.2105151906240.3032@angie.orcam.me.uk>
References: <162081180118299@kroah.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021, gregkh@linuxfoundation.org wrote:

> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

 Hmm, I can see it's commit 8fa5a93a74fa and commit 8b2055c13731 in 
queue/5.10 and linux-5.10.y respectively, so I guess it did apply after 
all, right?  I've sent a version for 5.4-stable and earlier separately.

  Maciej

> ------------------ original commit in Linus's tree ------------------
> 
> >From 193ced4a79599352d63cb8c9e2f0c6043106eb6a Mon Sep 17 00:00:00 2001
> From: "Maciej W. Rozycki" <macro@orcam.me.uk>
> Date: Wed, 10 Mar 2021 13:03:14 +0100
> Subject: [PATCH] FDDI: defxx: Make MMIO the configuration default except for
>  EISA
> 
> Recent versions of the PCI Express specification have deprecated support
> for I/O transactions and actually some PCIe host bridges, such as Power
> Systems Host Bridge 4 (PHB4), do not implement them.
> 
> The default kernel configuration choice for the defxx driver is the use
> of I/O ports rather than MMIO for PCI and EISA systems.  It may have
> made sense as a conservative backwards compatible choice back when MMIO
> operation support was added to the driver as a part of TURBOchannel bus
> support.  However nowadays this configuration choice makes the driver
> unusable with systems that do not implement I/O transactions for PCIe.
> 
> Make DEFXX_MMIO the configuration default then, except where configured
> for EISA.  This exception is because an EISA adapter can have its MMIO
> decoding disabled with ECU (EISA Configuration Utility) and therefore
> not available with the resource allocation infrastructure we implement,
> while port I/O is always readily available as it uses slot-specific
> addressing, directly mapped to the slot an option card has been placed
> in and handled with our EISA bus support core.  Conversely a kernel that
> supports modern systems which may not have I/O transactions implemented
> for PCIe will usually not be expected to handle legacy EISA systems.
> 
> The change of the default will make it easier for people, including but
> not limited to distribution packagers, to make a working choice for the
> driver.
> 
> Update the option description accordingly and while at it replace the
> potentially ambiguous PIO acronym with IOP for "port I/O" vs "I/O ports"
> according to our nomenclature used elsewhere.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: e89a2cfb7d7b ("[TC] defxx: TURBOchannel support")
> Cc: stable@vger.kernel.org # v2.6.21+
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/fddi/Kconfig b/drivers/net/fddi/Kconfig
> index f722079dfb6a..f99c1048c97e 100644
> --- a/drivers/net/fddi/Kconfig
> +++ b/drivers/net/fddi/Kconfig
> @@ -40,17 +40,20 @@ config DEFXX
>  
>  config DEFXX_MMIO
>  	bool
> -	prompt "Use MMIO instead of PIO" if PCI || EISA
> +	prompt "Use MMIO instead of IOP" if PCI || EISA
>  	depends on DEFXX
> -	default n if PCI || EISA
> +	default n if EISA
>  	default y
>  	help
>  	  This instructs the driver to use EISA or PCI memory-mapped I/O
> -	  (MMIO) as appropriate instead of programmed I/O ports (PIO).
> +	  (MMIO) as appropriate instead of programmed I/O ports (IOP).
>  	  Enabling this gives an improvement in processing time in parts
> -	  of the driver, but it may cause problems with EISA (DEFEA)
> -	  adapters.  TURBOchannel does not have the concept of I/O ports,
> -	  so MMIO is always used for these (DEFTA) adapters.
> +	  of the driver, but it requires a memory window to be configured
> +	  for EISA (DEFEA) adapters that may not always be available.
> +	  Conversely some PCIe host bridges do not support IOP, so MMIO
> +	  may be required to access PCI (DEFPA) adapters on downstream PCI
> +	  buses with some systems.  TURBOchannel does not have the concept
> +	  of I/O ports, so MMIO is always used for these (DEFTA) adapters.
>  
>  	  If unsure, say N.
>  
> 
