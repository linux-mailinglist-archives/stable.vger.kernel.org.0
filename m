Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4556223712
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 10:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgGQIcO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 17 Jul 2020 04:32:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38827 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgGQIcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 04:32:14 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-30-vOfOUf7XOJW9yv-pErlP7A-1; Fri, 17 Jul 2020 09:32:08 +0100
X-MC-Unique: vOfOUf7XOJW9yv-pErlP7A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 17 Jul 2020 09:32:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 17 Jul 2020 09:32:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'js1304@gmail.com'" <js1304@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@lge.com" <kernel-team@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
Thread-Topic: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
Thread-Index: AQHWWmWbQrqMs3IygU6Uq8saGSVLGakLcr1w
Date:   Fri, 17 Jul 2020 08:32:07 +0000
Message-ID: <be55deff4ef1453983522d247bd36110@AcuMS.aculab.com>
References: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: js1304@gmail.com
> Sent: 15 July 2020 06:05
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Currently, preventing cma area in page allocation is implemented by using
> current_gfp_context(). However, there are two problems of this
> implementation.
...
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6416d08..cd53894 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
...
> @@ -3693,6 +3691,16 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
>  	return alloc_flags;
>  }
> 
> +static inline void current_alloc_flags(gfp_t gfp_mask,
> +				unsigned int *alloc_flags)
> +{
> +	unsigned int pflags = READ_ONCE(current->flags);
> +
> +	if (!(pflags & PF_MEMALLOC_NOCMA) &&
> +		gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> +		*alloc_flags |= ALLOC_CMA;
> +}
> +

I'd guess this would be easier to understand and probably generate
better code if renamed and used as:
	alloc_flags |= can_alloc_cma(gpf_mask);

Given it is a 'static inline' the compiler might end up
generating the same code.
If you needed to clear a flag doing:
	alloc_flags = current_alloc_flags(gpf_mask, alloc_flags);
is much better for non-inlined function.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

