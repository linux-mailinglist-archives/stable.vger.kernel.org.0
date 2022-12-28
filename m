Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500BF657C58
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiL1PcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbiL1Pbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:31:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAB815FFE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:31:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1050B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BC3C433D2;
        Wed, 28 Dec 2022 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241490;
        bh=GUSb2ubqMpUEe1gXThVvU0MrSS4dGpwSBs4Dbp8p6ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aV9BShqIC3tKbu4kBgFbhOU0iyhUMZmcup81oWurMMLy1YAruHywX+qpohyrsI5Qd
         5K89kR0MSvJN0cCkjfuh89Q989hN87OUUiPIVpVW8p4Qa9AoFkAIcoWul9NJuoZ1oV
         sq998rmetFwquydruFtgM+nJ37SfmdN/ofSyLWL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0290/1073] mtd: Fix device name leak when register device failed in add_mtd_device()
Date:   Wed, 28 Dec 2022 15:31:18 +0100
Message-Id: <20221228144335.893079270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 895d68a39481a75c680aa421546931fb11942fa6 ]

There is a kmemleak when register device failed:
  unreferenced object 0xffff888101aab550 (size 8):
    comm "insmod", pid 3922, jiffies 4295277753 (age 925.408s)
    hex dump (first 8 bytes):
      6d 74 64 30 00 88 ff ff                          mtd0....
    backtrace:
      [<00000000bde26724>] __kmalloc_node_track_caller+0x4e/0x150
      [<000000003c32b416>] kvasprintf+0xb0/0x130
      [<000000001f7a8f15>] kobject_set_name_vargs+0x2f/0xb0
      [<000000006e781163>] dev_set_name+0xab/0xe0
      [<00000000e30d0c78>] add_mtd_device+0x4bb/0x700
      [<00000000f3d34de7>] mtd_device_parse_register+0x2ac/0x3f0
      [<00000000c0d88488>] 0xffffffffa0238457
      [<00000000b40d0922>] 0xffffffffa02a008f
      [<0000000023d17b9d>] do_one_initcall+0x87/0x2a0
      [<00000000770f6ca6>] do_init_module+0xdf/0x320
      [<000000007b6768fe>] load_module+0x2f98/0x3330
      [<00000000346bed5a>] __do_sys_finit_module+0x113/0x1b0
      [<00000000674c2290>] do_syscall_64+0x35/0x80
      [<000000004c6a8d97>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

If register device failed, should call put_device() to give up the
reference.

Fixes: 1f24b5a8ecbb ("[MTD] driver model updates")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221022121352.2534682-1-zhangxiaoxu5@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 477707bcad97..cc7e1fd1ef10 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -723,8 +723,10 @@ int add_mtd_device(struct mtd_info *mtd)
 	mtd_check_of_node(mtd);
 	of_node_get(mtd_get_of_node(mtd));
 	error = device_register(&mtd->dev);
-	if (error)
+	if (error) {
+		put_device(&mtd->dev);
 		goto fail_added;
+	}
 
 	/* Add the nvmem provider */
 	error = mtd_nvmem_add(mtd);
-- 
2.35.1



