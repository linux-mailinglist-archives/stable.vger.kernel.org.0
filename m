Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58E74F2771
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiDEIGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiDEH47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A064427DE;
        Tue,  5 Apr 2022 00:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A047961740;
        Tue,  5 Apr 2022 07:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF58EC340EE;
        Tue,  5 Apr 2022 07:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145050;
        bh=0m1s9fY8emgpod7a0c86QGW3B5W4ZS13ZfoY2qqIbTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obkCqheVI4W2j3Crud5Xn6Ni3j9YkHIJIAfkBU6dfPCmnoLGeAKl+gMRaVkIaJlO7
         5rXZYjKprR79YI1dh4EFSc9DBbIKeUP0yVjn3L3WQcV4xxtmY382clLz2re87AfRJc
         DWXdbEYRYN/G3jh5yAgT+CVPOdzTOoyGOThguncU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+6e2de48f06cdb2884bfc@syzkaller.appspotmail.com
Subject: [PATCH 5.17 0267/1126] watch_queue: Actually free the watch
Date:   Tue,  5 Apr 2022 09:16:54 +0200
Message-Id: <20220405070415.447858221@linuxfoundation.org>
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

[ Upstream commit 3d8dcf278b1ee1eff1e90be848fa2237db4c07a7 ]

free_watch() does everything barring actually freeing the watch object.  Fix
this by adding the missing kfree.

kmemleak produces a report something like the following.  Note that as an
address can be seen in the first word, the watch would appear to have gone
through call_rcu().

BUG: memory leak
unreferenced object 0xffff88810ce4a200 (size 96):
  comm "syz-executor352", pid 3605, jiffies 4294947473 (age 13.720s)
  hex dump (first 32 bytes):
    e0 82 48 0d 81 88 ff ff 00 00 00 00 00 00 00 00  ..H.............
    80 a2 e4 0c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8214e6cc>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8214e6cc>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8214e6cc>] keyctl_watch_key+0xec/0x2e0 security/keys/keyctl.c:1800
    [<ffffffff8214ec84>] __do_sys_keyctl+0x3c4/0x490 security/keys/keyctl.c:2016
    [<ffffffff84493a25>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84493a25>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-and-tested-by: syzbot+6e2de48f06cdb2884bfc@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 5848d4795816..3990e4df3d7b 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -395,6 +395,7 @@ static void free_watch(struct rcu_head *rcu)
 	put_watch_queue(rcu_access_pointer(watch->queue));
 	atomic_dec(&watch->cred->user->nr_watches);
 	put_cred(watch->cred);
+	kfree(watch);
 }
 
 static void __put_watch(struct kref *kref)
-- 
2.34.1



