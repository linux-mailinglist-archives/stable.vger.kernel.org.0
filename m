Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7042552975C
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 04:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiEQC2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 22:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQC2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 22:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EF4AE72;
        Mon, 16 May 2022 19:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEAB5B816D6;
        Tue, 17 May 2022 02:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DADC385AA;
        Tue, 17 May 2022 02:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652754492;
        bh=2BK+qccsnYN9U4J+o3pYJeINww3jHTy6bx3/JTI0z3I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MEbKNlPKH8gSYH1nlIUFrAU9S7BvJyRP0at6+SbdlQfrai23Uc1GAG5RWHaiDpThW
         ISal0fCB2hXg5wXbtKyujurYcAycwltkYuT5tEUqMBg4tmgKgXUebeOMZGx7NYMfqU
         utxt2ZS+LP/ht3FZG8GBlNpSldZwtAW+UC+Gh0RSymGdTt+IGwQeE9R9QTS1IoIJLf
         1ncZa27hX+sRLZvNrn4Zxv5dhO9ne9WZfv0Ds7A2hKjNUCRgM6EsUic8Pd1sm2ek6/
         RmAHBom1p62paArJ/mSNLSoUW7lL/0KbzpwoKzEhRea4cAJSCiwSDXJyWy5avrGl27
         dkN1hkQm6h7vQ==
Message-ID: <ffef8bce-3eb8-0e7e-dd64-e97c59251d2b@kernel.org>
Date:   Tue, 17 May 2022 10:28:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3] f2fs: fix to do sanity check for inline inode
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Yan <yanming@tju.edu.cn>, Chao Yu <chao.yu@oppo.com>
References: <20220515090547.1914-1-chao@kernel.org>
 <YoLwd3CUBIFn7+rS@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <YoLwd3CUBIFn7+rS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/5/17 8:46, Jaegeuk Kim wrote:
> On 05/15, Chao Yu wrote:
>> Yanming reported a kernel bug in Bugzilla kernel [1], which can be
>> reproduced. The bug message is:
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
>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=215895
>>
>> The bug is due to fuzzed inode has both inline_data and encrypted flags.
>> During f2fs_evict_inode(), as the inode was deleted by rename(), it
>> will cause inline data conversion due to conflicting flags. The page
>> cache will be polluted and the panic will be triggered in clear_inode().
>>
>> Try fixing the bug by doing more sanity checks for inline data inode in
>> sanity_check_inode().
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Ming Yan <yanming@tju.edu.cn>
>> Signed-off-by: Chao Yu <chao.yu@oppo.com>
>> ---
>> v3:
>> - clean up commit message suggested by Bagas Sanjaya.
>>   fs/f2fs/f2fs.h  | 8 ++++++++
>>   fs/f2fs/inode.c | 3 +--
>>   2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> index 492af5b96de1..0dc2461ef02c 100644
>> --- a/fs/f2fs/f2fs.h
>> +++ b/fs/f2fs/f2fs.h
>> @@ -4126,6 +4126,14 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
>>    */
>>   static inline bool f2fs_post_read_required(struct inode *inode)
>>   {
>> +	/*
>> +	 * used by sanity_check_inode(), when disk layout fields has not
>> +	 * been synchronized to inmem fields.
>> +	 */
>> +	if (S_ISREG(inode->i_mode) && (file_is_encrypt(inode) ||
>> +		F2FS_I(inode)->i_flags & F2FS_COMPR_FL ||
>> +		file_is_verity(inode)))
>> +		return true;
> 
> Again, I prefer to check this in sanity_check_inode(), since we don't need to
> check all the time here.

Sure, how about adding a new parameter for f2fs_may_inline_data() to indicate
its caller is sanity_check_inode(), and do the checks here only for such path?

Thanks,

> 
>>   	return f2fs_encrypted_file(inode) || fsverity_active(inode) ||
>>   		f2fs_compressed_file(inode);
>>   }
>> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
>> index 2fce8fa0dac8..5e494c98e3c2 100644
>> --- a/fs/f2fs/inode.c
>> +++ b/fs/f2fs/inode.c
>> @@ -276,8 +276,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
>>   		}
>>   	}
>>   
>> -	if (f2fs_has_inline_data(inode) &&
>> -			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
>> +	if (f2fs_has_inline_data(inode) && !f2fs_may_inline_data(inode)) {
>>   		set_sbi_flag(sbi, SBI_NEED_FSCK);
>>   		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
>>   			  __func__, inode->i_ino, inode->i_mode);
>> -- 
>> 2.32.0
