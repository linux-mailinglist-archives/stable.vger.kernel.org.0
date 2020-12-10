Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD02D5D91
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgLJO1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731718AbgLJO1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 09:27:07 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713C9C0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 06:26:27 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id z11so4863156qkj.7
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 06:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=urtRc14sNOSzmyfF5oYf2pKUsABrcVbMlU2XlhRaq2A=;
        b=qjMXaD39ZxBAafb69RXKhkgyav/AllBsQl0Ybtj6Tn1MlC8H0K5U+6NjPhFalAggTP
         YWNAPyMCfYkzS6FGNRfwL3+0665angygdn98U90ucu6wym9fEa8V9Rc59RMDo5aGsrOs
         jE2katn9VXsJDXrlkIaWml/5ZABT/uvUvheVvsYljYNvFiTKaEL6KAp+P8XN5dEWbHcj
         WmXxumsP7A4GoEL7XJRYIPZZIQw179csr/vXQUHFgqFzCg53gArOGDZk53oaqEHoZTw0
         we/YRmtVeRjE4dsppsACVeKDpwV/FPOxWcdySFdCRDTQJ9AtTLiG+XMP/2DhiZRkTwJx
         04yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=urtRc14sNOSzmyfF5oYf2pKUsABrcVbMlU2XlhRaq2A=;
        b=kk6MIbD/SjPJDyGqTlBSmF7Wo1JLjyQN61I0VzTcQK76lDzhAZ/zxehPdmKLH4S+6Y
         QflH1CdmL6EkmV9VQVnNAzr2NMyiv3dQJnTa4TpdNISASNdjY5cY8TiQX+wTcGaq7xkQ
         FufZTAdl9bGKGVKd83/uneiQvN5LyD5z5g2uocZ9QV1xbrilsVw0ij5mS8T5oKj9c1hE
         7AW72ajrhW/b5yd1+bAptWgSJwxpZr/CnPuz7wyvhf1eN05PLaZs6MM/Zs79WC27nvz8
         Ulv3XRxy9GWvx2obrHZA5NrU002WlFrcea2maBQIVwD26fNrPeQnauScKCECVwwJy5MK
         1sPw==
X-Gm-Message-State: AOAM533+PASSwHAuBWKg1N+wAJ4hYyaM41Je69RQzz9U4uwjBowfKS1U
        p5ruG9b3ejW9iWnKI/pr95O5Vyt6Ndcf0dgL
X-Google-Smtp-Source: ABdhPJzmccNjUu2/XSWwrFUz4n0gTBr3Oxg37qUu9ABLPs6t7yPgYFmYL1Gw1o1uitiJ71uv0Y77ew==
X-Received: by 2002:ae9:e007:: with SMTP id m7mr8945568qkk.416.1607610386120;
        Thu, 10 Dec 2020 06:26:26 -0800 (PST)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id m8sm3531606qkn.41.2020.12.10.06.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 06:26:25 -0800 (PST)
Subject: Re: [PATCH] btrfs: fix possible free space tree corruption with
 online conversion
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     stable@vger.kernel.org
References: <0d49d6227962f3f3d34b6c7ccfd0c330f98517af.1607545035.git.josef@toxicpanda.com>
 <8e34ff2a-e63a-8259-a1d3-0736932cab22@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <6642bcbe-01ca-05ed-8050-eb5f3ce82ba4@toxicpanda.com>
Date:   Thu, 10 Dec 2020 09:26:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <8e34ff2a-e63a-8259-a1d3-0736932cab22@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/20 4:22 AM, Nikolay Borisov wrote:
> 
> 
> On 9.12.20 г. 22:17 ч., Josef Bacik wrote:
>> While running btrfs/011 in a loop I would often ASSERT() while trying to
>> add a new free space entry that already existed, or get an -EEXIST while
>> adding a new block to the extent tree, which is another indication of
>> double allocation.
>>
>> This occurs because when we do the free space tree population, we create
>> the new root and then populate the tree and commit the transaction.
>> The problem is when you create a new root, the root node and commit root
>> node are the same.  This means that caching a block group before the
>> transaction is committed can race with other operations modifying the
>> free space tree, and thus you can get double adds and other sort of
> 
> FST creation happens during mount so what would initiate block group
> caching at that time, the race scenario should be better described in
> the change log. E.g. what those other operations might be, considering
> we are in mount ?
> 

It's happening during the transaction commit.  Creating the free space tree 
allocates blocks, which updates the FST via delayed refs.  These run during 
transaction commit, which allocates more blocks because we're now COW'ing the 
extent tree.  At this point if we have to cache a block group we start doing 
that, which happens in another thread.  Now we have the caching thread trying to 
cache while the tree is changing because of delayed refs running.

>> shenanigans.  This is only a problem for the first transaction, once
>> we've committed the transaction we created the free space tree in we're
>> OK to use the free space tree to cache block groups.
>>
>> Fix this by marking the fs_info as unsafe to load the free space tree,
>> and fall back on the old slow method.  We could be smarter than this,
>> for example caching the block group while we're populating the free
>> space tree, but since this is a serious problem I've opted for the
>> simplest solution.
>>
>> cc: stable@vger.kernel.org
>> Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> ---
>>   fs/btrfs/block-group.c     | 11 ++++++++++-
>>   fs/btrfs/ctree.h           |  3 +++
>>   fs/btrfs/free-space-tree.c |  9 ++++++++-
>>   3 files changed, 21 insertions(+), 2 deletions(-)
>>
> 
> ?<snip>
> 
> 
>>   /*
>> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
>> index e33a65bd9a0c..8fbda221f4b5 100644
>> --- a/fs/btrfs/free-space-tree.c
>> +++ b/fs/btrfs/free-space-tree.c
>> @@ -1150,6 +1150,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
>>   		return PTR_ERR(trans);
>>   
>>   	set_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
>> +	set_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
>>   	free_space_root = btrfs_create_tree(trans,
>>   					    BTRFS_FREE_SPACE_TREE_OBJECTID);
>>   	if (IS_ERR(free_space_root)) {
>> @@ -1171,8 +1172,14 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
>>   	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
>>   	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
>>   	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
>> +	ret = btrfs_commit_transaction(trans);
>>   
>> -	return btrfs_commit_transaction(trans);
>> +	/*
>> +	 * Now that we've committed the transaction any reading of our commit
>> +	 * root will be safe, so we can caching from the free space tree now.
>> +	 */
>> +	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
>> +	return ret;
> 
> I guess you can't simply move the clearing of the
> BTRFS_FS_CREATING_FREE_SPACE_TREE after the commit since it blocks
> delayed refs running.
> 
>>   
>>   abort:
>>   	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
> 
> Shouldn't the new flag be cleared on abort ?
> 

Yup I'll fix that, thanks,

Josef
