Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B9621447
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiKHN7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiKHN7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:59:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE9C528A4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:59:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A011B81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD862C433C1;
        Tue,  8 Nov 2022 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915968;
        bh=i3+7Jh+bNuw+hrRbkD24SMVNEGmvAB+40hHQDN1HIE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdgNbcTbGw7W9jcUx/0FtHOdpBdy0pYifAf9RSzedWFXSgsLiprs/+vmLcqM/YWKO
         6SedOfOXD2Usyr0ePTBn4PcQ5xeXwXBUfbGiPy91EdUAHLKsM9Rj+SE2pHWHGiwhjC
         gPYJsHJN8sGzTclv3IKYJsBVOBvb5mi52MBQaVXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/144] RDMA/core: Fix null-ptr-deref in ib_core_cleanup()
Date:   Tue,  8 Nov 2022 14:38:22 +0100
Message-Id: <20221108133346.358560543@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 07c0d131cc0fe1f3981a42958fc52d573d303d89 ]

KASAN reported a null-ptr-deref error:

  KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
  CPU: 1 PID: 379
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
  RIP: 0010:destroy_workqueue+0x2f/0x740
  RSP: 0018:ffff888016137df8 EFLAGS: 00000202
  ...
  Call Trace:
   ib_core_cleanup+0xa/0xa1 [ib_core]
   __do_sys_delete_module.constprop.0+0x34f/0x5b0
   do_syscall_64+0x3a/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x7fa1a0d221b7
  ...

It is because the fail of roce_gid_mgmt_init() is ignored:

 ib_core_init()
   roce_gid_mgmt_init()
     gid_cache_wq = alloc_ordered_workqueue # fail
 ...
 ib_core_cleanup()
   roce_gid_mgmt_cleanup()
     destroy_workqueue(gid_cache_wq)
     # destroy an unallocated wq

Fix this by catching the fail of roce_gid_mgmt_init() in ib_core_init().

Fixes: 03db3a2d81e6 ("IB/core: Add RoCE GID table management")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221025024146.109137-1-chenzhongjin@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 10 +++++++++-
 drivers/infiniband/core/nldev.c  |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 6ab46648af90..1519379b116e 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2814,10 +2814,18 @@ static int __init ib_core_init(void)
 
 	nldev_init();
 	rdma_nl_register(RDMA_NL_LS, ibnl_ls_cb_table);
-	roce_gid_mgmt_init();
+	ret = roce_gid_mgmt_init();
+	if (ret) {
+		pr_warn("Couldn't init RoCE GID management\n");
+		goto err_parent;
+	}
 
 	return 0;
 
+err_parent:
+	rdma_nl_unregister(RDMA_NL_LS);
+	nldev_exit();
+	unregister_pernet_device(&rdma_dev_net_ops);
 err_compat:
 	unregister_blocking_lsm_notifier(&ibdev_lsm_nb);
 err_sa:
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index e9b4b2cccaa0..cd89e59cbe33 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2349,7 +2349,7 @@ void __init nldev_init(void)
 	rdma_nl_register(RDMA_NL_NLDEV, nldev_cb_table);
 }
 
-void __exit nldev_exit(void)
+void nldev_exit(void)
 {
 	rdma_nl_unregister(RDMA_NL_NLDEV);
 }
-- 
2.35.1



