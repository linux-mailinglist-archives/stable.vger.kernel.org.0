Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7965A328EA7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242046AbhCATex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241842AbhCAT30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F2365091;
        Mon,  1 Mar 2021 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620139;
        bh=Ov1FRcWzGzo0rgYRc4DCloup+hqr9XQwv0SX7hOO8aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOOYRXGvbd3Uokw6BObPMwNdIAWK0pN31NEbu/c0F/DmvemjUTsttq7T7SAeVl1bz
         zDme115KyMlex4sbFxuUScxOQb/qNdz7zOooRjAGXNJYYljTwM0cEkaigbdpHWMKQ1
         b9l7M7Bivjh/dZEG7iCpxDftqlDVMibK01KbbruM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 045/775] firmware: arm_scmi: Fix call site of scmi_notification_exit
Date:   Mon,  1 Mar 2021 17:03:33 +0100
Message-Id: <20210301161203.950832539@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit a90b6543bf062d65292b2c76f1630507d1c9d8ec ]

Call scmi_notification_exit() only when SCMI platform driver instance has
been really successfully removed.

Link: https://lore.kernel.org/r/20210112191326.29091-1-cristian.marussi@arm.com
Fixes: 6b8a69131dc63 ("firmware: arm_scmi: Enable notification core")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
[sudeep.holla: Move the call outside the list mutex locking]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 5392e1fc6b4ef..cacdf1589b101 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -848,8 +848,6 @@ static int scmi_remove(struct platform_device *pdev)
 	struct scmi_info *info = platform_get_drvdata(pdev);
 	struct idr *idr = &info->tx_idr;
 
-	scmi_notification_exit(&info->handle);
-
 	mutex_lock(&scmi_list_mutex);
 	if (info->users)
 		ret = -EBUSY;
@@ -860,6 +858,8 @@ static int scmi_remove(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	scmi_notification_exit(&info->handle);
+
 	/* Safe to free channels since no more users */
 	ret = idr_for_each(idr, info->desc->ops->chan_free, idr);
 	idr_destroy(&info->tx_idr);
-- 
2.27.0



