Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D2029C3A8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822061AbgJ0Rql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901613AbgJ0O1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:27:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C6BA20754;
        Tue, 27 Oct 2020 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808849;
        bh=geRJY0xLy8R+4B4GRoxx5jSa4RHjSi3iK571iegNvGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TIL8ollVPCVU1FDtGU159/ICJDv9bvITWUup0GvQv37TDB8Ls10TAy7bm32F9U33
         pG6ewXFLpYJYueaS7WtC5qLBdi4Eqb57PJkUGQ0GMRu5+qt2t9p0Ds0Y7iTPFoBdIj
         NrJbp2I2cknmOyOctDSJs02e3NfBmZkeIwYkVkWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/264] media: platform: sti: hva: Fix runtime PM imbalance on error
Date:   Tue, 27 Oct 2020 14:54:35 +0100
Message-Id: <20201027135440.871483767@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit d912a1d9e9afe69c6066c1ceb6bfc09063074075 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/hva/hva-hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
index 166ed30bbfce5..d826c011c0952 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -393,7 +393,7 @@ int hva_hw_probe(struct platform_device *pdev, struct hva_dev *hva)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "%s     failed to set PM\n", HVA_PREFIX);
-		goto err_clk;
+		goto err_pm;
 	}
 
 	/* check IP hardware version */
-- 
2.25.1



