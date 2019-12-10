Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4213119A6C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLJVwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbfLJVHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492D32467E;
        Tue, 10 Dec 2019 21:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012060;
        bh=fKm1ZFrDKIByraym24ADBULjhawwkuZsmHr7TxK0mfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAWl9idQ7idGYFV2+KWQNpB5dkqLinljjF1zz2l0zEvU6vQoJTR9UJlMn3RVQdqOG
         nvEKYhWheQEaTVQPD7vIpUknZ1MoeAkuR0ylzLI39ijxFm+WGhlfjq373inxC2jmbF
         H2Qyt6OX+vaDFgXwxefvLlMAglqyQhj8bn+9BX8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 042/350] media: ov6650: Fix crop rectangle alignment not passed back
Date:   Tue, 10 Dec 2019 16:02:27 -0500
Message-Id: <20191210210735.9077-3-sashal@kernel.org>
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

[ Upstream commit 7b188d6ba27a131e7934a51a14ece331c0491f18 ]

Commit 4f996594ceaf ("[media] v4l2: make vidioc_s_crop const")
introduced a writable copy of constified user requested crop rectangle
in order to be able to perform hardware alignments on it.  Later
on, commit 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video
ops") replaced s_crop() video operation using that const argument with
set_selection() pad operation which had a corresponding argument not
constified, however the original behavior of the driver was not
restored.  Since that time, any hardware alignment applied on a user
requested crop rectangle is not passed back to the user calling
.set_selection() as it should be.

Fix the issue by dropping the copy and replacing all references to it
with references to the crop rectangle embedded in the user argument.

Fixes: 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video ops")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov6650.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 68776b0710f98..c6af725532585 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -465,38 +465,37 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_rect rect = sel->r;
 	int ret;
 
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
 	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	v4l_bound_align_image(&rect.width, 2, W_CIF, 1,
-			      &rect.height, 2, H_CIF, 1, 0);
-	v4l_bound_align_image(&rect.left, DEF_HSTRT << 1,
-			      (DEF_HSTRT << 1) + W_CIF - (__s32)rect.width, 1,
-			      &rect.top, DEF_VSTRT << 1,
-			      (DEF_VSTRT << 1) + H_CIF - (__s32)rect.height, 1,
-			      0);
+	v4l_bound_align_image(&sel->r.width, 2, W_CIF, 1,
+			      &sel->r.height, 2, H_CIF, 1, 0);
+	v4l_bound_align_image(&sel->r.left, DEF_HSTRT << 1,
+			      (DEF_HSTRT << 1) + W_CIF - (__s32)sel->r.width, 1,
+			      &sel->r.top, DEF_VSTRT << 1,
+			      (DEF_VSTRT << 1) + H_CIF - (__s32)sel->r.height,
+			      1, 0);
 
-	ret = ov6650_reg_write(client, REG_HSTRT, rect.left >> 1);
+	ret = ov6650_reg_write(client, REG_HSTRT, sel->r.left >> 1);
 	if (!ret) {
-		priv->rect.left = rect.left;
+		priv->rect.left = sel->r.left;
 		ret = ov6650_reg_write(client, REG_HSTOP,
-				(rect.left + rect.width) >> 1);
+				       (sel->r.left + sel->r.width) >> 1);
 	}
 	if (!ret) {
-		priv->rect.width = rect.width;
-		ret = ov6650_reg_write(client, REG_VSTRT, rect.top >> 1);
+		priv->rect.width = sel->r.width;
+		ret = ov6650_reg_write(client, REG_VSTRT, sel->r.top >> 1);
 	}
 	if (!ret) {
-		priv->rect.top = rect.top;
+		priv->rect.top = sel->r.top;
 		ret = ov6650_reg_write(client, REG_VSTOP,
-				(rect.top + rect.height) >> 1);
+				       (sel->r.top + sel->r.height) >> 1);
 	}
 	if (!ret)
-		priv->rect.height = rect.height;
+		priv->rect.height = sel->r.height;
 
 	return ret;
 }
-- 
2.20.1

