Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1253FB19
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbiFGKXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiFGKXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:23:47 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF4D59B85;
        Tue,  7 Jun 2022 03:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654597420;
        bh=vuv1CePQ0YJ86gUFoANkWhXm04M0cPlY5qdt9MXkKoo=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=N/MIdNBfidqzQLz4VwnpVoVNN9hPsZzQodo6AV6LciXGafDVZ2s1xZJeWR6vHiErv
         1wAj4VP7tCWP4ktSZKOxdxKxae7EhGt1emeT/WcxPoo8xLWW9M4Tqu6kAXVF0LSXok
         gdTSruzGmOL+N3qcY2V+giTsDBQQDg2k9qWvUz0M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MWASe-1oHpOz1AHy-00XZGv; Tue, 07
 Jun 2022 12:23:39 +0200
Message-ID: <8dbd2e3f-eb4d-836d-dba1-45b82dab64c4@gmx.com>
Date:   Tue, 7 Jun 2022 18:23:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] btrfs: reject log replay if there is unsupported RO flag
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <429396b1039ec416504bc2bffca36d66ec8b52e2.1654569076.git.wqu@suse.com>
 <20220607094914.GC3554947@falcondesktop>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220607094914.GC3554947@falcondesktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wiKPzrzmyrF5A+f6M/9JnM1jNuSeec38jUQhktROiBns/ODmluf
 LdclDLoUBZoAjkku7HFcZ0RUHx/yc+7oZSyvbBg/8ojyJ5X6BGHKi1ttKa7UnYTXqSEaNKS
 T2tMl32gymQZ8WnioigY0IzqQiJEmb2kCm1Y8L6nUzUWQM3XaUFlWeSG6rsOoRdDJLibXuo
 9mrnGDqo5RF/Q6azDQfpQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:EICKrD/E3j0=:GgGHUEo9j2y/14507B4Nrs
 dz3R7pQS+ZJDI/mTd9pT+KqRZMxzpTQaDi8ld2sSZqeVl/zFSXLSk160rkxVGrUMR3wzgw5S7
 2OgjSA0rKhHrLbOgAJgCsYqa1ANVgfS14IkGNqwmEvkm6Bt5acUzMmTcFMmZjE9Z4wqcou2yr
 iQWUcY7QIwmGTtue/U0rUyLhIhZJLXPzW7l2mJsybHXA91gWLopS6l6kMGazLqZSKzfiYcWzF
 4trQVbpZHRjLcBe6hZbOX3igMZ8QnKhwxHhEl5dLc9Z6Dwk89RNyoHaEQ3i4+X0+zo/yQMMGB
 ust90Gp41iCAonS9EyCVMv6h4gn2vNZCAydONHGHkgcBGOWNNAflxPUaz76V9N1fonsL803wb
 nrvpTBjGVkWohBrb6POv2C1UaXSo5GfOIOJHXobjpo6b99utrg5WBdI8/PC0qYS+v5FWYnLwn
 jC2uVi/I9g9lGcRwXvp6m9GH4fyIAOQ+JrXCbstd02HxACyzFNP7OUSr9Q3UeRa/Kgi+Pr2Z2
 qzhA8hblyZHh30gbd2YaQy/NWWtYtIM6N+6lJ4fR2b5oHBcebCtHTRTHqAyItLJrkXQ2VGoqj
 1Ld8BL7IQPIN1rW+BXD3ObEpak4HZQD5CFNTXdjGOF3nWM1H0e7HROQxlZtQ7Itamkmaes0I+
 x8F5OTlgVynM4FXRkBiWQpgo1MnwM/JwBMJgJKbwjG7YNIju2qTDGRIBhD4/kMV3wZy0nRs9p
 dMmhl6R+iWz43YL8dkogefcYPIk4kI03J+JdkxvwEra1NBtNmnO7lPPkEV/tz2puxuZChJVgN
 IU1P5Dlmbhh4nHdNw7EulM7wpAJf3evoyFxY9+fdNIQc6ZxUEurKOo5UPUIJ/pfr5pPIqN594
 z01v9R8FZbpOJ4XLFWGs4fLCJIxkLLryI2pKlIeBV3MD1zsKVd5emYUltSTFvScHyeAYJxi/Y
 ihmbVPCANeKIHAcp2zbwqvCBONyTPEvRFSXX5xi8nbEoZJAXhFvijpsrfnv6OtsmbuguTxhNE
 RCvp5tSy5/nHigEFpxHsIZA4B9Qo/VR2C+BWmRyuwxY6xyc+5ykV2EQD+S2b0VpVYoi4s/9/n
 ybUGK7+AdQxvT4RZMDZxfclk1V/T9Zs/4DbZk31tF2BWoiNuNEEwNEIEw==
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/6/7 17:49, Filipe Manana wrote:
> On Tue, Jun 07, 2022 at 10:31:46AM +0800, Qu Wenruo wrote:
>> [BUG]
>> If we have a btrfs image with dirty log, along with an unsupported RO
>> compatible flag:
>>
>> log_root		30474240
>> ...
>> compat_flags		0x0
>> compat_ro_flags		0x40000003
>> 			( FREE_SPACE_TREE |
>> 			  FREE_SPACE_TREE_VALID |
>> 			  unknown flag: 0x40000000 )
>>
>> Then even if we can only mount it RO, we will still cause metadata
>> update for log replay:
>>
>>   BTRFS info (device dm-1): flagging fs with big metadata feature
>>   BTRFS info (device dm-1): using free space tree
>>   BTRFS info (device dm-1): has skinny extents
>>   BTRFS info (device dm-1): start tree-log replay
>>
>> This is definitely against RO compact flag requirement.
>>
>> [CAUSE]
>> RO compact flag only forces us to do RO mount, but we will still do log
>> replay for plain RO mount.
>>
>> Thus this will result us to do log replay and update metadata.
>>
>> This can be very problematic for new RO compat flag, for example older
>> kernel can not understand v2 cache, and if we allow metadata update on
>> RO mount and invalidate/corrupt v2 cache.
>>
>> [FIX]
>> Just set the nologreplay flag if there is any unsupported RO compact
>> flag.
>>
>> This will reject log replay no matter if we have dirty log or not, with
>> the following message:
>>
>>   BTRFS info (device dm-1): disabling log replay due to unsupported ro =
compat features
>>
>> Cc: stable@vger.kernel.org #4.9+
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/disk-io.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index fe309db9f5ff..d06f1a176b5b 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3655,6 +3655,14 @@ int __cold open_ctree(struct super_block *sb, st=
ruct btrfs_fs_devices *fs_device
>>   		err =3D -EINVAL;
>>   		goto fail_alloc;
>>   	}
>> +	/*
>> +	 * We have unsupported RO compat features, although RO mounted, we
>> +	 * should any metadata write, including the log replay.
>> +	 * Or we can screw up whatever the new feature requires.
>> +	 */
>> +	if (features)
>> +		btrfs_set_and_info(fs_info, NOLOGREPLAY,
>> +		"disabling log replay due to unsupported ro compat features");
>
> Well, this might be surprising for users.
>
> On mount, it's expected that everything that was fsynced is available.
> Yes, there's a message printed informing the logs were not replayed,
> but this allows for applications to read stale data.
>
> I think just failing the mount and printing a message telling that the
> fs needs to be explicitly mounted with -o nologreplay is less prone to
> having stale data being read and used.

OK, I'm fine with either method, as long as we reject the log when there
is unsupported RO compat feature.

Thanks,
Qu

>
> Thanks.
>
>>
>>   	if (sectorsize < PAGE_SIZE) {
>>   		struct btrfs_subpage_info *subpage_info;
>> --
>> 2.36.1
>>
