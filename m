Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0618261AD7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIHSlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731290AbgIHQIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:08:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078B123EF2;
        Tue,  8 Sep 2020 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580062;
        bh=/IvZsneCXeaOhikdorhW99mg/h1pdfob0kUSatt8uFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbOdr5nKF6S5cRJE6S2z6jvw+C2YkPQHkxlc4llJVmRow6be8B963ytMYNXgO8BhY
         76/0f7HBWJCYwST7+xpaBGiKOG/Sfl8sJGaxGEE2T41HVg2K60xlWw/j1S7XIiyH2c
         THR+DQq0jB7PISAMVG0qvRf5D8t8JB4mQzROm9GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishna Manikandan <mkrishn@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/88] drm/msm: add shutdown support for display platform_driver
Date:   Tue,  8 Sep 2020 17:25:08 +0200
Message-Id: <20200908152221.460370773@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Manikandan <mkrishn@codeaurora.org>

[ Upstream commit 9d5cbf5fe46e350715389d89d0c350d83289a102 ]

Define shutdown callback for display drm driver,
so as to disable all the CRTCS when shutdown
notification is received by the driver.

This change will turn off the timing engine so
that no display transactions are requested
while mmu translations are getting disabled
during reboot sequence.

Signed-off-by: Krishna Manikandan <mkrishn@codeaurora.org>

Changes in v2:
	- Remove NULL check from msm_pdev_shutdown (Stephen Boyd)
	- Change commit text to reflect when this issue
	  was uncovered (Sai Prakash Ranjan)

Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 6f81de85fb860..7f45486b6650b 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1358,6 +1358,13 @@ static int msm_pdev_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void msm_pdev_shutdown(struct platform_device *pdev)
+{
+	struct drm_device *drm = platform_get_drvdata(pdev);
+
+	drm_atomic_helper_shutdown(drm);
+}
+
 static const struct of_device_id dt_match[] = {
 	{ .compatible = "qcom,mdp4", .data = (void *)KMS_MDP4 },
 	{ .compatible = "qcom,mdss", .data = (void *)KMS_MDP5 },
@@ -1369,6 +1376,7 @@ MODULE_DEVICE_TABLE(of, dt_match);
 static struct platform_driver msm_platform_driver = {
 	.probe      = msm_pdev_probe,
 	.remove     = msm_pdev_remove,
+	.shutdown   = msm_pdev_shutdown,
 	.driver     = {
 		.name   = "msm",
 		.of_match_table = dt_match,
-- 
2.25.1



