Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664F0540BDE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351394AbiFGScK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351519AbiFGS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CB2179956;
        Tue,  7 Jun 2022 10:55:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B410BCE2428;
        Tue,  7 Jun 2022 17:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5107DC385A5;
        Tue,  7 Jun 2022 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624520;
        bh=j3uNHWslQx2TMq4plPlTP9lh0uFCqJRr0z3ou4Fl1Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=el26cOOw3fGyGlTUHplxBoQ5CJdP4VGSmMnY8Q564MyiR28bX+peQjqSUsaOqKcrc
         hrnDgikzTS70VXmnT1FQ/t6hipz70veTyRMWL8ELKK/Xx2TVdmzflF7AgO6Tl33DK2
         sgEcSElN1r3PQAwlqQOSxL6UENslWZEm0gMQxFreKLsv7KWOE8Ea9JlnvQhAhUdgNl
         ce8NHViqYXF1xzz+UmL8q1AOs2D2aacsXUsBwGmxf9HpX/rY4HwHkJIeR3g/0//TMq
         vt+wwusopvPv/vfVvw6ktpLiDZ1xpvsgU1WA53G8T5aVp5OFOASDqq/EZe1XGEOs5/
         sYsC3o+od7KXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hou Tao <houtao1@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, nbd@other.debian.org
Subject: [PATCH AUTOSEL 5.17 49/60] nbd: call genl_unregister_family() first in nbd_cleanup()
Date:   Tue,  7 Jun 2022 13:52:46 -0400
Message-Id: <20220607175259.478835-49-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 06c4da89c24e7023ea448cadf8e9daf06a0aae6e ]

Otherwise there may be race between module removal and the handling of
netlink command, which can lead to the oops as shown below:

  BUG: kernel NULL pointer dereference, address: 0000000000000098
  Oops: 0002 [#1] SMP PTI
  CPU: 1 PID: 31299 Comm: nbd-client Tainted: G            E     5.14.0-rc4
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
  RIP: 0010:down_write+0x1a/0x50
  Call Trace:
   start_creating+0x89/0x130
   debugfs_create_dir+0x1b/0x130
   nbd_start_device+0x13d/0x390 [nbd]
   nbd_genl_connect+0x42f/0x748 [nbd]
   genl_family_rcv_msg_doit.isra.0+0xec/0x150
   genl_rcv_msg+0xe5/0x1e0
   netlink_rcv_skb+0x55/0x100
   genl_rcv+0x29/0x40
   netlink_unicast+0x1a8/0x250
   netlink_sendmsg+0x21b/0x430
   ____sys_sendmsg+0x2a4/0x2d0
   ___sys_sendmsg+0x81/0xc0
   __sys_sendmsg+0x62/0xb0
   __x64_sys_sendmsg+0x1f/0x30
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  Modules linked in: nbd(E-)

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220521073749.3146892-2-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5a1f98494ddd..9dc27f9e9ddc 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2529,6 +2529,12 @@ static void __exit nbd_cleanup(void)
 	struct nbd_device *nbd;
 	LIST_HEAD(del_list);
 
+	/*
+	 * Unregister netlink interface prior to waiting
+	 * for the completion of netlink commands.
+	 */
+	genl_unregister_family(&nbd_genl_family);
+
 	nbd_dbg_close();
 
 	mutex_lock(&nbd_index_mutex);
@@ -2547,7 +2553,6 @@ static void __exit nbd_cleanup(void)
 	destroy_workqueue(nbd_del_wq);
 
 	idr_destroy(&nbd_index_idr);
-	genl_unregister_family(&nbd_genl_family);
 	unregister_blkdev(NBD_MAJOR, "nbd");
 }
 
-- 
2.35.1

