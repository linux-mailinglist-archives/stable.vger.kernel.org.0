Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A584D42AE
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 09:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiCJIg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 03:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbiCJIgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 03:36:25 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4CAD2079;
        Thu, 10 Mar 2022 00:35:21 -0800 (PST)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KDj5b68lLzfYsH;
        Thu, 10 Mar 2022 16:33:55 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 16:35:18 +0800
Subject: Re: [PATCH -next] jffs2: fix use-after-free in
 jffs2_clear_xattr_subsystem
To:     <richard@nod.at>, <dwmw2@infradead.org>,
        <christian.brauner@ubuntu.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yukuai3@huawei.com>, <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>
References: <20211228125430.1880252-1-libaokun1@huawei.com>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <8a175ec6-1555-8575-1f03-0002efac1740@huawei.com>
Date:   Thu, 10 Mar 2022 16:35:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20211228125430.1880252-1-libaokun1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A gentle ping, sorry for the noise.

在 2021/12/28 20:54, Baokun Li 写道:
> When we mount a jffs2 image, assume that the first few blocks of
> the image are normal and contain at least one xattr-related inode,
> but the next block is abnormal. As a result, an error is returned
> in jffs2_scan_eraseblock(). jffs2_clear_xattr_subsystem() is then
> called in jffs2_build_filesystem() and then again in
> jffs2_do_fill_super().
>
> Finally we can observe the following report:
>   ==================================================================
>   BUG: KASAN: use-after-free in jffs2_clear_xattr_subsystem+0x95/0x6ac
>   Read of size 8 at addr ffff8881243384e0 by task mount/719
>
>   Call Trace:
>    dump_stack+0x115/0x16b
>    jffs2_clear_xattr_subsystem+0x95/0x6ac
>    jffs2_do_fill_super+0x84f/0xc30
>    jffs2_fill_super+0x2ea/0x4c0
>    mtd_get_sb+0x254/0x400
>    mtd_get_sb_by_nr+0x4f/0xd0
>    get_tree_mtd+0x498/0x840
>    jffs2_get_tree+0x25/0x30
>    vfs_get_tree+0x8d/0x2e0
>    path_mount+0x50f/0x1e50
>    do_mount+0x107/0x130
>    __se_sys_mount+0x1c5/0x2f0
>    __x64_sys_mount+0xc7/0x160
>    do_syscall_64+0x45/0x70
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
>   Allocated by task 719:
>    kasan_save_stack+0x23/0x60
>    __kasan_kmalloc.constprop.0+0x10b/0x120
>    kasan_slab_alloc+0x12/0x20
>    kmem_cache_alloc+0x1c0/0x870
>    jffs2_alloc_xattr_ref+0x2f/0xa0
>    jffs2_scan_medium.cold+0x3713/0x4794
>    jffs2_do_mount_fs.cold+0xa7/0x2253
>    jffs2_do_fill_super+0x383/0xc30
>    jffs2_fill_super+0x2ea/0x4c0
>   [...]
>
>   Freed by task 719:
>    kmem_cache_free+0xcc/0x7b0
>    jffs2_free_xattr_ref+0x78/0x98
>    jffs2_clear_xattr_subsystem+0xa1/0x6ac
>    jffs2_do_mount_fs.cold+0x5e6/0x2253
>    jffs2_do_fill_super+0x383/0xc30
>    jffs2_fill_super+0x2ea/0x4c0
>   [...]
>
>   The buggy address belongs to the object at ffff8881243384b8
>    which belongs to the cache jffs2_xattr_ref of size 48
>   The buggy address is located 40 bytes inside of
>    48-byte region [ffff8881243384b8, ffff8881243384e8)
>   [...]
>   ==================================================================
>
> The triggering of the BUG is shown in the following stack:
> -----------------------------------------------------------
> jffs2_fill_super
>    jffs2_do_fill_super
>      jffs2_do_mount_fs
>        jffs2_build_filesystem
>          jffs2_scan_medium
>            jffs2_scan_eraseblock        <--- ERROR
>          jffs2_clear_xattr_subsystem    <--- free
>      jffs2_clear_xattr_subsystem        <--- free again
> -----------------------------------------------------------
>
> An error is returned in jffs2_do_mount_fs(). If the error is returned
> by jffs2_sum_init(), the jffs2_clear_xattr_subsystem() does not need to
> be executed. If the error is returned by jffs2_build_filesystem(), the
> jffs2_clear_xattr_subsystem() also does not need to be executed again.
> So move jffs2_clear_xattr_subsystem() from 'out_inohash' to 'out_root'
> to fix this UAF problem.
>
> Fixes: aa98d7cf59b5 ("[JFFS2][XATTR] XATTR support on JFFS2 (version. 5)")
> Cc: stable@vger.kernel.org
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>   fs/jffs2/fs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
> index 2ac410477c4f..71f03a5d36ed 100644
> --- a/fs/jffs2/fs.c
> +++ b/fs/jffs2/fs.c
> @@ -603,8 +603,8 @@ int jffs2_do_fill_super(struct super_block *sb, struct fs_context *fc)
>   	jffs2_free_ino_caches(c);
>   	jffs2_free_raw_node_refs(c);
>   	kvfree(c->blocks);
> - out_inohash:
>   	jffs2_clear_xattr_subsystem(c);
> + out_inohash:
>   	kfree(c->inocache_list);
>    out_wbuf:
>   	jffs2_flash_cleanup(c);

-- 
With Best Regards,
Baokun Li

