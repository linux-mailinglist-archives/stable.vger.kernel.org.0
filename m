Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728DF29C6FB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409051AbgJ0OAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753566AbgJ0OAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:00:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BABC3218AC;
        Tue, 27 Oct 2020 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807209;
        bh=Etl385WUN4icE6iEWAybHyDVoUUE8rGg7lanvGlSY/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8+lt9plqVddAV8sijT0t/G1S7WgmYgPTKKOdSMkhjooCgbkCvwVhNyZtwj7b0CRm
         S24pF1dpuet5RguCIR4xupnmq8jPftnuunviWk5XmJUk6yPyt2NCVS34AiEo/HDTbn
         JZYgij+1t3sNWNf/7FkRbiJljISv8iRH9jZDT9h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 082/112] media: bdisp: Fix runtime PM imbalance on error
Date:   Tue, 27 Oct 2020 14:49:52 +0100
Message-Id: <20201027134904.424750125@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



