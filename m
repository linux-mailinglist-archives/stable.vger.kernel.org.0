Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB951B624
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 04:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbiEECxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 22:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbiEECxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 22:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0BF38BD2;
        Wed,  4 May 2022 19:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA5E2618B0;
        Thu,  5 May 2022 02:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D572C385A5;
        Thu,  5 May 2022 02:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651718966;
        bh=WsFxI8tAPwJTDxgTE3fIsf0Fr++lhBi5KhM8JEGqIKA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=By3loszQpJmgf45etbT6dtiYPHWUqSkk9Uyw/4f64S25gN8tjW+q3xqAzegMttCSo
         Clko/YftpeDtXalT88ONJEqs5QGnRUebZMgAatDy4cPwqaXmBLMvqM6toQy1Gs8f4O
         nJQ8nmcPxe+YEhRRzNNjusj+8CoV3w5kooAqJFh5GmQNm7oJWYJFKbMmKRFMb7t3BO
         x9edE0QeYb8BqzryYQp1y+a+Lv9EZrM0x3y6EXc9YpPt30xbNQ0Raapkn7elCbNbmZ
         km1hMAd7uOR8H4oIZ7V4IUu2s5z4txsOHiQZ3zU5Net19g7VWyU5isjxkdNPBdBuPj
         0EjdTes+iVg0w==
Message-ID: <173c51c2-eff3-8d76-7041-e9c58024a97e@kernel.org>
Date:   Thu, 5 May 2022 10:49:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] f2fs: fix to do sanity check for inline inode
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Yan <yanming@tju.edu.cn>, Chao Yu <chao.yu@oppo.com>
References: <20220428024940.12102-1-chao@kernel.org>
 <YnLwDx1smguDQ6qC@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <YnLwDx1smguDQ6qC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/5/5 5:28, Jaegeuk Kim wrote:
> On 04/28, Chao Yu wrote:
>> As Yanming reported in bugzilla:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=215895
>>
>> I have encountered a bug in F2FS file system in kernel v5.17.
>>
>> The kernel message is shown below:
>>
>> kernel BUG at fs/inode.c:611!
>> Call Trace:
>>   evict+0x282/0x4e0
>>   __dentry_kill+0x2b2/0x4d0
>>   dput+0x2dd/0x720
>>   do_renameat2+0x596/0x970
>>   __x64_sys_rename+0x78/0x90
>>   do_syscall_64+0x3b/0x90
>>
>> The root cause is: fuzzed inode has both inline_data flag and encrypted
>> flag, so after it was deleted by rename(), during f2fs_evict_inode(),
>> it will cause inline data conversion due to flags confilction, then
>> page cache will be polluted and trigger panic in clear_inode().
>>
>> This patch tries to fix the issue by do more sanity checks for inline
>> data inode in sanity_check_inode().
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Ming Yan <yanming@tju.edu.cn>
>> Signed-off-by: Chao Yu <chao.yu@oppo.com>
>> ---
>>   fs/f2fs/f2fs.h  | 7 +++++++
>>   fs/f2fs/inode.c | 3 +--
>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> index 27aa93caec06..64c511b498cc 100644
>> --- a/fs/f2fs/f2fs.h
>> +++ b/fs/f2fs/f2fs.h
>> @@ -4173,6 +4173,13 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
>>    */
>>   static inline bool f2fs_post_read_required(struct inode *inode)
>>   {
>> +	/*
>> +	 * used by sanity_check_inode(), when disk layout fields has not
>> +	 * been synchronized to inmem fields.
>> +	 */
>> +	if (file_is_encrypt(inode) || file_is_verity(inode) ||
>> +			F2FS_I(inode)->i_flags & F2FS_COMPR_FL)
>> +		return true;
>>   	return f2fs_encrypted_file(inode) || fsverity_active(inode) ||
>>   		f2fs_compressed_file(inode);
>>   }
>> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
>> index 83639238a1fe..234b8ed02644 100644
>> --- a/fs/f2fs/inode.c
>> +++ b/fs/f2fs/inode.c
>> @@ -276,8 +276,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
>>   		}
>>   	}
>>   
>> -	if (f2fs_has_inline_data(inode) &&
>> -			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
>> +	if (f2fs_has_inline_data(inode) && !f2fs_may_inline_data(inode)) {
> 
> It seems f2fs_may_inline_data() is breaking the atomic write case. Please fix.

sanity_check_inode() change only affect f2fs_iget(), during inode initialization,
file should not be set as atomic one, right?

I didn't see any failure during 'f2fs_io write atomic_write' testcase... could you
please provide me detail of the testcase?

Thanks,

> 
>>   		set_sbi_flag(sbi, SBI_NEED_FSCK);
>>   		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
>>   			  __func__, inode->i_ino, inode->i_mode);
>> -- 
>> 2.25.1
