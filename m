Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3A3178E81
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 11:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgCDKjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 05:39:55 -0500
Received: from foss.arm.com ([217.140.110.172]:60620 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgCDKjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 05:39:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9335530E;
        Wed,  4 Mar 2020 02:39:54 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88AAE3F534;
        Wed,  4 Mar 2020 02:39:53 -0800 (PST)
Date:   Wed, 4 Mar 2020 10:39:50 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com,
        stable@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH] vfio: platform: Switch to platform_get_irq_optional()
Message-ID: <20200304103950.4e98d0ff@donnerap.cambridge.arm.com>
In-Reply-To: <20200302203715.13889-1-eric.auger@redhat.com>
References: <20200302203715.13889-1-eric.auger@redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  2 Mar 2020 21:37:15 +0100
Eric Auger <eric.auger@redhat.com> wrote:

> Since commit 7723f4c5ecdb ("driver core: platform: Add an error
> message to platform_get_irq*()"), platform_get_irq() calls dev_err()
> on an error. As we enumerate all interrupts until platform_get_irq()
> fails, we now systematically get a message such as:
> "vfio-platform fff51000.ethernet: IRQ index 3 not found" which is
> a false positive.
> 
> Let's use platform_get_irq_optional() instead.

Yes, that seems correct to me and avoids the false positive error message I saw before.
 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Cc: stable@vger.kernel.org # v5.3+

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>

Thanks!
Andre

> ---
>  drivers/vfio/platform/vfio_platform.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index ae1a5eb98620..1e2769010089 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -44,7 +44,7 @@ static int get_platform_irq(struct vfio_platform_device *vdev, int i)
>  {
>  	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
>  
> -	return platform_get_irq(pdev, i);
> +	return platform_get_irq_optional(pdev, i);
>  }
>  
>  static int vfio_platform_probe(struct platform_device *pdev)

