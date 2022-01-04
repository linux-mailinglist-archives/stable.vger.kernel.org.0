Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052BD483F27
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiADJ3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiADJ3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 04:29:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDBCC061784;
        Tue,  4 Jan 2022 01:29:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C692B81163;
        Tue,  4 Jan 2022 09:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D17C36AEB;
        Tue,  4 Jan 2022 09:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641288574;
        bh=ySIA2aBN9LRv1tJ+pRUGBiq1mQARk0uKjAbUu7on19E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bdtRSeG73Wly7TiQ+FDgzQnffLlU8hDPq0jQmmq3OSv/Y8cKIRjDv+1e8WPiyKXQn
         3VID2f64Sv1Te11PlwR0kFyETDi0qbFvPkqwic/TgKpK1j5NN6/WHWkjzLqhp12s4R
         L4r8HuHs3Q3gmlTAms+HPoa9q3aiBe1o5BZFqgO70oUuyxoP+T4hsB8qxB4CDeonyb
         +0Na0t6y3oqqcHAJGJ9vVZA6eX6QbWHQ9FUZbNTdEReQdoHKeMh7vDBo314sjbSPbK
         cBGiLAuve8fR37fjZsrMGFdAWw7Ko5Ex5DSveyh+AhstgQHHzqFPebnTGWuHhUaj8P
         s6Ttr978TFI7Q==
Message-ID: <12184f7c-3662-7fdc-d44f-23ef29102ddd@kernel.org>
Date:   Tue, 4 Jan 2022 17:29:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5.10 60/76] f2fs: fix to do sanity check on last xattr
 entry in __f2fs_setxattr()
Content-Language: en-US
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenqing Liu <wenqingliu0120@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151326.779679392@linuxfoundation.org> <YdNmdhsKS5ZWHOlB@eldamar.lan>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <YdNmdhsKS5ZWHOlB@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/1/4 5:11, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Mon, Dec 27, 2021 at 04:31:15PM +0100, Greg Kroah-Hartman wrote:
>> From: Chao Yu <chao@kernel.org>
>>
>> commit 5598b24efaf4892741c798b425d543e4bed357a1 upstream.

I've no idea.

I didn't add this line from v1 to v3:

https://lore.kernel.org/lkml/20211211154059.7173-1-chao@kernel.org/T/
https://lore.kernel.org/all/20211212071923.2398-1-chao@kernel.org/T/
https://lore.kernel.org/all/20211212091630.6325-1-chao@kernel.org/T/

Am I missing anything?

Thanks,

>>
>> As Wenqing Liu reported in bugzilla:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=215235
>>
>> - Overview
>> page fault in f2fs_setxattr() when mount and operate on corrupted image
>>
>> - Reproduce
>> tested on kernel 5.16-rc3, 5.15.X under root
>>
>> 1. unzip tmp7.zip
>> 2. ./single.sh f2fs 7
>>
>> Sometimes need to run the script several times
>>
>> - Kernel dump
>> loop0: detected capacity change from 0 to 131072
>> F2FS-fs (loop0): Found nat_bits in checkpoint
>> F2FS-fs (loop0): Mounted with checkpoint version = 7548c2ee
>> BUG: unable to handle page fault for address: ffffe47bc7123f48
>> RIP: 0010:kfree+0x66/0x320
>> Call Trace:
>>   __f2fs_setxattr+0x2aa/0xc00 [f2fs]
>>   f2fs_setxattr+0xfa/0x480 [f2fs]
>>   __f2fs_set_acl+0x19b/0x330 [f2fs]
>>   __vfs_removexattr+0x52/0x70
>>   __vfs_removexattr_locked+0xb1/0x140
>>   vfs_removexattr+0x56/0x100
>>   removexattr+0x57/0x80
>>   path_removexattr+0xa3/0xc0
>>   __x64_sys_removexattr+0x17/0x20
>>   do_syscall_64+0x37/0xb0
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> The root cause is in __f2fs_setxattr(), we missed to do sanity check on
>> last xattr entry, result in out-of-bound memory access during updating
>> inconsistent xattr data of target inode.
>>
>> After the fix, it can detect such xattr inconsistency as below:
>>
>> F2FS-fs (loop11): inode (7) has invalid last xattr entry, entry_size: 60676
>> F2FS-fs (loop11): inode (8) has corrupted xattr
>> F2FS-fs (loop11): inode (8) has corrupted xattr
>> F2FS-fs (loop11): inode (8) has invalid last xattr entry, entry_size: 47736
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
>> Signed-off-by: Chao Yu <chao@kernel.org>
>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   fs/f2fs/xattr.c |   11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> --- a/fs/f2fs/xattr.c
>> +++ b/fs/f2fs/xattr.c
>> @@ -680,8 +680,17 @@ static int __f2fs_setxattr(struct inode
>>   	}
>>   
>>   	last = here;
>> -	while (!IS_XATTR_LAST_ENTRY(last))
>> +	while (!IS_XATTR_LAST_ENTRY(last)) {
>> +		if ((void *)(last) + sizeof(__u32) > last_base_addr ||
>> +			(void *)XATTR_NEXT_ENTRY(last) > last_base_addr) {
>> +			f2fs_err(F2FS_I_SB(inode), "inode (%lu) has invalid last xattr entry, entry_size: %zu",
>> +					inode->i_ino, ENTRY_SIZE(last));
>> +			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
>> +			error = -EFSCORRUPTED;
>> +			goto exit;
>> +		}
>>   		last = XATTR_NEXT_ENTRY(last);
>> +	}
>>   
>>   	newsize = XATTR_ALIGN(sizeof(struct f2fs_xattr_entry) + len + size);
> 
> It looks this commit while it was applied to several stable series
> (TTBOMK in 5.15.12, 5.10.89, 5.4.169, 4.19.223 and 4.14.260) it is
> still missing from mainline, Chao, or anyone else, do you know what
> happened here?
> 
> Regards,
> Salvatore
