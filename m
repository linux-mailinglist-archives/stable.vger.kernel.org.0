Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99356303392
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbhAZE6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731070AbhAYSuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B4F20679;
        Mon, 25 Jan 2021 18:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600571;
        bh=MJksqXmuYaGUzjr4jC6xeLEyWJivFShEUeqd9qu+zGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9UROJK6+S4E/burVp55KfuiJcuUy8owVhEuwQSPu6uBQUblAQBReHCqzQbY8CK+v
         12o3E2BwfsFpnHr4dCmOeRh2rn0GCj4yRIYl0xHnMLmhP6zf7GRlgXa9/B+XhkrLcR
         fu70ns4WSVdPYvNUIvIDS/jf+KR6zj/tjNW1cwkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/199] drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields
Date:   Mon, 25 Jan 2021 19:38:09 +0100
Message-Id: <20210125183219.096400419@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



