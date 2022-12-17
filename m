Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6F64F5DA
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiLQANl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLQAMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:12:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1561340825;
        Fri, 16 Dec 2022 16:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E63622D4;
        Sat, 17 Dec 2022 00:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EECC433F0;
        Sat, 17 Dec 2022 00:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235871;
        bh=XQ77/NIn43nPV6FOhatGAzc+UK1dL+UTMKzIc3Bguac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMeyBF2u3bpIQAtPzxcZrZ/m0m03QGTCOHJ80fw6h3hI+dyY4URSvKZ7gT80q6CH+
         4j2DsHHU0bk3fMI05UF/dcfEbxgzucUCs5AYhAGNZuEx7TQxJCuALCf4gD0wge4SCI
         MiWTbn0x6sc50bPE1ODx9kH/xerRtgFqPaRocUx4nNd1qKmwi25y957rcIkQFiu6Wj
         d58u5lO+35qxfzhUNFG3k9wIUO8qqhcAULss6/pKqXhqGqiMz/0Jmca/UpR0dkk/M5
         6v7fVPrM7TMMvlioym4orc7Jd6gNXjSxxPQFDsImK85Dl2cCQk3Q0X2vBqLv10J7md
         dHehQrNk8cidA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Fabio A M Martins <fabiomirmar@gmail.com>,
        Sasha Levin <sashal@kernel.org>, deller@gmx.de,
        linux-hyperv@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 3/5] video: hyperv_fb: Avoid taking busy spinlock on panic path
Date:   Fri, 16 Dec 2022 19:10:55 -0500
Message-Id: <20221217001058.41426-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001058.41426-1-sashal@kernel.org>
References: <20221217001058.41426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>

[ Upstream commit 1d044ca035dc22df0d3b39e56f2881071d9118bd ]

The Hyper-V framebuffer code registers a panic notifier in order
to try updating its fbdev if the kernel crashed. The notifier
callback is straightforward, but it calls the vmbus_sendpacket()
routine eventually, and such function takes a spinlock for the
ring buffer operations.

Panic path runs in atomic context, with local interrupts and
preemption disabled, and all secondary CPUs shutdown. That said,
taking a spinlock might cause a lockup if a secondary CPU was
disabled with such lock taken. Fix it here by checking if the
ring buffer spinlock is busy on Hyper-V framebuffer panic notifier;
if so, bail-out avoiding the potential lockup scenario.

Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220819221731.480795-10-gpiccoli@igalia.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/ring_buffer.c        | 13 +++++++++++++
 drivers/video/fbdev/hyperv_fb.c |  8 +++++++-
 include/linux/hyperv.h          |  2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 769851b6e74c..7ed6fad3fa8f 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -246,6 +246,19 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 	mutex_unlock(&ring_info->ring_buffer_mutex);
 }
 
+/*
+ * Check if the ring buffer spinlock is available to take or not; used on
+ * atomic contexts, like panic path (see the Hyper-V framebuffer driver).
+ */
+
+bool hv_ringbuffer_spinlock_busy(struct vmbus_channel *channel)
+{
+	struct hv_ring_buffer_info *rinfo = &channel->outbound;
+
+	return spin_is_locked(&rinfo->ring_lock);
+}
+EXPORT_SYMBOL_GPL(hv_ringbuffer_spinlock_busy);
+
 /* Write to the ring buffer. */
 int hv_ringbuffer_write(struct vmbus_channel *channel,
 			const struct kvec *kv_list, u32 kv_count)
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 40baa79f8046..f0a66a344d87 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -798,12 +798,18 @@ static void hvfb_ondemand_refresh_throttle(struct hvfb_par *par,
 static int hvfb_on_panic(struct notifier_block *nb,
 			 unsigned long e, void *p)
 {
+	struct hv_device *hdev;
 	struct hvfb_par *par;
 	struct fb_info *info;
 
 	par = container_of(nb, struct hvfb_par, hvfb_panic_nb);
-	par->synchronous_fb = true;
 	info = par->info;
+	hdev = device_to_hv_device(info->device);
+
+	if (hv_ringbuffer_spinlock_busy(hdev->channel))
+		return NOTIFY_DONE;
+
+	par->synchronous_fb = true;
 	if (par->need_docopy)
 		hvfb_docopy(par, 0, dio_fb_size);
 	synthvid_update(info, 0, 0, INT_MAX, INT_MAX);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 1ce131f29f3b..eada4d8d6587 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1269,6 +1269,8 @@ struct hv_ring_buffer_debug_info {
 int hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 				struct hv_ring_buffer_debug_info *debug_info);
 
+bool hv_ringbuffer_spinlock_busy(struct vmbus_channel *channel);
+
 /* Vmbus interface */
 #define vmbus_driver_register(driver)	\
 	__vmbus_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
-- 
2.35.1

