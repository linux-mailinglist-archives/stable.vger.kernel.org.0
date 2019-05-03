Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717861290D
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 09:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfECHsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 03:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfECHsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 03:48:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00F1F205F4;
        Fri,  3 May 2019 07:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556869716;
        bh=HNdiThygh/WXsUKAjnlXN4y71aTiNppah2fty/UkA2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qwuzjya+tCbxUYHXP7cevwNxW24wM3tlVgItz3ZhijQzrUjMybEeaC/HJhFClVrYt
         X3WgDRi/h9WoRT0ccUXZ6CBZAfbHQ7HjpQhROSYkxQBpAqoJ1We6Bc1NO57kEon4aY
         pXKk8hDUfDqrCDvmhRfa/r3jh53toXYhLkHEJq9A=
Date:   Fri, 3 May 2019 09:48:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrew Donnellan <ajd@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Stewart Smith <stewart@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/powernv: Restrict OPAL symbol map to only be
 readable by root
Message-ID: <20190503074834.GA27088@kroah.com>
References: <20190503074405.20708-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503074405.20708-1-ajd@linux.ibm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 05:44:05PM +1000, Andrew Donnellan wrote:
> Currently the OPAL symbol map is globally readable, which seems bad as it
> contains physical addresses.
> 
> Restrict it to root.
> 
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Jordan Niethe <jniethe5@gmail.com>
> Cc: Stewart Smith <stewart@linux.ibm.com>
> Fixes: c8742f85125d ("powerpc/powernv: Expose OPAL firmware symbol map")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
>  arch/powerpc/platforms/powernv/opal.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
> index 2b0eca104f86..505460a72052 100644
> --- a/arch/powerpc/platforms/powernv/opal.c
> +++ b/arch/powerpc/platforms/powernv/opal.c
> @@ -681,7 +681,10 @@ static ssize_t symbol_map_read(struct file *fp, struct kobject *kobj,
>  				       bin_attr->size);
>  }
>  
> -static BIN_ATTR_RO(symbol_map, 0);
> +static struct bin_attribute symbol_map_attr = {
> +	.attr = {.name = "symbol_map", .mode = 0400},
> +	.read = symbol_map_read
> +};
>  
>  static void opal_export_symmap(void)
>  {
> @@ -698,10 +701,10 @@ static void opal_export_symmap(void)
>  		return;
>  
>  	/* Setup attributes */
> -	bin_attr_symbol_map.private = __va(be64_to_cpu(syms[0]));
> -	bin_attr_symbol_map.size = be64_to_cpu(syms[1]);
> +        symbol_map_attr.private = __va(be64_to_cpu(syms[0]));

no tab?

checkpatch.pl is your friend :)

