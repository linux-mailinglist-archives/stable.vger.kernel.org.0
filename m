Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9A2500F40
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbiDNNZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244086AbiDNNYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:24:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FD725EE;
        Thu, 14 Apr 2022 06:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3FCBB82983;
        Thu, 14 Apr 2022 13:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4CFC385A5;
        Thu, 14 Apr 2022 13:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942358;
        bh=lnD7yt6YO2cGIAKs7gyBGH38eExMGroxm8P3My8bq/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AO5YrPbC0XmxMA57l6gFe8pOKAOkK0SnN5M1HUVCDVMmhGaA90tnO1yx1Fe4tov8K
         XGULWs0GcgRjYSunn33/L/SThgyW3lM8GR+7vdm9UKHm3uH2O76D6XnGYFXhYaowPd
         NESmL5sLZDrdAONp9i3JuC4vxwZIzkq5FMqildng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/338] media: stk1160: If start stream fails, return buffers with VB2_BUF_STATE_QUEUED
Date:   Thu, 14 Apr 2022 15:10:08 +0200
Message-Id: <20220414110841.891429206@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit fbe04b49a54e31f4321d632270207f0e6304cd16 ]

If the callback 'start_streaming' fails, then all
queued buffers in the driver should be returned with
state 'VB2_BUF_STATE_QUEUED'. Currently, they are
returned with 'VB2_BUF_STATE_ERROR' which is wrong.
Fix this. This also fixes the warning:

[   65.583633] WARNING: CPU: 5 PID: 593 at drivers/media/common/videobuf2/videobuf2-core.c:1612 vb2_start_streaming+0xd4/0x160 [videobuf2_common]
[   65.585027] Modules linked in: snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_soc_hdmi_codec dw_hdmi_i2s_audio saa7115 stk1160 videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc crct10dif_ce panfrost snd_soc_simple_card snd_soc_audio_graph_card snd_soc_spdif_tx snd_soc_simple_card_utils gpu_sched phy_rockchip_pcie snd_soc_rockchip_i2s rockchipdrm analogix_dp dw_mipi_dsi dw_hdmi cec drm_kms_helper drm rtc_rk808 rockchip_saradc industrialio_triggered_buffer kfifo_buf rockchip_thermal pcie_rockchip_host ip_tables x_tables ipv6
[   65.589383] CPU: 5 PID: 593 Comm: v4l2src0:src Tainted: G        W         5.16.0-rc4-62408-g32447129cb30-dirty #14
[   65.590293] Hardware name: Radxa ROCK Pi 4B (DT)
[   65.590696] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   65.591304] pc : vb2_start_streaming+0xd4/0x160 [videobuf2_common]
[   65.591850] lr : vb2_start_streaming+0x6c/0x160 [videobuf2_common]
[   65.592395] sp : ffff800012bc3ad0
[   65.592685] x29: ffff800012bc3ad0 x28: 0000000000000000 x27: ffff800012bc3cd8
[   65.593312] x26: 0000000000000000 x25: ffff00000d8a7800 x24: 0000000040045612
[   65.593938] x23: ffff800011323000 x22: ffff800012bc3cd8 x21: ffff00000908a8b0
[   65.594562] x20: ffff00000908a8c8 x19: 00000000fffffff4 x18: ffffffffffffffff
[   65.595188] x17: 000000040044ffff x16: 00400034b5503510 x15: ffff800011323f78
[   65.595813] x14: ffff000013163886 x13: ffff000013163885 x12: 00000000000002ce
[   65.596439] x11: 0000000000000028 x10: 0000000000000001 x9 : 0000000000000228
[   65.597064] x8 : 0101010101010101 x7 : 7f7f7f7f7f7f7f7f x6 : fefefeff726c5e78
[   65.597690] x5 : ffff800012bc3990 x4 : 0000000000000000 x3 : ffff000009a34880
[   65.598315] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000007cd99f0
[   65.598940] Call trace:
[   65.599155]  vb2_start_streaming+0xd4/0x160 [videobuf2_common]
[   65.599672]  vb2_core_streamon+0x17c/0x1a8 [videobuf2_common]
[   65.600179]  vb2_streamon+0x54/0x88 [videobuf2_v4l2]
[   65.600619]  vb2_ioctl_streamon+0x54/0x60 [videobuf2_v4l2]
[   65.601103]  v4l_streamon+0x3c/0x50 [videodev]
[   65.601521]  __video_do_ioctl+0x1a4/0x428 [videodev]
[   65.601977]  video_usercopy+0x320/0x828 [videodev]
[   65.602419]  video_ioctl2+0x3c/0x58 [videodev]
[   65.602830]  v4l2_ioctl+0x60/0x90 [videodev]
[   65.603227]  __arm64_sys_ioctl+0xa8/0xe0
[   65.603576]  invoke_syscall+0x54/0x118
[   65.603911]  el0_svc_common.constprop.3+0x84/0x100
[   65.604332]  do_el0_svc+0x34/0xa0
[   65.604625]  el0_svc+0x1c/0x50
[   65.604897]  el0t_64_sync_handler+0x88/0xb0
[   65.605264]  el0t_64_sync+0x16c/0x170
[   65.605587] ---[ end trace 578e0ba07742170d ]---

Fixes: 8ac456495a33d ("[media] stk1160: Stop device and unqueue buffers when start_streaming() fails")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/stk1160/stk1160-core.c |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c  | 10 +++++-----
 drivers/media/usb/stk1160/stk1160.h      |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index bb0db4cdc6c7..271994bfe9c5 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -413,7 +413,7 @@ static void stk1160_disconnect(struct usb_interface *interface)
 	/* Here is the only place where isoc get released */
 	stk1160_uninit_isoc(dev);
 
-	stk1160_clear_queue(dev);
+	stk1160_clear_queue(dev, VB2_BUF_STATE_ERROR);
 
 	video_unregister_device(&dev->vdev);
 	v4l2_device_disconnect(&dev->v4l2_dev);
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 504e413edcd2..381f9f189bb7 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -269,7 +269,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
 	stk1160_uninit_isoc(dev);
 out_stop_hw:
 	usb_set_interface(dev->udev, 0, 0);
-	stk1160_clear_queue(dev);
+	stk1160_clear_queue(dev, VB2_BUF_STATE_QUEUED);
 
 	mutex_unlock(&dev->v4l_lock);
 
@@ -317,7 +317,7 @@ static int stk1160_stop_streaming(struct stk1160 *dev)
 
 	stk1160_stop_hw(dev);
 
-	stk1160_clear_queue(dev);
+	stk1160_clear_queue(dev, VB2_BUF_STATE_ERROR);
 
 	stk1160_dbg("streaming stopped\n");
 
@@ -762,7 +762,7 @@ static const struct video_device v4l_template = {
 /********************************************************************/
 
 /* Must be called with both v4l_lock and vb_queue_lock hold */
-void stk1160_clear_queue(struct stk1160 *dev)
+void stk1160_clear_queue(struct stk1160 *dev, enum vb2_buffer_state vb2_state)
 {
 	struct stk1160_buffer *buf;
 	unsigned long flags;
@@ -773,7 +773,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = list_first_entry(&dev->avail_bufs,
 			struct stk1160_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, vb2_state);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
 			    buf, buf->vb.vb2_buf.index);
 	}
@@ -783,7 +783,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = dev->isoc_ctl.buf;
 		dev->isoc_ctl.buf = NULL;
 
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, vb2_state);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
 			    buf, buf->vb.vb2_buf.index);
 	}
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index acd1c811db08..54a046aacd33 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -177,7 +177,7 @@ struct regval {
 int stk1160_vb2_setup(struct stk1160 *dev);
 int stk1160_video_register(struct stk1160 *dev);
 void stk1160_video_unregister(struct stk1160 *dev);
-void stk1160_clear_queue(struct stk1160 *dev);
+void stk1160_clear_queue(struct stk1160 *dev, enum vb2_buffer_state vb2_state);
 
 /* Provided by stk1160-video.c */
 int stk1160_alloc_isoc(struct stk1160 *dev);
-- 
2.34.1



