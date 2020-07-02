Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B229D21181A
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGBBZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgGBBXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D8C2145D;
        Thu,  2 Jul 2020 01:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653030;
        bh=XShLMHFLIslsFzvvnDfxIF44y2nXE8NLb7s1NS6Wa0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6H49pPYM2bRb3F2x0OvH64m9Yksals2JLqrwueVggA3ug3oma9zyM2sLMmB4QF4U
         JscLPHKDQYx4NB5/wPjPBjE6MjcSipR3uJjLhO5yHA6Uld1/ofKFR/fQxoYNMSJumw
         NztWJIPuzMyu5DXsGJPe0J3hPvCFXwz4WRmoG5jI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 44/53] usb: dwc3: pci: Fix reference count leak in dwc3_pci_resume_work
Date:   Wed,  1 Jul 2020 21:21:53 -0400
Message-Id: <20200702012202.2700645-44-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 2655971ad4b34e97dd921df16bb0b08db9449df7 ]

dwc3_pci_resume_work() calls pm_runtime_get_sync() that increments
the reference counter. In case of failure, decrement the reference
before returning.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index b67372737dc9b..96c05b121fac8 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -206,8 +206,10 @@ static void dwc3_pci_resume_work(struct work_struct *work)
 	int ret;
 
 	ret = pm_runtime_get_sync(&dwc3->dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync_autosuspend(&dwc3->dev);
 		return;
+	}
 
 	pm_runtime_mark_last_busy(&dwc3->dev);
 	pm_runtime_put_sync_autosuspend(&dwc3->dev);
-- 
2.25.1

