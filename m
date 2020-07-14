Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4017121F4C7
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgGNOmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729257AbgGNOkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:40:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B68422519;
        Tue, 14 Jul 2020 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737609;
        bh=Nq5QR3iG8Cr3ox2BQ3/zYb67ZQcxz9425Pv2U2LcgGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuKHWvckfy9lpjPgDd1mtyqs+XKoidp5O77wkJTEDRyQTsKeJmIuUFdCpO+WHm0m0
         Guu2U/Vf0ikN1kCb8Rc3p1cAllXBNN6XMs+HKqWecVQnAeDb28mCgBfnJjGSoF6JGh
         2KxSZbUBi9KIs2JMOOJ/9OEixuDjfD5v7qotilp0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 12/12] drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout
Date:   Tue, 14 Jul 2020 10:39:54 -0400
Message-Id: <20200714143954.4035840-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143954.4035840-1-sashal@kernel.org>
References: <20200714143954.4035840-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 0156e76d388310a490aeb0f2fbb5b284ded3aecc ]

Tegra TRM says worst-case reply time is 1216us, and this should fix some
spurious timeouts that have been popping up.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c   | 4 ++--
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c
index c8ab1b5741a3e..db7769cb33eba 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c
@@ -118,10 +118,10 @@ g94_i2c_aux_xfer(struct nvkm_i2c_aux *obj, bool retry,
 		if (retries)
 			udelay(400);
 
-		/* transaction request, wait up to 1ms for it to complete */
+		/* transaction request, wait up to 2ms for it to complete */
 		nvkm_wr32(device, 0x00e4e4 + base, 0x00010000 | ctrl);
 
-		timeout = 1000;
+		timeout = 2000;
 		do {
 			ctrl = nvkm_rd32(device, 0x00e4e4 + base);
 			udelay(1);
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c
index 7ef60895f43a7..edb6148cbca04 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c
@@ -118,10 +118,10 @@ gm200_i2c_aux_xfer(struct nvkm_i2c_aux *obj, bool retry,
 		if (retries)
 			udelay(400);
 
-		/* transaction request, wait up to 1ms for it to complete */
+		/* transaction request, wait up to 2ms for it to complete */
 		nvkm_wr32(device, 0x00d954 + base, 0x00010000 | ctrl);
 
-		timeout = 1000;
+		timeout = 2000;
 		do {
 			ctrl = nvkm_rd32(device, 0x00d954 + base);
 			udelay(1);
-- 
2.25.1

