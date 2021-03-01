Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AFA328C02
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240573AbhCASno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240475AbhCASjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5A3B65153;
        Mon,  1 Mar 2021 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618315;
        bh=VL1A42evJs1EpeSn83gtZEc2je3YuV5/qah8GRmUoSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vr5HKQA0WIxcBiIntA+EOLQk1sZwMzHdgEqFck2DlsQ4rpyHZIDXfk/zV12iU16U2
         /aI+wVwW8Kl6S9OX6cci7ZOTS/32eAQluxHZ8Txyom7BR5OTpZ2sHbjh+j25e9KN0j
         o2hX5AYHls1jtmEzrhd3NFHzDxyq63eyJIgCOdoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/663] firmware: arm_scmi: Fix call site of scmi_notification_exit
Date:   Mon,  1 Mar 2021 17:04:51 +0100
Message-Id: <20210301161143.907692879@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 3dfd8b6a0ebf7..6b2ce3f28f7b9 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -847,8 +847,6 @@ static int scmi_remove(struct platform_device *pdev)
 	struct scmi_info *info = platform_get_drvdata(pdev);
 	struct idr *idr = &info->tx_idr;
 
-	scmi_notification_exit(&info->handle);
-
 	mutex_lock(&scmi_list_mutex);
 	if (info->users)
 		ret = -EBUSY;
@@ -859,6 +857,8 @@ static int scmi_remove(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	scmi_notification_exit(&info->handle);
+
 	/* Safe to free channels since no more users */
 	ret = idr_for_each(idr, info->desc->ops->chan_free, idr);
 	idr_destroy(&info->tx_idr);
-- 
2.27.0



