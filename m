Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D7765818F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbiL1Q3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiL1Q3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D111ADB4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87E306157B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966C9C433D2;
        Wed, 28 Dec 2022 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244722;
        bh=2q1vrMX8UCs1gsDCdclOCLM0Gx3S0BaTH5j2LUQGrb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UtS2SUPizQf4M46EyAGtdt1XgbT6uiCRBHGofEwCahvhl1oH/2IvWJ7qvt10xQO4
         xhlUgyo7zCe3QRLRxrhK7tIJMQ3WZyt5bJluMq5NwACjBX0tUHcvOwp0STMg9jJT7Z
         FrnyPbH8C3tnfkVNvLJYcDapRcbs64bYVY06QvOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Yang Shen <shenyang39@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0725/1146] coresight: trbe: remove cpuhp instance node before remove cpuhp state
Date:   Wed, 28 Dec 2022 15:37:44 +0100
Message-Id: <20221228144349.837683915@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yang Shen <shenyang39@huawei.com>

[ Upstream commit 20ee8c223f792947378196307d8e707c9cdc2d61 ]

cpuhp_state_add_instance() and cpuhp_state_remove_instance() should
be used in pairs. Or there will lead to the warn on
cpuhp_remove_multi_state() since the cpuhp_step list is not empty.

The following is the error log with 'rmmod coresight-trbe':
Error: Removing state 215 which has instances left.
Call trace:
  __cpuhp_remove_state_cpuslocked+0x144/0x160
  __cpuhp_remove_state+0xac/0x100
  arm_trbe_device_remove+0x2c/0x60 [coresight_trbe]
  platform_remove+0x34/0x70
  device_remove+0x54/0x90
  device_release_driver_internal+0x1e4/0x250
  driver_detach+0x5c/0xb0
  bus_remove_driver+0x64/0xc0
  driver_unregister+0x3c/0x70
  platform_driver_unregister+0x20/0x30
  arm_trbe_exit+0x1c/0x658 [coresight_trbe]
  __arm64_sys_delete_module+0x1ac/0x24c
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0x58/0x1a0
  do_el0_svc+0x38/0xd0
  el0_svc+0x2c/0xc0
  el0t_64_sync_handler+0x1ac/0x1b0
  el0t_64_sync+0x19c/0x1a0
 ---[ end trace 0000000000000000 ]---

Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20221122090355.23533-1-shenyang39@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 2b386bb848f8..1fc4fd79a1c6 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1434,6 +1434,7 @@ static int arm_trbe_probe_cpuhp(struct trbe_drvdata *drvdata)
 
 static void arm_trbe_remove_cpuhp(struct trbe_drvdata *drvdata)
 {
+	cpuhp_state_remove_instance(drvdata->trbe_online, &drvdata->hotplug_node);
 	cpuhp_remove_multi_state(drvdata->trbe_online);
 }
 
-- 
2.35.1



