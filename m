Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A76B41B9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjCJNz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjCJNzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:55:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39CD112DFA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:55:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40108617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5917DC433EF;
        Fri, 10 Mar 2023 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456530;
        bh=+0gThIHyZBEUYHQ/4qVHTDMAbmenVVT/8tL5NhFFXkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9ZqYHUxT8zjJbYcWpRd8AhHEZGCrRq9/oxBxK5SnWD15GYVFR+3pfSELk6R4mIuw
         jPi9aBRwUXUdUPZh5RrXtiX7Hk4t+TZcsqHoDFgKkcSaRd3dVmZOLUmKnmWIp0pXJP
         5GKH/b2qlNApyy+KFEbt8Xu5N2Qxis4o2WcRyi9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 034/211] ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()
Date:   Fri, 10 Mar 2023 14:36:54 +0100
Message-Id: <20230310133719.773919547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 1e591ea072df7211f64542a09482b5f81cb3ad27 ]

There is a memory leaks problem reported by kmemleak:

unreferenced object 0xffff888102007a00 (size 128):
  comm "ubirsvol", pid 32090, jiffies 4298464136 (age 2361.231s)
  hex dump (first 32 bytes):
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace:
[<ffffffff8176cecd>] __kmalloc+0x4d/0x150
[<ffffffffa02a9a36>] ubi_eba_create_table+0x76/0x170 [ubi]
[<ffffffffa029764e>] ubi_resize_volume+0x1be/0xbc0 [ubi]
[<ffffffffa02a3321>] ubi_cdev_ioctl+0x701/0x1850 [ubi]
[<ffffffff81975d2d>] __x64_sys_ioctl+0x11d/0x170
[<ffffffff83c142a5>] do_syscall_64+0x35/0x80
[<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

This is due to a mismatch between create and destroy interfaces, and
in detail that "new_eba_tbl" created by ubi_eba_create_table() but
destroyed by kfree(), while will causing "new_eba_tbl->entries" not
freed.

Fix it by replacing kfree(new_eba_tbl) with
ubi_eba_destroy_table(new_eba_tbl)

Fixes: 799dca34ac54 ("UBI: hide EBA internals")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/vmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 74637575346e8..9fbc64b997cef 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -515,7 +515,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 	return err;
 
 out_free:
-	kfree(new_eba_tbl);
+	ubi_eba_destroy_table(new_eba_tbl);
 	return err;
 }
 
-- 
2.39.2



