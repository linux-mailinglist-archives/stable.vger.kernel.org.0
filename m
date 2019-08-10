Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8A88E7B
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 23:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfHJVCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 17:02:06 -0400
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:48350 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbfHJVCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 17:02:06 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id D4B0D8368EFE;
        Sat, 10 Aug 2019 21:02:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:599:800:960:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3874:4321:4425:5007:7576:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21433:21451:21627:21772:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:23,LUA_SUMMARY:none
X-HE-Tag: rings78_8660776233603
X-Filterd-Recvd-Size: 2510
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Sat, 10 Aug 2019 21:02:03 +0000 (UTC)
Message-ID: <b8a167bfb3731a665ba54b4fa4ccf899a31d9644.camel@perches.com>
Subject: Re: [PATCH 3.16 004/157] iio: Use kmalloc_array() in
 iio_scan_mask_set()
From:   Joe Perches <joe@perches.com>
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Jonathan Cameron <jic23@kernel.org>
Date:   Sat, 10 Aug 2019 14:02:02 -0700
In-Reply-To: <lsq.1565469607.57202441@decadent.org.uk>
References: <lsq.1565469607.57202441@decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2019-08-10 at 21:40 +0100, Ben Hutchings wrote:
> 3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

Unless to enable applying further patches,
I doubt there is ever a need to have any
of Markus Elfring's patches applied to any
-stable kernel.

> ------------------
> 
> From: Markus Elfring <elfring@users.sourceforge.net>
> 
> commit 057ac1acdfc4743f066fcefe359385cad00549eb upstream.
> 
> A multiplication for the size determination of a memory allocation
> indicated that an array data structure should be processed.
> Thus use the corresponding function "kmalloc_array".
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/iio/industrialio-buffer.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> --- a/drivers/iio/industrialio-buffer.c
> +++ b/drivers/iio/industrialio-buffer.c
> @@ -836,10 +836,9 @@ int iio_scan_mask_set(struct iio_dev *in
>  	const unsigned long *mask;
>  	unsigned long *trialmask;
>  
> -	trialmask = kmalloc(sizeof(*trialmask)*
> -			    BITS_TO_LONGS(indio_dev->masklength),
> -			    GFP_KERNEL);
> -
> +	trialmask = kmalloc_array(BITS_TO_LONGS(indio_dev->masklength),
> +				  sizeof(*trialmask),
> +				  GFP_KERNEL);
>  	if (trialmask == NULL)
>  		return -ENOMEM;
>  	if (!indio_dev->masklength) {
> 

