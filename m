Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE808101805
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfKSFgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729018AbfKSFgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47893206EC;
        Tue, 19 Nov 2019 05:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141806;
        bh=1WDmaeQnzHdPuKnUb+DOjRMz6dZ0mYdB0EDJCkGbeH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVlnRRYTehan28yD6I88C3EDkxN8A4kpzVMRkLzBgPs/UO0Q2QeRy8KmSpzfMO3vl
         tIKumO+bCvNKNUmRxtHE2MpXVy/DcpZx+b8SFNTB9Vr6rPBDVl+GYs1QGSIkPwV/4V
         ebN0Hsofu1dtcgU0jXPRbswGob8G8tmXXyGG72mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 287/422] usb: chipidea: Fix otg event handler
Date:   Tue, 19 Nov 2019 06:18:04 +0100
Message-Id: <20191119051417.584670547@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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
index db4ceffcf2a61..f25d4827fd49c 100644
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -203,14 +203,17 @@ static void ci_otg_work(struct work_struct *work)
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



