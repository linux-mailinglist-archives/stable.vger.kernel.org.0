Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3DB515A22
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 05:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbiD3Da1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 23:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiD3DaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 23:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753913D48C;
        Fri, 29 Apr 2022 20:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC99A624D4;
        Sat, 30 Apr 2022 03:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF49C385AD;
        Sat, 30 Apr 2022 03:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651289219;
        bh=d3ZW5fNPK57eX66J9ylKtIPChK1LOQBQAo/4SDkWPvk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=RBq81V1B0zC1wsouKSpwHcYn/RAVKgyizDbYM3/yVAZUOp35whj2HgfAFJgUfrRA9
         KcmTRSIvFGUMxmSSHn5dZn1Lh0QP007kCZMsrNrkwdrHFWeBXLNWy0F/kxSi+BY+7H
         JXPxxOgtE03yzUinsNtfAI2wc2Srm4MgxKbRUGvuuMnZgTzyLLZaW1rY8vR152J6AB
         oUzNcKul34iJI0xwW5mZaFonY4WO02G1vRI+WBpsOZH3nbr/HADkYgy+YFVQwedsRv
         MPxItXG2YhmYjIefDA943fD4PdKLLxtHUdn4brKm5TuHufjUVBbO9eGhcp/OenTLZs
         rMBDcenRcxfyw==
Received: by mail-wm1-f47.google.com with SMTP id p189so5541698wmp.3;
        Fri, 29 Apr 2022 20:26:59 -0700 (PDT)
X-Gm-Message-State: AOAM531fJLJegFSxB1thi9tfS83Yr3hxGnNF9l1Ovb2p97dEHKeOpRnt
        A+j5oR12HHJO3l/hNlRW6GnTVa3B2myBYMqBB64=
X-Google-Smtp-Source: ABdhPJzEDelgZYI9HaASTigWNgH5drnhUAvbr85xTlM+Xv8ERFusnHEgo96dz4tPdMyNM7ga0jrYWBKiJe3/P395BX8=
X-Received: by 2002:a05:600c:384f:b0:393:e79f:a146 with SMTP id
 s15-20020a05600c384f00b00393e79fa146mr5823746wmr.102.1651289217537; Fri, 29
 Apr 2022 20:26:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64e7:0:0:0:0:0 with HTTP; Fri, 29 Apr 2022 20:26:56
 -0700 (PDT)
In-Reply-To: <CAKYAXd_9BT7je6-UHgDYCY-WD2maxYtam0_En8pgS_FiwRJP9Q@mail.gmail.com>
References: <20220418173923.193173-1-tadeusz.struk@linaro.org> <CAKYAXd_9BT7je6-UHgDYCY-WD2maxYtam0_En8pgS_FiwRJP9Q@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 30 Apr 2022 12:26:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8sQDJyftZ_N8bgCMcMCMraQ=6_8x+QZ5XprMN3P4x9gQ@mail.gmail.com>
Message-ID: <CAKYAXd8sQDJyftZ_N8bgCMcMCMraQ=6_8x+QZ5XprMN3P4x9gQ@mail.gmail.com>
Subject: Re: [PATCH] exfat: check if cluster num is valid
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-04-22 14:54 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2022-04-19 2:39 GMT+09:00, Tadeusz Struk <tadeusz.struk@linaro.org>:
> Hi Tadeusz,
>
>> Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
>> This was triggered by reproducer calling truncate with size 0,
>> which causes the following trace:
>>
>> BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490
>> fs/exfat/balloc.c:174
>> Read of size 8 at addr ffff888115aa9508 by task syz-executor251/365
>>
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
>>  print_address_description+0x81/0x3c0 mm/kasan/report.c:233
>>  __kasan_report mm/kasan/report.c:419 [inline]
>>  kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
>>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
>>  exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
>>  exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
>>  __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
>>  exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
>>  exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
>>  notify_change+0xb76/0xe10 fs/attr.c:336
>>  do_truncate+0x1ea/0x2d0 fs/open.c:65
> Could you please share how to reproduce this ?
Ping, If you apply this patch to your source, there is a problem. You
need to add +1 to EXFAT_DATA_CLUSTER_COUNT(sbi).
and please use is_valid_cluster() to check if cluster is valid instead of it.

>
> Thanks.
>>
>> Add checks to validate if cluster number is within valid range in
>> exfat_clear_bitmap() and exfat_set_bitmap()
>>
>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> Cc: Sungjong Seo <sj1557.seo@samsung.com>
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>>
>> Link:
>> https://syzkaller.appspot.com/bug?id=50381fc73821ecae743b8cf24b4c9a04776f767c
>> Reported-by: syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
>> Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
>> ---
>>  fs/exfat/balloc.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
>> index 03f142307174..4ed81f86f993 100644
>> --- a/fs/exfat/balloc.c
>> +++ b/fs/exfat/balloc.c
>> @@ -149,6 +149,9 @@ int exfat_set_bitmap(struct inode *inode, unsigned
>> int
>> clu, bool sync)
>>  	struct exfat_sb_info *sbi = EXFAT_SB(sb);
>>
>>  	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
>> +	if (clu > EXFAT_DATA_CLUSTER_COUNT(sbi))
>> +		return -EINVAL;
>> +
>>  	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
>>  	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
>>  	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
>> @@ -167,6 +170,9 @@ void exfat_clear_bitmap(struct inode *inode, unsigned
>> int clu, bool sync)
>>  	struct exfat_mount_options *opts = &sbi->options;
>>
>>  	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
>> +	if (clu > EXFAT_DATA_CLUSTER_COUNT(sbi))
>> +		return;
>> +
>>  	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
>>  	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
>>  	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
>> --
>> 2.35.1
>>
>>
>
