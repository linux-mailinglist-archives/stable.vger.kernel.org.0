Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5B15EC57
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390980AbgBNR0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:26:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390985AbgBNQIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6361B24686;
        Fri, 14 Feb 2020 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696511;
        bh=sMUNR4yGWZ+2fKyLeI7Zo66jkrR7W2W8hwkVr/geNGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewyc5AyHOs0I1Ef/SZVT85DU1shbjAgrsGsollM2stsvYhhguPx2ekrbatzmbF8Px
         BQbFqEbaxZI6Ylqp6gAOFHd/taLH0hZ0zVFHsR2GyO9LXpC5dx6ahELmKx49wqU3Ax
         WIp1lN2cKQkEvNttZOjBaSZ1ppJzJyPFOrONARy8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 313/459] drm/nouveau/fault/gv100-: fix memory leak on module unload
Date:   Fri, 14 Feb 2020 10:59:23 -0500
Message-Id: <20200214160149.11681-313-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 633cc9beeb6f9b5fa2f17a2a9d0e2790cb6c3de7 ]

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c
index ca251560d3e09..bb4a4266897c3 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c
@@ -146,6 +146,7 @@ nvkm_fault_dtor(struct nvkm_subdev *subdev)
 	struct nvkm_fault *fault = nvkm_fault(subdev);
 	int i;
 
+	nvkm_notify_fini(&fault->nrpfb);
 	nvkm_event_fini(&fault->event);
 
 	for (i = 0; i < fault->buffer_nr; i++) {
-- 
2.20.1

