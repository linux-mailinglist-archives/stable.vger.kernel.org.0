Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DF92A228F
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 01:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgKBAa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 19:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbgKBAa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 19:30:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E3CB2145D;
        Mon,  2 Nov 2020 00:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604277057;
        bh=hsc6sghMQfpJdDMaorF3YDs6oHrvYR5tUOTOnKqRVLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJ79ea2gOEhSEYDv0nTxp0ZdUNj0cbaUa0XUyhGD/Dec6D7cQIZAbRFRAj6tUDMkO
         J1Sj2HAbgAt1qNg1twQ8oK6A7cFFasaMZdd3sxN2y6qC9Zn9HP9hPjLYwjtxnMW1VF
         yUUBPL7uLtK10EQ1qFSstk4q/IBK56u35ZiHpYQ8=
Date:   Sun, 1 Nov 2020 19:30:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH AUTOSEL 5.9 089/147] dm: change max_io_len() to use
 blk_max_size_offset()
Message-ID: <20201102003056.GD2092@sasha-vm>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-89-sashal@kernel.org>
 <20201027121959.GA13012@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201027121959.GA13012@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 08:19:59AM -0400, Mike Snitzer wrote:
>On Mon, Oct 26 2020 at  7:48pm -0400,
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Mike Snitzer <snitzer@redhat.com>
>>
>> [ Upstream commit 5091cdec56faeaefa79de4b6cb3c3c55e50d1ac3 ]
>>
>> Using blk_max_size_offset() enables DM core's splitting to impose
>> ti->max_io_len (via q->limits.chunk_sectors) and also fallback to
>> respecting q->limits.max_sectors if chunk_sectors isn't set.
>>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Not sure why this commit elevated to stable@ picking it up, please
>explain.

I misread the series this patch was in as being a fix rather than only
the first patch, sorry :(

>But you cannot take this commit standalone. These commits are prereqs:
>
>22ada802ede8 block: use lcm_not_zero() when stacking chunk_sectors
>07d098e6bbad block: allow 'chunk_sectors' to be non-power-of-2
>882ec4e609c1 dm table: stack 'chunk_sectors' limit to account for target-specific splitting
>
>This goes for all stable@ trees you AUTOSEL'd commit 5091cdec56f for.
>
>Mike
>
>> ---
>>  drivers/md/dm.c | 20 ++++++++------------
>>  1 file changed, 8 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 6ed05ca65a0f8..3982012b1309c 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1051,22 +1051,18 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
>>  static sector_t max_io_len(sector_t sector, struct dm_target *ti)
>>  {
>>  	sector_t len = max_io_len_target_boundary(sector, ti);
>> -	sector_t offset, max_len;
>> +	sector_t max_len;
>>
>>  	/*
>>  	 * Does the target need to split even further?
>> +	 * - q->limits.chunk_sectors reflects ti->max_io_len so
>> +	 *   blk_max_size_offset() provides required splitting.
>> +	 * - blk_max_size_offset() also respects q->limits.max_sectors
>>  	 */
>> -	if (ti->max_io_len) {
>> -		offset = dm_target_offset(ti, sector);
>> -		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
>> -			max_len = sector_div(offset, ti->max_io_len);
>> -		else
>> -			max_len = offset & (ti->max_io_len - 1);
>> -		max_len = ti->max_io_len - max_len;
>> -
>> -		if (len > max_len)
>> -			len = max_len;
>> -	}
>> +	max_len = blk_max_size_offset(dm_table_get_md(ti->table)->queue,
>> +				      dm_target_offset(ti, sector));
>> +	if (len > max_len)
>> +		len = max_len;
>>
>>  	return len;
>>  }
>> --
>> 2.25.1
>>
>

-- 
Thanks,
Sasha
