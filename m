Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5992B48394E
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 00:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiACXwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 18:52:47 -0500
Received: from mout.gmx.net ([212.227.15.15]:48517 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbiACXwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jan 2022 18:52:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641253963;
        bh=d6KlGJncg2e4/DkfXIDnBvkDgK2Fao5F+NMagXJ6bn8=;
        h=X-UI-Sender-Class:Date:To:References:From:Subject:In-Reply-To;
        b=bt2y4xRFDP/yWfBwFJe/XQGS7flNTGzgR677h2vheSIflH0NjCJkyrhcoCk64Jo3o
         RdwI/d/S7DSuXDE1rI3RgLjEJTmnzsDXzpfhi9u6/FZqMtYcLBwHcAJXwtdoc4csTt
         xBY7vCj0cmTyEVYAYBhgaSe55skB6C8V6Oc7t4V0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mo6qv-1mb1HN45aF-00pa8G; Tue, 04
 Jan 2022 00:52:43 +0100
Message-ID: <4f1857d7-3788-6d0e-96a1-23a9a3ec61e9@gmx.com>
Date:   Tue, 4 Jan 2022 07:52:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20211216114736.69757-1-wqu@suse.com>
 <20211216114736.69757-2-wqu@suse.com> <20220103185237.GQ28560@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: don't start transaction for scrub if the fs is
 mounted read-only
In-Reply-To: <20220103185237.GQ28560@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:prK4FaiTbwRDvhqpYW/Nr4bbfyMqIHye3gFXZ8pL7t2XZ0wXBl+
 zvGvGbGPoksR3/x9PfIS7gGY4GnEFpZecRhMtrHKGEBOOo2ZQWKc7Ny0/LsuSTXO25mUnkK
 9x0MvzdhU6sae3wEoHTfHquzncp/UhGpIM02NlTHwLhJ2NN91ak3Qot60W7e4QCG2HmkSOW
 JTv60Sk6A4dW/TcCO7GrA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:s/Q2/ePLEBo=:1rT4SmcaBTfaKw/HEAzSfx
 0mnxZl1BFLlALmE180n277dIPwwoSLnSn+dIPI9AP/oRKuSBzEa11T3+UTcik4omlYmWCMfqT
 F/FRn/1g6LEPjYff3bb+XugNUpOq6xBDLg/lfUeAZpQqSP46mbP7hAKvZfBQqGVAKdEW8j0f/
 wJo4KYVHJgd9+oWpYIFOoNODKhy+6H1zyob5mFs51mMLtziUgidFLJpZ9rj+0Ul2CAhyC7xno
 ZRyyWN5GqKUoloL+xmS99eXIOYdvCUud7Qq1nNrTX+2nnREWs6k8e3RUksVbcGHPSYvu92WT/
 XwtCj8jpNbs/3GOxlyBUJriKbdOYIpXMMmR76xsT5ARgtijgkMI/4T3qyTMY17DnzCFy26Eo8
 Z9niMEj1E5TGXw6O1SqI7NfGd/cyWRt64kJFKlh5+M8Y3TnP2/9d/+oj0JZtwehABNubN5qBJ
 TFA4I+ZqG9oA0xbs2nqz+L0+xOYipPhIB3QRxueDpQQzozzEbESTzLZu4RkqR7uxkuQYG7GyH
 4QJ7Lwfpbm9y/LMDIWMv71BwCW5xZxlt0w9IkVwIzQ3Irhs5NtjQqElCM84lcHFcgvM0mTQvK
 U+3QSQ3tHv74XqkI1hGZ4ORSZOqxd2sEnIeSp3k+l0TmkbEtBuNvFq9XMS2IDc7H1bOe942PB
 QPmNELQEPeg8hj7PRbkwSZ0PQ/CP4W7njItMukHLnzGyCLST9LCQG9sxOnZEou+X3FsNgduHL
 QVA4/UISYQdOD8os6CCynL21I0RsFcNG2aRXdbBmvTTu0IE1s888TGHBPo8z4iTLiceKDdYVK
 kfNzKDa5MJuJ//oovCkvGBBaTaMOiu11apx/jJ6IfKc56ucdMTJYY2iKOvS4wHPHsZVn40dRD
 LaT+LSTGMZA1AQvuBgAWdt+rVSkR+ZyKzjj4hET9OiafYSGWfjqdjJwa694qBetHhHNnl3MD5
 f74bxAtB7SwAcSe7NRgD+ZSclgw9X98FXOh6OX/n1eZz26IAyHSqExoty2fDrwVtuy3230646
 V1Q+zoFqTJb8b/g0rEas+0vYVu5CHRkMBVBiOIv1mtx7nxTUOlB8sPn8NQkuc4y7Y1M0yDDH+
 +niNNdvotmJIWQ=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/1/4 02:52, David Sterba wrote:
> On Thu, Dec 16, 2021 at 07:47:35PM +0800, Qu Wenruo wrote:
>> [BUG]
>> The following super simple script would crash btrfs at unmount time, if
>> CONFIG_BTRFS_ASSERT() is set.
>>
>>   mkfs.btrfs -f $dev
>>   mount $dev $mnt
>>   xfs_io -f -c "pwrite 0 4k" $mnt/file
>>   umount $mnt
>>   mount -r ro $dev $mnt
>>   btrfs scrub start -Br $mnt
>>   umount $mnt
>>
>> This will trigger the following ASSERT() introduced by commit
>> 0a31daa4b602 ("btrfs: add assertion for empty list of transactions at
>> late stage of umount").
>>
>> That patch is deifnitely not the cause, it just makes enough noise for
>> us developer.
>>
>> [CAUSE]
>> We will start transaction for the following call chain during scrub:
>>
>>    scrub_enumerate_chunks()
>>    |- btrfs_inc_block_group_ro()
>>       |- btrfs_join_transaction()
>>
>> However for RO mount, there is no running transaction at all, thus
>> btrfs_join_transaction() will start a new transaction.
>>
>> Furthermore, since it's read-only mount, btrfs_sync_fs() will not call
>> btrfs_commit_super() to commit the new but empty transaction.
>>
>> And lead to the ASSERT() being triggered.
>>
>> The bug should be there for a long time. Only the new ASSERT() makes it
>> noisy enough to be noticed.
>>
>> [FIX]
>> For read-only scrub on read-only mount, there is no need to start a
>> transaction nor to allocate new chunks in btrfs_inc_block_group_ro().
>>
>> Just do extra read-only mount check in btrfs_inc_block_group_ro(), and
>> if it's read-only, skip all chunk allocation and go inc_block_group_ro(=
)
>> directly.
>>
>> Since we're here, also add extra debug message at unmount for
>> btrfs_fs_info::trans_list.
>> Sometimes just knowing that there is no dirty metadata bytes for a
>> uncommitted transaction can tell us a lot of things.
>>
>> Cc: stable@vger.kernel.org # 5.4+
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/block-group.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
>> index 1db24e6d6d90..702219361b12 100644
>> --- a/fs/btrfs/block-group.c
>> +++ b/fs/btrfs/block-group.c
>> @@ -2544,6 +2544,19 @@ int btrfs_inc_block_group_ro(struct btrfs_block_=
group *cache,
>>   	int ret;
>>   	bool dirty_bg_running;
>>
>> +	/*
>> +	 * This can only happen when we are doing read-only scrub on read-onl=
y
>> +	 * mount.
>> +	 * In that case we should not start a new transaction on read-only fs=
.
>> +	 * Thus here we skip all chunk allocation.
>> +	 */
>> +	if (sb_rdonly(fs_info->sb)) {
>
> Should this also verify or at least assert that do_chunk_alloc is not
> set? The scrub code is used for replace that can set the parameter to
> true.

Replace start needs RW mount, thus we don't need to bother replace in
this case.

>
>> +		mutex_lock(&fs_info->ro_block_group_mutex);
>> +		ret =3D inc_block_group_ro(cache, 0);
>> +		mutex_unlock(&fs_info->ro_block_group_mutex);
>> +		return ret;
>
> So this is taking a shortcut and skips a few things done in the function
> that use the transaction. I'm not sure how safe this is, it depends on
> the read-only status of superblock, that can chage any time, so what are
> further calls to btrfs_inc_block_group_ro going to do regaring the
> transaction?

By anytime you mean "remount". Thus if that's your concern, I can make
remount to stop read-only scrub, just to be extra safe.

Another thing is, only scrub and balance uses this function, for balance
it needs RW.

For scrub, if one scrub is already running, even it's RO and then the fs
mounted RW, then the next scrub run will return -EINPROGRESS or similar
error.

Thus I don't think we need to bother too much about this.

Thanks,
Qu

>
>> +	}
>> +
>>   	do {
>>   		trans =3D btrfs_join_transaction(root);
>>   		if (IS_ERR(trans))
>> --
>> 2.34.1
