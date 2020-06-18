Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521321FE654
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgFRBOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbgFRBOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EDD821D7B;
        Thu, 18 Jun 2020 01:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442891;
        bh=mIJ1TUXp7dszAtRrMyJYmXKkKV2repG8ZIcsS6zctIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTWvIGZS2MrSC/X735ehRXNLIFjta010kH1iqXTcfcAa+a1r8PrJAHl67pd6KKcit
         ei2LC2C/0TcGnR7ZroLmOJh5QlZVzTE72K3wbtFQ3CxbusFsxRXAz9Ro5dGjR28V7m
         rT+MVcTWdQXzFd8QKrfgKRyVE55duCm4cU/+H1fY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 314/388] drm/nouveau/disp/gm200-: fix NV_PDISP_SOR_HDMI2_CTRL(n) selection
Date:   Wed, 17 Jun 2020 21:06:51 -0400
Message-Id: <20200618010805.600873-314-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit a1ef8bad506e4ffa0c57ac5f8cb99ab5cbc3b1fc ]

This is a SOR register, and not indexed by the bound head.

Fixes display not coming up on high-bandwidth HDMI displays under a
number of configurations.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigm200.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigm200.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigm200.c
index 9b16a08eb4d9..bf6d41fb0c9f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigm200.c
@@ -27,10 +27,10 @@ void
 gm200_hdmi_scdc(struct nvkm_ior *ior, int head, u8 scdc)
 {
 	struct nvkm_device *device = ior->disp->engine.subdev.device;
-	const u32 hoff = head * 0x800;
+	const u32 soff = nv50_ior_base(ior);
 	const u32 ctrl = scdc & 0x3;
 
-	nvkm_mask(device, 0x61c5bc + hoff, 0x00000003, ctrl);
+	nvkm_mask(device, 0x61c5bc + soff, 0x00000003, ctrl);
 
 	ior->tmds.high_speed = !!(scdc & 0x2);
 }
-- 
2.25.1

