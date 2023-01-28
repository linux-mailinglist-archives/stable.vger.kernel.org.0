Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADC67F434
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 04:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjA1DLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 22:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjA1DLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 22:11:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C83C7E6F1;
        Fri, 27 Jan 2023 19:11:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD49361D7C;
        Sat, 28 Jan 2023 03:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAADBC433D2;
        Sat, 28 Jan 2023 03:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674875507;
        bh=XPaMcUNFzQtuzwo6CK8GiZUG4h20tNH9I9lk8x2KzFM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QG3VCHBlSfGhLGgZuhtNYKVq0bCXEY9+S+ordZOyfTL6rdDY64iDbVBnSroHV0mgy
         SB4zYXYLqeQzVWEWGawo2yVSzeuAx1c4X7gjWXx5XCrsol7HRPOrt5NuqSTadxeIbf
         2bjibS7c9FkPb9CzzAk8Dps0MTkCsENRcVaw6CwTSTg0/pEt/DfsiMjSZW/ySvK3pv
         0tCNCgOzOlXfnRhzMuDpVLDmUJa00BIwZPwWvFd5dCoZLPI04uo8uRv3oKJuEt5L+E
         YdZNJ5ZoBRBDTqDuuy1GA7POL/Zobg5Hs+i900EE7/j5Kc/lKNNkehQSNs2N3locDR
         QwNGYeNTRhevA==
Message-ID: <b2112f3d-e0a5-0562-9ea1-a158c75ef3b3@kernel.org>
Date:   Sat, 28 Jan 2023 11:11:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: retry to update the inode page given
 EIO
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
References: <20230105233908.1030651-1-jaegeuk@kernel.org>
 <Y74O+5SklijYqMU1@google.com>
 <77b18266-69c4-c7f0-0eab-d2069a7b21d5@kernel.org>
 <Y78E9NpDxtvr2/Hs@google.com>
 <bb9a9d1a-0d4c-b27e-e724-f99d5b8b4283@kernel.org>
 <Y8CfUMsas4ZqVL0R@google.com>
Content-Language: en-US
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <Y8CfUMsas4ZqVL0R@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/1/13 8:01, Jaegeuk Kim wrote:
> On 01/12, Chao Yu wrote:
>> On 2023/1/12 2:50, Jaegeuk Kim wrote:
>>> On 01/11, Chao Yu wrote:
>>>> On 2023/1/11 9:20, Jaegeuk Kim wrote:
>>>>> In f2fs_update_inode_page, f2fs_get_node_page handles EIO along with
>>>>> f2fs_handle_page_eio that stops checkpoint, if the disk couldn't be recovered.
>>>>> As a result, we don't need to stop checkpoint right away given single EIO.
>>>>
>>>> f2fs_handle_page_eio() only covers the case that EIO occurs on the same
>>>> page, should we cover the case EIO occurs on different pages?
>>>
>>> Which case are you looking at?
>>
>> - __get_node_page(PageA)		- __get_node_page(PageB)
>>   - f2fs_handle_page_eio
>>    - sbi->page_eio_ofs[type] = PageA->index
>> 					 - f2fs_handle_page_eio
>> 					  - sbi->page_eio_ofs[type] = PageB->index
>>
>> In such race case, it may has low probability to set CP_ERROR_FLAG as we expect?
> 
> Do you see that case in products?

Not yet.

> I'm trying to avoid setting CP_ERROR_FLAG here.

Copied, how about using the same logic for node page as meta page, like
we did in f2fs_get_meta_page_retry()?

Thanks,

> 
>>
>> Thanks,
>>
>>>
>>>>
>>>> Thanks,
>>>>
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Randall Huang <huangrandall@google.com>
>>>>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>>>>> ---
>>>>>
>>>>>     Change log from v1:
>>>>>      - fix a bug
>>>>>
>>>>>     fs/f2fs/inode.c | 2 +-
>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
>>>>> index ff6cf66ed46b..2ed7a621fdf1 100644
>>>>> --- a/fs/f2fs/inode.c
>>>>> +++ b/fs/f2fs/inode.c
>>>>> @@ -719,7 +719,7 @@ void f2fs_update_inode_page(struct inode *inode)
>>>>>     	if (IS_ERR(node_page)) {
>>>>>     		int err = PTR_ERR(node_page);
>>>>> -		if (err == -ENOMEM) {
>>>>> +		if (err == -ENOMEM || (err == -EIO && !f2fs_cp_error(sbi))) {
>>>>>     			cond_resched();
>>>>>     			goto retry;
>>>>>     		} else if (err != -ENOENT) {
