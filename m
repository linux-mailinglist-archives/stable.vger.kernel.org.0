Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAAF594C3D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344083AbiHPAjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345133AbiHPAh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:37:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D9818B8A6;
        Mon, 15 Aug 2022 13:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F26F26121F;
        Mon, 15 Aug 2022 20:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E384CC433D6;
        Mon, 15 Aug 2022 20:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595891;
        bh=F2p/WEQeJi8ajn9AXc1MfaTPlgWmnAqr2FACq5qrus4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNYCpO6EPI/mplPxYXKVQV92PE+RjXA3+2rS3TEdB1fINXSoJklV84M/1irYYFr2q
         WFgd36r8fhCYwuX5+glJhiL2W+zsYeEMQ2aPvDp/DKUkpkpibNuLxBidb26y2a+OA8
         4GnShZrRUDF90Uq5M/pCo3AW/L1bXmcvbk4OJiOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0908/1157] rpmsg: mtk_rpmsg: Fix circular locking dependency
Date:   Mon, 15 Aug 2022 20:04:24 +0200
Message-Id: <20220815180515.773884086@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 353d9214682e65c55cdffad8c82139a3321c5f13 ]

During execution of the worker that's used to register rpmsg devices
we are safely locking the channels mutex but, when creating a new
endpoint for such devices, we are registering a IPI on the SCP, which
then makes the SCP to trigger an interrupt, lock its own mutex and in
turn register more subdevices.
This creates a circular locking dependency situation, as the mtk_rpmsg
channels_lock will then depend on the SCP IPI lock.

[   15.447736] ======================================================
[   15.460158] WARNING: possible circular locking dependency detected
[   15.460161] 5.17.0-next-20220324+ #399 Not tainted
[   15.460165] ------------------------------------------------------
[   15.460166] kworker/0:3/155 is trying to acquire lock:
[   15.460170] ffff5b4d0eaf1308 (&scp->ipi_desc[i].lock){+.+.}-{4:4}, at: scp_ipi_lock+0x34/0x50 [mtk_scp_ipi]
[   15.504958]
[]                but task is already holding lock:
[   15.504960] ffff5b4d0e8f1918 (&mtk_subdev->channels_lock){+.+.}-{4:4}, at: mtk_register_device_work_function+0x50/0x1cc [mtk_rpmsg]
[   15.504978]
[]                which lock already depends on the new lock.

[   15.504980]
[]                the existing dependency chain (in reverse order) is:
[   15.504982]
[]               -> #1 (&mtk_subdev->channels_lock){+.+.}-{4:4}:
[   15.504990]        lock_acquire+0x68/0x84
[   15.504999]        __mutex_lock+0xa4/0x3e0
[   15.505007]        mutex_lock_nested+0x40/0x70
[   15.505012]        mtk_rpmsg_ns_cb+0xe4/0x134 [mtk_rpmsg]
[   15.641684]        mtk_rpmsg_ipi_handler+0x38/0x64 [mtk_rpmsg]
[   15.641693]        scp_ipi_handler+0xbc/0x180 [mtk_scp]
[   15.663905]        mt8192_scp_irq_handler+0x44/0xa4 [mtk_scp]
[   15.663915]        scp_irq_handler+0x6c/0xa0 [mtk_scp]
[   15.685779]        irq_thread_fn+0x34/0xa0
[   15.685785]        irq_thread+0x18c/0x240
[   15.685789]        kthread+0x104/0x110
[   15.709579]        ret_from_fork+0x10/0x20
[   15.709586]
[]               -> #0 (&scp->ipi_desc[i].lock){+.+.}-{4:4}:
[   15.731271]        __lock_acquire+0x11e4/0x1910
[   15.740367]        lock_acquire.part.0+0xd8/0x220
[   15.749813]        lock_acquire+0x68/0x84
[   15.757861]        __mutex_lock+0xa4/0x3e0
[   15.766084]        mutex_lock_nested+0x40/0x70
[   15.775006]        scp_ipi_lock+0x34/0x50 [mtk_scp_ipi]
[   15.785503]        scp_ipi_register+0x40/0xa4 [mtk_scp_ipi]
[   15.796697]        scp_register_ipi+0x1c/0x30 [mtk_scp]
[   15.807194]        mtk_rpmsg_create_ept+0xa0/0x108 [mtk_rpmsg]
[   15.818912]        rpmsg_create_ept+0x44/0x60
[   15.827660]        cros_ec_rpmsg_probe+0x15c/0x1f0
[   15.837282]        rpmsg_dev_probe+0x128/0x1d0
[   15.846203]        really_probe.part.0+0xa4/0x2a0
[   15.855649]        __driver_probe_device+0xa0/0x150
[   15.865443]        driver_probe_device+0x48/0x150
[   15.877157]        __device_attach_driver+0xc0/0x12c
[   15.889359]        bus_for_each_drv+0x80/0xe0
[   15.900330]        __device_attach+0xe4/0x190
[   15.911303]        device_initial_probe+0x1c/0x2c
[   15.922969]        bus_probe_device+0xa8/0xb0
[   15.933927]        device_add+0x3a8/0x8a0
[   15.944193]        device_register+0x28/0x40
[   15.954970]        rpmsg_register_device+0x5c/0xa0
[   15.966782]        mtk_register_device_work_function+0x148/0x1cc [mtk_rpmsg]
[   15.983146]        process_one_work+0x294/0x664
[   15.994458]        worker_thread+0x7c/0x45c
[   16.005069]        kthread+0x104/0x110
[   16.014789]        ret_from_fork+0x10/0x20
[   16.025201]
[]               other info that might help us debug this:

[   16.047769]  Possible unsafe locking scenario:

[   16.063942]        CPU0                    CPU1
[   16.075166]        ----                    ----
[   16.086376]   lock(&mtk_subdev->channels_lock);
[   16.097592]                                lock(&scp->ipi_desc[i].lock);
[   16.113188]                                lock(&mtk_subdev->channels_lock);
[   16.129482]   lock(&scp->ipi_desc[i].lock);
[   16.140020]
[]                *** DEADLOCK ***

[   16.158282] 4 locks held by kworker/0:3/155:
[   16.168978]  #0: ffff5b4d00008748 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1fc/0x664
[   16.190017]  #1: ffff80000953bdc8 ((work_completion)(&mtk_subdev->register_work)){+.+.}-{0:0}, at: process_one_work+0x1fc/0x664
[   16.215269]  #2: ffff5b4d0e8f1918 (&mtk_subdev->channels_lock){+.+.}-{4:4}, at: mtk_register_device_work_function+0x50/0x1cc [mtk_rpmsg]
[   16.242131]  #3: ffff5b4d05964190 (&dev->mutex){....}-{4:4}, at: __device_attach+0x44/0x190

To solve this, simply unlock the channels_lock mutex before calling
mtk_rpmsg_register_device() and relock it right after, as safety is
still ensured by the locking mechanism that happens right after
through SCP.

Fixes: 7017996951fd ("rpmsg: add rpmsg support for mt8183 SCP.")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220525091201.14210-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/mtk_rpmsg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rpmsg/mtk_rpmsg.c b/drivers/rpmsg/mtk_rpmsg.c
index 5b4404b8be4c..d1213c33da20 100644
--- a/drivers/rpmsg/mtk_rpmsg.c
+++ b/drivers/rpmsg/mtk_rpmsg.c
@@ -234,7 +234,9 @@ static void mtk_register_device_work_function(struct work_struct *register_work)
 		if (info->registered)
 			continue;
 
+		mutex_unlock(&subdev->channels_lock);
 		ret = mtk_rpmsg_register_device(subdev, &info->info);
+		mutex_lock(&subdev->channels_lock);
 		if (ret) {
 			dev_err(&pdev->dev, "Can't create rpmsg_device\n");
 			continue;
-- 
2.35.1



