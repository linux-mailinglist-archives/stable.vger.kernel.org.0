Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AF6498BE0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbiAXTRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:17:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44358 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348273AbiAXTPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:15:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9281612FA;
        Mon, 24 Jan 2022 19:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D8C340E5;
        Mon, 24 Jan 2022 19:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051708;
        bh=vQxa3OKPW4dCeFASeWVK/aTkRn+gKtR3N8LvRWNxdF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N13T2ow8XYL9j0aYu2U1XpmirHEltUT4y1FEpRH0CtxVv+rTiPUGediLtr8ogBZ5U
         VbuXNXPnibF0fZ0ZBKCI6OYZ0JKnQ2jKb+QJ6h3XF3Pc8KADm7i8cl6e4L/h/vi+az
         pDiKOYJ+k6at/sHkDuk3VPHfadj9IznE6/BAvL+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/239] media: mtk-vcodec: call v4l2_m2m_ctx_release first when file is released
Date:   Mon, 24 Jan 2022 19:41:39 +0100
Message-Id: <20220124183945.080723468@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit 9f89c881bffbdffe4060ffaef3489a2830a6dd9c ]

The func v4l2_m2m_ctx_release waits for currently running jobs
to finish and then stop streaming both queues and frees the buffers.
All this should be done before the call to mtk_vcodec_enc_release
which frees the encoder handler. This fixes null-pointer dereference bug:

[  638.028076] Mem abort info:
[  638.030932]   ESR = 0x96000004
[  638.033978]   EC = 0x25: DABT (current EL), IL = 32 bits
[  638.039293]   SET = 0, FnV = 0
[  638.042338]   EA = 0, S1PTW = 0
[  638.045474]   FSC = 0x04: level 0 translation fault
[  638.050349] Data abort info:
[  638.053224]   ISV = 0, ISS = 0x00000004
[  638.057055]   CM = 0, WnR = 0
[  638.060018] user pgtable: 4k pages, 48-bit VAs, pgdp=000000012b6db000
[  638.066485] [00000000000001a0] pgd=0000000000000000, p4d=0000000000000000
[  638.073277] Internal error: Oops: 96000004 [#1] SMP
[  638.078145] Modules linked in: rfkill mtk_vcodec_dec mtk_vcodec_enc uvcvideo mtk_mdp mtk_vcodec_common videobuf2_dma_contig v4l2_h264 cdc_ether v4l2_mem2mem videobuf2_vmalloc usbnet videobuf2_memops videobuf2_v4l2 r8152 videobuf2_common videodev cros_ec_sensors cros_ec_sensors_core industrialio_triggered_buffer kfifo_buf elan_i2c elants_i2c sbs_battery mc cros_usbpd_charger cros_ec_chardev cros_usbpd_logger crct10dif_ce mtk_vpu fuse ip_tables x_tables ipv6
[  638.118583] CPU: 0 PID: 212 Comm: kworker/u8:5 Not tainted 5.15.0-06427-g58a1d4dcfc74-dirty #109
[  638.127357] Hardware name: Google Elm (DT)
[  638.131444] Workqueue: mtk-vcodec-enc mtk_venc_worker [mtk_vcodec_enc]
[  638.137974] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  638.144925] pc : vp8_enc_encode+0x34/0x2b0 [mtk_vcodec_enc]
[  638.150493] lr : venc_if_encode+0xac/0x1b0 [mtk_vcodec_enc]
[  638.156060] sp : ffff8000124d3c40
[  638.159364] x29: ffff8000124d3c40 x28: 0000000000000000 x27: 0000000000000000
[  638.166493] x26: 0000000000000000 x25: ffff0000e7f252d0 x24: ffff8000124d3d58
[  638.173621] x23: ffff8000124d3d58 x22: ffff8000124d3d60 x21: 0000000000000001
[  638.180750] x20: ffff80001137e000 x19: 0000000000000000 x18: 0000000000000001
[  638.187878] x17: 000000040044ffff x16: 00400032b5503510 x15: 0000000000000000
[  638.195006] x14: ffff8000118536c0 x13: ffff8000ee1da000 x12: 0000000030d4d91d
[  638.202134] x11: 0000000000000000 x10: 0000000000000980 x9 : ffff8000124d3b20
[  638.209262] x8 : ffff0000c18d4ea0 x7 : ffff0000c18d44c0 x6 : ffff0000c18d44c0
[  638.216391] x5 : ffff80000904a3b0 x4 : ffff8000124d3d58 x3 : ffff8000124d3d60
[  638.223519] x2 : ffff8000124d3d78 x1 : 0000000000000001 x0 : ffff80001137efb8
[  638.230648] Call trace:
[  638.233084]  vp8_enc_encode+0x34/0x2b0 [mtk_vcodec_enc]
[  638.238304]  venc_if_encode+0xac/0x1b0 [mtk_vcodec_enc]
[  638.243525]  mtk_venc_worker+0x110/0x250 [mtk_vcodec_enc]
[  638.248918]  process_one_work+0x1f8/0x498
[  638.252923]  worker_thread+0x140/0x538
[  638.256664]  kthread+0x148/0x158
[  638.259884]  ret_from_fork+0x10/0x20
[  638.263455] Code: f90023f9 2a0103f5 aa0303f6 aa0403f8 (f940d277)
[  638.269538] ---[ end trace e374fc10f8e181f5 ]---

[gst-master] root@debian:~/gst-build# [  638.019193] Unable to handle kernel NULL pointer dereference at virtual address 00000000000001a0
Fixes: 4e855a6efa547 ("[media] vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index 83f859e8509c9..b95006a864c26 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -217,11 +217,11 @@ static int fops_vcodec_release(struct file *file)
 	mtk_v4l2_debug(1, "[%d] encoder", ctx->id);
 	mutex_lock(&dev->dev_mutex);
 
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	mtk_vcodec_enc_release(ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 
 	list_del_init(&ctx->list);
 	kfree(ctx);
-- 
2.34.1



