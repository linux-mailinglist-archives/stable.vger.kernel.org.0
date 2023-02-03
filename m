Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689F7689616
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbjBCK1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjBCK1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:27:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8C58AC07
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:26:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11664B82A71
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DDDC433D2;
        Fri,  3 Feb 2023 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420006;
        bh=S7wEEfAUdIx5jrUJ1SbKokddBYPBiPwSPs3PZ6941d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvC4ZyLtUYds382V/exxPQSIqFZLlCuLf15FGUieCpCxpcvuOZp/kA3EhKrMWthcF
         QgnZO9Lwb9aUPzod2BLq7Evy/qNrgmU0hw07t/kRVRWf5gLBbl5gBGmqHeMzMf8F2k
         WKVpRMP1qXXiZRgxXD1gtuHPkduyVeGACOxQtYdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/134] driver core: Fix test_async_probe_init saves device in wrong array
Date:   Fri,  3 Feb 2023 11:12:34 +0100
Message-Id: <20230203101026.075163074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 9be182da0a7526f1b9a3777a336f83baa2e64d23 ]

In test_async_probe_init, second set of asynchronous devices are saved
in sync_dev[sync_id], which should be async_dev[async_id].
This makes these devices not unregistered when exit.

> modprobe test_async_driver_probe && \
> modprobe -r test_async_driver_probe && \
> modprobe test_async_driver_probe
 ...
> sysfs: cannot create duplicate filename '/devices/platform/test_async_driver.4'
> kobject_add_internal failed for test_async_driver.4 with -EEXIST,
  don't try to register things with the same name in the same directory.

Fixes: 57ea974fb871 ("driver core: Rewrite test_async_driver_probe to cover serialization and NUMA affinity")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221125063541.241328-1-chenzhongjin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/test/test_async_driver_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/test/test_async_driver_probe.c b/drivers/base/test/test_async_driver_probe.c
index 3bb7beb127a9..c157a912d673 100644
--- a/drivers/base/test/test_async_driver_probe.c
+++ b/drivers/base/test/test_async_driver_probe.c
@@ -146,7 +146,7 @@ static int __init test_async_probe_init(void)
 	calltime = ktime_get();
 	for_each_online_cpu(cpu) {
 		nid = cpu_to_node(cpu);
-		pdev = &sync_dev[sync_id];
+		pdev = &async_dev[async_id];
 
 		*pdev = test_platform_device_register_node("test_async_driver",
 							   async_id,
-- 
2.39.0



