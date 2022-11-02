Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575B86158A3
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiKBCzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiKBCzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:55:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E5B22292
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:55:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CA30B82064
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DADC433D6;
        Wed,  2 Nov 2022 02:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357731;
        bh=ISGbMphGcokC5aWV8QUStdB6GXY95Nx/yNBw0OH7iNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWLtqoW63N4qnqKlqS0WjXtvChCIxOqFGcLCwhuouNKw+ZJJS+YjQqOo2BMGjmGBG
         S0rztdq4gEa2SP8bTIH05V7dUJvoS/hCjkWjEW0s4Wpwt//sM6KCO8LhMGZpzxUdCT
         a8saHul/J20u4naaadmojQewDXU9ILOgGhMikUdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 220/240] netdevsim: fix memory leak in nsim_bus_dev_new()
Date:   Wed,  2 Nov 2022 03:33:15 +0100
Message-Id: <20221102022116.376818162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit cf2010aa1c739bab067cbc90b690d28eaa0b47da ]

If device_register() failed in nsim_bus_dev_new(), the value of reference
in nsim_bus_dev->dev is 1. obj->name in nsim_bus_dev->dev will not be
released.

unreferenced object 0xffff88810352c480 (size 16):
  comm "echo", pid 5691, jiffies 4294945921 (age 133.270s)
  hex dump (first 16 bytes):
    6e 65 74 64 65 76 73 69 6d 31 00 00 00 00 00 00  netdevsim1......
  backtrace:
    [<000000005e2e5e26>] __kmalloc_node_track_caller+0x3a/0xb0
    [<0000000094ca4fc8>] kvasprintf+0xc3/0x160
    [<00000000aad09bcc>] kvasprintf_const+0x55/0x180
    [<000000009bac868d>] kobject_set_name_vargs+0x56/0x150
    [<000000007c1a5d70>] dev_set_name+0xbb/0xf0
    [<00000000ad0d126b>] device_add+0x1f8/0x1cb0
    [<00000000c222ae24>] new_device_store+0x3b6/0x5e0
    [<0000000043593421>] bus_attr_store+0x72/0xa0
    [<00000000cbb1833a>] sysfs_kf_write+0x106/0x160
    [<00000000d0dedb8a>] kernfs_fop_write_iter+0x3a8/0x5a0
    [<00000000770b66e2>] vfs_write+0x8f0/0xc80
    [<0000000078bb39be>] ksys_write+0x106/0x210
    [<00000000005e55a4>] do_syscall_64+0x35/0x80
    [<00000000eaa40bbc>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 40e4fe4ce115 ("netdevsim: move device registration and related code to bus.c")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221026015405.128795-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bus.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index b5f4df1a07a3..0052968e881e 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -117,6 +117,10 @@ static const struct attribute_group *nsim_bus_dev_attr_groups[] = {
 
 static void nsim_bus_dev_release(struct device *dev)
 {
+	struct nsim_bus_dev *nsim_bus_dev;
+
+	nsim_bus_dev = container_of(dev, struct nsim_bus_dev, dev);
+	kfree(nsim_bus_dev);
 }
 
 static struct device_type nsim_bus_dev_type = {
@@ -291,6 +295,8 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queu
 
 err_nsim_bus_dev_id_free:
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
+	put_device(&nsim_bus_dev->dev);
+	nsim_bus_dev = NULL;
 err_nsim_bus_dev_free:
 	kfree(nsim_bus_dev);
 	return ERR_PTR(err);
@@ -300,9 +306,8 @@ static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 {
 	/* Disallow using nsim_bus_dev */
 	smp_store_release(&nsim_bus_dev->init, false);
-	device_unregister(&nsim_bus_dev->dev);
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
-	kfree(nsim_bus_dev);
+	device_unregister(&nsim_bus_dev->dev);
 }
 
 static struct device_driver nsim_driver = {
-- 
2.35.1



