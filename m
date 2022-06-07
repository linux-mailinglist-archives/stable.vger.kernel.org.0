Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95615417FB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378703AbiFGVHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378661AbiFGVBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:01:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B93920E53D;
        Tue,  7 Jun 2022 11:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCC3CB81FE1;
        Tue,  7 Jun 2022 18:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBE4C385A2;
        Tue,  7 Jun 2022 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627521;
        bh=K0bdUzOfeyMkxgs4pOZ4/dubG5F1GljN0qv8FWivZ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10ob+5Os258xH8buI2vKckcKpQnYUvPuBFB5KSZAeVK2BtmiFJnSAtGzGNBCvhDxN
         An6gRGBAIkmHc7VkXLwhvXRt4zjVeV57cJcYqgOQZ9qPnh+oCCQaCCF6AM68qUj8d1
         atwNk04l9avmlMpqiZFyvHqCDpw3jSR2FD5CuBNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fine Fan <ffan@redhat.com>,
        Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>
Subject: [PATCH 5.17 769/772] md: Dont set mddev private to NULL in raid0 pers->free
Date:   Tue,  7 Jun 2022 19:06:01 +0200
Message-Id: <20220607165011.681618180@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit 0f2571ad7a30ff6b33cde142439f9378669f8b4f upstream.

In normal stop process, it does like this:
   do_md_stop
      |
   __md_stop (pers->free(); mddev->private=NULL)
      |
   md_free (free mddev)
__md_stop sets mddev->private to NULL after pers->free. The raid device
will be stopped and mddev memory is free. But in reshape, it doesn't
free the mddev and mddev will still be used in new raid.

In reshape, it first sets mddev->private to new_pers and then runs
old_pers->free(). Now raid0 sets mddev->private to NULL in raid0_free.
The new raid can't work anymore. It will panic when dereference
mddev->private because of NULL pointer dereference.

It can panic like this:
[63010.814972] kernel BUG at drivers/md/raid10.c:928!
[63010.819778] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[63010.825011] CPU: 3 PID: 44437 Comm: md0_resync Kdump: loaded Not tainted 5.14.0-86.el9.x86_64 #1
[63010.833789] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.15.0 09/11/2020
[63010.841440] RIP: 0010:raise_barrier+0x161/0x170 [raid10]
[63010.865508] RSP: 0018:ffffc312408bbc10 EFLAGS: 00010246
[63010.870734] RAX: 0000000000000000 RBX: ffffa00bf7d39800 RCX: 0000000000000000
[63010.877866] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffa00bf7d39800
[63010.884999] RBP: 0000000000000000 R08: fffffa4945e74400 R09: 0000000000000000
[63010.892132] R10: ffffa00eed02f798 R11: 0000000000000000 R12: ffffa00bbc435200
[63010.899266] R13: ffffa00bf7d39800 R14: 0000000000000400 R15: 0000000000000003
[63010.906399] FS:  0000000000000000(0000) GS:ffffa00eed000000(0000) knlGS:0000000000000000
[63010.914485] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[63010.920229] CR2: 00007f5cfbe99828 CR3: 0000000105efe000 CR4: 00000000003506e0
[63010.927363] Call Trace:
[63010.929822]  ? bio_reset+0xe/0x40
[63010.933144]  ? raid10_alloc_init_r10buf+0x60/0xa0 [raid10]
[63010.938629]  raid10_sync_request+0x756/0x1610 [raid10]
[63010.943770]  md_do_sync.cold+0x3e4/0x94c
[63010.947698]  md_thread+0xab/0x160
[63010.951024]  ? md_write_inc+0x50/0x50
[63010.954688]  kthread+0x149/0x170
[63010.957923]  ? set_kthread_struct+0x40/0x40
[63010.962107]  ret_from_fork+0x22/0x30

Removing the code that sets mddev->private to NULL in raid0 can fix
problem.

Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
Reported-by: Fine Fan <ffan@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid0.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -361,7 +361,6 @@ static void free_conf(struct mddev *mdde
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	mddev->private = NULL;
 }
 
 static void raid0_free(struct mddev *mddev, void *priv)


