Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1C272E0E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgIUQpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbgIUQpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC3E2399A;
        Mon, 21 Sep 2020 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706721;
        bh=xjZXQcpiIWSbrq4vUTAl/BD54Tv1jv4rLS9iNd3uiJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rI4ecV6psF8RabxVgCXrwRMe95yzGgPWe+LMOCrYvHIOWcTl38bSdn3xqSqpYvpWK
         Rn+TSiXk6SAiHYhKc2cVQxe4/L/GXCy0IuN0GZcaEMiGY41cYC8tnvcGpU18S3t4kL
         deoW3mmMWgTCl0A3qAzV/bd9ep6gV9IBFQLxe/go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 068/118] drm/mediatek: Add missing put_device() call in mtk_ddp_comp_init()
Date:   Mon, 21 Sep 2020 18:28:00 +0200
Message-Id: <20200921162039.505702820@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit d494c257271153633a05c11e6dec85ddfc7700ee ]

if of_find_device_by_node() succeed, mtk_ddp_comp_init() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: d0afe37f5209 ("drm/mediatek: support CMDQ interface in ddp component")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index 57c88de9a3293..526648885b97e 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -496,6 +496,7 @@ int mtk_ddp_comp_init(struct device *dev, struct device_node *node,
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
 	if (of_address_to_resource(node, 0, &res) != 0) {
 		dev_err(dev, "Missing reg in %s node\n", node->full_name);
+		put_device(&larb_pdev->dev);
 		return -EINVAL;
 	}
 	comp->regs_pa = res.start;
-- 
2.25.1



