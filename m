Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7287A2E8370
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 11:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbhAAKCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 05:02:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbhAAKCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 05:02:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609495244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R8fi1KwYHvOc1yjxvPQQOFq9DnCMByDXrTVloSIzr/k=;
        b=CZThlntU5BJ1m97qYn5MdAksZYsKmBR61NtSMpjsj5z5IwdwtNTQ2loQr5BmLoDltwAbyx
        hT7KkpfcFg/B/Mg5C3GwglrVJPa6wmjnyuGVnecaf+8bqcxfoNTG6j3EFrBj1x8QibWnUK
        k1rscYme+UTda2i4cIe48FZGJg6kGEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-rfV7-ssXM1SEK_UeLAG1Qg-1; Fri, 01 Jan 2021 05:00:40 -0500
X-MC-Unique: rfV7-ssXM1SEK_UeLAG1Qg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A08B803650;
        Fri,  1 Jan 2021 10:00:37 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1BF31971E;
        Fri,  1 Jan 2021 10:00:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 101A0KA1031760;
        Fri, 1 Jan 2021 05:00:20 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 101A0IkO031756;
        Fri, 1 Jan 2021 05:00:18 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 1 Jan 2021 05:00:18 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Ignat Korchagin <ignat@cloudflare.com>
cc:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        ebiggers@kernel.org, Damien.LeMoal@wdc.com,
        herbert@gondor.apana.org.au, kernel-team@cloudflare.com,
        nobuto.murata@canonical.com, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org,
        mail@maciej.szmigiero.name, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dm crypt: use GFP_ATOMIC when allocating crypto
 requests from softirq
In-Reply-To: <20201230214520.154793-2-ignat@cloudflare.com>
Message-ID: <alpine.LRH.2.02.2101010450460.31009@file01.intranet.prod.int.rdu2.redhat.com>
References: <20201230214520.154793-1-ignat@cloudflare.com> <20201230214520.154793-2-ignat@cloudflare.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Wed, 30 Dec 2020, Ignat Korchagin wrote:

> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 53791138d78b..e4fd690c70e1 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1539,7 +1549,10 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
>  
>  	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
>  
> -		crypt_alloc_req(cc, ctx);
> +		r = crypt_alloc_req(cc, ctx);
> +		if (r)
> +			return BLK_STS_RESOURCE;
> +
>  		atomic_inc(&ctx->cc_pending);
>  
>  		if (crypt_integrity_aead(cc))
> -- 
> 2.20.1

I'm not quite convinced that returning BLK_STS_RESOURCE will help. The 
block layer will convert this value back to -ENOMEM and return it to the 
caller, resulting in an I/O error.

Note that GFP_ATOMIC allocations may fail anytime and you must handle 
allocation failure gracefully - i.e. process the request without any 
error.

An acceptable solution would be to punt the request to a workqueue and do 
GFP_NOIO allocation from the workqueue. Or add the request to some list 
and process the list when some other request completes.

You should write a test that simulates allocation failure and verify that 
the kernel handles it gracefully without any I/O error.

Mikulas

