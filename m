Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5429153FD38
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbiFGLRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbiFGLR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:17:29 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8EF6830C;
        Tue,  7 Jun 2022 04:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654600620;
        bh=EzjI/SzZhivYF0P4SXAXlJ8k5nYDwDTxNs/9flEB4OM=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=SA/W3UgG4Mw+8zxE88wy7ArEj7ZTBg301Yqw4XcvHEjJLFltszm9H49LcUOQZWQQ+
         2HLPIVh15O0i8B0OM2dMHDgxEVD7gwb8qdiT3WRJBFIRBjvb5u8g863rYbtj27W97a
         qP7nuF0rJhWfhfpPqYgbGrWXHNfPv7XJem0o6dg4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mr9Fs-1nSArC0BV8-00oHiM; Tue, 07
 Jun 2022 13:17:00 +0200
Message-ID: <12b47c70-965d-1679-6982-909e2b489b41@gmx.com>
Date:   Tue, 7 Jun 2022 19:16:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] btrfs: correctly populate
 btrfs_super_block::log_root_transid
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <f7ae86f509d11d941ceac2a153b38a4f3bc5d342.1654578537.git.wqu@suse.com>
 <20220607094055.GB3554947@falcondesktop>
 <532d5fd2-e93b-2fec-72d3-d0b0f099e541@gmx.com>
 <20220607104533.GA3559971@falcondesktop>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220607104533.GA3559971@falcondesktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vzJe7WwW6kxeWI7DGBEahxgLE/VqriJzER10SAAB3upypChBpVl
 W34raouxWrv3zamD2wKcyJF4ECG22VwT+QhjfybhwiMSR9d5LCy28bIIL2P9yp0keGkg7Tl
 c057CnaYlxfPQv3CJFct5chZwWcyIxVcwF4e4KrCe5yBaTVBSy+QE83P3KyLDDbN2VMHW6B
 h7wAQ76wk3OZQ2I5H9fgw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vCgFv2LojVo=:TnyWdsF3IKo6RSBe/CGpDu
 P2UruEQVE60TRasHjoplfviIq8LB4okZDzmkcoZNYKDawfN+X+R/HOahzIkQM45IoO/T5tILX
 SRHDjpYobg+fAjkDnuiQpSfMcnV+g5zuXwGq5Pqr+DKTP1lilY0SWPfrt92TfvCJVfqMAqDIA
 Bhryo96sJcMo5eUpl6ZQvqUbw1sor1ytqnogaMzIUeBFGh/OmiNE/Iis6A/WyzkUlVRnDbT+o
 qyOFS1CZP8rBNFQOX+mQXR9q6SPk17IEmFEC5P14u4oCvyKyyDO0HC/+o28mMWQyGZ7zQhe2e
 rJraAITva3ircu7FbRB1zQ/WLfklrAHWs0qr3zfBh24YMRot+pypnDDEVFBLWc+F4CIsU3jtw
 ZYNFaAb5nLt7VeWbLbbPukc5uz0ibapMMrRdvppnFHSoi+qM5Wzs9AlSeUy0QXfaDBDfJETWK
 1rXSoKK22t80GMinU7cFAB2Mrrc2MQ6SVrfhue043K7RGo43lnxXqcwWnoz7guz6Ld9f6DW4y
 LJaOmYkBIPUvOJmc29Mu3AbiKAXbWyPtXB+VV1jziYqpUazbRKMZ1Ajuu2gLV/tD1ln2Fvxyj
 GnuWqDtR856PhhtHd8fgbFHOLxfwE4c/Ya9UolFC0F4yJ2sI8KSTgkf0dGgG2j8oc99L7/vFQ
 x8DRUiyL8ZuBUlzuxxJsIM8qKDEUMuVNpBCEziqal83gioq9QDOYv25YvdMTztbyvoyGt9XfI
 0+q45CLxj1Wb2J8stCyBwMpYe8YAB9p1+yNmWd7bODSkRGiEt9etOM1RpEtbK+PWwyhQdIeuC
 CnNFHTryRsnzPgXMgk/vBSv0+iF+rJHkoqz1FeK7x24X4CAL159f1Xr8tSbHKvtDQMpdvfkrr
 HyAj4aX+dUn0LsPQLo7ivdFenZSqCKySsYtJ94jz/gSLr1MSUtT0s0E+ILug3Rtst+HUxL3r/
 KrJ0+P+SlfIRyNEjjAWVIRq88X/2EV3oGBdWY3A35bVLl/w7NnbuHIqwXZ3eU1khU2X67KGjJ
 GYmLd8waw0pZJXNVfOPnQR5TisjaAa9AxFGo1hBZMNjCdq/+sb4d4pllzyKAU/tNkAIyQIl9y
 zdNGFxFMfQL8ANE/dCEBtlCewCJHKHgIeyQ/F3w8SD2mq1Y0aWjLb6nFw==
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/6/7 18:45, Filipe Manana wrote:
> On Tue, Jun 07, 2022 at 06:30:03PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/6/7 17:40, Filipe Manana wrote:
>>> On Tue, Jun 07, 2022 at 01:09:13PM +0800, Qu Wenruo wrote:
>>>> [BUG]
>>>> After creating a dirty log tree, although
>>>> btrfs_super_block::log_root and log_root_level is correctly populated=
,
>>>> its generation is still left 0:
>>>>
>>>>    log_root                30474240
>>>>    log_root_transid        0 <<<
>>>>    log_root_level          0
>>>>
>>>> [CAUSE]
>>>> We just forgot to update btrfs_super_block::log_root_transid complete=
ly.
>>>>
>>>> Thus it's always the original value (0) from the initial super block.
>>>>
>>>> Thankfully this old behavior won't break log replay, as in
>>>> btrfs_read_tree(), parent generation 0 means we just skip the generat=
ion
>>>
>>> btrfs_read_tree() does not exists, it's btrfs_read_tree_root().
>>>
>>> This is actually irrelevant, because we don't read the root log tree w=
ith
>>> btrfs_read_tree_root(). We use read_tree_block() for that (at btrfs_re=
play_log()),
>>
>> Oh, right, I forgot to check that code, and just assumed every root rea=
d
>> from superblock would has its generation checked, but it's not the case
>> for log tree root.
>>
>>> and we use a generation matching the committed transaction + 1 (as it =
can never
>>> be anything else).
>>>
>>> For every other log tree, we use btrfs_read_tree_root(), but the gener=
ation is
>>> stored in the root's root item stored in the root log tree.
>>>
>>> The log_root_transid field was added to the super block by:
>>>
>>> commit c3027eb5523d6983f12628f3fe13d8a7576db701
>>> Author: Chris Mason <chris.mason@oracle.com>
>>> Date:   Mon Dec 8 16:40:21 2008 -0500
>>>
>>>       Btrfs: Add inode sequence number for NFS and reserved space in a=
 few structs
>>>
>>> But it was never used.
>>>
>>> So this change is not needed.
>>
>> Then, considering we have never really set log_root_transid anywhere,
>> and in theory we're always using btrfs_super_block::generation + 1, why
>
> It's not in theory only, it's in practice too.
> We use committed generation + 1 since the first day the log tree was add=
ed:
>
> commit e02119d5a7b4396c5a872582fddc8bd6d305a70a
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Fri Sep 5 16:13:11 2008 -0400
>
>      Btrfs: Add a write ahead tree log to optimize synchronous operation=
s
>
> (back then we read the root log tree directly at open_ctree()).
>
>> not just deprecate that member?
>>
>> In fact, every time (thankfully not that many times for me) I checked
>> log_root_transid, I can not help but to wonder why it's always 0.
>
> You'd have to ask Chris why he added the field if it was never used and,
> as far as I can see, was always useless since the life of a log tree
> has never spanned more than 1 transaction, its generation must necessari=
ly
> be "committed transaction generation + 1".
>
> Maybe just add a comment on top of the field saying it's unused and shou=
ld
> always be 0.
>
> It's technically part of the disk format, so it's probably better not be=
ing
> renamed to '__le64 unused;'.

OK, I'd follow the old leafsize way to rename it to __le64
__unused_log_root_transid.


I'm asking because some newer feature will going to add something very
similar to log tree (write-intent tree, just like the write-intent
bitmap from DM code, for RAID56 mount time scrub).

Initially I was not that confident about the extra tree root, tree
level, tree transid, extra write-intent generation.

But it looks like we're fine to contain at least 25 u64, so it should be
mostly fine, and no need to reuse old members like leafsize nor this
log_tree_transid.

Thanks,
Qu
>
> Thanks.
>
>>
>> Thanks,
>> Qu
>>
>>>
>>> Thanks.
>>>
>>>
>>>> check.
>>>>
>>>> And per-root log tree is still done properly using the root generatio=
n,
>>>> so here we really only missed the generation check for log tree root,
>>>> and even we fixed it, it should not cause any compatible problem.
>>>>
>>>> [FIX]
>>>> Just update btrfs_super_block::log_root_transid properly.
>>>
>>> We don't need this.
>>>
>>> The log_root_transid field was added to the super block by:
>>>
>>> commit c3027eb5523d6983f12628f3fe13d8a7576db701
>>> Author: Chris Mason <chris.mason@oracle.com>
>>> Date:   Mon Dec 8 16:40:21 2008 -0500
>>>
>>>       Btrfs: Add inode sequence number for NFS and reserved space in a=
 few structs
>>>
>>> But it was never used.
>>> For btrfs_read_tree_root(), what we use is the
>>>
>>>
>>>
>>>>
>>>> Cc: stable@vger.kernel.org #4.9+
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>    fs/btrfs/tree-log.c | 5 ++++-
>>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>>>> index 370388fadf96..27a76d6fef8c 100644
>>>> --- a/fs/btrfs/tree-log.c
>>>> +++ b/fs/btrfs/tree-log.c
>>>> @@ -3083,7 +3083,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *t=
rans,
>>>>    	struct btrfs_log_ctx root_log_ctx;
>>>>    	struct blk_plug plug;
>>>>    	u64 log_root_start;
>>>> -	u64 log_root_level;
>>>> +	u64 log_root_transid;
>>>> +	u8 log_root_level;
>>>>
>>>>    	mutex_lock(&root->log_mutex);
>>>>    	log_transid =3D ctx->log_transid;
>>>> @@ -3297,6 +3298,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *t=
rans,
>>>>
>>>>    	log_root_start =3D log_root_tree->node->start;
>>>>    	log_root_level =3D btrfs_header_level(log_root_tree->node);
>>>> +	log_root_transid =3D btrfs_header_generation(log_root_tree->node);
>>>>    	log_root_tree->log_transid++;
>>>>    	mutex_unlock(&log_root_tree->log_mutex);
>>>>
>>>> @@ -3334,6 +3336,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *t=
rans,
>>>>
>>>>    	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_star=
t);
>>>>    	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_roo=
t_level);
>>>> +	btrfs_set_super_log_root_transid(fs_info->super_for_commit, log_roo=
t_transid);
>>>>    	ret =3D write_all_supers(fs_info, 1);
>>>>    	mutex_unlock(&fs_info->tree_log_mutex);
>>>>    	if (ret) {
>>>> --
>>>> 2.36.1
>>>>
