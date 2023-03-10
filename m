Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629E16B450D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjCJOal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjCJOaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1DDF601F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA3D6B822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26020C4339B;
        Fri, 10 Mar 2023 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458545;
        bh=mgUoHvibDgXBk10kzDRSATtYB+0KIf2h3FzsJ0JreAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXnTFa+LZUlZ53+ybpPlxyR+N6YPjiCPQdkNzvvbhwTwoLg694djXO5vZ5TB4H6NB
         yRFtS7VmdjVY5zphFk9RNGLMfUa3NeeWcP1J4ubiE2KvzbeYxesGXgBVoNrVYzmMnu
         hYCzeUTaCjz/eyuLJFWZfwbv03TFQ7mAnsHCeYjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladis Dronov <vdronov@redhat.com>,
        Koba Ko <koba.ko@canonical.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/357] crypto: ccp - Failure on re-initialization due to duplicate sysfs filename
Date:   Fri, 10 Mar 2023 14:35:52 +0100
Message-Id: <20230310133736.762512154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Koba Ko <koba.taiwan@gmail.com>

[ Upstream commit 299bf602b3f92f1456aef59c6413591fb02e762a ]

The following warning appears during the CCP module re-initialization:

[  140.965403] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:07.1/0000:03:00.2/dma/dma0chan0'
[  140.975736] CPU: 0 PID: 388 Comm: kworker/0:2 Kdump: loaded Not
tainted 6.2.0-0.rc2.18.eln124.x86_64 #1
[  140.985185] Hardware name: HPE ProLiant DL325 Gen10/ProLiant DL325
Gen10, BIOS A41 07/17/2020
[  140.993761] Workqueue: events work_for_cpu_fn
[  140.998151] Call Trace:
[  141.000613]  <TASK>
[  141.002726]  dump_stack_lvl+0x33/0x46
[  141.006415]  sysfs_warn_dup.cold+0x17/0x23
[  141.010542]  sysfs_create_dir_ns+0xba/0xd0
[  141.014670]  kobject_add_internal+0xba/0x260
[  141.018970]  kobject_add+0x81/0xb0
[  141.022395]  device_add+0xdc/0x7e0
[  141.025822]  ? complete_all+0x20/0x90
[  141.029510]  __dma_async_device_channel_register+0xc9/0x130
[  141.035119]  dma_async_device_register+0x19e/0x3b0
[  141.039943]  ccp_dmaengine_register+0x334/0x3f0 [ccp]
[  141.045042]  ccp5_init+0x662/0x6a0 [ccp]
[  141.049000]  ? devm_kmalloc+0x40/0xd0
[  141.052688]  ccp_dev_init+0xbb/0xf0 [ccp]
[  141.056732]  ? __pci_set_master+0x56/0xd0
[  141.060768]  sp_init+0x70/0x90 [ccp]
[  141.064377]  sp_pci_probe+0x186/0x1b0 [ccp]
[  141.068596]  local_pci_probe+0x41/0x80
[  141.072374]  work_for_cpu_fn+0x16/0x20
[  141.076145]  process_one_work+0x1c8/0x380
[  141.080181]  worker_thread+0x1ab/0x380
[  141.083953]  ? __pfx_worker_thread+0x10/0x10
[  141.088250]  kthread+0xda/0x100
[  141.091413]  ? __pfx_kthread+0x10/0x10
[  141.095185]  ret_from_fork+0x2c/0x50
[  141.098788]  </TASK>
[  141.100996] kobject_add_internal failed for dma0chan0 with -EEXIST,
don't try to register things with the same name in the same directory.
[  141.113703] ccp 0000:03:00.2: ccp initialization failed

The /dma/dma0chan0 sysfs file is not removed since dma_chan object
has been released in ccp_dma_release() before releasing dma device.
A correct procedure would be: release dma channels first => unregister
dma device => release ccp dma object.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216888
Fixes: 68dbe80f5b51 ("crypto: ccp - Release dma channels before dmaengine unrgister")
Tested-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Koba Ko <koba.ko@canonical.com>
Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-dmaengine.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index b9299defb431d..e416456b2b8aa 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -643,14 +643,26 @@ static void ccp_dma_release(struct ccp_device *ccp)
 		chan = ccp->ccp_dma_chan + i;
 		dma_chan = &chan->dma_chan;
 
-		if (dma_chan->client_count)
-			dma_release_channel(dma_chan);
-
 		tasklet_kill(&chan->cleanup_tasklet);
 		list_del_rcu(&dma_chan->device_node);
 	}
 }
 
+static void ccp_dma_release_channels(struct ccp_device *ccp)
+{
+	struct ccp_dma_chan *chan;
+	struct dma_chan *dma_chan;
+	unsigned int i;
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		chan = ccp->ccp_dma_chan + i;
+		dma_chan = &chan->dma_chan;
+
+		if (dma_chan->client_count)
+			dma_release_channel(dma_chan);
+	}
+}
+
 int ccp_dmaengine_register(struct ccp_device *ccp)
 {
 	struct ccp_dma_chan *chan;
@@ -771,8 +783,9 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	if (!dmaengine)
 		return;
 
-	ccp_dma_release(ccp);
+	ccp_dma_release_channels(ccp);
 	dma_async_device_unregister(dma_dev);
+	ccp_dma_release(ccp);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
-- 
2.39.2



