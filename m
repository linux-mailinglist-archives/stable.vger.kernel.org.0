Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9194753FF6D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 14:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbiFGMv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 08:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiFGMv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 08:51:57 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EE01C136;
        Tue,  7 Jun 2022 05:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654606309;
        bh=HzFWcgIGisyh0z7VYE8goP/Uy202HPcAMHiudtxqK/g=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=d7vcCvRcE4UKXED7OzF/gBn6I155B6AooTlbFWacd+SVpQO/rTzJj+qRMPr4JA255
         Hj6ZmuPltUANgQF8TDM6yhcOCRNBoSZTNAHeaEYdkp/D87o/t/H7Xpf8TVfMG8vyrE
         vc5EtH8oRhu2Dn2c0ifGlAS6iGtURv1XTBqMQFqQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N9dsV-1nk6hF3UIv-015Wke; Tue, 07
 Jun 2022 14:51:49 +0200
Message-ID: <398607e9-5dab-8280-6ff1-73f2eaa5a701@gmx.com>
Date:   Tue, 7 Jun 2022 20:51:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] btrfs: reject log replay if there is unsupported RO
 flag
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <a6612cd9432b8ae6429cceee561c0259232cc554.1654602414.git.wqu@suse.com>
 <20220607123517.GB3568258@falcondesktop>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220607123517.GB3568258@falcondesktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lwjcWiSjhsVZY1AGP6Dzf0vLlFySeja0u6wLUTDG/23OLFPyRbE
 CqfnKYKlNxHCnRNjI7RK/G/fFEAx9msrl81aiJkY4HcAtfYU/OHCK3w9iz7hsGqCGRUvDjV
 ZBNGNbrwFsxYvsXXNIfIeUE0SWma7YCLPaWUCM+uuuqKSolfROTsczF5ySSvKEimdQI2ojn
 pFzgRI2fnPR07EkyPV+oA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y+IT6xnmO9k=:YYOIkCiZtpqBVds01m7/PS
 G78UlRZobhVwhzhBGIXJiKJ6Cc/lpPGjlESQ65s5S4YsYBHO8QxSykJev9y3go0pfVsg53i8l
 /TUGVrqAz0AA2udcyes/8JVB5+nnszon2am02Ti+ag6pxCweDznLi6WAS2DELHNXFGI3XFDPG
 JmenJK1CkezDbsCyb8uYJ0DVZ22N/NXeRW8z2WeMLPU2iCaI+iomnmtpLBqfEq4QdmnsqKBqM
 Kl5li2C8iuFw/Yic/s8w+gq4+pA7LgCJaEgxysKJjxlD9kH9ODq8Z63V3NRzbJ/Ra/Ave6jhw
 etTafAdCjq9a6y6W4cXhG9ZcM0EhcsV1J91hUQPBw8c/iOUB/iz9nHIWQsaiYuZ6HN/hwJpj5
 TFiz1bCVdHWxRTkYvRvAAHSalR0PfIP60mIUxFjbZcq5o0MPfIUxY3dKYumI2KVeUNq8SdzN6
 wc9tfrcOWcJ8dBt3IjQftcqUOLPeAvYhqbSpWxJV8WAU5MtZJxYwIRYuJfJLVcnlhW3UQ6izi
 tI0RLNd5xSZ4ybEdCj8cEiYamk3uzoRjIQ+bgrsPpm3O3dYFauhd67+NennvDxddbm0Y5WhvV
 z4Klh+RTM6Uki1Nr1FjGYKIvFiyNhIGjVfieS5AHaTevS0F9uNQv3zsFMI1qWaXNktPal2xmJ
 bEftEXsDSKNytGKWl4j+Gga8kigT7WShcGnxmui4FgJXcDnSoVvahi//uFVqwDQIhAqtTcjYy
 psFjf1kecF98N5pdmBs+BSoU5+2NHvixr5V4Oow0xKDd8kOgR1Tzops2jS6K5mjvRccZTla4A
 VoxkrXcyOzjM23AHNcbcWnfWOHb4S8zxVqOmfdx9bnRhYV2hIYCju5NL78KET6Qn6/NhjWJJl
 vjmH1HsbkklEqfueqiekGpW65Hqvf4cnqLynmKfuM6ODLwFz8kcMo/gtGcRImulhXi7eowV6R
 Z3akuDa1IJPDuoWkGlCH2tuZtmy8Q3Ud2Df0jOvn/uddOy0tqrvXe9NwR/HQubII15dFt+6am
 6ok026HtOuMyg3tJ1RGHoDXFKGIerWABEDVpzRnnkIXoT4HrK0mgxT6jWbOFnB60JiIFR1+7g
 J9BfSDZblvDoKdW69yqCZ10Bd2qSA5ZtrrtcaMJ600gfm7aiwGBvyexmQ==
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/6/7 20:35, Filipe Manana wrote:
> On Tue, Jun 07, 2022 at 07:48:24PM +0800, Qu Wenruo wrote:
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
>> Just reject the mount unless rescue=3Dnologreplay is provided:
>>
>>    BTRFS error (device dm-1): cannot replay dirty log with unsupport op=
tional features (0x40000000), try rescue=3Dnologreplay instead
>>
>> We don't want to set rescue=3Dnologreply directly, as this would make t=
he
>> end user to read the old data, and cause confusion.
>>
>> Since the such case is really rare, we're mostly fine to just reject th=
e
>> mount with an error message, which also includes the proper workaround.
>>
>> Cc: stable@vger.kernel.org #4.9+
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v2:
>> - Reject the mount instead of setting nologreplay
>>    To avoid the confusion which can return old data.
>>    Unfortunately I don't have a better to shrink the new error message
>>    into one 80-char line.
>> ---
>>   fs/btrfs/disk-io.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index fe309db9f5ff..f20bd8024334 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3655,6 +3655,20 @@ int __cold open_ctree(struct super_block *sb, st=
ruct btrfs_fs_devices *fs_device
>>   		err =3D -EINVAL;
>>   		goto fail_alloc;
>>   	}
>> +	/*
>> +	 * We have unsupported RO compat features, although RO mounted, we
>> +	 * should not cause any metadata write, including log replay.
>> +	 * Or we can screw up whatever the new feature requires.
>> +	 */
>> +	if (unlikely(features && btrfs_super_log_root(disk_super) &&
>> +		     !btrfs_test_opt(fs_info, NOLOGREPLAY))) {
>> +		btrfs_err(fs_info,
>> +"cannot replay dirty log with unsupport optional features (0x%llx), tr=
y rescue=3Dnologreplay instead",
>
> unsupport -> unsupported
>
> The "optional" sounds superfluous.
>
> You are CC'ing stable 4.9+, but IIRC the rescue=3D mount option is relat=
ively
> recent, so the message will need to be updated (4.9, at least, doesn't h=
ave it).

Yep, thus when this get merged, I'll manually backport the patch to
older kernels.

Thanks,
Qu
>
> Other than that it looks fine to me.
>
> It's clear that it's a problem with the free space tree, but with verity=
 (the only
> other RO compat feature), I'm not sure we need this constraint, and it m=
ay happen
> more often since verity support is recent, unlike the free space tree wh=
ich has
> been around for years.
>
> Thanks.
>
>> +			  features);
>> +		err =3D -EINVAL;
>> +		goto fail_alloc;
>> +	}
>> +
>>
>>   	if (sectorsize < PAGE_SIZE) {
>>   		struct btrfs_subpage_info *subpage_info;
>> --
>> 2.36.1
>>
