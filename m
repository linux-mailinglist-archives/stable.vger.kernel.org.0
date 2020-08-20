Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7852124BEB0
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgHTNaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgHTJcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAEAF22B4B;
        Thu, 20 Aug 2020 09:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915970;
        bh=BvelV7rj7pX8LClD7CfT1GkoCmXsCtbsF1V8T+D2ddY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PASYbDjI65LDqwfZhMeO43BKFxg1GlLUdbg+jlX/0x8PJkqc2zg4/XWfWmhb5KebD
         iJgXboeCNIQIx97cJc5NksClGec952s8y1XVxwZqZE6GQ+sSfRyK2VeJDGVtSKisMQ
         WRWTcdZ5bOc4ESTAaO8BWjDp/JcjugtqBtQhn8nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 199/232] drm/vmwgfx: Fix two list_for_each loop exit tests
Date:   Thu, 20 Aug 2020 11:20:50 +0200
Message-Id: <20200820091622.446084378@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4437c1152ce0e57ab8f401aa696ea6291cc07ab1 ]

These if statements are supposed to be true if we ended the
list_for_each_entry() loops without hitting a break statement but they
don't work.

In the first loop, we increment "i" after the "if (i == unit)" condition
so we don't necessarily know that "i" is not equal to unit at the end of
the loop.

In the second loop we exit when mode is not pointing to a valid
drm_display_mode struct so it doesn't make sense to check "mode->type".

Fixes: a278724aa23c ("drm/vmwgfx: Implement fbdev on kms v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 04d66592f6050..b7a9cee69ea72 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2578,7 +2578,7 @@ int vmw_kms_fbdev_init_data(struct vmw_private *dev_priv,
 		++i;
 	}
 
-	if (i != unit) {
+	if (&con->head == &dev_priv->dev->mode_config.connector_list) {
 		DRM_ERROR("Could not find initial display unit.\n");
 		ret = -EINVAL;
 		goto out_unlock;
@@ -2602,13 +2602,13 @@ int vmw_kms_fbdev_init_data(struct vmw_private *dev_priv,
 			break;
 	}
 
-	if (mode->type & DRM_MODE_TYPE_PREFERRED)
-		*p_mode = mode;
-	else {
+	if (&mode->head == &con->modes) {
 		WARN_ONCE(true, "Could not find initial preferred mode.\n");
 		*p_mode = list_first_entry(&con->modes,
 					   struct drm_display_mode,
 					   head);
+	} else {
+		*p_mode = mode;
 	}
 
  out_unlock:
-- 
2.25.1



