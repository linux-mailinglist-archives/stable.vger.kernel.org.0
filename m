Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC5631A8A
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 08:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKUHpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 02:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKUHpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 02:45:43 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338182DE1;
        Sun, 20 Nov 2022 23:45:41 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NFzvD2l4YzRpHV;
        Mon, 21 Nov 2022 15:45:12 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 15:45:39 +0800
Received: from [10.67.108.67] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 15:45:39 +0800
Message-ID: <35670b32-1337-04be-0269-f7f0f845833c@huawei.com>
Date:   Mon, 21 Nov 2022 15:45:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH v2] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment
 usage as dirty
Content-Language: en-US
To:     Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC:     <linux-nilfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <akpm@linux-foundation.org>
References: <20221119093424.193145-1-chenzhongjin@huawei.com>
 <CAKFNMokEHD4FfPRcuRB4GrVquiT_RkWkNGKgb+ZPLPSGwfbDHQ@mail.gmail.com>
 <db11fe6a-356b-a522-f275-9b8ce8ab3b4a@huawei.com>
 <CAKFNMo=SsnbZxrAU-ho_37J4ZBqG+VY0kDJxDa3widrb2Gkj1g@mail.gmail.com>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <CAKFNMo=SsnbZxrAU-ho_37J4ZBqG+VY0kDJxDa3widrb2Gkj1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2022/11/21 14:48, Ryusuke Konishi wrote:
> On Mon, Nov 21, 2022 at 11:16 AM Chen Zhongjin wrote:
>> Hi,
>>
>> On 2022/11/19 22:09, Ryusuke Konishi wrote:
>>> On Sat, Nov 19, 2022 at 6:37 PM Chen Zhongjin wrote:
>>>> In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
>>>> nilfs_segment_usage is not set dirty, which makes it can be found by
>>>> nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).
>>> The body of the patch looks OK, but this part of the commit log is a
>>> bit misleading.
>>> Could you please modify the expression so that we can understand this
>>> patch fixes the issue when the disk image is corrupted and the leak
>>> wasn't always there ?
>> Makes sense. I'm going to fix the message as this:
> Thank you for responding to my comment.
>
>> When extending segment, the current segment is allocated and set dirty
>> by previous nilfs_sufile_alloc().
>> But for some special cases such as corrupted image it can be unreliable,
>> so nilfs_sufile_mark_dirty()
>> is called to promise that current segment is dirty.
> This sentence is a little different because nilfs_sufile_mark_dirty()
> is originally called to dirty the buffer to include it as a part of
> the log of nilfs ahead, where the completed usage data will be stored
> later.
>
> And, unlike the dirty state of buffers and inodes, the dirty state of
> segments is persistent and resides on disk until it's freed by
> nilfs_sufile_free() unless it's destroyed on disk.
>
>> However, nilfs_sufile_mark_dirty() only sets buffer and inode dirty
>> while nilfs_segment_usage can
>> still be clean an used by following nilfs_sufile_alloc() because it
>> checks nilfs_segment_usage_clean(su).
>>
>> This will cause the problem reported...
> So, how about a description like this:
>
> When extending segments, nilfs_sufile_alloc() is called to get an
> unassigned segment.
> nilfs_sufile_alloc() then marks it as dirty to avoid accidentally
> allocating the same segment in the future.
> But for some special cases such as a corrupted image it can be unreliable.
>
> If such corruption of the dirty state of the segment occurs, nilfs2
> may reallocate a segment that is in use and pick the same segment for
> writing twice at the same time.
> ...
> This will cause the reported problem.
> ...
> Fix the problem by setting usage as dirty every time in
> nilfs_sufile_mark_dirty() which is called for the current segment
> before allocating additional segments during constructing segments to
> be written out.

Thanks for your explanation!

I made some simplification, so everything looks like:


When extending segments, nilfs_sufile_alloc() is called to get an
unassigned segment, then mark it as dirty to avoid accidentally
allocating the same segment in the future.

But for some special cases such as a corrupted image it can be
unreliable.
If such corruption of the dirty state of the segment occurs, nilfs2 may
reallocate a segment that is in use and pick the same segment for
writing twice at the same time.

This will cause the problem reported by syzkaller:
https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24

This case started with segbuf1.segnum = 3, nextnum = 4 when constructed.
It supposed segment 4 has already been allocated and marked as dirty.

However the dirty state was corrupted and segment 4 usage was not dirty.
For the first time nilfs_segctor_extend_segments() segment 4 was
allocated again, which made segbuf2 and next segbuf3 had same segment 4.

sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
added to both buffer lists of two segbuf. It makes the lists broken
which causes NULL pointer dereference.

Fix the problem by setting usage as dirty every time in
nilfs_sufile_mark_dirty(), which is called during constructing current
segment to be written out and before allocating next segment.

Also add lock in it to protect the usage modification.


If it looks good, I'll sent the v3 patch for it.

Best,
Chen
> Regards,
> Ryusuke Konishi
>
>> Could you please have a check? Thanks!
>>
>> Best,
>> Chen
>>> Originally, the assumption was that the current and next segments
>>> pointed to by log headers had been made dirty, and in fact mkfs.nilfs2
>>> and nilfs2 itself had created metadata that way, so it wasn't really a
>>> problem.  Usually the segment usage that this patch tries to dirty is
>>> already marked dirty and usually results in duplicate processing.
>>> nilfs_sufile_mark_dirty() is really only supposed to dirty that buffer
>>> and inode, and this patch changes the role.
>>>
>>> However, that assumption was incomplete in the sense that it does not
>>> assume broken metadata (whether intentionally or as a result of
>>> device/media failure), and lacked checks or protection from it.  In
>>> the meantime, you showed the simple and safe workaround even though it
>>> duplicates in almost all cases and even changes the semantics of the
>>> function.
>>> In terms of the stability and safety, your patch is good that we can
>>> ignore the inefficiency, so I am pushing for this change.
>>>
>>> Thanks,
>>> Ryusuke Konishi
>>>
>>>> This will cause the problem reported by syzkaller:
>>>> https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24
>>>>
>>>> It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
>>>> nilfs_sufile_alloc() not called to allocate a new segment.
>>>>
>>>> The first time nilfs_segctor_extend_segments() allocated segment
>>>> segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
>>>> nextnextnum = 4 segment because its su is not set dirty.
>>>> So segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.
>>>>
>>>> sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
>>>> added to both buffer lists of two segbuf.
>>>> It makes the list head of second list linked to the first one. When
>>>> iterating the first one, it will access and deref the head of second,
>>>> which causes NULL pointer dereference.
>>>>
>>>> Fix this by setting usage as dirty in nilfs_sufile_mark_dirty(),
>>>> and add lock in it to protect the usage modification.
>>>>
>>>> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
>>>> Cc: stable@vger.kernel.org
>>>> Reported-by: syzbot+77e4f005cb899d4268d1@syzkaller.appspotmail.com
>>>> Reported-by: Liu Shixin <liushixin2@huawei.com>
>>>> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
>>>> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>>>> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>>>> ---
>>>> v1 -> v2:
>>>> 1) Add lock protection as Ryusuke suggested and slightly fix commit
>>>> message.
>>>> 2) Fix and add tags.
>>>> ---
>>>>    fs/nilfs2/sufile.c | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
>>>> index 77ff8e95421f..dc359b56fdfa 100644
>>>> --- a/fs/nilfs2/sufile.c
>>>> +++ b/fs/nilfs2/sufile.c
>>>> @@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
>>>>    int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
>>>>    {
>>>>           struct buffer_head *bh;
>>>> +       void *kaddr;
>>>> +       struct nilfs_segment_usage *su;
>>>>           int ret;
>>>>
>>>> +       down_write(&NILFS_MDT(sufile)->mi_sem);
>>>>           ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
>>>>           if (!ret) {
>>>>                   mark_buffer_dirty(bh);
>>>>                   nilfs_mdt_mark_dirty(sufile);
>>>> +               kaddr = kmap_atomic(bh->b_page);
>>>> +               su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
>>>> +               nilfs_segment_usage_set_dirty(su);
>>>> +               kunmap_atomic(kaddr);
>>>>                   brelse(bh);
>>>>           }
>>>> +       up_write(&NILFS_MDT(sufile)->mi_sem);
>>>>           return ret;
>>>>    }
>>>>
>>>> --
>>>> 2.17.1
>>>>
