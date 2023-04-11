Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37276DD5DE
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 10:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjDKItJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 04:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjDKItI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 04:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75843130;
        Tue, 11 Apr 2023 01:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDECE61C33;
        Tue, 11 Apr 2023 08:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93AFC433EF;
        Tue, 11 Apr 2023 08:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681202945;
        bh=7yfrR6dmJx+qORzGn2QhK/+A8If/IB+/5XHfyvlZS+Q=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=h+N9ImHa+vGsvDlOJ17F6cSCk/Xp21smuB3ZL9I4rL6w80NUxg6BtXXMnS1Jsjb2F
         +2r8qG23l4tWVf4PimsynV4NpOb4kNNFOR8v43/uMCVXMQ0tcwzRKfT5MYvr6ggYW/
         zn08yaDY0DMgwVlmMLlj6iDNYK0otq9BjZpcU56IaU1JcSYbs3j6sBHNOFyu6jxSKx
         IKMvZUDgAHD34Y/jWY2xFna+zjmM5zAufs5cn2ktJAOLMr9nYYHL9Cb93zYjLJVmaQ
         Bm47SGXTTO7BxplzjCwlf0JGCYCVVlsnEBFTJtSkztXsDxk6jpRUB0T/ezTTOj2zI5
         AWatxIOWX0QEw==
Message-ID: <3b98678e-70e9-4af9-3067-bcb2820364bc@kernel.org>
Date:   Tue, 11 Apr 2023 16:49:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [f2fs-dev] [PATCH] f2fs: get out of a repeat loop when getting a
 locked data page
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20230323213919.1876157-1-jaegeuk@kernel.org>
 <8aea02b0-86f9-539a-02e9-27b381e68b66@kernel.org>
 <ZCG2mfviZfY1dqb4@google.com> <ZCHCykI/BLcfDzt7@casper.infradead.org>
 <ZC2kSfNUXKK4PfpM@google.com>
 <9dc4ba32-5be5-26d8-5dd2-9bd48d6b0af4@kernel.org>
 <ZC46Ccm8xTT4OlE3@google.com>
 <c07853c1-6512-6539-a9dd-d9681dd51727@kernel.org>
 <ZDSaoHnlZbYMfbV7@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <ZDSaoHnlZbYMfbV7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/4/11 7:24, Jaegeuk Kim wrote:
> On 04/10, Chao Yu wrote:
>> On 2023/4/6 11:18, Jaegeuk Kim wrote:
>>> On 04/06, Chao Yu wrote:
>>>> On 2023/4/6 0:39, Jaegeuk Kim wrote:
>>>>> On 03/27, Matthew Wilcox wrote:
>>>>>> On Mon, Mar 27, 2023 at 08:30:33AM -0700, Jaegeuk Kim wrote:
>>>>>>> On 03/26, Chao Yu wrote:
>>>>>>>> On 2023/3/24 5:39, Jaegeuk Kim wrote:
>>>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=216050
>>>>>>>>>
>>>>>>>>> Somehow we're getting a page which has a different mapping.
>>>>>>>>> Let's avoid the infinite loop.
>>>>>>>>>
>>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>>>>>>>>> ---
>>>>>>>>>      fs/f2fs/data.c | 8 ++------
>>>>>>>>>      1 file changed, 2 insertions(+), 6 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>>>>>>>>> index bf51e6e4eb64..80702c93e885 100644
>>>>>>>>> --- a/fs/f2fs/data.c
>>>>>>>>> +++ b/fs/f2fs/data.c
>>>>>>>>> @@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
>>>>>>>>>      {
>>>>>>>>>      	struct address_space *mapping = inode->i_mapping;
>>>>>>>>>      	struct page *page;
>>>>>>>>> -repeat:
>>>>>>>>> +
>>>>>>>>>      	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
>>>>>>>>>      	if (IS_ERR(page))
>>>>>>>>>      		return page;
>>>>>>>>>      	/* wait for read completion */
>>>>>>>>>      	lock_page(page);
>>>>>>>>> -	if (unlikely(page->mapping != mapping)) {
>>>>>>>>
>>>>>>>> How about using such logic only for move_data_page() to limit affect for
>>>>>>>> other paths?
>>>>>>>
>>>>>>> Why move_data_page() only? If this happens, we'll fall into a loop in anywhere?
>>>>>>>
>>>>>>>>
>>>>>>>> Jaegeuk, any thoughts about why mapping is mismatch in between page's one and
>>>>>>>> inode->i_mapping?
>>>>>>>
>>>>>>>>
>>>>>>>> After several times code review, I didn't get any clue about why f2fs always
>>>>>>>> get the different mapping in a loop.
>>>>>>>
>>>>>>> I couldn't find the path to happen this. So weird. Please check the history in the
>>>>>>> bug.
>>>>>>>
>>>>>>>>
>>>>>>>> Maybe we can loop MM guys to check whether below folio_file_page() may return
>>>>>>>> page which has different mapping?
>>>>>>>
>>>>>>> Matthew may have some idea on this?
>>>>>>
>>>>>> There's a lot of comments in the bug ... hard to come into this one
>>>>>> cold.
>>>>>>
>>>>>> I did notice this one (#119):
>>>>>> : Interestingly, ref count is 514, which looks suspiciously as a binary
>>>>>> : flag 1000000010. Is it possible that during 5.17/5.18 implementation
>>>>>> : of a "pin", somehow binary flag was written to ref count, or something
>>>>>> : like '1 << ...' happens?
>>>>>>
>>>>>> That indicates to me that somehow you've got hold of a THP that is in
>>>>>> the page cache.  Probably shmem/tmpfs.  That indicate to me a refcount
>>>>>> problem that looks something like this:
>>>>>>
>>>>>> f2fs allocates a page
>>>>>> f2fs adds the page to the page cache
>>>>>> f2fs puts the reference to the page without removing it from the
>>>>>> page cache (how?)
>>>>>
>>>>> Is it somewhat related to setting a bit in private field?
>>>>
>>>> IIUC, it looks the page reference is added/removed as pair.
>>>>
>>>>>
>>>>> When we migrate the blocks, we do:
>>>>> 1) get_lock_page()
>>>>
>>>> - f2fs_grab_cache_page
>>>>    - pagecache_get_page
>>>>     - __filemap_get_folio
>>>>      - no_page  -> filemap_alloc_folio  page_ref = 1 (referenced by caller)
>>>>       - filemap_add_folio page_ref = 2 (referenced by radix tree)
>>>>
>>>>> 2) submit read
>>>>> 3) lock_page()
>>>>> 3) set_page_dirty()
>>>>> 4) set_page_private_gcing(page)
>>>>
>>>> page_ref = 3 (reference by private data)
>>>>
>>>>>
>>>>> --- in fs/f2fs/f2fs.h
>>>>> 1409 #define PAGE_PRIVATE_SET_FUNC(name, flagname) \
>>>>> 1410 static inline void set_page_private_##name(struct page *page) \
>>>>> 1411 { \
>>>>> 1412         if (!PagePrivate(page)) { \
>>>>> 1413                 get_page(page); \
>>>>> 1414                 SetPagePrivate(page); \
>>>>> 1415                 set_page_private(page, 0); \
>>>>> 1416         } \
>>>>> 1417         set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
>>>>> 1418         set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>>> 1419 }
>>>>>
>>>>>
>>>>> 5) set_page_writebac()
>>>>> 6) submit write
>>>>> 7) unlock_page()
>>>>> 8) put_page(page)
>>>>
>>>> page_ref = 2 (ref by caller was removed)
>>>>
>>>>>
>>>>> Later, f2fs_invalidate_folio will do put_page again by:
>>>>> clear_page_private_gcing(&folio->page);
>>>>
>>>> page_ref = 1 (ref by private was removed, and the last left ref is hold by radix tree)
>>>>
>>>>>
>>>>> --- in fs/f2fs/f2fs.h
>>>>> 1421 #define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
>>>>> 1422 static inline void clear_page_private_##name(struct page *page) \
>>>>> 1423 { \
>>>>> 1424         clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>>> 1425         if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) { \
>>>>> 1426                 set_page_private(page, 0); \
>>>>> 1427                 if (PagePrivate(page)) { \
>>>>> 1428                         ClearPagePrivate(page); \
>>>>
>>>> Since PagePrivate was cleared, so folio_detach_private in
>>>> f2fs_invalidate_folio()/f2fs_release_folio will just skip drop reference.
>>>>
>>>> static inline void *folio_detach_private(struct folio *folio)
>>>> {
>>>> 	void *data = folio_get_private(folio);
>>>>
>>>> 	if (!folio_test_private(folio))
>>>> 		return NULL;
>>>> 	folio_clear_private(folio);
>>>> 	folio->private = NULL;
>>>> 	folio_put(folio);
>>>>
>>>> 	return data;
>>>> }
>>>>
>>>> Or am I missing something?
>>>
>>> Ah, I missed folio_test_private() tho, can we really expect get_page(),
>>> SetPagePrivate(), and set_page_private() is in pair with folio_detach_private()?
>>
>> I guess we are trying to maintain PagePrivate and page_private w/
>> inner {set,clear}_page_private_* functions, if they are called in paired correctly,
>> we don't need to call folio_detach_private() additionally in .release_folio and
>> .invalid_folio, right? Otherwise there must be a bug.
> 
> Agreed.
> 
>>
>> In this patch, I use bug_on to instead folio_detach_private().
>> https://lore.kernel.org/linux-f2fs-devel/20230410022418.1843178-1-chao@kernel.org/
>>
>> In this patch, I use {attach,detach}_page_private() to clean up openned codes.
>> https://lore.kernel.org/linux-f2fs-devel/20230410022418.1843178-2-chao@kernel.org/
> 
> Looks like it doesn't need to apply two patches, 

Agreed,

> and missed f2fs_delete_entry case as well.

Good catch, I have another patch that only clean up set_page_private(),
but I guess your below implementation covers all cases, thanks! :)

Thanks,

> 
>  From 3fb0f570681dcd1c6c2f3e18ee7ff41428820b35 Mon Sep 17 00:00:00 2001
> From: Chao Yu <chao@kernel.org>
> Date: Mon, 10 Apr 2023 10:24:17 +0800
> Subject: [PATCH] f2fs: remove folio_detach_private() in .invalidate_folio and
>   .release_folio
> 
> We have maintain PagePrivate and page_private and page reference
> w/ {set,clear}_page_private_*, it doesn't need to call
> folio_detach_private() in the end of .invalidate_folio and
> .release_folio, remove it and use f2fs_bug_on instead.
> 
> Signed-off-by: Chao Yu <chao@kernel.org>
> [Jaegeuk Kim: cover f2fs_delete_entry case]
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>   fs/f2fs/data.c |  4 ++--
>   fs/f2fs/dir.c  |  5 ++---
>   fs/f2fs/f2fs.h | 32 ++++++++------------------------
>   3 files changed, 12 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 5a3636b70f48..8870ff630409 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -3734,7 +3734,7 @@ void f2fs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
>   			inode->i_ino == F2FS_COMPRESS_INO(sbi))
>   		clear_page_private_data(&folio->page);
>   
> -	folio_detach_private(folio);
> +	f2fs_bug_on(sbi, page_private(&folio->page));
>   }
>   
>   bool f2fs_release_folio(struct folio *folio, gfp_t wait)
> @@ -3756,7 +3756,7 @@ bool f2fs_release_folio(struct folio *folio, gfp_t wait)
>   	clear_page_private_reference(&folio->page);
>   	clear_page_private_gcing(&folio->page);
>   
> -	folio_detach_private(folio);
> +	f2fs_bug_on(sbi, page_private(&folio->page));
>   	return true;
>   }
>   
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index d6dd8327e82d..cea179dec3b6 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -906,13 +906,12 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
>   		clear_page_dirty_for_io(page);
>   		ClearPageUptodate(page);
>   
> +		clear_page_private_reference(page);
>   		clear_page_private_gcing(page);
> +		f2fs_bug_on(F2FS_I_SB(dir), page_private(page));
>   
>   		inode_dec_dirty_pages(dir);
>   		f2fs_remove_dirty_inode(dir);
> -
> -		detach_page_private(page);
> -		set_page_private(page, 0);
>   	}
>   	f2fs_put_page(page, 1);
>   
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 68eadc1ac130..1b1df9e33028 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1408,11 +1408,8 @@ static inline bool page_private_##name(struct page *page) \
>   #define PAGE_PRIVATE_SET_FUNC(name, flagname) \
>   static inline void set_page_private_##name(struct page *page) \
>   { \
> -	if (!PagePrivate(page)) { \
> -		get_page(page); \
> -		SetPagePrivate(page); \
> -		set_page_private(page, 0); \
> -	} \
> +	if (!PagePrivate(page)) \
> +		attach_page_private(page, (void *)0); \
>   	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
>   	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>   }
> @@ -1421,13 +1418,8 @@ static inline void set_page_private_##name(struct page *page) \
>   static inline void clear_page_private_##name(struct page *page) \
>   { \
>   	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
> -	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) { \
> -		set_page_private(page, 0); \
> -		if (PagePrivate(page)) { \
> -			ClearPagePrivate(page); \
> -			put_page(page); \
> -		}\
> -	} \
> +	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
> +		detach_page_private(page); \
>   }
>   
>   PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
> @@ -1456,11 +1448,8 @@ static inline unsigned long get_page_private_data(struct page *page)
>   
>   static inline void set_page_private_data(struct page *page, unsigned long data)
>   {
> -	if (!PagePrivate(page)) {
> -		get_page(page);
> -		SetPagePrivate(page);
> -		set_page_private(page, 0);
> -	}
> +	if (!PagePrivate(page))
> +		attach_page_private(page, (void *)0);
>   	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page));
>   	page_private(page) |= data << PAGE_PRIVATE_MAX;
>   }
> @@ -1468,13 +1457,8 @@ static inline void set_page_private_data(struct page *page, unsigned long data)
>   static inline void clear_page_private_data(struct page *page)
>   {
>   	page_private(page) &= GENMASK(PAGE_PRIVATE_MAX - 1, 0);
> -	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) {
> -		set_page_private(page, 0);
> -		if (PagePrivate(page)) {
> -			ClearPagePrivate(page);
> -			put_page(page);
> -		}
> -	}
> +	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER))
> +		detach_page_private(page);
>   }
>   
>   /* For compression */
