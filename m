Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB2F37CCC4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbhELQrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243540AbhELQla (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FC2661CE3;
        Wed, 12 May 2021 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835477;
        bh=6DUXciyEjmtfGO6cJaWQWSnLd81pCtVDguoeLrZeN4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRKxqhToZ6qsmP+9SCelNThGobQrYhCTNEOXsECBPCi7tTNLp6PWpQtLNF2ko64id
         wfoz4JlzJ7QQDiAi+Vnr75GfnfFSbHC3d1GB6yavJnWIjomixLA5LzyLdHVqOnCxQk
         SdXo3AyaJZQndqvmkyzcruTgxScRxSbRXDrGiZ4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 360/677] media: venus: core: Fix some resource leaks in the error path of venus_probe()
Date:   Wed, 12 May 2021 16:46:46 +0200
Message-Id: <20210512144849.286730347@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5a465c5391a856a0c1e9554964d660676c35d1b2 ]

If an error occurs after a successful 'of_icc_get()' call, it must be
undone.

Use 'devm_of_icc_get()' instead of 'of_icc_get()' to avoid the leak.
Update the remove function accordingly and axe the now unneeded
'icc_put()' calls.

Fixes: 32f0a6ddc8c9 ("media: venus: Use on-chip interconnect API")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index d2842f496b47..ae374bb2a48f 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -224,11 +224,11 @@ static int venus_probe(struct platform_device *pdev)
 	if (IS_ERR(core->base))
 		return PTR_ERR(core->base);
 
-	core->video_path = of_icc_get(dev, "video-mem");
+	core->video_path = devm_of_icc_get(dev, "video-mem");
 	if (IS_ERR(core->video_path))
 		return PTR_ERR(core->video_path);
 
-	core->cpucfg_path = of_icc_get(dev, "cpu-cfg");
+	core->cpucfg_path = devm_of_icc_get(dev, "cpu-cfg");
 	if (IS_ERR(core->cpucfg_path))
 		return PTR_ERR(core->cpucfg_path);
 
@@ -367,9 +367,6 @@ static int venus_remove(struct platform_device *pdev)
 
 	hfi_destroy(core);
 
-	icc_put(core->video_path);
-	icc_put(core->cpucfg_path);
-
 	v4l2_device_unregister(&core->v4l2_dev);
 
 	mutex_destroy(&core->pm_lock);
-- 
2.30.2



