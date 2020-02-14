Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB0215E965
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392369AbgBNQOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392363AbgBNQOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15CD246E0;
        Fri, 14 Feb 2020 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696881;
        bh=IBGB+xDX7Tk9f82+ViaLQcfskmpjmicN/oxDPAoTq6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPkprbZUFyqb/JA39AE1UgbnlLJCK5xvJEMM0/pcxJTPiKSCcU1AF5KIXq5kkwaie
         CoddkStmsHI4ZcDTGubJV5DdUXqpJsGLxwDLmW91bM8HQneK25rPjur21ftHP2cMLk
         8UFgg3zFe1yu/qHv0JxfN0KZlb1CTaNMH+yHN8cI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 136/252] drm/gma500: remove set but not used variables 'hist_reg'
Date:   Fri, 14 Feb 2020 11:09:51 -0500
Message-Id: <20200214161147.15842-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 72f775611daf3ce20358388facbaf11f22899fa2 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/gma500/psb_irq.c: In function psb_irq_turn_off_dpst:
drivers/gpu/drm/gma500/psb_irq.c:473:6:
	warning: variable hist_reg set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191227114811.14907-1-chenzhou10@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/psb_irq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_irq.c b/drivers/gpu/drm/gma500/psb_irq.c
index f75f199c84311..518d7b4456bf1 100644
--- a/drivers/gpu/drm/gma500/psb_irq.c
+++ b/drivers/gpu/drm/gma500/psb_irq.c
@@ -471,12 +471,11 @@ void psb_irq_turn_off_dpst(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv =
 	    (struct drm_psb_private *) dev->dev_private;
-	u32 hist_reg;
 	u32 pwm_reg;
 
 	if (gma_power_begin(dev, false)) {
 		PSB_WVDC32(0x00000000, HISTOGRAM_INT_CONTROL);
-		hist_reg = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
+		PSB_RVDC32(HISTOGRAM_INT_CONTROL);
 
 		psb_disable_pipestat(dev_priv, 0, PIPE_DPST_EVENT_ENABLE);
 
-- 
2.20.1

