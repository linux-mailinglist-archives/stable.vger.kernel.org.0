Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C348D6B4A06
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbjCJPRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbjCJPR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:17:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577B9DDF01
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:08:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F94861A38
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A5EC433EF;
        Fri, 10 Mar 2023 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460869;
        bh=u47g8HaZ8/+aKmcIUyutp4zgaeAjYshSn4tTDmA2i3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHv/60Dn8Epglly81UEL1k98XMVu69SQW4UmGZPOale3vA0IGcaIUnXsFbl/7+Zhp
         VYFV0BH+nyNABCCZCce63eZBbSr9rfUNB+Iz4AvWryxN+emEPZO2aVZIJuLw36AwMg
         uDLDChEfuC+knCVzyIx/B1eUB+NjOQgs8zqAON7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/529] ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()
Date:   Fri, 10 Mar 2023 14:39:51 +0100
Message-Id: <20230310133825.676137955@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 6c7822c1cc451..2e5bd473e5e25 100644
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



