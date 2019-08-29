Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7616CA1754
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfH2Ku0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbfH2KuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFBF7233FF;
        Thu, 29 Aug 2019 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075824;
        bh=/J/pL/ZILwbj2fpr2R1wl8p3szobp5UMq8WAj4cQep8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpuqgoxHIjxCqYQ9XuuKOMrw1P4gqLHLePnoFnxfyzOpAODLeUIjsXddSqiI18QC8
         kolrxpn2knIiqMyiWcFDesFj50ZhlazMQkSNX+/vGJwtGUIeZ6lUXvJ4PRRMbc9lpr
         QDTJOOE7VP9AV1yyAQL3f0+VP5dXMEle2QGOmK30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@st.com>,
        Pavel Machek <pavel@ucw.cz>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/29] media: stm32-dcmi: fix irq = 0 case
Date:   Thu, 29 Aug 2019 06:49:53 -0400
Message-Id: <20190829105009.2265-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@st.com>

[ Upstream commit dbb9fcc8c2d8d4ea1104f51d4947a8a8199a2cb5 ]

Manage the irq = 0 case, where we shall return an error.

Fixes: b5b5a27bee58 ("media: stm32-dcmi: return appropriate error codes during probe")

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Reported-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index d386822658922..1d9c028e52cba 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1681,7 +1681,7 @@ static int dcmi_probe(struct platform_device *pdev)
 	if (irq <= 0) {
 		if (irq != -EPROBE_DEFER)
 			dev_err(&pdev->dev, "Could not get irq\n");
-		return irq;
+		return irq ? irq : -ENXIO;
 	}
 
 	dcmi->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
2.20.1

