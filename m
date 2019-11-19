Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B961018A9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfKSF1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbfKSF1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 401BC22309;
        Tue, 19 Nov 2019 05:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141242;
        bh=fb+uDVLzQj+oXotwUSncvB4df9zFhWnG3pcDqa1qYLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOmd3ElgNEkvFxNfCon0VWde7nIMDFupPJu9wnV9RHW2vUTfiZCZqQ/tKT7XfG2DN
         8SqlOFJb6GWfxnGc/Wc4kQMxA6IKR8jnUWRem+LXMMP5JSg3tphOgcz75i9zH3ATpg
         x4UwanTeTccLL34Md9zO5p2gD+4kBdH0jOeEQsAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/422] media: i2c: Fix pm_runtime_get_if_in_use() usage in sensor drivers
Date:   Tue, 19 Nov 2019 06:14:49 +0100
Message-Id: <20191119051405.318887799@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 4d471563d87b2b83e73b8abffb9273950e6d2e36 ]

pm_runtime_get_if_in_use() returns -EINVAL if runtime PM is disabled. This
should not be considered an error. Generally the driver has enabled
runtime PM already so getting this error due to runtime PM being disabled
will not happen.

Instead of checking for lesser or equal to zero, check for zero only.
Address this for drivers where this pattern exists.

This patch has been produced using the following command:

$ git grep -l pm_runtime_get_if_in_use -- drivers/media/i2c/ | \
  xargs perl -i -pe 's/(pm_runtime_get_if_in_use\(.*\)) \<\= 0/!$1/'

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov13858.c | 2 +-
 drivers/media/i2c/ov2685.c  | 2 +-
 drivers/media/i2c/ov5670.c  | 2 +-
 drivers/media/i2c/ov5695.c  | 2 +-
 drivers/media/i2c/ov7740.c  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index a66f6201f53c7..0e7a85c4996c7 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1230,7 +1230,7 @@ static int ov13858_set_ctrl(struct v4l2_ctrl *ctrl)
 	 * Applying V4L2 control value only happens
 	 * when power is up for streaming
 	 */
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	ret = 0;
diff --git a/drivers/media/i2c/ov2685.c b/drivers/media/i2c/ov2685.c
index 385c1886a9470..98a1f2e312b58 100644
--- a/drivers/media/i2c/ov2685.c
+++ b/drivers/media/i2c/ov2685.c
@@ -549,7 +549,7 @@ static int ov2685_set_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	}
 
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 7b7c74d773707..53dd30d96e691 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2016,7 +2016,7 @@ static int ov5670_set_ctrl(struct v4l2_ctrl *ctrl)
 	}
 
 	/* V4L2 controls values will be applied only when power is already up */
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
diff --git a/drivers/media/i2c/ov5695.c b/drivers/media/i2c/ov5695.c
index 9a80decd93d3c..5d107c53364d6 100644
--- a/drivers/media/i2c/ov5695.c
+++ b/drivers/media/i2c/ov5695.c
@@ -1110,7 +1110,7 @@ static int ov5695_set_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	}
 
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 8a6a7a5929aa3..7804013934ab5 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -510,7 +510,7 @@ static int ov7740_set_ctrl(struct v4l2_ctrl *ctrl)
 	int ret;
 	u8 val = 0;
 
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
-- 
2.20.1



