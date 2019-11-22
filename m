Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2387106EB8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbfKVLA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbfKVLAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 167FB20706;
        Fri, 22 Nov 2019 11:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420448;
        bh=VZ69EaVF1a9oQj7zBLNDMh1JGIjNLhQeYaadd78Ayrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VY+kL1bJ1xMrX1BxAFg1bgftH1UfQO6+j5jQeDgUcus52es/lSEQPPTFWgbUpSGTc
         gGqHGgAdDvh7Xr5aITT/Ca5VNlygFgJkgMpd5fEcEgrlSnQ9aC56UhPGcqzP4tSrLF
         wWu1KWSK+Kg+5PLWcJ8FomtiWjqylY8e+tys3QN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/220] mtd: physmap_of: Release resources on error
Date:   Fri, 22 Nov 2019 11:27:54 +0100
Message-Id: <20191122100920.607987616@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

[ Upstream commit ef0de747f7ad179c7698a5b0e28db05f18ecbf57 ]

During probe, if there was an error the memory region and the memory
map were not properly released.This can lead a system unusable if
deferred probe is in use.

Replace mem_request and map with devm_ioremap_resource

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/physmap_of_core.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/maps/physmap_of_core.c b/drivers/mtd/maps/physmap_of_core.c
index 4129535b8e46f..ece605d78c215 100644
--- a/drivers/mtd/maps/physmap_of_core.c
+++ b/drivers/mtd/maps/physmap_of_core.c
@@ -31,7 +31,6 @@
 struct of_flash_list {
 	struct mtd_info *mtd;
 	struct map_info map;
-	struct resource *res;
 };
 
 struct of_flash {
@@ -56,18 +55,10 @@ static int of_flash_remove(struct platform_device *dev)
 			mtd_concat_destroy(info->cmtd);
 	}
 
-	for (i = 0; i < info->list_size; i++) {
+	for (i = 0; i < info->list_size; i++)
 		if (info->list[i].mtd)
 			map_destroy(info->list[i].mtd);
 
-		if (info->list[i].map.virt)
-			iounmap(info->list[i].map.virt);
-
-		if (info->list[i].res) {
-			release_resource(info->list[i].res);
-			kfree(info->list[i].res);
-		}
-	}
 	return 0;
 }
 
@@ -215,10 +206,11 @@ static int of_flash_probe(struct platform_device *dev)
 
 		err = -EBUSY;
 		res_size = resource_size(&res);
-		info->list[i].res = request_mem_region(res.start, res_size,
-						       dev_name(&dev->dev));
-		if (!info->list[i].res)
+		info->list[i].map.virt = devm_ioremap_resource(&dev->dev, &res);
+		if (IS_ERR(info->list[i].map.virt)) {
+			err = PTR_ERR(info->list[i].map.virt);
 			goto err_out;
+		}
 
 		err = -ENXIO;
 		width = of_get_property(dp, "bank-width", NULL);
@@ -246,15 +238,6 @@ static int of_flash_probe(struct platform_device *dev)
 		if (err)
 			goto err_out;
 
-		err = -ENOMEM;
-		info->list[i].map.virt = ioremap(info->list[i].map.phys,
-						 info->list[i].map.size);
-		if (!info->list[i].map.virt) {
-			dev_err(&dev->dev, "Failed to ioremap() flash"
-				" region\n");
-			goto err_out;
-		}
-
 		simple_map_init(&info->list[i].map);
 
 		/*
-- 
2.20.1



