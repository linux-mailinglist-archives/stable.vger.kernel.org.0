Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510D1131C06
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 00:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAFXDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 18:03:08 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:56158 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgAFXDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 18:03:07 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2020 18:03:07 EST
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 1A4BFA0633;
        Mon,  6 Jan 2020 22:58:06 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 6tA-PVALLdKP; Mon,  6 Jan 2020 22:57:45 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id BDF95A0440;
        Mon,  6 Jan 2020 22:57:44 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net BDF95A0440
Date:   Mon, 6 Jan 2020 22:57:40 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     linux-bcache@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
In-Reply-To: <20200104065802.113137-1-colyli@suse.de>
Message-ID: <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
References: <20200104065802.113137-1-colyli@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 4 Jan 2020, Coly Li wrote:

> In year 2007 high performance SSD was still expensive, in order to
> save more space for real workload or meta data, the readahead I/Os
> for non-meta data was bypassed and not cached on SSD.
> 
> In now days, SSD price drops a lot and people can find larger size
> SSD with more comfortable price. It is unncessary to bypass normal
> readahead I/Os to save SSD space for now.
> 
> This patch removes the code which checks REQ_RAHEAD tag of bio in
> check_should_bypass(), then all readahead I/Os will be cached on SSD.
> 
> NOTE: this patch still keeps the checking of "REQ_META|REQ_PRIO" in
> should_writeback(), because we still want to cache meta data I/Os
> even they are asynchronized.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Eric Wheeler <bcache@linux.ewheeler.net>

Acked-by: Eric Wheeler <bcache@linux.ewheeler.net>


> ---
>  drivers/md/bcache/request.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 73478a91a342..acc07c4f27ae 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -378,15 +378,6 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>  	     op_is_write(bio_op(bio))))
>  		goto skip;
>  
> -	/*
> -	 * Flag for bypass if the IO is for read-ahead or background,
> -	 * unless the read-ahead request is for metadata
> -	 * (eg, for gfs2 or xfs).
> -	 */
> -	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
> -	    !(bio->bi_opf & (REQ_META|REQ_PRIO)))
> -		goto skip;
> -
>  	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
>  	    bio_sectors(bio) & (c->sb.block_size - 1)) {
>  		pr_debug("skipping unaligned io");
> -- 
> 2.16.4
> 
> 
