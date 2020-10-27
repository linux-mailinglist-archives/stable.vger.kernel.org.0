Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E917129AD19
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752045AbgJ0NUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:20:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752043AbgJ0NUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 09:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603804831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zrbs4feV+OXib8FNuFXZ5PG/XcfO+Cqus0Ov9BLA2gQ=;
        b=en1UdeYXYGJsRH/7qqw+HYMT0XVuLFBW955FDfN73Kpr4OjImjCYLQzrnSl9QLsSJNC+R0
        CJDWOFszCsJY02WkjA2B6JpDl9BoCT5ldgtlAJONJinwi4Dy6xNiZ8emVa6d0oZgT5lQGL
        0eQUt6fTmhF3oYfkWXYMPcV4694/Ucc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-b7rfsrgcNqqMnUuBXXqp3Q-1; Tue, 27 Oct 2020 09:20:29 -0400
X-MC-Unique: b7rfsrgcNqqMnUuBXXqp3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9742A188C129;
        Tue, 27 Oct 2020 13:20:28 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 56F045D9DD;
        Tue, 27 Oct 2020 13:20:25 +0000 (UTC)
Date:   Tue, 27 Oct 2020 08:19:59 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH AUTOSEL 5.9 089/147] dm: change max_io_len() to use
 blk_max_size_offset()
Message-ID: <20201027121959.GA13012@redhat.com>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-89-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026234905.1022767-89-sashal@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26 2020 at  7:48pm -0400,
Sasha Levin <sashal@kernel.org> wrote:

> From: Mike Snitzer <snitzer@redhat.com>
> 
> [ Upstream commit 5091cdec56faeaefa79de4b6cb3c3c55e50d1ac3 ]
> 
> Using blk_max_size_offset() enables DM core's splitting to impose
> ti->max_io_len (via q->limits.chunk_sectors) and also fallback to
> respecting q->limits.max_sectors if chunk_sectors isn't set.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Not sure why this commit elevated to stable@ picking it up, please
explain.

But you cannot take this commit standalone. These commits are prereqs:

22ada802ede8 block: use lcm_not_zero() when stacking chunk_sectors
07d098e6bbad block: allow 'chunk_sectors' to be non-power-of-2
882ec4e609c1 dm table: stack 'chunk_sectors' limit to account for target-specific splitting

This goes for all stable@ trees you AUTOSEL'd commit 5091cdec56f for.

Mike

> ---
>  drivers/md/dm.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 6ed05ca65a0f8..3982012b1309c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1051,22 +1051,18 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
>  static sector_t max_io_len(sector_t sector, struct dm_target *ti)
>  {
>  	sector_t len = max_io_len_target_boundary(sector, ti);
> -	sector_t offset, max_len;
> +	sector_t max_len;
>  
>  	/*
>  	 * Does the target need to split even further?
> +	 * - q->limits.chunk_sectors reflects ti->max_io_len so
> +	 *   blk_max_size_offset() provides required splitting.
> +	 * - blk_max_size_offset() also respects q->limits.max_sectors
>  	 */
> -	if (ti->max_io_len) {
> -		offset = dm_target_offset(ti, sector);
> -		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
> -			max_len = sector_div(offset, ti->max_io_len);
> -		else
> -			max_len = offset & (ti->max_io_len - 1);
> -		max_len = ti->max_io_len - max_len;
> -
> -		if (len > max_len)
> -			len = max_len;
> -	}
> +	max_len = blk_max_size_offset(dm_table_get_md(ti->table)->queue,
> +				      dm_target_offset(ti, sector));
> +	if (len > max_len)
> +		len = max_len;
>  
>  	return len;
>  }
> -- 
> 2.25.1
> 

