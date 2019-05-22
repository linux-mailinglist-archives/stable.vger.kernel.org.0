Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C6F26DE0
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbfEVTpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731413AbfEVT2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:28:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D75520675;
        Wed, 22 May 2019 19:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553281;
        bh=/8Hl4knxiOx6qeODctPBRtxpqleFuvFFLcMbE7xdhVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwmx7PXXoq1CveQq2hNeYSCWw2uWAIQLjRLQ+lXJWrAaTN1BYl7KWbDOlEB4lZ1co
         pOCefbHH2rrUxnqMwdn+KLfbavcAxMcKYE0j2+roL9qBETc3j7klvzUBLgPu4++kQS
         ene7mD0QNgAxcgOux6FveX9ZIQ8KafZHwaYigTC8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 055/244] slimbus: fix a potential NULL pointer dereference in of_qcom_slim_ngd_register
Date:   Wed, 22 May 2019 15:23:21 -0400
Message-Id: <20190522192630.24917-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

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

