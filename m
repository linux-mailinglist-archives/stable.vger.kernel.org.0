Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5198D12C638
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbfL2Roq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730744AbfL2Rop (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EB06206A4;
        Sun, 29 Dec 2019 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641484;
        bh=8PQ9uLdV6LAq8aFh1VGm/KzOXdHxL4/LEYUFy+YHq6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWPHtgxHqXVwe4XwUHU7kgKmjN2qlqDFQKoWPhOod9Q0T/XV/RhdvQl9dtrTaKQ9Q
         6FW3M4J5O8pagsQe0XPi1lqqYdrOuqX95YdqEXzmafW9cl0Rjnq1gyx94SCk51MYAc
         nUJWA8RdoBCoqSli3DXuAJZLO8errVYjvWB/1d9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/434] media: ov6650: Fix stored crop rectangle not in sync with hardware
Date:   Sun, 29 Dec 2019 18:22:18 +0100
Message-Id: <20191229172707.195017138@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5426fed2574e..43c3f1b6e19a 100644
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



