Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82604DBA83
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 23:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358224AbiCPWJu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Mar 2022 18:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358225AbiCPWJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 18:09:48 -0400
X-Greylist: delayed 442 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Mar 2022 15:08:33 PDT
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B6713D64
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 15:08:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id D913F6081104;
        Wed, 16 Mar 2022 23:01:09 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 8vaihv-rfqXQ; Wed, 16 Mar 2022 23:01:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 4F3016081107;
        Wed, 16 Mar 2022 23:01:09 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dGMp6Mx7hpNU; Wed, 16 Mar 2022 23:01:09 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 1FE796081104;
        Wed, 16 Mar 2022 23:01:09 +0100 (CET)
Date:   Wed, 16 Mar 2022 23:01:09 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     libaokun <libaokun1@huawei.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        christian brauner <christian.brauner@ubuntu.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        yukuai3 <yukuai3@huawei.com>, stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Message-ID: <1891491465.152789.1647468069089.JavaMail.zimbra@nod.at>
In-Reply-To: <8a175ec6-1555-8575-1f03-0002efac1740@huawei.com>
References: <20211228125430.1880252-1-libaokun1@huawei.com> <8a175ec6-1555-8575-1f03-0002efac1740@huawei.com>
Subject: Re: [PATCH -next] jffs2: fix use-after-free in
 jffs2_clear_xattr_subsystem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: jffs2: fix use-after-free in jffs2_clear_xattr_subsystem
Thread-Index: CCC9RxtPxe322JVfIQ6ZCv5ouCR7KA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "libaokun" <libaokun1@huawei.com>
> An: "richard" <richard@nod.at>, "David Woodhouse" <dwmw2@infradead.org>, "christian brauner"
> <christian.brauner@ubuntu.com>, "linux-mtd" <linux-mtd@lists.infradead.org>, "linux-kernel"
> <linux-kernel@vger.kernel.org>
> CC: "yukuai3" <yukuai3@huawei.com>, "stable" <stable@vger.kernel.org>, "Hulk Robot" <hulkci@huawei.com>, "libaokun"
> <libaokun1@huawei.com>
> Gesendet: Donnerstag, 10. März 2022 09:35:18
> Betreff: Re: [PATCH -next] jffs2: fix use-after-free in jffs2_clear_xattr_subsystem

> A gentle ping, sorry for the noise.
> 
> 在 2021/12/28 20:54, Baokun Li 写道:
>> When we mount a jffs2 image, assume that the first few blocks of
>> the image are normal and contain at least one xattr-related inode,
>> but the next block is abnormal. As a result, an error is returned
>> in jffs2_scan_eraseblock(). jffs2_clear_xattr_subsystem() is then
>> called in jffs2_build_filesystem() and then again in
>> jffs2_do_fill_super().
>>
>> Finally we can observe the following report:
>>   ==================================================================
>>   BUG: KASAN: use-after-free in jffs2_clear_xattr_subsystem+0x95/0x6ac
>>   Read of size 8 at addr ffff8881243384e0 by task mount/719
>>
>>   Call Trace:
>>    dump_stack+0x115/0x16b
>>    jffs2_clear_xattr_subsystem+0x95/0x6ac
>>    jffs2_do_fill_super+0x84f/0xc30
>>    jffs2_fill_super+0x2ea/0x4c0
>>    mtd_get_sb+0x254/0x400
>>    mtd_get_sb_by_nr+0x4f/0xd0
>>    get_tree_mtd+0x498/0x840
>>    jffs2_get_tree+0x25/0x30
>>    vfs_get_tree+0x8d/0x2e0
>>    path_mount+0x50f/0x1e50
>>    do_mount+0x107/0x130
>>    __se_sys_mount+0x1c5/0x2f0
>>    __x64_sys_mount+0xc7/0x160
>>    do_syscall_64+0x45/0x70
>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>>   Allocated by task 719:
>>    kasan_save_stack+0x23/0x60
>>    __kasan_kmalloc.constprop.0+0x10b/0x120
>>    kasan_slab_alloc+0x12/0x20
>>    kmem_cache_alloc+0x1c0/0x870
>>    jffs2_alloc_xattr_ref+0x2f/0xa0
>>    jffs2_scan_medium.cold+0x3713/0x4794
>>    jffs2_do_mount_fs.cold+0xa7/0x2253
>>    jffs2_do_fill_super+0x383/0xc30
>>    jffs2_fill_super+0x2ea/0x4c0
>>   [...]
>>
>>   Freed by task 719:
>>    kmem_cache_free+0xcc/0x7b0
>>    jffs2_free_xattr_ref+0x78/0x98
>>    jffs2_clear_xattr_subsystem+0xa1/0x6ac
>>    jffs2_do_mount_fs.cold+0x5e6/0x2253
>>    jffs2_do_fill_super+0x383/0xc30
>>    jffs2_fill_super+0x2ea/0x4c0
>>   [...]
>>
>>   The buggy address belongs to the object at ffff8881243384b8
>>    which belongs to the cache jffs2_xattr_ref of size 48
>>   The buggy address is located 40 bytes inside of
>>    48-byte region [ffff8881243384b8, ffff8881243384e8)
>>   [...]
>>   ==================================================================
>>
>> The triggering of the BUG is shown in the following stack:
>> -----------------------------------------------------------
>> jffs2_fill_super
>>    jffs2_do_fill_super
>>      jffs2_do_mount_fs
>>        jffs2_build_filesystem
>>          jffs2_scan_medium
>>            jffs2_scan_eraseblock        <--- ERROR
>>          jffs2_clear_xattr_subsystem    <--- free
>>      jffs2_clear_xattr_subsystem        <--- free again
>> -----------------------------------------------------------
>>
>> An error is returned in jffs2_do_mount_fs(). If the error is returned
>> by jffs2_sum_init(), the jffs2_clear_xattr_subsystem() does not need to
>> be executed. If the error is returned by jffs2_build_filesystem(), the
>> jffs2_clear_xattr_subsystem() also does not need to be executed again.
>> So move jffs2_clear_xattr_subsystem() from 'out_inohash' to 'out_root'
>> to fix this UAF problem.
>>
>> Fixes: aa98d7cf59b5 ("[JFFS2][XATTR] XATTR support on JFFS2 (version. 5)")
>> Cc: stable@vger.kernel.org
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Applied. Thanks for fixing!

Thanks,
//richard
