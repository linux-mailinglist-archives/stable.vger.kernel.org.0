Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3427F29B6DC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368755AbgJ0P1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798071AbgJ0PZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F1522064B;
        Tue, 27 Oct 2020 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812327;
        bh=MKdIcZFigxGEm5Ll1r8U5dgmoPxrQX53Q37S9YRTPvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDMquoetpvFh6qbxMmNEPlbpGoT++Qo0jaONdzUHeDB/Aeu3HB3Lsj7wtipsbeRcU
         3fROdzU9SZBZal3lyp9kafT/C5xAAVe3hPI77NKnuDvdpSxCi6euD1pMgI0A9SaaHD
         wIw9ZfHd5+3KrMM+zktQwARgMs+YQ4R3dQ7cgh1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 143/757] media: i2c: max9286: Allocate v4l2_async_subdev dynamically
Date:   Tue, 27 Oct 2020 14:46:33 +0100
Message-Id: <20201027135457.303071341@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 86d37bf31af647760f1f17e7c1afa1bdba075198 ]

v4l2_async_notifier_add_subdev() requires the asd to be allocated
dynamically, but the max9286 driver embeds it in the max9286_source
structure. This causes memory corruption when the notifier is destroyed
at remove time with v4l2_async_notifier_cleanup().

Fix this issue by registering the asd with
v4l2_async_notifier_add_fwnode_subdev(), which allocates it dynamically
internally. A new max9286_asd structure is introduced, to store a
pointer to the corresonding max9286_source that needs to be accessed
from bound and unbind callbacks. There's no need to take an extra
explicit reference to the fwnode anymore as
v4l2_async_notifier_add_fwnode_subdev() does so internally.

While at it, use %u instead of %d to print the unsigned index in the
error message from the v4l2_async_notifier_add_fwnode_subdev() error
path.

Fixes: 66d8c9d2422d ("media: i2c: Add MAX9286 driver")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 40 +++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index b364a3f604861..c82c1493e099d 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -135,13 +135,19 @@
 #define MAX9286_SRC_PAD			4
 
 struct max9286_source {
-	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *sd;
 	struct fwnode_handle *fwnode;
 };
 
-#define asd_to_max9286_source(_asd) \
-	container_of(_asd, struct max9286_source, asd)
+struct max9286_asd {
+	struct v4l2_async_subdev base;
+	struct max9286_source *source;
+};
+
+static inline struct max9286_asd *to_max9286_asd(struct v4l2_async_subdev *asd)
+{
+	return container_of(asd, struct max9286_asd, base);
+}
 
 struct max9286_priv {
 	struct i2c_client *client;
@@ -481,7 +487,7 @@ static int max9286_notify_bound(struct v4l2_async_notifier *notifier,
 				struct v4l2_async_subdev *asd)
 {
 	struct max9286_priv *priv = sd_to_max9286(notifier->sd);
-	struct max9286_source *source = asd_to_max9286_source(asd);
+	struct max9286_source *source = to_max9286_asd(asd)->source;
 	unsigned int index = to_index(priv, source);
 	unsigned int src_pad;
 	int ret;
@@ -545,7 +551,7 @@ static void max9286_notify_unbind(struct v4l2_async_notifier *notifier,
 				  struct v4l2_async_subdev *asd)
 {
 	struct max9286_priv *priv = sd_to_max9286(notifier->sd);
-	struct max9286_source *source = asd_to_max9286_source(asd);
+	struct max9286_source *source = to_max9286_asd(asd)->source;
 	unsigned int index = to_index(priv, source);
 
 	source->sd = NULL;
@@ -570,23 +576,19 @@ static int max9286_v4l2_notifier_register(struct max9286_priv *priv)
 
 	for_each_source(priv, source) {
 		unsigned int i = to_index(priv, source);
-
-		source->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		source->asd.match.fwnode = source->fwnode;
-
-		ret = v4l2_async_notifier_add_subdev(&priv->notifier,
-						     &source->asd);
-		if (ret) {
-			dev_err(dev, "Failed to add subdev for source %d", i);
+		struct v4l2_async_subdev *asd;
+
+		asd = v4l2_async_notifier_add_fwnode_subdev(&priv->notifier,
+							    source->fwnode,
+							    sizeof(*asd));
+		if (IS_ERR(asd)) {
+			dev_err(dev, "Failed to add subdev for source %u: %ld",
+				i, PTR_ERR(asd));
 			v4l2_async_notifier_cleanup(&priv->notifier);
-			return ret;
+			return PTR_ERR(asd);
 		}
 
-		/*
-		 * Balance the reference counting handled through
-		 * v4l2_async_notifier_cleanup()
-		 */
-		fwnode_handle_get(source->fwnode);
+		to_max9286_asd(asd)->source = source;
 	}
 
 	priv->notifier.ops = &max9286_notify_ops;
-- 
2.25.1



