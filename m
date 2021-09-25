Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935924184BB
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhIYVsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhIYVsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 17:48:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DC960EDF;
        Sat, 25 Sep 2021 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632606402;
        bh=IwJTlMAzH8i8U4CMf8blsQrL77W/6wGPb6pa8tNXmbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8vj8oSiG+RO8wc5mnJwpCTbG1vARBbLwnstdnyIw4DC23tz+mB14pNv2gfbXDWtS
         qDkKeBQSzy3IvPKJbZjhb8tpe5tMjtKOEh3on5kSgOVIcWkZ1JRfErj+lYCZtBsk3s
         Q+TqGD6TF63DlGyfKLxFDm9NBbH7VcYnX3HAs2a2ZMpV6wRbiKDmBastVMqofEJ0Jp
         X+g6XN9X0+KWtmb/w4Rm5BwIAoBf///t8i6hX1shtQOm2RXpl/RVXq+yLF4t+wLiLt
         M1vcohpFxUylEItfl8+6qFA3iWDjtE/Lr6vh7XhaUyefoUsjFxFPcDh6XRsMXx4RcN
         pHY+cRznGP3eQ==
Received: by pali.im (Postfix)
        id 1B1F8847; Sat, 25 Sep 2021 23:46:40 +0200 (CEST)
Date:   Sat, 25 Sep 2021 23:46:39 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     kabel@kernel.org, lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Increase polling delay to
 1.5s while waiting" failed to apply to 5.10-stable tree
Message-ID: <20210925214639.3fnbfc5eovd5bzqg@pali>
References: <16317166872028@kroah.com>
 <20210915165243.xaviyv4pwdmk6vhi@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210915165243.xaviyv4pwdmk6vhi@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 15 September 2021 18:52:43 Pali Rohár wrote:
> On Wednesday 15 September 2021 16:38:07 gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hello! Below is backport for 5.10 (and probably it should apply also for
> older versions):

Hello Greg! Have you looked at this backport for 5.10?

> From 4c801c70bdcd34ca0527d54206c0358a73154801 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
> Date: Thu, 22 Jul 2021 16:40:39 +0200
> Subject: [PATCH] PCI: aardvark: Increase polling delay to 1.5s while waiting
>  for PIO response
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Measurements in different conditions showed that aardvark hardware PIO
> response can take up to 1.44s. Increase wait timeout from 1ms to 1.5s to
> ensure that we do not miss responses from hardware. After 1.44s hardware
> returns errors (e.g. Completer abort).
> 
> The previous two patches fixed checking for PIO status, so now we can use
> it to also catch errors which are reported by hardware after 1.44s.
> 
> After applying this patch, kernel can detect and print PIO errors to dmesg:
> 
>     [    6.879999] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100004
>     [    6.896436] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100004
>     [    6.913049] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100010
>     [    6.929663] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100010
>     [    6.953558] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100014
>     [    6.970170] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100014
>     [    6.994328] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100004
> 
> Without this patch kernel prints only a generic error to dmesg:
> 
>     [    5.246847] advk-pcie d0070000.pcie: config read/write timed out
> 
> Link: https://lore.kernel.org/r/20210722144041.12661-3-pali@kernel.org
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Cc: stable@vger.kernel.org # 7fbcb5da811b ("PCI: aardvark: Don't rely on jiffies while holding spinlock")
> ---
>  drivers/pci/controller/pci-aardvark.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
> index b1b41b61e0bd..11cf6f4e9775 100644
> --- a/drivers/pci/controller/pci-aardvark.c
> +++ b/drivers/pci/controller/pci-aardvark.c
> @@ -173,7 +173,7 @@
>  	(PCIE_CONF_BUS(bus) | PCIE_CONF_DEV(PCI_SLOT(devfn))	| \
>  	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where))
>  
> -#define PIO_RETRY_CNT			500
> +#define PIO_RETRY_CNT			750000 /* 1.5 s */
>  #define PIO_RETRY_DELAY			2 /* 2 us*/
>  
>  #define LINK_WAIT_MAX_RETRIES		10
> -- 
> 2.20.1
> 
> 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 02bcec3ea5591720114f586960490b04b093a09e Mon Sep 17 00:00:00 2001
> > From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
> > Date: Thu, 22 Jul 2021 16:40:39 +0200
> > Subject: [PATCH] PCI: aardvark: Increase polling delay to 1.5s while waiting
> >  for PIO response
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > 
> > Measurements in different conditions showed that aardvark hardware PIO
> > response can take up to 1.44s. Increase wait timeout from 1ms to 1.5s to
> > ensure that we do not miss responses from hardware. After 1.44s hardware
> > returns errors (e.g. Completer abort).
> > 
> > The previous two patches fixed checking for PIO status, so now we can use
> > it to also catch errors which are reported by hardware after 1.44s.
> > 
> > After applying this patch, kernel can detect and print PIO errors to dmesg:
> > 
> >     [    6.879999] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100004
> >     [    6.896436] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100004
> >     [    6.913049] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100010
> >     [    6.929663] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100010
> >     [    6.953558] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100014
> >     [    6.970170] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100014
> >     [    6.994328] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100004
> > 
> > Without this patch kernel prints only a generic error to dmesg:
> > 
> >     [    5.246847] advk-pcie d0070000.pcie: config read/write timed out
> > 
> > Link: https://lore.kernel.org/r/20210722144041.12661-3-pali@kernel.org
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Reviewed-by: Marek Behún <kabel@kernel.org>
> > Cc: stable@vger.kernel.org # 7fbcb5da811b ("PCI: aardvark: Don't rely on jiffies while holding spinlock")
> > 
> > diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
> > index 8bd060e084f1..5b9e4e79c3ae 100644
> > --- a/drivers/pci/controller/pci-aardvark.c
> > +++ b/drivers/pci/controller/pci-aardvark.c
> > @@ -167,7 +167,7 @@
> >  #define PCIE_CONFIG_WR_TYPE0			0xa
> >  #define PCIE_CONFIG_WR_TYPE1			0xb
> >  
> > -#define PIO_RETRY_CNT			500
> > +#define PIO_RETRY_CNT			750000 /* 1.5 s */
> >  #define PIO_RETRY_DELAY			2 /* 2 us*/
> >  
> >  #define LINK_WAIT_MAX_RETRIES		10
> > 
