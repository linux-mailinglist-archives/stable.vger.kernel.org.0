Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702DA538227
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiE3OWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241391AbiE3ORd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964088FFAF;
        Mon, 30 May 2022 06:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 302A560EC3;
        Mon, 30 May 2022 13:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C81C3411F;
        Mon, 30 May 2022 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918365;
        bh=ZRBlCTHt0pyFWYQr3Ew2t9lLWa2U4S35aOox2RxugS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+LglB8FlitDGTYZYnf0Mj4AmwVFoWvtfRPe2SlUpJAzRNvzSE5B/N5KnRu7iVM4O
         nTf4+4O3fD0DbO3q0KzeuK8HIEAsM9lA4rWR/OS66+cG/XsMiN+yGnw83joLkXx8nj
         lKGLd4hOcA7uPq33jdaCEsTZ+C7MP7BgkO5cAXbw9x2NiI2lMCHfh3SHADnPiTksqb
         VSL6KiQLvT99UT5NzEZlx7QTfRZAIdzisVMVX80cBjniGB/0wMtu/RBB34i+jnXCau
         zRM8N3FcShQKTW/1rSuWZ1/mxP3O8zCe0ugzrmVBC8NlN5g/HFQggzDRLVJpd14Vwo
         WD1aAGK+TQ0UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jacob-chen@iotwrt.com,
        ezequiel@vanguardiasur.com.ar, heiko@sntech.de,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 55/76] media: rga: fix possible memory leak in rga_probe
Date:   Mon, 30 May 2022 09:43:45 -0400
Message-Id: <20220530134406.1934928-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index d99ea8973b67..e3246344fb72 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -868,7 +868,7 @@ static int rga_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_resume_and_get(rga->dev);
 	if (ret < 0)
-		goto rel_vdev;
+		goto rel_m2m;
 
 	rga->version.major = (rga_read(rga, RGA_VERSION_INFO) >> 24) & 0xFF;
 	rga->version.minor = (rga_read(rga, RGA_VERSION_INFO) >> 20) & 0x0F;
@@ -884,7 +884,7 @@ static int rga_probe(struct platform_device *pdev)
 					   DMA_ATTR_WRITE_COMBINE);
 	if (!rga->cmdbuf_virt) {
 		ret = -ENOMEM;
-		goto rel_vdev;
+		goto rel_m2m;
 	}
 
 	rga->src_mmu_pages =
@@ -921,6 +921,8 @@ static int rga_probe(struct platform_device *pdev)
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

