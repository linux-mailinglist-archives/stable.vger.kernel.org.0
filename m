Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1515D49AA0F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324043AbiAYDaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39442 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384630AbiAYCWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 21:22:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C029DB81619;
        Tue, 25 Jan 2022 02:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BB8C340E4;
        Tue, 25 Jan 2022 02:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643077328;
        bh=ppR/AYsgW9y0/lBa8Psg2sMOYuXPJPZT3SUUjYtczno=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CfIYFV92Vc/SCEINZZPRFMwWlVRwwuPILutJgRzq5q3Xo9a/ihgQepw0xrwGK9oL9
         ZwYB0uPILRq4KGHysS3cSwR2KpHEkUrkxjtRm2kBD49N68R5HolMZbpr8y8Rk/axqT
         TpWdKYeWbJEw83s3s4kkx/UYLAwyTwSUL3OBQzeWpMMKAKvyCC4mZFk4fwrAY5n5ee
         13dBa+M5YenMClzE9L6wwcG+OtHtDOBFhj6KY3W7WVE8kUlyekaq1bVxNEUzxlilnF
         OysgSJt3s7PqQ2FfUIyiVK6IK+tmLm0CsVVy35m0Ne9EUmp2ahLQkFj2T5ZnLDMiD1
         l6LRazeoK6b0w==
Message-ID: <3c56cf70-2557-2e9c-4694-588ddaa91220@kernel.org>
Date:   Tue, 25 Jan 2022 10:22:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 4.19 026/239] f2fs: fix to do sanity check in is_alive()
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20220124183943.102762895@linuxfoundation.org>
 <20220124183943.957395248@linuxfoundation.org>
 <20220124203637.GA19321@duo.ucw.cz>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20220124203637.GA19321@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/1/25 4:36, Pavel Machek wrote:
> Hi!
> 
>> From: Chao Yu <chao@kernel.org>
>>
>> commit 77900c45ee5cd5da63bd4d818a41dbdf367e81cd upstream.
>>
>> In fuzzed image, SSA table may indicate that a data block belongs to
>> invalid node, which node ID is out-of-range (0, 1, 2 or max_nid), in
>> order to avoid migrating inconsistent data in such corrupted image,
>> let's do sanity check anyway before data block migration.
> 
> This may be good idea, but AFAICT this leads to leak of page reference.

Hi Pavel,

Oops, you're right, my bad.

> 
>> +++ b/fs/f2fs/gc.c
>> @@ -589,6 +589,9 @@ static bool is_alive(struct f2fs_sb_info
>>   		set_sbi_flag(sbi, SBI_NEED_FSCK);
>>   	}
>>   
>> +	if (f2fs_check_nid_range(sbi, dni->ino))
>> +		return false;
>> +
>>   	*nofs = ofs_of_node(node_page);
>>   	source_blkaddr = datablock_addr(NULL, node_page, ofs_in_node);
>>   	f2fs_put_page(node_page, 1);
> 
> AFAICT f2fs_put_page() needs to be done in the error path, too.
> 
> (Problem seems to exist in mainline, too).
> 
> Something like this?

Could you please send a formal patch to f2fs mailing list for better review?

Anyway, thanks a lot for the report and the patch!

Thanks,

> 
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
> Best regards,
> 								Pavel
> 
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index ee308a8de432..e020804f7b07 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -1038,8 +1038,10 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
>   		set_sbi_flag(sbi, SBI_NEED_FSCK);
>   	}
>   
> -	if (f2fs_check_nid_range(sbi, dni->ino))
> +	if (f2fs_check_nid_range(sbi, dni->ino)) {
> +		f2fs_put_page(node_page, 1);
>   		return false;
> +	}
>   
>   	*nofs = ofs_of_node(node_page);
>   	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
> 
> 
