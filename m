Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416A676935
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388758AbfGZNuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387659AbfGZNoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBD022BF5;
        Fri, 26 Jul 2019 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148671;
        bh=sGdTX6qKLjso5PUS4UyRoXjmf1z7TAMwe0dJsMXsIs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9V/c/YrW+FIXLslmUTT1TD8YGfTc0R16TKobI57+riL6rzGKRxwm08B5/O5HIU0h
         jlZF2HFvTsGEuXFRa/vN35TM4mBm5ufAC42xPEtRhXf2w2mjupv2eP/daSGfc9UWbJ
         pVuTXmb+qB0FpwYvDpElsmIiyjwc9R0KvxYJy9o8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongxin Liu <yongxin.liu@windriver.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 37/37] drm/nouveau: fix memory leak in nouveau_conn_reset()
Date:   Fri, 26 Jul 2019 09:43:32 -0400
Message-Id: <20190726134332.12626-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongxin Liu <yongxin.liu@windriver.com>

[ Upstream commit 09b90e2fe35faeace2488234e2a7728f2ea8ba26 ]

In nouveau_conn_reset(), if connector->state is true,
__drm_atomic_helper_connector_destroy_state() will be called,
but the memory pointed by asyc isn't freed. Memory leak happens
in the following function __drm_atomic_helper_connector_reset(),
where newly allocated asyc->state will be assigned to connector->state.

So using nouveau_conn_atomic_destroy_state() instead of
__drm_atomic_helper_connector_destroy_state to free the "old" asyc.

Here the is the log showing memory leak.

unreferenced object 0xffff8c5480483c80 (size 192):
  comm "kworker/0:2", pid 188, jiffies 4294695279 (age 53.179s)
  hex dump (first 32 bytes):
    00 f0 ba 7b 54 8c ff ff 00 00 00 00 00 00 00 00  ...{T...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000005005c0d0>] kmem_cache_alloc_trace+0x195/0x2c0
    [<00000000a122baed>] nouveau_conn_reset+0x25/0xc0 [nouveau]
    [<000000004fd189a2>] nouveau_connector_create+0x3a7/0x610 [nouveau]
    [<00000000c73343a8>] nv50_display_create+0x343/0x980 [nouveau]
    [<000000002e2b03c3>] nouveau_display_create+0x51f/0x660 [nouveau]
    [<00000000c924699b>] nouveau_drm_device_init+0x182/0x7f0 [nouveau]
    [<00000000cc029436>] nouveau_drm_probe+0x20c/0x2c0 [nouveau]
    [<000000007e961c3e>] local_pci_probe+0x47/0xa0
    [<00000000da14d569>] work_for_cpu_fn+0x1a/0x30
    [<0000000028da4805>] process_one_work+0x27c/0x660
    [<000000001d415b04>] worker_thread+0x22b/0x3f0
    [<0000000003b69f1f>] kthread+0x12f/0x150
    [<00000000c94c29b7>] ret_from_fork+0x3a/0x50

Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 2c6d19683688..4a7d50a96d36 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -251,7 +251,7 @@ nouveau_conn_reset(struct drm_connector *connector)
 		return;
 
 	if (connector->state)
-		__drm_atomic_helper_connector_destroy_state(connector->state);
+		nouveau_conn_atomic_destroy_state(connector, connector->state);
 	__drm_atomic_helper_connector_reset(connector, &asyc->state);
 	asyc->dither.mode = DITHERING_MODE_AUTO;
 	asyc->dither.depth = DITHERING_DEPTH_AUTO;
-- 
2.20.1

