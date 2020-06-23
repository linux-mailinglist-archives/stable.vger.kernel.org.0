Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B04205F3C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391152AbgFWUat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391057AbgFWU3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:29:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43ED42064B;
        Tue, 23 Jun 2020 20:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944191;
        bh=VBdzvVfhqazPp12xh0vochK2TNE8hSqZV2m7XV3otm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpYxCPgJ+J3aM5L3uoezPcYPlfnhQVq7BPwgWEc0uNMRwv9Iyz5T3nN8lQpheweJm
         RH6mwhbD6JjktKjyaQsCm4+FcCq688E+vOdJ3wyFfQ8XYxYvJhWaeJbhUnhw7AFTVJ
         3IFEqZCAiIIQbodwFOhqTe6EluHGXqWNYhb03J6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 209/314] drm/nouveau/disp/gm200-: fix NV_PDISP_SOR_HDMI2_CTRL(n) selection
Date:   Tue, 23 Jun 2020 21:56:44 +0200
Message-Id: <20200623195348.887652076@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9b16a08eb4d9f..bf6d41fb0c9fe 100644
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



