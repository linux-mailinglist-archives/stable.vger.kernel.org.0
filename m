Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6536BCF94
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfIXQ64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410405AbfIXQri (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:47:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DB220673;
        Tue, 24 Sep 2019 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343657;
        bh=xnovLF+3uh2WwoA52FYSiy8zjjoMSiF+mmojNkCbgjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/BP3fwns5wEeGwubLKxMgVosRRw8RKtLurfFXTRafDMpG8aPv2K35slqEEwM6KQG
         DN1hwgciWOgOugx3UR5FQTWTtk7FDdTSbNTCsn5uSjYC2WmD26dQLVNWoiFgPj6Bvu
         Ln775SvcZVWRd1HqGKhPmtsHZkWHwbNwtKLxSWvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Menzynski <mmenzyns@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 43/70] drm/nouveau/volt: Fix for some cards having 0 maximum voltage
Date:   Tue, 24 Sep 2019 12:45:22 -0400
Message-Id: <20190924164549.27058-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164549.27058-1-sashal@kernel.org>
References: <20190924164549.27058-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Menzynski <mmenzyns@redhat.com>

[ Upstream commit a1af2afbd244089560794c260b2d4326a86e39b6 ]

Some, mostly Fermi, vbioses appear to have zero max voltage. That causes Nouveau to not parse voltage entries, thus users not being able to set higher clocks.

When changing this value Nvidia driver still appeared to ignore it, and I wasn't able to find out why, thus the code is ignoring the value if it is zero.

CC: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Mark Menzynski <mmenzyns@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c
index 7143ea4611aa3..33a9fb5ac5585 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c
@@ -96,6 +96,8 @@ nvbios_volt_parse(struct nvkm_bios *bios, u8 *ver, u8 *hdr, u8 *cnt, u8 *len,
 		info->min     = min(info->base,
 				    info->base + info->step * info->vidmask);
 		info->max     = nvbios_rd32(bios, volt + 0x0e);
+		if (!info->max)
+			info->max = max(info->base, info->base + info->step * info->vidmask);
 		break;
 	case 0x50:
 		info->min     = nvbios_rd32(bios, volt + 0x0a);
-- 
2.20.1

