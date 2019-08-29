Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C27A28B5
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 23:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfH2VQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 17:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfH2VQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 17:16:42 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CECB208C2;
        Thu, 29 Aug 2019 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567113401;
        bh=S8jZl5qXwtASsh5sqmmpoIddnxCBuXvV58tUABgzZKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pf4R/qE5U0ptoMvA6pBMA2mE1A59uGzHclP0IcO1McDCsMmRqgD/adkoEj+nu59xk
         dR/inm3HdrOS6Hml8x/aWb6cykxATePFa/h5RbsRBepApDwGyxBIOKpa6ihPstjoLd
         QEcnRqw1Vl2tvAuVCKYZI6mtQlXlE9yeSISENWnw=
Date:   Thu, 29 Aug 2019 17:16:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.2 66/76] ceph: fix buffer free while holding
 i_ceph_lock in __ceph_setxattr()
Message-ID: <20190829211640.GN5281@sasha-vm>
References: <20190829181311.7562-1-sashal@kernel.org>
 <20190829181311.7562-66-sashal@kernel.org>
 <CAOi1vP9-A-U6J15hT+XmtXzBw5WVRZECry8gPFzqp0CV36ecig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP9-A-U6J15hT+XmtXzBw5WVRZECry8gPFzqp0CV36ecig@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 10:51:04PM +0200, Ilya Dryomov wrote:
>On Thu, Aug 29, 2019 at 8:15 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Luis Henriques <lhenriques@suse.com>
>>
>> [ Upstream commit 86968ef21596515958d5f0a40233d02be78ecec0 ]
>>
>> Calling ceph_buffer_put() in __ceph_setxattr() may end up freeing the
>> i_xattrs.prealloc_blob buffer while holding the i_ceph_lock.  This can be
>> fixed by postponing the call until later, when the lock is released.
>>
>> The following backtrace was triggered by fstests generic/117.
>>
>>   BUG: sleeping function called from invalid context at mm/vmalloc.c:2283
>>   in_atomic(): 1, irqs_disabled(): 0, pid: 650, name: fsstress
>>   3 locks held by fsstress/650:
>>    #0: 00000000870a0fe8 (sb_writers#8){.+.+}, at: mnt_want_write+0x20/0x50
>>    #1: 00000000ba0c4c74 (&type->i_mutex_dir_key#6){++++}, at: vfs_setxattr+0x55/0xa0
>>    #2: 000000008dfbb3f2 (&(&ci->i_ceph_lock)->rlock){+.+.}, at: __ceph_setxattr+0x297/0x810
>>   CPU: 1 PID: 650 Comm: fsstress Not tainted 5.2.0+ #437
>>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
>>   Call Trace:
>>    dump_stack+0x67/0x90
>>    ___might_sleep.cold+0x9f/0xb1
>>    vfree+0x4b/0x60
>>    ceph_buffer_release+0x1b/0x60
>>    __ceph_setxattr+0x2b4/0x810
>>    __vfs_setxattr+0x66/0x80
>>    __vfs_setxattr_noperm+0x59/0xf0
>>    vfs_setxattr+0x81/0xa0
>>    setxattr+0x115/0x230
>>    ? filename_lookup+0xc9/0x140
>>    ? rcu_read_lock_sched_held+0x74/0x80
>>    ? rcu_sync_lockdep_assert+0x2e/0x60
>>    ? __sb_start_write+0x142/0x1a0
>>    ? mnt_want_write+0x20/0x50
>>    path_setxattr+0xba/0xd0
>>    __x64_sys_lsetxattr+0x24/0x30
>>    do_syscall_64+0x50/0x1c0
>>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>   RIP: 0033:0x7ff23514359a
>>
>> Signed-off-by: Luis Henriques <lhenriques@suse.com>
>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/ceph/xattr.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index 0619adbcbe14c..8382299fc2d84 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -1028,6 +1028,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>>         struct ceph_inode_info *ci = ceph_inode(inode);
>>         struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>         struct ceph_cap_flush *prealloc_cf = NULL;
>> +       struct ceph_buffer *old_blob = NULL;
>>         int issued;
>>         int err;
>>         int dirty = 0;
>> @@ -1101,13 +1102,15 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>>                 struct ceph_buffer *blob;
>>
>>                 spin_unlock(&ci->i_ceph_lock);
>> -               dout(" preaallocating new blob size=%d\n", required_blob_size);
>> +               ceph_buffer_put(old_blob); /* Shouldn't be required */
>> +               dout(" pre-allocating new blob size=%d\n", required_blob_size);
>>                 blob = ceph_buffer_new(required_blob_size, GFP_NOFS);
>>                 if (!blob)
>>                         goto do_sync_unlocked;
>>                 spin_lock(&ci->i_ceph_lock);
>> +               /* prealloc_blob can't be released while holding i_ceph_lock */
>>                 if (ci->i_xattrs.prealloc_blob)
>> -                       ceph_buffer_put(ci->i_xattrs.prealloc_blob);
>> +                       old_blob = ci->i_xattrs.prealloc_blob;
>>                 ci->i_xattrs.prealloc_blob = blob;
>>                 goto retry;
>>         }
>> @@ -1123,6 +1126,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>>         }
>>
>>         spin_unlock(&ci->i_ceph_lock);
>> +       ceph_buffer_put(old_blob);
>>         if (lock_snap_rwsem)
>>                 up_read(&mdsc->snap_rwsem);
>>         if (dirty)
>
>Hi Sasha,
>
>I didn't tag i_ceph_lock series for stable because this is a very old
>bug which no one ever hit in real life, at least to my knowledge.

I can drop it if you prefer.

--
Thanks,
Sasha
