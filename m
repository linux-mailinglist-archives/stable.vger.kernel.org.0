Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2468415C78
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfEGFe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfEGFe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F7002087F;
        Tue,  7 May 2019 05:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207295;
        bh=3f0uVeaAqp1CRpVf+BTqUt9BAmjeUznxOi6BaEov8wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcnxSTo3eMAwXu2EvnyGf5d8wNjiljaCRMhE9rkopxs4i5Ze0rLnuZx0sdRzWrRCS
         TtH6VRQVm0qg0hTInRxGq2Y1AVyuKbV+hUcCv13Bcu97lHGALadvWF7HW8n4WzPjdT
         N6Ms0vdzFNeOa+a5jr01JfNFQSc0KEWgLffuSjTc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.0 70/99] drm/sun4i: Fix component unbinding and component master deletion
Date:   Tue,  7 May 2019 01:32:04 -0400
Message-Id: <20190507053235.29900-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit f5a9ed867c83875546c9aadd4ed8e785e9adcc3c ]

For our component-backed driver to be properly removed, we need to
delete the component master in sun4i_drv_remove and make sure to call
component_unbind_all in the master's unbind so that all components are
unbound when the master is.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190418132727.5128-4-paul.kocialkowski@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index c6b65a969979..9a5713fa03b2 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -148,6 +148,8 @@ static void sun4i_drv_unbind(struct device *dev)
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);
 	drm_dev_put(drm);
+
+	component_unbind_all(dev, NULL);
 }
 
 static const struct component_master_ops sun4i_drv_master_ops = {
@@ -395,6 +397,8 @@ static int sun4i_drv_probe(struct platform_device *pdev)
 
 static int sun4i_drv_remove(struct platform_device *pdev)
 {
+	component_master_del(&pdev->dev, &sun4i_drv_master_ops);
+
 	return 0;
 }
 
-- 
2.20.1

