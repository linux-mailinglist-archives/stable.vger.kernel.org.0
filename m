Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24AF5192E3
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244540AbiEDAnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbiEDAnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:43:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1510F38BC6;
        Tue,  3 May 2022 17:39:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2E02B8227E;
        Wed,  4 May 2022 00:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC3EC385A4;
        Wed,  4 May 2022 00:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651624771;
        bh=xlKxpLDsGDGqIEBxZuWucqMujX6BG0fM6Gh35+FdMGY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=b9JoHDXlj3YVviGODLUCXCiwap0JGZceDZFB8LsU8AHsYwzyjBJ4Xo6aoKC84aqPk
         xaQ+ZoXuRr+DrZV/j+/BD6Rtnlg3tXACE5zvfF1xmaRGhDnl5zX5K9qpLDj5Qe0LGX
         OpCIEJ5wgQmw71F/3NlylbGuRq1L50tx8R1aCOUk6kzEXsOpD9aMPG4Vs93tOSqo6R
         Spz7Tz9DqEi8k6sErFcR/PKNTPVhmtMO0qPtdyny7r3aO5iYlIQGSXrA/skflGN9xC
         j0JxoZ2S5J325sCuBXMXzHbFPyNMUdeYR1KLaW8mR/LkHrDACOgRAqmaFzF2YDkrpI
         wj6ha0aV+rwLg==
Message-ID: <6c0e4596-1698-25d5-7b59-c0ee6ef7eefd@kernel.org>
Date:   Wed, 4 May 2022 08:39:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] f2fs: fix deadloop in foreground GC
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Yan <yanming@tju.edu.cn>, Chao Yu <chao.yu@oppo.com>
References: <20220429204631.7241-1-chao@kernel.org>
 <YnGrvEjxgaXDnxxi@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <YnGrvEjxgaXDnxxi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/5/4 6:25, Jaegeuk Kim wrote:
> On 04/30, Chao Yu wrote:
>> As Yanming reported in bugzilla:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=215914
>>
>> The root cause is: in a very small sized image, it's very easy to
>> exceed threshold of foreground GC, if we calculate free space and
>> dirty data based on section granularity, in corner case,
>> has_not_enough_free_secs() will always return true, result in
>> deadloop in f2fs_gc().
> 
> Performance regression was reported. Can we check this for very small sized
> image only?

I noticed that, I've fixed the issue in v2, could you please take a look?

Thanks,

> 
>>
>> So this patch refactors has_not_enough_free_secs() as below to fix
>> this issue:
>> 1. calculate needed space based on block granularity, and separate
>> all blocks to two parts, section part, and block part, comparing
>> section part to free section, and comparing block part to free space
>> in openned log.
>> 2. account F2FS_DIRTY_NODES, F2FS_DIRTY_IMETA and F2FS_DIRTY_DENTS
>> as node block consumer;
>> 3. account F2FS_DIRTY_DENTS as data block consumer;
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Ming Yan <yanming@tju.edu.cn>
>> Signed-off-by: Chao Yu <chao.yu@oppo.com>
>> ---
>>   fs/f2fs/segment.h | 30 +++++++++++++++++-------------
>>   1 file changed, 17 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
>> index 8a591455d796..28f7aa9b40bf 100644
>> --- a/fs/f2fs/segment.h
>> +++ b/fs/f2fs/segment.h
>> @@ -575,11 +575,10 @@ static inline int reserved_sections(struct f2fs_sb_info *sbi)
>>   	return GET_SEC_FROM_SEG(sbi, reserved_segments(sbi));
>>   }
>>   
>> -static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi)
>> +static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi,
>> +			unsigned int node_blocks, unsigned int dent_blocks)
>>   {
>> -	unsigned int node_blocks = get_pages(sbi, F2FS_DIRTY_NODES) +
>> -					get_pages(sbi, F2FS_DIRTY_DENTS);
>> -	unsigned int dent_blocks = get_pages(sbi, F2FS_DIRTY_DENTS);
>> +
>>   	unsigned int segno, left_blocks;
>>   	int i;
>>   
>> @@ -605,19 +604,24 @@ static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi)
>>   static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi,
>>   					int freed, int needed)
>>   {
>> -	int node_secs = get_blocktype_secs(sbi, F2FS_DIRTY_NODES);
>> -	int dent_secs = get_blocktype_secs(sbi, F2FS_DIRTY_DENTS);
>> -	int imeta_secs = get_blocktype_secs(sbi, F2FS_DIRTY_IMETA);
>> +	unsigned int total_node_blocks = get_pages(sbi, F2FS_DIRTY_NODES) +
>> +					get_pages(sbi, F2FS_DIRTY_DENTS) +
>> +					get_pages(sbi, F2FS_DIRTY_IMETA);
>> +	unsigned int total_dent_blocks = get_pages(sbi, F2FS_DIRTY_DENTS);
>> +	unsigned int node_secs = total_node_blocks / BLKS_PER_SEC(sbi);
>> +	unsigned int dent_secs = total_dent_blocks / BLKS_PER_SEC(sbi);
>> +	unsigned int node_blocks = total_node_blocks % BLKS_PER_SEC(sbi);
>> +	unsigned int dent_blocks = total_dent_blocks % BLKS_PER_SEC(sbi);
>>   
>>   	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
>>   		return false;
>>   
>> -	if (free_sections(sbi) + freed == reserved_sections(sbi) + needed &&
>> -			has_curseg_enough_space(sbi))
>> -		return false;
>> -	return (free_sections(sbi) + freed) <=
>> -		(node_secs + 2 * dent_secs + imeta_secs +
>> -		reserved_sections(sbi) + needed);
>> +	if (free_sections(sbi) + freed <=
>> +			node_secs + dent_secs + reserved_sections(sbi) + needed)
>> +		return true;
>> +	if (!has_curseg_enough_space(sbi, node_blocks, dent_blocks))
>> +		return true;
>> +	return false;
>>   }
>>   
>>   static inline bool f2fs_is_checkpoint_ready(struct f2fs_sb_info *sbi)
>> -- 
>> 2.32.0
