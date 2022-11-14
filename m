Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA862809E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbiKNNH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbiKNNH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C56F2AE1C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FB71B80EB8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C053AC433C1;
        Mon, 14 Nov 2022 13:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431243;
        bh=K7xfyKPAiruMrrgsFgbOG1RiSY28tE7CY3wdv/lF0fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTT4q4bwl/KqdQAkOmMPX6V68g2Jj0u4dS4AxeMfpW256u8hrmn6UaPY2ZChy8BQA
         pjBhwzoJx3fJGk30q6TMt06su2orNof7HAmgFdn6KgoKtJRefpec7hl1MCYSYmhAh+
         7hHTl0/rWbtfIyGctuwYS0SI96uTkLX6gEowvwrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+69c9fdccc6dd08961d34@syzkaller.appspotmail.com,
        ZhangPeng <zhangpeng362@huawei.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 6.0 154/190] udf: Fix a slab-out-of-bounds write bug in udf_find_entry()
Date:   Mon, 14 Nov 2022 13:46:18 +0100
Message-Id: <20221114124505.548859381@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangPeng <zhangpeng362@huawei.com>

commit c8af247de385ce49afabc3bf1cf4fd455c94bfe8 upstream.

Syzbot reported a slab-out-of-bounds Write bug:

loop0: detected capacity change from 0 to 2048
==================================================================
BUG: KASAN: slab-out-of-bounds in udf_find_entry+0x8a5/0x14f0
fs/udf/namei.c:253
Write of size 105 at addr ffff8880123ff896 by task syz-executor323/3610

CPU: 0 PID: 3610 Comm: syz-executor323 Not tainted
6.1.0-rc2-syzkaller-00105-gb229b6ca5abb #0
Hardware name: Google Compute Engine/Google Compute Engine, BIOS
Google 10/11/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:284
 print_report+0x107/0x1f0 mm/kasan/report.c:395
 kasan_report+0xcd/0x100 mm/kasan/report.c:495
 kasan_check_range+0x2a7/0x2e0 mm/kasan/generic.c:189
 memcpy+0x3c/0x60 mm/kasan/shadow.c:66
 udf_find_entry+0x8a5/0x14f0 fs/udf/namei.c:253
 udf_lookup+0xef/0x340 fs/udf/namei.c:309
 lookup_open fs/namei.c:3391 [inline]
 open_last_lookups fs/namei.c:3481 [inline]
 path_openat+0x10e6/0x2df0 fs/namei.c:3710
 do_filp_open+0x264/0x4f0 fs/namei.c:3740
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_creat fs/open.c:1402 [inline]
 __se_sys_creat fs/open.c:1396 [inline]
 __x64_sys_creat+0x11f/0x160 fs/open.c:1396
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ffab0d164d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe1a7e6bb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ffab0d164d9
RDX: 00007ffab0d164d9 RSI: 0000000000000000 RDI: 0000000020000180
RBP: 00007ffab0cd5a10 R08: 0000000000000000 R09: 0000000000000000
R10: 00005555573552c0 R11: 0000000000000246 R12: 00007ffab0cd5aa0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Allocated by task 3610:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x3d/0x60 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 __kasan_kmalloc+0x97/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:576 [inline]
 udf_find_entry+0x7b6/0x14f0 fs/udf/namei.c:243
 udf_lookup+0xef/0x340 fs/udf/namei.c:309
 lookup_open fs/namei.c:3391 [inline]
 open_last_lookups fs/namei.c:3481 [inline]
 path_openat+0x10e6/0x2df0 fs/namei.c:3710
 do_filp_open+0x264/0x4f0 fs/namei.c:3740
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_creat fs/open.c:1402 [inline]
 __se_sys_creat fs/open.c:1396 [inline]
 __x64_sys_creat+0x11f/0x160 fs/open.c:1396
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff8880123ff800
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 150 bytes inside of
 256-byte region [ffff8880123ff800, ffff8880123ff900)

The buggy address belongs to the physical page:
page:ffffea000048ff80 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x123fe
head:ffffea000048ff80 order:1 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea00004b8500 dead000000000003 ffff888012041b40
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x0(),
pid 1, tgid 1 (swapper/0), ts 1841222404, free_ts 0
 create_dummy_stack mm/page_owner.c:67 [inline]
 register_early_stack+0x77/0xd0 mm/page_owner.c:83
 init_page_owner+0x3a/0x731 mm/page_owner.c:93
 kernel_init_freeable+0x41c/0x5d5 init/main.c:1629
 kernel_init+0x19/0x2b0 init/main.c:1519
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8880123ff780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880123ff800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880123ff880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06
                                                                ^
 ffff8880123ff900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880123ff980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

Fix this by changing the memory size allocated for copy_name from
UDF_NAME_LEN(254) to UDF_NAME_LEN_CS0(255), because the total length
(lfi) of subsequent memcpy can be up to 255.

CC: stable@vger.kernel.org
Reported-by: syzbot+69c9fdccc6dd08961d34@syzkaller.appspotmail.com
Fixes: 066b9cded00b ("udf: Use separate buffer for copying split names")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221109013542.442790-1-zhangpeng362@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -240,7 +240,7 @@ static struct fileIdentDesc *udf_find_en
 						      poffset - lfi);
 			else {
 				if (!copy_name) {
-					copy_name = kmalloc(UDF_NAME_LEN,
+					copy_name = kmalloc(UDF_NAME_LEN_CS0,
 							    GFP_NOFS);
 					if (!copy_name) {
 						fi = ERR_PTR(-ENOMEM);


