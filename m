Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD09558D3C
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 04:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiFXCdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 22:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiFXCdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 22:33:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BCB5000D;
        Thu, 23 Jun 2022 19:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72066B825F6;
        Fri, 24 Jun 2022 02:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4C3C385A2;
        Fri, 24 Jun 2022 02:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656038010;
        bh=a4iNX4jJ+gnqj1zIP5Wj5jnZb07NsrcpoyCEobpZ5Yo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=QfGE9onBynAV5WJCdKW0ZlWgQ80YMC52LULQ97xE//WWZo6QwcmuJqlkH4tEuTc3M
         nsom2WtlMWAC/HeruQEgj/mPiVNpRzy3j47ZGbj4YsHROf4iPsefb8eFOVgJBGvXAN
         h+LTRBYRPcbR/g4J4ertVwXtmcrqpxsnGj811zg00Hjw/+GnfoCkvhAbEZmwRHhyKx
         6iL1wm75mi0PBIipCwsZY6N/2NEFNL7APn/Ni5MZSg3iyBd7PHXho0UTNTc9vwanFK
         dz5N9yLow9VNSqhpYoog9UHX5P//5jPEe327D/gl3ApN3+5/5lXH8Easc1xJgsrzEq
         khPYJ9cP65xXg==
Received: by mail-qv1-f54.google.com with SMTP id cu16so2776950qvb.7;
        Thu, 23 Jun 2022 19:33:30 -0700 (PDT)
X-Gm-Message-State: AJIora+XIlYnuOa49SwcEBBHGj7GJwSMZ329/4UIG2NdLOnAwvyilrBG
        xWjx1b3k0LeI8MvQfRawLz9vQCvJe5KPGm+UtYc=
X-Google-Smtp-Source: AGRyM1uFq4naYNdLJNqLP+TvQkfc5iyrf/CltRak4zEUTFYg/Sq8LP4x3FXpp3cKVwH24M/PCK+tvgAW529tJ0DGf5E=
X-Received: by 2002:ad4:5dc5:0:b0:470:93c8:e908 with SMTP id
 m5-20020ad45dc5000000b0047093c8e908mr1548301qvh.115.1656038009063; Thu, 23
 Jun 2022 19:33:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:2a86:0:0:0:0 with HTTP; Thu, 23 Jun 2022 19:33:28
 -0700 (PDT)
In-Reply-To: <YrSeAGmk4GZndtdn@sol.localdomain>
References: <20220623033635.973929-1-xu.xin16@zte.com.cn> <20220623094956.977053-1-xu.xin16@zte.com.cn>
 <YrSeAGmk4GZndtdn@sol.localdomain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Jun 2022 11:33:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qoLKbWGX7omYUfarSugRnose8X8o3Zhb1XctiUtamQg@mail.gmail.com>
Message-ID: <CAKYAXd8qoLKbWGX7omYUfarSugRnose8X8o3Zhb1XctiUtamQg@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ntfs: fix BUG_ON of ntfs_read_block()
To:     Eric Biggers <ebiggers@kernel.org>, xu.xin16@zte.com.cn
Cc:     cgel.zte@gmail.com, anton@tuxera.com,
        linux-ntfs-dev@lists.sourceforge.net, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>,
        syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com,
        Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-06-24 2:08 GMT+09:00, Eric Biggers <ebiggers@kernel.org>:
> On Thu, Jun 23, 2022 at 09:49:56AM +0000, cgel.zte@gmail.com wrote:
>> From: xu xin <xu.xin16@zte.com.cn>
>>
>> As the bug description at
>> https://lore.kernel.org/lkml/20220623033635.973929-1-xu.xin16@zte.com.cn/
>> attckers can use this bug to crash the system.
>>
>> So to avoid panic, remove the BUG_ON, and use ntfs_warning to output a
>> warning to the syslog and return instead until someone really solve
>> the problem.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
>> Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
>> Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
>> Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
>> Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>> ---
>>
>> Change for v2:
>>  - Use ntfs_warning instead of WARN().
>>  - Add the tag Cc: stable@vger.kernel.org.
>> ---
>>  fs/ntfs/aops.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
>> index 5f4fb6ca6f2e..84d68efb4ace 100644
>> --- a/fs/ntfs/aops.c
>> +++ b/fs/ntfs/aops.c
>> @@ -183,7 +183,12 @@ static int ntfs_read_block(struct page *page)
>>  	vol = ni->vol;
>>
>>  	/* $MFT/$DATA must have its complete runlist in memory at all times. */
>> -	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
>> +	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
>> +		ntfs_warning(vi->i_sb, "Error because ni->runlist.rl, ni->mft_no, "
>> +				"and NInoAttr(ni) is null.");
>> +		unlock_page(page);
>> +		return -EINVAL;
>> +	}
>
> A better warning message that doesn't rely on implementation details
> (struct
> field and macro names) would be "Runlist of $MFT/$DATA is not cached".
> Also,
> why does this situation happen in the first place?  Is there a way to
> prevent
> this situation in the first place?

ntfs_mapping_pairs_decompress() should return error pointer instead of NULL.
Callers is checking error value using IS_ERR(). and the mapping pairs
array of @MFT entry is empty, I think it's corrupted, it should cause
mount failure.

I haven't checked if this patch fix the problem. Xu, Can you check it ?

diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index 97932fb5179c..31263fe0772f 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -766,8 +766,11 @@ runlist_element
*ntfs_mapping_pairs_decompress(const ntfs_volume *vol,
                return ERR_PTR(-EIO);
        }
        /* If the mapping pairs array is valid but empty, nothing to do. */
-       if (!vcn && !*buf)
+       if (!vcn && !*buf) {
+               if (!old_rl)
+                       return ERR_PTR(-EIO);
                return old_rl;
+       }
        /* Current position in runlist array. */
        rlpos = 0;
        /* Allocate first page and set current runlist size to one page. */

>
> - Eric
>
