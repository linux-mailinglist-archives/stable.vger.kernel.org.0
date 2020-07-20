Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7909226C69
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgGTQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:50:31 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:44054 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728495AbgGTQub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 12:50:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id C62BE1802DA32;
        Mon, 20 Jul 2020 16:50:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2903:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:4425:5007:6119:7576:7903:8603:10004:10400:11026:11232:11658:11914:12043:12114:12297:12438:12555:12740:12760:12895:12986:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: tree55_401562926f26
X-Filterd-Recvd-Size: 2217
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Mon, 20 Jul 2020 16:50:28 +0000 (UTC)
Message-ID: <613577badc9937049d40ff14d11646f64b3dac36.camel@perches.com>
Subject: Re: [PATCH 5.4 047/215] iio:humidity:hdc100x Fix alignment and data
 leak issues
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Alison Schofield <amsfield22@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date:   Mon, 20 Jul 2020 09:50:26 -0700
In-Reply-To: <20200720152822.437100100@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
         <20200720152822.437100100@linuxfoundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-07-20 at 17:35 +0200, Greg Kroah-Hartman wrote:
> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> commit ea5e7a7bb6205d24371373cd80325db1bc15eded upstream.
> 
> One of a class of bugs pointed out by Lars in a recent review.
> iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
> to the size of the timestamp (8 bytes).  This is not guaranteed in
> this driver which uses an array of smaller elements on the stack.
> As Lars also noted this anti pattern can involve a leak of data to
> userspace and that indeed can happen here.  We close both issues by
> moving to a suitable structure in the iio_priv() data.
> This data is allocated with kzalloc so no data can leak apart
> from previous readings.
[]
> +++ b/drivers/iio/humidity/hdc100x.c
> @@ -38,6 +38,11 @@ struct hdc100x_data {
>  
>  	/* integration time of the sensor */
>  	int adc_int_us[2];
> +	/* Ensure natural alignment of timestamp */
> +	struct {
> +		__be16 channels[2];
> +		s64 ts __aligned(8);

Why does an s64 need __aligned(8) ?
This seems needlessly redundant.

Isn't this naturally aligned by the compiler?

The struct isn't packed.

