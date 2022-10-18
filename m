Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29A8601FC0
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJRAjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiJRAi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:38:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8087857C4;
        Mon, 17 Oct 2022 17:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AEA26135F;
        Tue, 18 Oct 2022 00:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136A9C43145;
        Tue, 18 Oct 2022 00:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051921;
        bh=4WiH9hmE57Uofm2X2goOrr7ClljV8IXJ19jH0V3IDb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr7j04xRXuJ6UOz0o1MnaNYykQ48upvgQTD+3czgcyXGXv2nbVC0gbWOsh14PUeQP
         jnq84CiSF8r8qgA4FvVp/+RflzQiDEpOlu7995EOpqUO1rfnoy25v9e2VV8NcNFcm3
         weMDBK2BiBVtq6vhtPtqg4mHVxij7qq0pXBImastw8zMgFmWuyT+mPuZp6Q88KDNpk
         pd/9ozByXy85jQhtb2x310iMn4VpORo3tg3cPqk8pbiy26aosP4M/gAZhuxoKSh0mS
         SulDmhSgr2/nIUY7pMZWg2piE8dRyk+YduO9JpJiD9vax10dlLORc0Fl/yyQ6rqB5u
         vcqxOLb2U4Y4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Angus Chen <angus.chen@jaguarmicro.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 8/8] virtio_pci: don't try to use intxif pin is zero
Date:   Mon, 17 Oct 2022 20:11:47 -0400
Message-Id: <20221018001147.2732350-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001147.2732350-1-sashal@kernel.org>
References: <20221018001147.2732350-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angus Chen <angus.chen@jaguarmicro.com>

[ Upstream commit 71491c54eafa318fdd24a1f26a1c82b28e1ac21d ]

The background is that we use dpu in cloud computing,the arch is x86,80
cores. We will have a lots of virtio devices,like 512 or more.
When we probe about 200 virtio_blk devices,it will fail and
the stack is printed as follows:

[25338.485128] virtio-pci 0000:b3:00.0: virtio_pci: leaving for legacy driver
[25338.496174] genirq: Flags mismatch irq 0. 00000080 (virtio418) vs. 00015a00 (timer)
[25338.503822] CPU: 20 PID: 5431 Comm: kworker/20:0 Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-305.30.1.el8.x86_64
[25338.516403] Hardware name: Inspur NF5280M5/YZMB-00882-10E, BIOS 4.1.21 08/25/2021
[25338.523881] Workqueue: events work_for_cpu_fn
[25338.528235] Call Trace:
[25338.530687]  dump_stack+0x5c/0x80
[25338.534000]  __setup_irq.cold.53+0x7c/0xd3
[25338.538098]  request_threaded_irq+0xf5/0x160
[25338.542371]  vp_find_vqs+0xc7/0x190
[25338.545866]  init_vq+0x17c/0x2e0 [virtio_blk]
[25338.550223]  ? ncpus_cmp_func+0x10/0x10
[25338.554061]  virtblk_probe+0xe6/0x8a0 [virtio_blk]
[25338.558846]  virtio_dev_probe+0x158/0x1f0
[25338.562861]  really_probe+0x255/0x4a0
[25338.566524]  ? __driver_attach_async_helper+0x90/0x90
[25338.571567]  driver_probe_device+0x49/0xc0
[25338.575660]  bus_for_each_drv+0x79/0xc0
[25338.579499]  __device_attach+0xdc/0x160
[25338.583337]  bus_probe_device+0x9d/0xb0
[25338.587167]  device_add+0x418/0x780
[25338.590654]  register_virtio_device+0x9e/0xe0
[25338.595011]  virtio_pci_probe+0xb3/0x140
[25338.598941]  local_pci_probe+0x41/0x90
[25338.602689]  work_for_cpu_fn+0x16/0x20
[25338.606443]  process_one_work+0x1a7/0x360
[25338.610456]  ? create_worker+0x1a0/0x1a0
[25338.614381]  worker_thread+0x1cf/0x390
[25338.618132]  ? create_worker+0x1a0/0x1a0
[25338.622051]  kthread+0x116/0x130
[25338.625283]  ? kthread_flush_work_fn+0x10/0x10
[25338.629731]  ret_from_fork+0x1f/0x40
[25338.633395] virtio_blk: probe of virtio418 failed with error -16

The log :
"genirq: Flags mismatch irq 0. 00000080 (virtio418) vs. 00015a00 (timer)"
was printed because of the irq 0 is used by timer exclusive,and when
vp_find_vqs call vp_find_vqs_msix and returns false twice (for
whatever reason), then it will call vp_find_vqs_intx as a fallback.
Because vp_dev->pci_dev->irq is zero, we request irq 0 with
flag IRQF_SHARED, and get a backtrace like above.

According to PCI spec about "Interrupt Pin" Register (Offset 3Dh):
"The Interrupt Pin register is a read-only register that identifies the
 legacy interrupt Message(s) the Function uses. Valid values are 01h, 02h,
 03h, and 04h that map to legacy interrupt Messages for INTA,
 INTB, INTC, and INTD respectively. A value of 00h indicates that the
 Function uses no legacy interrupt Message(s)."

So if vp_dev->pci_dev->pin is zero, we should not request legacy
interrupt.

Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20220930000915.548-1-angus.chen@jaguarmicro.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 924554b7010d..9f2f215a69b6 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -405,6 +405,9 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ctx, desc);
 	if (!err)
 		return 0;
+	/* Is there an interrupt pin? If not give up. */
+	if (!(to_vp_device(vdev)->pci_dev->pin))
+		return err;
 	/* Finally fall back to regular interrupts. */
 	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
 }
-- 
2.35.1

