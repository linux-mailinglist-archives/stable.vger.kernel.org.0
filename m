Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A6B2F1CC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbfE3DPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730525AbfE3DPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:54 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A35A2449A;
        Thu, 30 May 2019 03:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186154;
        bh=YXvC1Hdn+3DvFR3FlbnTnvh6ogn6IMg4kqbEvyiC4KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Akfs9G38iiIQlPFrtSDy3K0KZ3UfGOVvvu/omayqfapTOOeiolcp1vCAvkKY0RIBR
         SoPHGuTkt70JJil/RxMbBApPTOzd4C8Dkv4ksVom53GuocCOqXTJkzjBqDBMJqPOdf
         63W9op2EgR2CyCyEEcPYXXwvClSknn8YWNdu1tOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 340/346] drm/drv: Hold ref on parent device during drm_device lifetime
Date:   Wed, 29 May 2019 20:06:53 -0700
Message-Id: <20190530030557.956988397@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 56be6503aab2bc3a30beae408071b9be5e1bae51 ]

This makes it safe to access drm_device->dev after the parent device has
been removed/unplugged.

Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: Gerd Hoffmann <kraxel@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190225144232.20761-2-noralf@tronnes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 7a59b8b3ed5a4..81c8936bc1d3c 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -499,7 +499,7 @@ int drm_dev_init(struct drm_device *dev,
 	BUG_ON(!parent);
 
 	kref_init(&dev->ref);
-	dev->dev = parent;
+	dev->dev = get_device(parent);
 	dev->driver = driver;
 
 	/* no per-device feature limits by default */
@@ -569,6 +569,7 @@ int drm_dev_init(struct drm_device *dev,
 	drm_minor_free(dev, DRM_MINOR_RENDER);
 	drm_fs_inode_free(dev->anon_inode);
 err_free:
+	put_device(dev->dev);
 	mutex_destroy(&dev->master_mutex);
 	mutex_destroy(&dev->ctxlist_mutex);
 	mutex_destroy(&dev->clientlist_mutex);
@@ -604,6 +605,8 @@ void drm_dev_fini(struct drm_device *dev)
 	drm_minor_free(dev, DRM_MINOR_PRIMARY);
 	drm_minor_free(dev, DRM_MINOR_RENDER);
 
+	put_device(dev->dev);
+
 	mutex_destroy(&dev->master_mutex);
 	mutex_destroy(&dev->ctxlist_mutex);
 	mutex_destroy(&dev->clientlist_mutex);
-- 
2.20.1



