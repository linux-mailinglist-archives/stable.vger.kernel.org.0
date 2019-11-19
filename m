Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC02D101632
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731727AbfKSFvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731725AbfKSFvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:51:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 147D521939;
        Tue, 19 Nov 2019 05:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142664;
        bh=HhY6aRuiU+JFIVbArd6TnC9cOXQnnSAEu6elwhYbO2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmS7kFm1SKzwcCBlO4HklHSGFhPZWYS9snLX4gTzsq++eeIQ/X4Kc8w5cWXI8UOsq
         ligElru7JYGNSHXquLgukgXocCtr8bnQC5pJJPUz6+xTWg2uJ9VukbKq0nX7cGnFp5
         nbzp73py2jMJiAR4mQc98MstAzn9SIlEd78WarNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 157/239] usb: chipidea: Fix otg event handler
Date:   Tue, 19 Nov 2019 06:19:17 +0100
Message-Id: <20191119051333.133155502@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 10236fe715228..8bf4032226ed5 100644
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



