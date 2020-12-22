Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE42E0762
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 09:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLVIqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 03:46:40 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9545 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgLVIqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 03:46:40 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D0VK64K68zhvVD;
        Tue, 22 Dec 2020 16:45:14 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.210) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 22 Dec
 2020 16:45:53 +0800
Subject: Re: [PATCH 5.10.y] f2fs: fix to seek incorrect data offset in inline
 data file
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
        <chao@kernel.org>, <jaegeuk@kernel.org>,
        kitestramuort <kitestramuort@autistici.org>
References: <20201222011634.124180-1-yuchao0@huawei.com>
 <X+GwEz8NTepCKEFX@kroah.com> <X+GwQ9G4RufeTpxy@kroah.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <99920a3b-421b-e1dc-e6d8-96813da5bd10@huawei.com>
Date:   Tue, 22 Dec 2020 16:45:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <X+GwQ9G4RufeTpxy@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/12/22 16:37, Greg KH wrote:
> On Tue, Dec 22, 2020 at 09:36:35AM +0100, Greg KH wrote:
>> On Tue, Dec 22, 2020 at 09:16:34AM +0800, Chao Yu wrote:
>>> As kitestramuort reported:
>>>
>>> F2FS-fs (nvme0n1p4): access invalid blkaddr:1598541474
>>> [   25.725898] ------------[ cut here ]------------
>>> [   25.725903] WARNING: CPU: 6 PID: 2018 at f2fs_is_valid_blkaddr+0x23a/0x250
>>> [   25.725923] Call Trace:
>>> [   25.725927]  ? f2fs_llseek+0x204/0x620
>>> [   25.725929]  ? ovl_copy_up_data+0x14f/0x200
>>> [   25.725931]  ? ovl_copy_up_inode+0x174/0x1e0
>>> [   25.725933]  ? ovl_copy_up_one+0xa22/0xdf0
>>> [   25.725936]  ? ovl_copy_up_flags+0xa6/0xf0
>>> [   25.725938]  ? ovl_aio_cleanup_handler+0xd0/0xd0
>>> [   25.725939]  ? ovl_maybe_copy_up+0x86/0xa0
>>> [   25.725941]  ? ovl_open+0x22/0x80
>>> [   25.725943]  ? do_dentry_open+0x136/0x350
>>> [   25.725945]  ? path_openat+0xb7e/0xf40
>>> [   25.725947]  ? __check_sticky+0x40/0x40
>>> [   25.725948]  ? do_filp_open+0x70/0x100
>>> [   25.725950]  ? __check_sticky+0x40/0x40
>>> [   25.725951]  ? __check_sticky+0x40/0x40
>>> [   25.725953]  ? __x64_sys_openat+0x1db/0x2c0
>>> [   25.725955]  ? do_syscall_64+0x2d/0x40
>>> [   25.725957]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> llseek() reports invalid block address access, the root cause is if
>>> file has inline data, f2fs_seek_block() will access inline data regard
>>> as block address index in inode block, which should be wrong, fix it.
>>>
>>> Fixes: 788e96d1d3994 ("f2fs: code cleanup by removing unnecessary check")
>>> Fixes: 267378d4de69 ("f2fs: introduce f2fs_seek_block to support SEEK_{DATA, HOLE} in llseek")
>>> Cc: stable <stable@vger.kernel.org> # 3.16+
>>> Reported-by: kitestramuort <kitestramuort@autistici.org>
>>> Signed-off-by: Chao Yu <yuchao0@huawei.com>
>>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>>> ---
>>>
>>> This will cause boot failure in f2fs image, which was reported in gentoo
>>> community, I'd like to fix them in stable kernel 5.10 first as request in
>>> bugzilla:
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=210825
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read:
>>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> for how to do this properly.

I forgot to add "Cc: stable ..." tag in original patch before this patch been
merged in Linus' tree, so I think "Option 2" should be right way to backport this
patch, however, I forgot to tag commit id of this patch.

>>
>> </formletter>
> 
> Specifically, what is the git commit id of this patch in Linus's tree?

Will add git commit id, and resend the patch.

Thanks,

> 
> thanks,
> 
> greg k-h
> .
> 
