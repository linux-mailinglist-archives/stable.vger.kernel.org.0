Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C136D0676
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 15:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjC3NXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 09:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjC3NXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 09:23:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DA719A6;
        Thu, 30 Mar 2023 06:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9457B828C9;
        Thu, 30 Mar 2023 13:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2B7C433EF;
        Thu, 30 Mar 2023 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680182613;
        bh=TGIs6JDAlrKBTqIgEGbRkwj7I9yX6LExss8MV4sE0Dg=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=IhqSs3U9BRjzWl3cNjUqNg+tMH+PCRo4kJPCn0mYm9obGiqp9QNaMGPxZPhu8EK+E
         ErL1Q3dpywuho9ewjW56W2vraeeWKdpVnjoO5MNXmeUQKiLMPDPpe/bJNJlGv7iHBC
         5IbgN0DvPBoRAZ1YVBPW4gnwx0XFVqhGr/JVVijT7CkcU8pdmAVpOI5GtvXBdB8ghH
         QsH3E5R6YI/At+Bf5xh7WLsASsULlGpvbDtfXweCPLPoHTkaSCZSgR2mDVRx8Oh9vZ
         CUh9grxANKApX5wybxAhTq0Ht4iFTNpQP9x+qLn7ZKkaIAolwOgEqCgyPb8Hg93sgx
         o4FUTelOSKQsA==
Message-ID: <44470d45-32c2-d07f-108e-5cb709ffcdfc@kernel.org>
Date:   Thu, 30 Mar 2023 21:23:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        willy@infradead.org
References: <20230323213919.1876157-1-jaegeuk@kernel.org>
 <8aea02b0-86f9-539a-02e9-27b381e68b66@kernel.org>
 <ZCG2mfviZfY1dqb4@google.com>
From:   Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH] f2fs: get out of a repeat loop when getting a
 locked data page
In-Reply-To: <ZCG2mfviZfY1dqb4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023/3/27 23:30, Jaegeuk Kim wrote:
> On 03/26, Chao Yu wrote:
>> On 2023/3/24 5:39, Jaegeuk Kim wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=216050
>>>
>>> Somehow we're getting a page which has a different mapping.
>>> Let's avoid the infinite loop.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>>> ---
>>>    fs/f2fs/data.c | 8 ++------
>>>    1 file changed, 2 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>>> index bf51e6e4eb64..80702c93e885 100644
>>> --- a/fs/f2fs/data.c
>>> +++ b/fs/f2fs/data.c
>>> @@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
>>>    {
>>>    	struct address_space *mapping = inode->i_mapping;
>>>    	struct page *page;
>>> -repeat:
>>> +
>>>    	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
>>>    	if (IS_ERR(page))
>>>    		return page;
>>>    	/* wait for read completion */
>>>    	lock_page(page);
>>> -	if (unlikely(page->mapping != mapping)) {
>>
>> How about using such logic only for move_data_page() to limit affect for
>> other paths?
> 
> Why move_data_page() only? If this happens, we'll fall into a loop in anywhere?

Actually, we only suffer dead loop from foreground GC path, right? I suspect the
bug was triggered in this path only.

It looks there are a lot of cases in where we repeat triggering read once
two mappings are mismatched, e.g.
- __get_meta_page
- __get_node_page
- f2fs_write_begin
- f2fs_quota_read

Thanks,

> 
>>
>> Jaegeuk, any thoughts about why mapping is mismatch in between page's one and
>> inode->i_mapping?
> 
>>
>> After several times code review, I didn't get any clue about why f2fs always
>> get the different mapping in a loop.
> 
> I couldn't find the path to happen this. So weird. Please check the history in the
> bug.
> 
>>
>> Maybe we can loop MM guys to check whether below folio_file_page() may return
>> page which has different mapping?
> 
> Matthew may have some idea on this?
> 
>>
>> struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
>> 		int fgp_flags, gfp_t gfp)
>> {
>> 	struct folio *folio;
>>
>> 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
>> 	if (IS_ERR(folio))
>> 		return NULL;
>> 	return folio_file_page(folio, index);
>> }
>>
>> Thanks,
>>
>>> -		f2fs_put_page(page, 1);
>>> -		goto repeat;
>>> -	}
>>> -	if (unlikely(!PageUptodate(page))) {
>>> +	if (unlikely(page->mapping != mapping || !PageUptodate(page))) {
>>>    		f2fs_put_page(page, 1);
>>>    		return ERR_PTR(-EIO);
>>>    	}
