Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E907248BC9
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHRQjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 12:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgHRQjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 12:39:35 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FCA120658;
        Tue, 18 Aug 2020 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597768775;
        bh=cC5/abviHevA7jlLShKrtEFcRZtkHaSdZsY50V9jqkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2O2e4+0d7LNe5VlCRSlnkM+csTW1S1zK9BMCkxaf+p9Awfno9p1KLTbREnc2QYjr3
         qAJqLRv6lIme0c1DYTo6CdQad+DxLt8SwA0pluJmFUIuJp7ai2Ok8kRI5lCFqV4Zng
         m7AzqT25vRp66BYcgA527A8V1t8cPVBXf5YnTxco=
Date:   Tue, 18 Aug 2020 09:39:32 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Eric Deal <eric.deal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Subject: Re: [PATCH] block: fix get_max_io_size()
Message-ID: <20200818163932.GA2674385@dhcp-10-100-145-180.wdl.wdc.com>
References: <20200806215837.3968445-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806215837.3968445-1-kbusch@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

The proposed alternatives continue to break with allowable (however
unlikely) queue limits, where this should be safe for any possible
settings. I think this should be okay to go as-is.

On Thu, Aug 06, 2020 at 02:58:37PM -0700, Keith Busch wrote:
> A previous commit aligning splits to physical block sizes inadvertently
> modified one return case such that that it now returns 0 length splits
> when the number of sectors doesn't exceed the physical offset. This
> later hits a BUG in bio_split(). Restore the previous working behavior.
> 
> Reported-by: Eric Deal <eric.deal@wdc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: stable@vger.kernel.org
> Fixes: 9cc5169cd478b ("block: Improve physical block alignment of split bios")
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  block/blk-merge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 5196dc145270..d7fef954d42f 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -154,7 +154,7 @@ static inline unsigned get_max_io_size(struct request_queue *q,
>  	if (max_sectors > start_offset)
>  		return max_sectors - start_offset;
>  
> -	return sectors & (lbs - 1);
> +	return sectors & ~(lbs - 1);
>  }
>  
>  static inline unsigned get_max_segment_size(const struct request_queue *q,
> -- 
