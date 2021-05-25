Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BC139001C
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhEYLii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 07:38:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhEYLig (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 07:38:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621942626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1tBEB3SzpdexLywxXZPiYr8gSbU1T57J4sUwzcuUpvk=;
        b=h/+goRkPyfMw1GdERlfKHwnCMqSGEI8p3PUNkAOJ8Tnk9qetDVYR5ZjoavvwfYegpy4n5D
        npi5BisdleEIfJ+xC8vUFIqIW9TaqNZZztm43TndHfyA7mBpmIDbyv7NVIhTSmQ++WQJia
        xfEUq73nLEl0ysVz8r3g3kFuqoiwNHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-w5k79UYvNQW8hjSJ6tT_1w-1; Tue, 25 May 2021 07:37:04 -0400
X-MC-Unique: w5k79UYvNQW8hjSJ6tT_1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61044800D62;
        Tue, 25 May 2021 11:37:03 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BDE070136;
        Tue, 25 May 2021 11:36:59 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 14PBaxIG013626;
        Tue, 25 May 2021 07:36:59 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 14PBav2Z013621;
        Tue, 25 May 2021 07:36:58 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 25 May 2021 07:36:57 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Tokarev <mjt@tls.msk.ru>,
        Mike Snitzer <snitzer@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: Patch regression - Re: [PATCH 5.10 070/104] dm snapshot: fix a crash
 when an origin has no snapshots
In-Reply-To: <20210524152335.174655194@linuxfoundation.org>
Message-ID: <alpine.LRH.2.02.2105250734180.13437@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210524152332.844251980@linuxfoundation.org> <20210524152335.174655194@linuxfoundation.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

I'd like to ask you to drop this patch from all stable branches.

It causes regression with snapshot merging and the regression is much 
worse than the bug that it fixes.

Mikulas



On Mon, 24 May 2021, Greg Kroah-Hartman wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> commit 7ee06ddc4038f936b0d4459d37a7d4d844fb03db upstream.
> 
> If an origin target has no snapshots, o->split_boundary is set to 0.
> This causes BUG_ON(sectors <= 0) in block/bio.c:bio_split().
> 
> Fix this by initializing chunk_size, and in turn split_boundary, to
> rounddown_pow_of_two(UINT_MAX) -- the largest power of two that fits
> into "unsigned" type.
> 
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> Tested-by: Michael Tokarev <mjt@tls.msk.ru>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/md/dm-snap.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -854,12 +854,11 @@ static int dm_add_exception(void *contex
>  static uint32_t __minimum_chunk_size(struct origin *o)
>  {
>  	struct dm_snapshot *snap;
> -	unsigned chunk_size = 0;
> +	unsigned chunk_size = rounddown_pow_of_two(UINT_MAX);
>  
>  	if (o)
>  		list_for_each_entry(snap, &o->snapshots, list)
> -			chunk_size = min_not_zero(chunk_size,
> -						  snap->store->chunk_size);
> +			chunk_size = min(chunk_size, snap->store->chunk_size);
>  
>  	return (uint32_t) chunk_size;
>  }
> 
> 

