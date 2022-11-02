Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7706158A4
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiKBCzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiKBCzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:55:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0452229E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:55:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CA32B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25280C433C1;
        Wed,  2 Nov 2022 02:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357736;
        bh=hthi5zfPFDWaMr1k6x5wja4+oyIfPRIQ6Ny6Cw9Wo1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHrVLNaYIfDGM7/1hX7OJSPOiqGeiFE9My12tBH5IGmaR89O9FSpnh/WdfdaljFsj
         4MhMpWFHDpJn4rLOsTXRXtZeqOPsIO6XgSezaPheIedK4PAoBOhUAaZnX29UIbGcmI
         LfNXfpI2750HddodWqnTuC2jPYjtz0zSxG1Sj6+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 221/240] netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resources_register() failed
Date:   Wed,  2 Nov 2022 03:33:16 +0100
Message-Id: <20221102022116.400179831@linuxfoundation.org>
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

[ Upstream commit 6b1da9f7126f05e857da6db24c6a04aa7974d644 ]

If some items in nsim_dev_resources_register() fail, memory leak will
occur. The following is the memory leak information.

unreferenced object 0xffff888074c02600 (size 128):
  comm "echo", pid 8159, jiffies 4294945184 (age 493.530s)
  hex dump (first 32 bytes):
    40 47 ea 89 ff ff ff ff 01 00 00 00 00 00 00 00  @G..............
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace:
    [<0000000011a31c98>] kmalloc_trace+0x22/0x60
    [<0000000027384c69>] devl_resource_register+0x144/0x4e0
    [<00000000a16db248>] nsim_drv_probe+0x37a/0x1260
    [<000000007d1f448c>] really_probe+0x20b/0xb10
    [<00000000c416848a>] __driver_probe_device+0x1b3/0x4a0
    [<00000000077e0351>] driver_probe_device+0x49/0x140
    [<0000000054f2465a>] __device_attach_driver+0x18c/0x2a0
    [<000000008538f359>] bus_for_each_drv+0x151/0x1d0
    [<0000000038e09747>] __device_attach+0x1c9/0x4e0
    [<00000000dd86e533>] bus_probe_device+0x1d5/0x280
    [<00000000839bea35>] device_add+0xae0/0x1cb0
    [<000000009c2abf46>] new_device_store+0x3b6/0x5f0
    [<00000000fb823d7f>] bus_attr_store+0x72/0xa0
    [<000000007acc4295>] sysfs_kf_write+0x106/0x160
    [<000000005f50cb4d>] kernfs_fop_write_iter+0x3a8/0x5a0
    [<0000000075eb41bf>] vfs_write+0x8f0/0xc80

Fixes: 37923ed6b8ce ("netdevsim: Add simple FIB resource controller via devlink")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e88f783c297e..f31af8f0c0d6 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -442,7 +442,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     &params);
 	if (err) {
 		pr_err("Failed to register IPv4 top resource\n");
-		goto out;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib", (u64)-1,
@@ -450,7 +450,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB resource\n");
-		return err;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
@@ -458,7 +458,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB rules resource\n");
-		return err;
+		goto err_out;
 	}
 
 	/* Resources for IPv6 */
@@ -468,7 +468,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     &params);
 	if (err) {
 		pr_err("Failed to register IPv6 top resource\n");
-		goto out;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib", (u64)-1,
@@ -476,7 +476,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB resource\n");
-		return err;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
@@ -484,7 +484,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB rules resource\n");
-		return err;
+		goto err_out;
 	}
 
 	/* Resources for nexthops */
@@ -492,8 +492,14 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_NEXTHOPS,
 				     DEVLINK_RESOURCE_ID_PARENT_TOP,
 				     &params);
+	if (err) {
+		pr_err("Failed to register NEXTHOPS resource\n");
+		goto err_out;
+	}
+	return 0;
 
-out:
+err_out:
+	devl_resources_unregister(devlink);
 	return err;
 }
 
-- 
2.35.1



