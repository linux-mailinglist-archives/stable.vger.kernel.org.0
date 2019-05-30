Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52282F145
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbfE3DQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbfE3DQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF6D245DE;
        Thu, 30 May 2019 03:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186206;
        bh=UqQpgM2LIjyIonQ1lPUloHQJVx5eSfX41d1up0734sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnbBuDDAAmqI+jzft4Mf35QENSrLe8J2fQdBufeFUwLkguekYuISlX9lywaUm4a64
         WXLkwFDs+oR5vN4aEA34ZdJABO31Trxs0qZRWxNooISQc3OhTvMHTv9h8BY3un+CNN
         N3KtWdU1KwcDpU+/o2x9iluatUznA9Nyrtg8nDIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/276] slimbus: fix a potential NULL pointer dereference in of_qcom_slim_ngd_register
Date:   Wed, 29 May 2019 20:04:12 -0700
Message-Id: <20190530030532.054046669@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 06d5d6b7f9948a89543e1160ef852d57892c750d ]

In case platform_device_alloc fails, the fix returns an error
code to avoid the NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 14a9d18306cbf..f63d1b8a09335 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1331,6 +1331,10 @@ static int of_qcom_slim_ngd_register(struct device *parent,
 			return -ENOMEM;
 
 		ngd->pdev = platform_device_alloc(QCOM_SLIM_NGD_DRV_NAME, id);
+		if (!ngd->pdev) {
+			kfree(ngd);
+			return -ENOMEM;
+		}
 		ngd->id = id;
 		ngd->pdev->dev.parent = parent;
 		ngd->pdev->driver_override = QCOM_SLIM_NGD_DRV_NAME;
-- 
2.20.1



