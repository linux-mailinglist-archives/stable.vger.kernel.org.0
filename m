Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC60C484A83
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 23:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbiADWNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 17:13:20 -0500
Received: from mout.gmx.net ([212.227.17.22]:53807 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235325AbiADWNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 17:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641334394;
        bh=fpvxyYibSdfw4s9eoY6OLTgOUY4RVuKo1WmbyYVMans=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=SkfbkDZMiYrZd24sMjhmYsR862cX7Nhvq0bAIcWN6PL1DW9bGjfjmIs/s+X07GRxG
         qRYnlPMXgBi1vAqSUZ+I0DqxDQZJ68KGm4sdjp3M3O26SGv/zgq9zOETOQLYdtEMaf
         EQYVeerxow/eELRJjTfipgmVDihRKWfOYKwZjIcI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N3KTy-1mNFXv0Q66-010KDV; Tue, 04
 Jan 2022 23:13:13 +0100
Message-ID: <0a9a1a2c-7052-cb80-a87d-5f1ef6f8802c@gmx.com>
Date:   Wed, 5 Jan 2022 06:13:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 1/2] btrfs: don't start transaction for scrub if the fs is
 mounted read-only
Content-Language: en-US
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20211216114736.69757-1-wqu@suse.com>
 <20211216114736.69757-2-wqu@suse.com> <20220103185237.GQ28560@twin.jikos.cz>
 <4f1857d7-3788-6d0e-96a1-23a9a3ec61e9@gmx.com>
 <20220104184044.GV28560@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220104184044.GV28560@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nURearjOL1JfoDO/TzB/iG05rzy+9UkJ7Bn7JOW8UkUEUMrVGyu
 rbmsasEYmrfFo+x4eDkuTVnXXrdJxLHP9OQcox+Zt7OQ3Oi3u0ZFcXWif3jvfMNLrqXasdh
 +jJeMy82NIlXONDFUe5a3Iy+oXfAilJb9n/60MIseenIfCrso9fM3NvZFlbM3K9dk0GASP4
 x3ayrjbOu64hTS3ooBn5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QDaMLvVU+Nc=:T80KUMWj+hULiKzeRW6CIH
 4es1W/xwQytzQXqe6QCK0G0FRSYeYoA3OlSGEQLmyKkMvMo1nekvnGwmYWpJUuKbpei4p/J0Y
 HXwJy9aVtIv6T5CuehUp7y0g9W2iFwAdiDKkGJSFTZqj0u2r3FGNjS5XgKJHlvYv7rvbiJoog
 NOz7q14zECpqiNRTMTq27FOgcWxWW7O42F7TtcfFf+iD2elrj8OHScazhUTC/QJy9paKEOw9c
 3NW+j1TlAornXEMQ+pJM+qreWU+oIULgkvBCbUPSy1QT/uQTlD+/E8sdO/CW/bmd13KAEInDq
 OdFlpQ6T1bNorQOwP9Evr9T6WO53lEugZqG3Aj/0ShX7k/hv09+fNq2SmwjHF2ZFGhgy8KmY2
 L0peASbQD/+mIdNsTq8Xxjer+GWF1Gj2M1PAofC6bUQJeYTnGYqRoJX0WTSpZKfAtUGjByayV
 wdeod+fAbQ2GEZwx8qh8+LpF4OhLUSFkQWvDYXYyXxewM0kxQjZ57Fv06DTC+Csx7JnBnpqom
 9cKFHye1f4bXa13lm18W8rB9OJbw1/TH2lt6Yg2VJgIbIjCLy36AhedNCsR2a+fAlhXr9zgX6
 I1148+YIAXRW8DpJBW2jtsZr9ZOKL9Dic3Wxysx6fw3XXQP3RfgF0n8QT1tiiZF4saZNetNw/
 Sie5OL2Edp/YY3VO82lz53rFM/uVgJVWRyOPd88ZdSHcwwjVR8QrnhUYuulA+KytbPvvU+Pv1
 CYXxWEKUssfcc5BhDt0E4OmiyIbnFcHWnCuLZdjrvquBOWmggNORnHHwFPP6aoBxusnJ1IM2X
 RiZb/xBpL3I204olNW/aE2kmhoFXrzxyWPafFLJMkK8Qw57sv5wkRCzTAcfTSUBiuAFF1ccKS
 MPzIScKNHB6/i2FbATZiUbucYhZsq10hAR1p5j1Ot8+jzSvN0RThqR/9Gt5Q+lYet4NCZa1Iq
 PmtzvIB6KroOnmEwCPtZQfNMYEiw7+rbf0lLyPQo+SB/YcwMcbEY65E9JwvJ4I02eunvPfKfx
 hi2+cuDPHXfUAW7oLcCZS+EaaCvaeFJKHMX4z94ijuGfgBQstMn1EQBq9U5AhWgbXajRSj/6K
 V+c+nV+fQrFs7Q=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/1/5 02:40, David Sterba wrote:
> On Tue, Jan 04, 2022 at 07:52:39AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/1/4 02:52, David Sterba wrote:
>>> On Thu, Dec 16, 2021 at 07:47:35PM +0800, Qu Wenruo wrote:
>>>> [BUG]
>>>> The following super simple script would crash btrfs at unmount time, =
if
>>>> CONFIG_BTRFS_ASSERT() is set.
>>>>
>>>>    mkfs.btrfs -f $dev
>>>>    mount $dev $mnt
>>>>    xfs_io -f -c "pwrite 0 4k" $mnt/file
>>>>    umount $mnt
>>>>    mount -r ro $dev $mnt
>>>>    btrfs scrub start -Br $mnt
>>>>    umount $mnt
>>>>
>>>> This will trigger the following ASSERT() introduced by commit
>>>> 0a31daa4b602 ("btrfs: add assertion for empty list of transactions at
>>>> late stage of umount").
>>>>
>>>> That patch is deifnitely not the cause, it just makes enough noise fo=
r
>>>> us developer.
>>>>
>>>> [CAUSE]
>>>> We will start transaction for the following call chain during scrub:
>>>>
>>>>     scrub_enumerate_chunks()
>>>>     |- btrfs_inc_block_group_ro()
>>>>        |- btrfs_join_transaction()
>>>>
>>>> However for RO mount, there is no running transaction at all, thus
>>>> btrfs_join_transaction() will start a new transaction.
>>>>
>>>> Furthermore, since it's read-only mount, btrfs_sync_fs() will not cal=
l
>>>> btrfs_commit_super() to commit the new but empty transaction.
>>>>
>>>> And lead to the ASSERT() being triggered.
>>>>
>>>> The bug should be there for a long time. Only the new ASSERT() makes =
it
>>>> noisy enough to be noticed.
>>>>
>>>> [FIX]
>>>> For read-only scrub on read-only mount, there is no need to start a
>>>> transaction nor to allocate new chunks in btrfs_inc_block_group_ro().
>>>>
>>>> Just do extra read-only mount check in btrfs_inc_block_group_ro(), an=
d
>>>> if it's read-only, skip all chunk allocation and go inc_block_group_r=
o()
>>>> directly.
>>>>
>>>> Since we're here, also add extra debug message at unmount for
>>>> btrfs_fs_info::trans_list.
>>>> Sometimes just knowing that there is no dirty metadata bytes for a
>>>> uncommitted transaction can tell us a lot of things.
>>>>
>>>> Cc: stable@vger.kernel.org # 5.4+
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>    fs/btrfs/block-group.c | 13 +++++++++++++
>>>>    1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
>>>> index 1db24e6d6d90..702219361b12 100644
>>>> --- a/fs/btrfs/block-group.c
>>>> +++ b/fs/btrfs/block-group.c
>>>> @@ -2544,6 +2544,19 @@ int btrfs_inc_block_group_ro(struct btrfs_bloc=
k_group *cache,
>>>>    	int ret;
>>>>    	bool dirty_bg_running;
>>>>
>>>> +	/*
>>>> +	 * This can only happen when we are doing read-only scrub on read-o=
nly
>>>> +	 * mount.
>>>> +	 * In that case we should not start a new transaction on read-only =
fs.
>>>> +	 * Thus here we skip all chunk allocation.
>>>> +	 */
>>>> +	if (sb_rdonly(fs_info->sb)) {
>>>
>>> Should this also verify or at least assert that do_chunk_alloc is not
>>> set? The scrub code is used for replace that can set the parameter to
>>> true.
>>
>> Replace start needs RW mount, thus we don't need to bother replace in
>> this case.
>
> What if replace starts on rw mount, and then it's flipped to read-only?
> I don't see how this is prevented (like by mnt_want_write). It should
> not cause any problems either, as it would not start the transaction.

For this case, there are 2 entrances:

- Remount RO
   We will stop replace in that case

- Some fs error (like trans abort)
   I believe we should fail at any transaction start.

Thanks,
Qu
>
>>>> +		mutex_lock(&fs_info->ro_block_group_mutex);
>>>> +		ret =3D inc_block_group_ro(cache, 0);
>>>> +		mutex_unlock(&fs_info->ro_block_group_mutex);
>>>> +		return ret;
>>>
>>> So this is taking a shortcut and skips a few things done in the functi=
on
>>> that use the transaction. I'm not sure how safe this is, it depends on
>>> the read-only status of superblock, that can chage any time, so what a=
re
>>> further calls to btrfs_inc_block_group_ro going to do regaring the
>>> transaction?
>>
>> By anytime you mean "remount". Thus if that's your concern, I can make
>> remount to stop read-only scrub, just to be extra safe.
>
> If scrub is running in the read-only mode then it's fine, the corner
> cases I'm interested in are some mixture of read-write/read-only on the
> filesystem and scrub and when they get out of sync.
>
>> Another thing is, only scrub and balance uses this function, for balanc=
e
>> it needs RW.
>>
>> For scrub, if one scrub is already running, even it's RO and then the f=
s
>> mounted RW, then the next scrub run will return -EINPROGRESS or similar
>> error.
>>
>> Thus I don't think we need to bother too much about this.
>
> It's not about another scrub running, that won't work, but what if
> scrub is started, and then at some point the filesystem gets remounted
> read-only. Both can be done without any notification by any system tool
> or service. So ther's no problematic case, then ok, I'm probably not
> understanding it completely yet so I'm asking. If it works by accident
> or there's a corner case left I'd rather find it now.
