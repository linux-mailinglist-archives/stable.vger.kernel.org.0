Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D82119A66
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfLJVHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:07:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfLJVHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5CA524687;
        Tue, 10 Dec 2019 21:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012063;
        bh=uqHLQvzm+xZtTxEjJWFZKxJIQ3F3G+GRncOmGj48G7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/XIRrXgOh/bO8GJyWEhRZ4hZxEC/59XYDexXMRhesOrAP8BCxD9BCL+yVrr4BaOR
         vt5W0qBsuc4m/TKTKVo3CsBBMKe1WkGm2+KPYZvIxNJN1f2dFKfC0enLIf0jMY95nm
         6lGZU9NP17VDiQV6a3UeCrES31UPh3xnrGVVnjCE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 045/350] media: ov6650: Fix stored crop rectangle not in sync with hardware
Date:   Tue, 10 Dec 2019 16:02:30 -0500
Message-Id: <20191210210735.9077-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 1463b371aff0682c70141f7521db13cc4bbf3016 ]

The driver stores crop rectangle settings supposed to be in line with
hardware state in a device private structure.  Since the driver initial
submission, crop rectangle width and height settings are not updated
correctly when rectangle offset settings are applied on hardware.  If
an error occurs while the device is updated, the stored settings my no
longer reflect hardware state and consecutive calls to .get_selection()
as well as .get/set_fmt() may return incorrect information.  That in
turn may affect ability of a bridge device to use correct DMA transfer
settings if such incorrect informamtion on active frame format returned
by .get/set_fmt() is used.

Assuming a failed update of the device means its actual settings haven't
changed, update crop rectangle width and height settings stored in the
device private structure correctly while the rectangle offset is
successfully applied on hardware so the stored values always reflect
actual hardware state to the extent possible.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov6650.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 5426fed2574ec..43c3f1b6e19ac 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -481,6 +481,7 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 
 	ret = ov6650_reg_write(client, REG_HSTRT, sel->r.left >> 1);
 	if (!ret) {
+		priv->rect.width += priv->rect.left - sel->r.left;
 		priv->rect.left = sel->r.left;
 		ret = ov6650_reg_write(client, REG_HSTOP,
 				       (sel->r.left + sel->r.width) >> 1);
@@ -490,6 +491,7 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 		ret = ov6650_reg_write(client, REG_VSTRT, sel->r.top >> 1);
 	}
 	if (!ret) {
+		priv->rect.height += priv->rect.top - sel->r.top;
 		priv->rect.top = sel->r.top;
 		ret = ov6650_reg_write(client, REG_VSTOP,
 				       (sel->r.top + sel->r.height) >> 1);
-- 
2.20.1

