Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0270263DE82
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiK3Sht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiK3Shq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:37:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54169491A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 659AA61D74
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE89C433C1;
        Wed, 30 Nov 2022 18:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833446;
        bh=xEWTVGyJfFpbD4hWXOp2L+zNR4YYuDtukWOaBEupzks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duqI+ZU8wy+O1W37aZdyJ4F22PDFsSURoo0w5aZ/zRvcwpn/ODTM+k421UJNW+jdW
         DULMZe3u6cr2bCELxy3RCWooIHhlaH4EbnYtJi0zqguEI2/svqQU7U3jsxDmUmHyAh
         PYL127pLbLUPMErotNy7KTqQ6rdBDY5IWdhXH1vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/206] 9p/fd: fix issue of list_del corruption in p9_fd_cancel()
Date:   Wed, 30 Nov 2022 19:22:13 +0100
Message-Id: <20221130180535.061270250@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 11c10956515b8ec44cf4f2a7b9d8bf8b9dc05ec4 ]

Syz reported the following issue:
kernel BUG at lib/list_debug.c:53!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:__list_del_entry_valid.cold+0x5c/0x72
Call Trace:
<TASK>
p9_fd_cancel+0xb1/0x270
p9_client_rpc+0x8ea/0xba0
p9_client_create+0x9c0/0xed0
v9fs_session_init+0x1e0/0x1620
v9fs_mount+0xba/0xb80
legacy_get_tree+0x103/0x200
vfs_get_tree+0x89/0x2d0
path_mount+0x4c0/0x1ac0
__x64_sys_mount+0x33b/0x430
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
</TASK>

The process is as follows:
Thread A:                       Thread B:
p9_poll_workfn()                p9_client_create()
...                                 ...
    p9_conn_cancel()                p9_fd_cancel()
        list_del()                      ...
        ...                             list_del()  //list_del
                                                      corruption
There is no lock protection when deleting list in p9_conn_cancel(). After
deleting list in Thread A, thread B will delete the same list again. It
will cause issue of list_del corruption.

Setting req->status to REQ_STATUS_ERROR under lock prevents other
cleanup paths from trying to manipulate req_list.
The other thread can safely check req->status because it still holds a
reference to req at this point.

Link: https://lkml.kernel.org/r/20221110122606.383352-1-shaozhengchao@huawei.com
Fixes: 52f1c45dde91 ("9p: trans_fd/p9_conn_cancel: drop client lock earlier")
Reported-by: syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
[Dominique: add description of the fix in commit message]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index a8c1f742148c..31f2026514f3 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -204,9 +204,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
+		req->status = REQ_STATUS_ERROR;
 	}
 
 	spin_unlock(&m->req_lock);
-- 
2.35.1



