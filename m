Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E311EEAF9
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 21:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgFDTOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 15:14:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgFDTOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 15:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591298056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+P5s6QFAet4IgovHLPL8H2pSUM47EY9OL/ITWccuoIw=;
        b=drXSah+U8RKH2DtOEDk3Zm84pa3MM+LxIaAhsQCqtqniZ02SfsO+RPp0obKD1LgeSiGiAO
        cPCBtQCcSjNNq5QSS5XwXVG9VuzospxIIvTlYa+SBUeB2znP1hhDQKbnGpX8ugYAJTZOjf
        o59myH6iPKvr69ekh+4AQzEDz6iyrVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-4LOqTJZ5P32dR1PTB1DGwQ-1; Thu, 04 Jun 2020 15:14:12 -0400
X-MC-Unique: 4LOqTJZ5P32dR1PTB1DGwQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14A9F18B638C;
        Thu,  4 Jun 2020 19:14:11 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B66555C1B0;
        Thu,  4 Jun 2020 19:14:02 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 054JE2vE003437;
        Thu, 4 Jun 2020 15:14:02 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 054JE2As003433;
        Thu, 4 Jun 2020 15:14:02 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 4 Jun 2020 15:14:02 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dm crypt: avoid truncating the logical block size
In-Reply-To: <20200604190126.15735-1-ebiggers@kernel.org>
Message-ID: <alpine.LRH.2.02.2006041512500.3360@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200604190126.15735-1-ebiggers@kernel.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Thu, 4 Jun 2020, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> queue_limits::logical_block_size got changed from unsigned short to
> unsigned int, but it was forgotten to update crypt_io_hints() to use the
> new type.  Fix it.
> 
> Fixes: ad6bf88a6c19 ("block: fix an integer overflow in logical block size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-crypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 3df90daba89e..a1dcb8675484 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3274,7 +3274,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	limits->max_segment_size = PAGE_SIZE;
>  
>  	limits->logical_block_size =
> -		max_t(unsigned short, limits->logical_block_size, cc->sector_size);
> +		max_t(unsigned, limits->logical_block_size, cc->sector_size);
>  	limits->physical_block_size =
>  		max_t(unsigned, limits->physical_block_size, cc->sector_size);
>  	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
> -- 
> 2.27.0.278.ge193c7cf3a9-goog
> 

