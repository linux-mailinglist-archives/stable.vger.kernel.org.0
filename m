Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB66B2613A6
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgIHPhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 11:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbgIHPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D062D2247F;
        Tue,  8 Sep 2020 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579287;
        bh=igUA3ysCtvbQZlZxzdgP/arDzUKvL7VVNXaZw/amLFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmOQBc2wPQqW1yDYIrfCbpPrwcmAHohr5befgvOLNrLC/sFMOBwbejk7W/wo9Ng9Q
         y5wUbOf5AeJju48O/BDHN2P1hn2NUw9muuFCtk0ci08zCZXWwKDns3FWJFOteHq7Bo
         p4AGnmRrTbZF+9mVV4UffzSYhUnY6WhYgWKQja8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishna Manikandan <mkrishn@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 007/186] drm/msm: add shutdown support for display platform_driver
Date:   Tue,  8 Sep 2020 17:22:29 +0200
Message-Id: <20200908152242.007988241@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
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
index f6ce40bf36998..b4d61af7a104e 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1328,6 +1328,13 @@ static int msm_pdev_remove(struct platform_device *pdev)
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
@@ -1340,6 +1347,7 @@ MODULE_DEVICE_TABLE(of, dt_match);
 static struct platform_driver msm_platform_driver = {
 	.probe      = msm_pdev_probe,
 	.remove     = msm_pdev_remove,
+	.shutdown   = msm_pdev_shutdown,
 	.driver     = {
 		.name   = "msm",
 		.of_match_table = dt_match,
-- 
2.25.1



