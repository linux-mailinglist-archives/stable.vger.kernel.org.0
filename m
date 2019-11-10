Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05760F639C
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfKJCvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbfKJCvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31C522794;
        Sun, 10 Nov 2019 02:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354265;
        bh=/NIyCPyZeLdBwZL2f6/XlX7dwDQA8o09yF4PJxAG3WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wK7VOwEMNMcPo3yQVH8MzWYB+SUVRdNywLnuF2IMpPatHL8MYqHv85TDBFUUsmGrj
         0dvvXMKeOThX9SQHqAxxwbq0+CpPwSr/yyCIR2Y8NiIgoEBqzhRw6BaNe1vVWZFcni
         6Kx3OmAtAe5sJHfrNdCSbnpWcizYfZt9Ms1Y6yHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/40] usb: chipidea: Fix otg event handler
Date:   Sat,  9 Nov 2019 21:50:06 -0500
Message-Id: <20191110025032.827-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 59739131e0ca06db7560f9073fff2fb83f6bc2a5 ]

At OTG work running time, it's possible that several events need to be
addressed (e.g. ID and VBUS events). The current implementation handles
only one event at a time which leads to ignoring the other one. Fix it.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/otg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/otg.c b/drivers/usb/chipidea/otg.c
index f36a1ac3bfbdf..b8650210be0f7 100644
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -206,14 +206,17 @@ static void ci_otg_work(struct work_struct *work)
 	}
 
 	pm_runtime_get_sync(ci->dev);
+
 	if (ci->id_event) {
 		ci->id_event = false;
 		ci_handle_id_switch(ci);
-	} else if (ci->b_sess_valid_event) {
+	}
+
+	if (ci->b_sess_valid_event) {
 		ci->b_sess_valid_event = false;
 		ci_handle_vbus_change(ci);
-	} else
-		dev_err(ci->dev, "unexpected event occurs at %s\n", __func__);
+	}
+
 	pm_runtime_put_sync(ci->dev);
 
 	enable_irq(ci->irq);
-- 
2.20.1

