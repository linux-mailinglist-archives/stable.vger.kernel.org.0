Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5EB2FC80C
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733045AbhATCbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730760AbhATB30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA44023443;
        Wed, 20 Jan 2021 01:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106079;
        bh=MJksqXmuYaGUzjr4jC6xeLEyWJivFShEUeqd9qu+zGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G05x/AzQZd3gohIhyEdgZxi7a3iH4Bj3qc7pTG+fPzVyQa8R7e9d+x6j/ulERw+3Q
         aXqQ+inM2AFN9O/U0vN85JM/ugp6LZ+ZBA7TccAR4ypm8wg/T5qJEgnmy17XkJZRci
         C2D2QNAF1kscvZOEdU4atCePnW6vE0FXT9E/v5XX6dh6TFiKkQayb/R9vG75ivS0za
         C+iCNoXyDLGc+fA/5btz18AhoKi8dfHto0a24Z7DW2bDSiv67n7ieQPUWOZLZvI6LZ
         Cn0Th6PZ0LC4D7opio3yY1P4BqRWGTQLYYtUk3vyBPQ3rpB8bYVLJBfMnMOUWBXQn0
         g1JZpw2dqeTHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 13/15] drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields
Date:   Tue, 19 Jan 2021 20:27:38 -0500
Message-Id: <20210120012740.770354-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012740.770354-1-sashal@kernel.org>
References: <20210120012740.770354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit ba6e9ab0fcf3d76e3952deb12b5f993991621d9c ]

Noticed while debugging GA102.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c
index edb6148cbca04..d0e80ad526845 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c
@@ -33,7 +33,7 @@ static void
 gm200_i2c_aux_fini(struct gm200_i2c_aux *aux)
 {
 	struct nvkm_device *device = aux->base.pad->i2c->subdev.device;
-	nvkm_mask(device, 0x00d954 + (aux->ch * 0x50), 0x00310000, 0x00000000);
+	nvkm_mask(device, 0x00d954 + (aux->ch * 0x50), 0x00710000, 0x00000000);
 }
 
 static int
@@ -54,10 +54,10 @@ gm200_i2c_aux_init(struct gm200_i2c_aux *aux)
 			AUX_ERR(&aux->base, "begin idle timeout %08x", ctrl);
 			return -EBUSY;
 		}
-	} while (ctrl & 0x03010000);
+	} while (ctrl & 0x07010000);
 
 	/* set some magic, and wait up to 1ms for it to appear */
-	nvkm_mask(device, 0x00d954 + (aux->ch * 0x50), 0x00300000, ureq);
+	nvkm_mask(device, 0x00d954 + (aux->ch * 0x50), 0x00700000, ureq);
 	timeout = 1000;
 	do {
 		ctrl = nvkm_rd32(device, 0x00d954 + (aux->ch * 0x50));
@@ -67,7 +67,7 @@ gm200_i2c_aux_init(struct gm200_i2c_aux *aux)
 			gm200_i2c_aux_fini(aux);
 			return -EBUSY;
 		}
-	} while ((ctrl & 0x03000000) != urep);
+	} while ((ctrl & 0x07000000) != urep);
 
 	return 0;
 }
-- 
2.27.0

