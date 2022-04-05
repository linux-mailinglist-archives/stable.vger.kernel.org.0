Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251444F27C0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbiDEIIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbiDEH6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA89FA27FD;
        Tue,  5 Apr 2022 00:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 422F8615CD;
        Tue,  5 Apr 2022 07:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5400AC340EE;
        Tue,  5 Apr 2022 07:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145154;
        bh=05a6KU7fYB5BMQ9kQRDYKFJHTPiHYdALd0KX/8D9TdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIwv5XLuoDewZwfw5QnaMxKamXqBd2dwPChgzRIO8UN08sKW/wFE907PHYdqk//23
         e982qsJKhEs9ni1+/H0sFL8ARX/ajMH0pjsNA48vgwGyiwj88M4zbYU+6JVP3fJ6ek
         xPVU9WRV0oa5h513kF/ZJqDlnriFpSXqN/WMI7FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+d55757faa9b80590767b@syzkaller.appspotmail.com
Subject: [PATCH 5.17 0266/1126] watch_queue: Fix NULL dereference in error cleanup
Date:   Tue,  5 Apr 2022 09:16:53 +0200
Message-Id: <20220405070415.418486452@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit a635415a064e77bcfbf43da413fd9dfe0bbed9cb ]

In watch_queue_set_size(), the error cleanup code doesn't take account of
the fact that __free_page() can't handle a NULL pointer when trying to free
up buffer pages that did get allocated.

Fix this by only calling __free_page() on the pages actually allocated.

Without the fix, this can lead to something like the following:

BUG: KASAN: null-ptr-deref in __free_pages+0x1f/0x1b0 mm/page_alloc.c:5473
Read of size 4 at addr 0000000000000034 by task syz-executor168/3599
...
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __kasan_report mm/kasan/report.c:446 [inline]
 kasan_report.cold+0x66/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 page_ref_count include/linux/page_ref.h:67 [inline]
 put_page_testzero include/linux/mm.h:717 [inline]
 __free_pages+0x1f/0x1b0 mm/page_alloc.c:5473
 watch_queue_set_size+0x499/0x630 kernel/watch_queue.c:275
 pipe_ioctl+0xac/0x2b0 fs/pipe.c:632
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-and-tested-by: syzbot+d55757faa9b80590767b@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 00703444a219..5848d4795816 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -271,7 +271,7 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	return 0;
 
 error_p:
-	for (i = 0; i < nr_pages; i++)
+	while (--i >= 0)
 		__free_page(pages[i]);
 	kfree(pages);
 error:
-- 
2.34.1



