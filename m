Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B521453800F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbiE3Nx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239308AbiE3Nv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10DE84A23;
        Mon, 30 May 2022 06:36:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 635EC60F78;
        Mon, 30 May 2022 13:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F92CC3411A;
        Mon, 30 May 2022 13:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917775;
        bh=phB7LXbMznbVSVQXBgVCBso+VRteL7PNg//ZRtMP2a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIS0IJSvBp8KGJdRd3t8HjBM4aTAc4X8QXHwGxHblK2WWpUC1RYM/vT7hkGRCKXdR
         baUhz9bHkbBU+F8gru/YGoEkNeMnRavEnZvsI4kfkzhDH4MeYfDIimTycEHjg7yeq8
         7KP6/w4sK670gPDIsjWKgO84YJgvV2LjxeHDVMGONswdM8S11WKiYQ99R6mv5e4L4w
         I+2R6Hn4hTkhfHjfMh1mU7/hamdn7q4OiYzAZHA7l1moWnZrbtCpeokbkGr0o7ahG+
         R621luR/CxygBmnjuGk3O7NcEY0AtBwpTDH8PR0nIYGDW/JJfgR3NAcDVgXeKvCm82
         G2+n5c19sqPiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jacob-chen@iotwrt.com,
        ezequiel@vanguardiasur.com.ar, heiko@sntech.de,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 093/135] media: rga: fix possible memory leak in rga_probe
Date:   Mon, 30 May 2022 09:30:51 -0400
Message-Id: <20220530133133.1931716-93-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit a71eb6025305192e646040cd76ccacb5bd48a1b5 ]

rga->m2m_dev needs to be freed when rga_probe fails.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 3d3d1062e212..2f8df74ad0fd 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -865,7 +865,7 @@ static int rga_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_resume_and_get(rga->dev);
 	if (ret < 0)
-		goto rel_vdev;
+		goto rel_m2m;
 
 	rga->version.major = (rga_read(rga, RGA_VERSION_INFO) >> 24) & 0xFF;
 	rga->version.minor = (rga_read(rga, RGA_VERSION_INFO) >> 20) & 0x0F;
@@ -881,7 +881,7 @@ static int rga_probe(struct platform_device *pdev)
 					   DMA_ATTR_WRITE_COMBINE);
 	if (!rga->cmdbuf_virt) {
 		ret = -ENOMEM;
-		goto rel_vdev;
+		goto rel_m2m;
 	}
 
 	rga->src_mmu_pages =
@@ -918,6 +918,8 @@ static int rga_probe(struct platform_device *pdev)
 free_dma:
 	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, rga->cmdbuf_virt,
 		       rga->cmdbuf_phy, DMA_ATTR_WRITE_COMBINE);
+rel_m2m:
+	v4l2_m2m_release(rga->m2m_dev);
 rel_vdev:
 	video_device_release(vfd);
 unreg_v4l2_dev:
-- 
2.35.1

