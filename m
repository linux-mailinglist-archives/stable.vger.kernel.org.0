Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46498CA85F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390992AbfJCQ0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391006AbfJCQ0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A48D20867;
        Thu,  3 Oct 2019 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119963;
        bh=hur19vWkAiOq3yd3smTM1bKIGxosmEdosTs5oL2XyEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+wf+UKf0WOY88XF11KwAyxpCV8tEuxD9qv3vEvG0inSCHDh9ctFyjOGm7WeO8nVT
         aoxo93L0W9vbZDV4Qhwawv/1viuXOc9cvnNFiAz2u1MVVaQQmZJe1cJd4IZ1cEIINT
         qrfX9SNy2ofkX123qiYVhHozjok8GZoFn6rXVCIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 047/313] media: exynos4-is: fix leaked of_node references
Date:   Thu,  3 Oct 2019 17:50:25 +0200
Message-Id: <20191003154537.772007236@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit da79bf41a4d170ca93cc8f3881a70d734a071c37 ]

The call to of_get_child_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
drivers/media/platform/exynos4-is/fimc-is.c:813:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 807, but without a corresponding object release within this function.
drivers/media/platform/exynos4-is/fimc-is.c:870:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 807, but without a corresponding object release within this function.
drivers/media/platform/exynos4-is/fimc-is.c:885:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 807, but without a corresponding object release within this function.
drivers/media/platform/exynos4-is/media-dev.c:545:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 541, but without a corresponding object release within this function.
drivers/media/platform/exynos4-is/media-dev.c:528:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 499, but without a corresponding object release within this function.
drivers/media/platform/exynos4-is/media-dev.c:534:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 499, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/fimc-is.c   | 1 +
 drivers/media/platform/exynos4-is/media-dev.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index e043d55133a31..b7cc8e651e327 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -806,6 +806,7 @@ static int fimc_is_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	is->pmu_regs = of_iomap(node, 0);
+	of_node_put(node);
 	if (!is->pmu_regs)
 		return -ENOMEM;
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 1b83a6ec745fb..3cece7cd73e28 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -499,6 +499,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 			continue;
 
 		ret = fimc_md_parse_port_node(fmd, port, index);
+		of_node_put(port);
 		if (ret < 0) {
 			of_node_put(node);
 			goto cleanup;
@@ -538,6 +539,7 @@ static int __of_get_csis_id(struct device_node *np)
 	if (!np)
 		return -EINVAL;
 	of_property_read_u32(np, "reg", &reg);
+	of_node_put(np);
 	return reg - FIMC_INPUT_MIPI_CSI2_0;
 }
 
-- 
2.20.1



