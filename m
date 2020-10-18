Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA4291B49
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732562AbgJRTad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732145AbgJRT1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1258A22273;
        Sun, 18 Oct 2020 19:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049256;
        bh=Etl385WUN4icE6iEWAybHyDVoUUE8rGg7lanvGlSY/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBiuVrnrqt7qrHSQFFo1H+ZLMNt2iRcJlKEZnTXcP6vY8Ij2aFStVulv4n0i/2bOT
         B2Q3rLGNvGchYk9MM/PTBeiBr40ghJPtHx8O44CzQewWXSDL61+j8FH75PLXMT9xzi
         7Ilr26JOrp6HEPCYpm5OoIrEyHlbrdmHQ/jgGTz8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/33] media: bdisp: Fix runtime PM imbalance on error
Date:   Sun, 18 Oct 2020 15:27:01 -0400
Message-Id: <20201018192728.4056577-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192728.4056577-1-sashal@kernel.org>
References: <20201018192728.4056577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit dbd2f2dc025f9be8ae063e4f270099677238f620 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index a00dfaa1b945d..6c97063cb3b3f 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -1369,7 +1369,7 @@ static int bdisp_probe(struct platform_device *pdev)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "failed to set PM\n");
-		goto err_dbg;
+		goto err_pm;
 	}
 
 	/* Continuous memory allocator */
@@ -1406,7 +1406,6 @@ static int bdisp_probe(struct platform_device *pdev)
 	vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
 err_pm:
 	pm_runtime_put(dev);
-err_dbg:
 	bdisp_debugfs_remove(bdisp);
 err_v4l2:
 	v4l2_device_unregister(&bdisp->v4l2_dev);
-- 
2.25.1

