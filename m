Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFD929BC8A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810100AbgJ0Qdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802471AbgJ0PtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:49:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BC59222E9;
        Tue, 27 Oct 2020 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813743;
        bh=L2+RJXccCaMCISHwYIWzmgF0+1Wiq4nILRjct3Rac6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViJy3stqr3uHWO/JlDd7UmiASkb/ZVLUNm7sMmTgAIF3imnNDGpIV6PNMvnaA8uLQ
         ltXUClxXBgLRBgUw4UuBVlxUL2rFx+A3VbdJN0vS14KHJM+/mgYCPuNBM1hF+LgN5W
         OlPGLYNPuZO/sYFFmRuBKKWXRq2oxPfRMZDKQ+ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 656/757] media: platform: sti: hva: Fix runtime PM imbalance on error
Date:   Tue, 27 Oct 2020 14:55:06 +0100
Message-Id: <20201027135521.298484657@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index bb13348be0832..43f279e2a6a38 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -389,7 +389,7 @@ int hva_hw_probe(struct platform_device *pdev, struct hva_dev *hva)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "%s     failed to set PM\n", HVA_PREFIX);
-		goto err_clk;
+		goto err_pm;
 	}
 
 	/* check IP hardware version */
-- 
2.25.1



