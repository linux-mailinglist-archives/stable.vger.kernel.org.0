Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75094554C26
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 16:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiFVOGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 10:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiFVOGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 10:06:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6A437BD1;
        Wed, 22 Jun 2022 07:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7E31B81F2F;
        Wed, 22 Jun 2022 14:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A2DC34114;
        Wed, 22 Jun 2022 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655906778;
        bh=V32Oq5PdZyE2PUlLwoGNPxQgY0tVovIx+oQ1azyoNT0=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=POjo8xAwHIgk0d94B/d1cMAHnUPwBOJC5GtCli01F/NRkB/tpT0OyudXuLTZVpuw3
         JfrPzf+BiXbRfveuDt6f1yHYj9q03KbBg/HJN+40ph6OZJo217RPm2hzxItRwKx9Pj
         DlaFFybb0QGFTds02CtmPnyBAHVLsuRRNSeyrimRp6XajDhYYAoMZSFQ2AS4g3EM2g
         /xOkY6NrdbMrhZXCuCm1rUluqjGtjDlCYl83mbSWDnQBiOft25sg1IWTgogehYV/CH
         sGvVd5YCeXm9WPeP6V7f7q/d9D9+zSbYfZKT5uKRgypXvNbtEoK9yUrqwFq8cG7+51
         IPrwsJjWG6ViQ==
Message-ID: <4c090b50-bfd1-ae90-ac72-ebae3963f578@kernel.org>
Date:   Wed, 22 Jun 2022 22:06:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: attach inline_data after setting
 compression
Content-Language: en-US
From:   Chao Yu <chao@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20220617223106.3517374-1-jaegeuk@kernel.org>
 <ae324c70-8671-8878-5854-c0910c744379@kernel.org>
In-Reply-To: <ae324c70-8671-8878-5854-c0910c744379@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/19 8:35, Chao Yu wrote:
> On 2022/6/18 6:31, Jaegeuk Kim wrote:
>> This fixes the below corruption.
>>
>> [345393.335389] F2FS-fs (vdb): sanity_check_inode: inode (ino=6d0, mode=33206) should not have inline_data, run fsck to fix
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 677a82b44ebf ("f2fs: fix to do sanity check for inline inode")
>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>> ---
>>    fs/f2fs/namei.c | 16 ++++++++++------
>>    1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
>> index c549acb52ac4..a841abe6a071 100644
>> --- a/fs/f2fs/namei.c
>> +++ b/fs/f2fs/namei.c
>> @@ -89,8 +89,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>>    	if (test_opt(sbi, INLINE_XATTR))
>>    		set_inode_flag(inode, FI_INLINE_XATTR);
>>    
>> -	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
>> -		set_inode_flag(inode, FI_INLINE_DATA);
>>    	if (f2fs_may_inline_dentry(inode))
>>    		set_inode_flag(inode, FI_INLINE_DENTRY);
>>    
>> @@ -107,10 +105,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>>    
>>    	f2fs_init_extent_tree(inode, NULL);
>>    
>> -	stat_inc_inline_xattr(inode);
>> -	stat_inc_inline_inode(inode);
>> -	stat_inc_inline_dir(inode);
>> -
>>    	F2FS_I(inode)->i_flags =
>>    		f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
>>    
>> @@ -127,6 +121,14 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>>    			set_compress_context(inode);
>>    	}
>>    
>> +	/* Should enable inline_data after compression set */
>> +	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
>> +		set_inode_flag(inode, FI_INLINE_DATA);
>> +
>> +	stat_inc_inline_xattr(inode);
>> +	stat_inc_inline_inode(inode);
>> +	stat_inc_inline_dir(inode);
>> +
>>    	f2fs_set_inode_flags(inode);
>>    
>>    	trace_f2fs_new_inode(inode, 0);
>> @@ -325,6 +327,8 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
>>    		if (!is_extension_exist(name, ext[i], false))
>>    			continue;
>>    
>> +		/* Do not use inline_data with compression */
>> +		clear_inode_flag(inode, FI_INLINE_DATA);
> 
> if (is_inode_set_flag()) {
> 	clear_inode_flag();
> 	stat_dec_inline_inode();
> }

Missed to send new version to mailing list?

https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/commit/?h=dev&id=4cde00d50707c2ef6647b9b96b2cb40b6eb24397

Thanks,

> 
> Thanks,
> 
>>    		set_compress_context(inode);
>>    		return;
>>    	}
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
