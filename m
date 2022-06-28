Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D9B55DB4C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241686AbiF1HuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 03:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241378AbiF1HuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 03:50:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF66510EC;
        Tue, 28 Jun 2022 00:50:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63A2860ED0;
        Tue, 28 Jun 2022 07:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B077C3411D;
        Tue, 28 Jun 2022 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656402607;
        bh=B5QIhlbtzECgsRE8EI6Zyf1MuzRiNeg87KIBkcQ7vvU=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=uBEY+beYn2AWAxOKCmPu7Pw+1xiYKV0VUre/0qN+Me1NzxYbEo4V+U01T42wdCMI2
         WivFZE+tGZfl6IKsIFAq+uYSROpIolPF3O3nTjazZoFrk4OwzcxhNWb6hNNvkPCxS2
         J5T6rJacKk8KDTCbtObsfVOJvPOWH1mt46cTO8gwDSmFfsSkp17r+UA3T8w6tKJqrh
         qwOPiU13V6z4mQ0/nVbvioRI97P3N8PkTwC6Qqc9JRKDG31aAChLd6BB/ZoSxr7vFM
         qRWlRyJj9U2irA7pLgXYlRkgzTGt2lgM88LF87u6XLMU8cXD2torMVXCgR0JOkagI1
         vo0IK3sEeZTsA==
Message-ID: <ea40fecd-a16f-4ded-a062-21b097d67230@kernel.org>
Date:   Tue, 28 Jun 2022 15:50:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [f2fs-dev] [PATCH 1/3 v2] f2fs: attach inline_data after setting
 compression
Content-Language: en-US
From:   Chao Yu <chao@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20220617223106.3517374-1-jaegeuk@kernel.org>
 <YrNJBMGpjPdtwVY+@google.com>
 <f3484c66-bb5e-b4d6-fc43-95a73c280f1d@kernel.org>
In-Reply-To: <f3484c66-bb5e-b4d6-fc43-95a73c280f1d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/28 15:46, Chao Yu wrote:
> On 2022/6/23 0:53, Jaegeuk Kim wrote:
>> This fixes the below corruption.
>>
>> [345393.335389] F2FS-fs (vdb): sanity_check_inode: inode (ino=6d0, mode=33206) should not have inline_data, run fsck to fix
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 677a82b44ebf ("f2fs: fix to do sanity check for inline inode")
>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>> ---
>>   fs/f2fs/namei.c | 17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
>> index c549acb52ac4..bf00d5057abb 100644
>> --- a/fs/f2fs/namei.c
>> +++ b/fs/f2fs/namei.c
>> @@ -89,8 +89,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>>       if (test_opt(sbi, INLINE_XATTR))
>>           set_inode_flag(inode, FI_INLINE_XATTR);
>> -    if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
>> -        set_inode_flag(inode, FI_INLINE_DATA);
>>       if (f2fs_may_inline_dentry(inode))
>>           set_inode_flag(inode, FI_INLINE_DENTRY);
>> @@ -107,10 +105,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>>       f2fs_init_extent_tree(inode, NULL);
>> -    stat_inc_inline_xattr(inode);
>> -    stat_inc_inline_inode(inode);
>> -    stat_inc_inline_dir(inode);
>> -
>>       F2FS_I(inode)->i_flags =
>>           f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
>> @@ -127,6 +121,14 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>>               set_compress_context(inode);
>>       }
>> +    /* Should enable inline_data after compression set */
>> +    if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
>> +        set_inode_flag(inode, FI_INLINE_DATA);
>> +
>> +    stat_inc_inline_xattr(inode);
>> +    stat_inc_inline_inode(inode);
>> +    stat_inc_inline_dir(inode);
>> +
>>       f2fs_set_inode_flags(inode);
>>       trace_f2fs_new_inode(inode, 0);
>> @@ -325,6 +327,9 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
>>           if (!is_extension_exist(name, ext[i], false))
>>               continue;
>> +        /* Do not use inline_data with compression */
>> +        stat_dec_inline_inode(inode);
>> +        clear_inode_flag(inode, FI_INLINE_DATA);
> 
> It looks we don't need to dirty inode if there is no inline_data flag.

Oh, it looks set_compress_context() will dirty inode anyway.... :P

Thanks,

> 
> Thanks,
> 
>>           set_compress_context(inode);
>>           return;
>>       }
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
