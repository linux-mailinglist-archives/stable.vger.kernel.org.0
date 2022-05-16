Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E7052954E
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 01:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347822AbiEPXcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 19:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346625AbiEPXcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 19:32:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF312C673;
        Mon, 16 May 2022 16:31:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B3AB816A9;
        Mon, 16 May 2022 23:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0726C385B8;
        Mon, 16 May 2022 23:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652743916;
        bh=iLc5AL3V7Ys+hwNkZmlnccb1Qrnh6JQ/xtPdNvzpUUw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Le/A75jBBAMVkJ9BDNodn34IKwIrFXp6YQVYwBq34f4nJGm3r91vynuAA5k/+EVKr
         6InQkgg3ui/OxjzmDT+gGDIY8km7R50beteNcJIdLTBq8d7qyC7/nznbBNQ6pL5wbc
         /L5Xz+5D5g4FaU4n0oJ1IEx85GEGPofQFtT1AQD7aHM7SY1LsFFMN4LlxW1P1tCNmU
         suxtIozIUSki2QmgUsXOSX8OhF3nlcULhIBk1skPo03ahdcf032fCEPIiR9H3efESF
         dLFsqsaqYxPQjpZu3q7lwm8zh+fIY5hrlBlqlDTnvpaX6gVMy2CudnLuMaR11c4JYw
         zn/Nb9sVNd9jw==
Received: by mail-wr1-f51.google.com with SMTP id d21so6518187wra.10;
        Mon, 16 May 2022 16:31:56 -0700 (PDT)
X-Gm-Message-State: AOAM532cACQ9fCGGYuX7+JK31rDhihnzGdqTn37/Ns1/FILei17PeSV+
        lGZ/v6FAuZG8HYSK9wl750KZGLz9/ICzO0WJVzk=
X-Google-Smtp-Source: ABdhPJySq1/ubpgJ7MHSploXrO4dg3+DRK3Y/FHkqhTWcHXVQH6mmocEBYrS4XZKXEZvUpRC4F0Eem0GwkB/oYWmp0c=
X-Received: by 2002:a5d:6286:0:b0:20d:9b5:6a97 with SMTP id
 k6-20020a5d6286000000b0020d09b56a97mr5547888wru.165.1652743914881; Mon, 16
 May 2022 16:31:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Mon, 16 May 2022 16:31:54
 -0700 (PDT)
In-Reply-To: <c9ab0896-b19b-b8b8-cf63-ad437a123270@linaro.org>
References: <20220511185909.175110-1-tadeusz.struk@linaro.org>
 <CGME20220511185940epcas1p1e51c30e41ff82ae642f8f949ffa4b189@epcas1p1.samsung.com>
 <20220511185909.175110-2-tadeusz.struk@linaro.org> <000101d8686b$56d88750$048995f0$@samsung.com>
 <c9ab0896-b19b-b8b8-cf63-ad437a123270@linaro.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 17 May 2022 08:31:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_kcZF0tHMX_CsR83qmX25PhdGQPJibMh1-30=5przrjQ@mail.gmail.com>
Message-ID: <CAKYAXd_kcZF0tHMX_CsR83qmX25PhdGQPJibMh1-30=5przrjQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] exfat: check if cluster num is valid
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022-05-16 23:51 GMT+09:00, Tadeusz Struk <tadeusz.struk@linaro.org>:
> On 5/15/22 07:52, Sungjong Seo wrote:
>>> Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
>>> This was triggered by reproducer calling truncute with size 0, which
>>> causes the following trace:
>>>
>>> BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490
>>> fs/exfat/balloc.c:174 Read of size 8 at addr ffff888115aa9508 by task
>>> syz-
>>> executor251/365
>>>
>>> Call Trace:
>>>   __dump_stack lib/dump_stack.c:77 [inline]  dump_stack_lvl+0x1e2/0x24b
>>> lib/dump_stack.c:118
>>>   print_address_description+0x81/0x3c0 mm/kasan/report.c:233
>>> __kasan_report mm/kasan/report.c:419 [inline]
>>>   kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
>>>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
>>>   exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
>>>   exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
>>>   __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
>>>   exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
>>>   exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
>>>   notify_change+0xb76/0xe10 fs/attr.c:336
>>>   do_truncate+0x1ea/0x2d0 fs/open.c:65
>>>
>>> Add checks to validate if cluster number is within valid range in
>>> exfat_clear_bitmap() and exfat_set_bitmap()
>>>
>>> Cc: Namjae Jeon<linkinjeon@kernel.org>
>>> Cc: Sungjong Seo<sj1557.seo@samsung.com>
>>> Cc:linux-fsdevel@vger.kernel.org
>>> Cc:stable@vger.kernel.org
>>> Cc:linux-kernel@vger.kernel.org
>>>
>>> Link:https://protect2.fireeye.com/v1/url?k=24a746d8-45dcec51-24a6cd97-
>>> 74fe48600034-8e4653a49a463f3c&q=1&e=0efc824d-6463-4253-9cd7-
>>> ce3199dbf513&u=https%3A%2F%2Fsyzkaller.appspot.com%2Fbug%3Fid%3D50381fc738
>>> 21ecae743b8cf24b4c9a04776f767c
>>> Reported-by:syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
>>> Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
>>> Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>
>> Looks good.
>> And it seems that WARN_ON() is no longer needed.
>
> Right. Do you want me to send a follow up patch that drops the WARN_ONs?
You don't need to do it. I have applied this patch to #exfat dev
branch after removing it.
Note that I have combined 1/2 into 2/2 patch.
Thanks!
>
>> Reviewed-by: Sungjong Seo<sj1557.seo@samsung.com>
>>
>
> Thank you.
>
> --
> Thanks,
> Tadeusz
>
