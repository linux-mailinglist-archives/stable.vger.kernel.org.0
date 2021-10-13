Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91F42BD2D
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 12:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhJMKkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 06:40:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:24307 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJMKkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 06:40:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HTpmH2fh6zYklJ;
        Wed, 13 Oct 2021 18:33:51 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 18:38:14 +0800
Received: from [10.174.176.52] (10.174.176.52) by
 kwepemm600015.china.huawei.com (7.193.23.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 18:38:13 +0800
Subject: Re: [PATCH 4.19,v2] VFS: Fix fuseblk memory leak caused by mount
 concurrency
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dhowells@redhat.com>, <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhangxiaoxu5@huawei.com>
References: <20211013095101.641329-1-chenxiaosong2@huawei.com>
 <YWawy0J9JfStEku0@kroah.com>
From:   "chenxiaosong (A)" <chenxiaosong2@huawei.com>
Message-ID: <429d87b0-3a53-052a-a304-0afa8d51900d@huawei.com>
Date:   Wed, 13 Oct 2021 18:38:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YWawy0J9JfStEku0@kroah.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.52]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600015.china.huawei.com (7.193.23.52)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

�� 2021/10/13 18:11, Greg KH д��:
> On Wed, Oct 13, 2021 at 05:51:01PM +0800, ChenXiaoSong wrote:
>> If two processes mount same superblock, memory leak occurs:
>>
>> CPU0               |  CPU1
>> do_new_mount       |  do_new_mount
>>    fs_set_subtype   |    fs_set_subtype
>>      kstrdup        |
>>                     |      kstrdup
>>      memrory leak   |
>>
>> Fix this by adding a write lock while calling fs_set_subtype.
>>
>> Linus's tree already have refactoring patchset [1], one of them can fix this bug:
>>          c30da2e981a7 (fuse: convert to use the new mount API)
>>
>> Since we did not merge the refactoring patchset in this branch, I create this patch.
>>
>> [1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/
>>
>> Fixes: 79c0b2df79eb (add filesystem subtype support)
>> Cc: David Howells <dhowells@redhat.com>
>> Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
>> ---
>> v1: Can not mount sshfs ([PATCH linux-4.19.y] VFS: Fix fuseblk memory leak caused by mount concurrency)
>> v2: Use write lock while writing superblock
>>
>>   fs/namespace.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> As you are referring to a fuse-only patch above, why are you trying to
> resolve this issue in the core namespace code instead?
> 
> How does fuse have anything to do with this?
> 
> confused,
> 
> greg k-h
> .
> 

Now, only `fuse_fs_type` and `fuseblk_fs_type` has `FS_HAS_SUBTYPE` flag 
in kernel code, but maybe there is a filesystem module(`struct 
file_system_type` has `FS_HAS_SUBTYPE` flag). And only mounting fuseblk 
filesystem(e.g. ntfs) will occur memory leak now.
