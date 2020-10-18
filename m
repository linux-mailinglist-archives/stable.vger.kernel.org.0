Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823EF291BA5
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbgJRT0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731824AbgJRT0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32CB222EB;
        Sun, 18 Oct 2020 19:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049208;
        bh=Wxi1XBhGF/wh1370KrNDn2t5GpIdHOqlEnjSG0PyVcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcUe2L6bOphGdf26XeD/Sy0JjQYnu2DVLKujMgbtr4kj9CjM4Lao8gB2yWMTt1eVc
         dZ0ret4/huTQHsUZblRz4OmiXdgio0DcHo1BeSwFRIYfj6jZmjRTnY7X+kunQR+keA
         NiTkPn86Or+07LxjOS/v29QIbfW+uLkRnNZyD4Fo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/41] media: platform: sti: hva: Fix runtime PM imbalance on error
Date:   Sun, 18 Oct 2020 15:26:03 -0400
Message-Id: <20201018192635.4056198-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192635.4056198-1-sashal@kernel.org>
References: <20201018192635.4056198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cf2a8d8845367..c4d97fb80aaec 100644
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

