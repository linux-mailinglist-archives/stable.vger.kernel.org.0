Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFEA49A904
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321894AbiAYDUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:20:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37646 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357206AbiAXTth (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:49:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AB6FB81188;
        Mon, 24 Jan 2022 19:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A27C340E8;
        Mon, 24 Jan 2022 19:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053775;
        bh=VHxhncLM05CKD8ZqIUX3uIMUbkQi3PdPyrNZ2fAV1Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0DyD9GxutFaBBzhtWeGsxdCQcl5VpXyYjKBtKLAbi2sykJJnWkpbLsyeu/uIJT9z
         MPgNCB4RezeR54mrTqLClrUq793Bn1DynuwciwutowuHRPvFvTDIddvhsdji3/ipFq
         lUFgGZsMBVwK178HR92EPJC5Vzjis2TgbyPW2v5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/563] media: hantro: Fix probe func error path
Date:   Mon, 24 Jan 2022 19:38:57 +0100
Message-Id: <20220124184030.360088937@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 37af43b250fda6162005d47bf7c959c70d52b107 ]

If clocks for some reason couldn't be enabled, probe function returns
immediately, without disabling PM. This obviously leaves PM ref counters
unbalanced.

Fix that by jumping to appropriate error path, so effects of PM functions
are reversed.

Fixes: 775fec69008d ("media: add Rockchip VPU JPEG encoder driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index 7749ca9a8ebbf..bc97ec0a7e4af 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -829,7 +829,7 @@ static int hantro_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare(vpu->variant->num_clocks, vpu->clocks);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to prepare clocks\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
@@ -885,6 +885,7 @@ err_v4l2_unreg:
 	v4l2_device_unregister(&vpu->v4l2_dev);
 err_clk_unprepare:
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
+err_pm_disable:
 	pm_runtime_dont_use_autosuspend(vpu->dev);
 	pm_runtime_disable(vpu->dev);
 	return ret;
-- 
2.34.1



