Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0DAA592
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfIEOQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 10:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbfIEOQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 10:16:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1020206CD;
        Thu,  5 Sep 2019 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567692997;
        bh=CGAJUIJz+juuwAaJD4ZTV4RiFqhOn/XNcDZ6VtvCqQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f82WwUyhWlg1KGh1JlWsm4/jFYe6mQURSfoZk74KmI+LI0ag2Nv+w5+Fy3Q9hPgiP
         9biuGKfs28GCH4InwYj9oLfNVlleVY1i6jMDopx/doQhjnBRE2pSeFtu+D9r4g2R7q
         Y9EGuhxbi1d2bok7vkkMpwYm0aZytY7+itZclZCw=
Date:   Thu, 5 Sep 2019 16:16:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] x86/platform/uv: Decode UVsystab Info
Message-ID: <20190905141634.GA25790@kroah.com>
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
 <20190905130253.325911213@stormcage.eag.rdlabs.hpecorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905130253.325911213@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 08:02:58AM -0500, Mike Travis wrote:
> Decode the hubless UVsystab passed from BIOS to the kernel saving
> pertinent info in a similar manner that hubbed UVsystabs are decoded.
> 
> Signed-off-by: Mike Travis <mike.travis@hpe.com>
> Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
> Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> To: Thomas Gleixner <tglx@linutronix.de>
> To: Ingo Molnar <mingo@redhat.com>
> To: H. Peter Anvin <hpa@zytor.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Borislav Petkov <bp@alien8.de>
> To: Christoph Hellwig <hch@infradead.org>
> Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> Cc: Russ Anderson <russ.anderson@hpe.com>
> Cc: Hedi Berriche <hedi.berriche@hpe.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

If you are trying to get one of my automated "WTF: patch XXXX was
seriously submitted to be applied to the stable tree?" emails, you are
on track for it...

Please go read the documentation link I sent you last time and figure
out how you can justify any of this patch series for a stable kernel
tree.

Also, nit:

> --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -1303,7 +1303,8 @@ static int __init decode_uv_systab(void)
>  	struct uv_systab *st;
>  	int i;
>  
> -	if (uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE)
> +	/* Select only UV4 (hubbed or hubless) and higher */
> +	if (is_uv_hubbed(-2) < uv(4) && is_uv_hubless(-2) < uv(4))
>  		return 0;	/* No extended UVsystab required */
>  
>  	st = uv_systab;
> @@ -1554,8 +1555,19 @@ static __init int uv_system_init_hubless
>  
>  	/* Init kernel/BIOS interface */
>  	rc = uv_bios_init();
> +	if (rc < 0) {
> +		pr_err("UV: BIOS init error:%d\n", rc);

Why isn't that function printing an error?


> +		return rc;
> +	}
> +
> +	/* Process UVsystab */
> +	rc = decode_uv_systab();
> +	if (rc < 0) {
> +		pr_err("UV: UVsystab decode error:%d\n", rc);

Same here, have the function itself print the error, makes this type of
stuff much cleaner.

greg k-h
