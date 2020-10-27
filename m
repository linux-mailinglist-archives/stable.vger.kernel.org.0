Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93C29B51E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793782AbgJ0PIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755003AbgJ0PHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A9A6206F4;
        Tue, 27 Oct 2020 15:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811272;
        bh=We996f3Yt0RlMfvEgD/QJQy46NEviZymVLgf3GEBbvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eywQ9O/VxuRbbGF59zHM0s4GGzOR8JpJynn4nYATPcPQJ/wAT0ESj5f+CLyVgyjya
         eUVTHuNMxxhFDV8IMndJGyJCoYJunAGMJWpcGhXt5eBCX8PxSi2FmZdnq1tb440Ti1
         KHBp5HwCRr+2M9NzT7XwVzv63dgWvD00H2zdmLL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 434/633] rpmsg: Avoid double-free in mtk_rpmsg_register_device
Date:   Tue, 27 Oct 2020 14:52:57 +0100
Message-Id: <20201027135543.087484945@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit 231331b2dbd71487159a0400d9ffd967eb0d0e08 ]

If rpmsg_register_device fails, it will call
mtk_rpmsg_release_device which already frees mdev.

Fixes: 7017996951fd ("rpmsg: add rpmsg support for mt8183 SCP.")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200903080547.v3.1.I56cf27cd59f4013bd074dc622c8b8248b034a4cc@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/mtk_rpmsg.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/rpmsg/mtk_rpmsg.c b/drivers/rpmsg/mtk_rpmsg.c
index 83f2b8804ee98..96a17ec291401 100644
--- a/drivers/rpmsg/mtk_rpmsg.c
+++ b/drivers/rpmsg/mtk_rpmsg.c
@@ -200,7 +200,6 @@ static int mtk_rpmsg_register_device(struct mtk_rpmsg_rproc_subdev *mtk_subdev,
 	struct rpmsg_device *rpdev;
 	struct mtk_rpmsg_device *mdev;
 	struct platform_device *pdev = mtk_subdev->pdev;
-	int ret;
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
@@ -219,13 +218,7 @@ static int mtk_rpmsg_register_device(struct mtk_rpmsg_rproc_subdev *mtk_subdev,
 	rpdev->dev.parent = &pdev->dev;
 	rpdev->dev.release = mtk_rpmsg_release_device;
 
-	ret = rpmsg_register_device(rpdev);
-	if (ret) {
-		kfree(mdev);
-		return ret;
-	}
-
-	return 0;
+	return rpmsg_register_device(rpdev);
 }
 
 static void mtk_register_device_work_function(struct work_struct *register_work)
-- 
2.25.1



