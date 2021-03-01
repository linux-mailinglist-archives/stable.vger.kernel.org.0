Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323CF32865E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhCARJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236254AbhCARDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C05D64F40;
        Mon,  1 Mar 2021 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616727;
        bh=1XfFHkKc5MZ1jdYHZqmhtLbMCNrVvwi3dBdETPH5AB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/h3xkT3c9f+HKhoVlLaadm741294T6/zcGG3rX4W34r3MXAuUtujtqapH7l/16pT
         NcjnKjGwRVSKwCPS43UMm1s/IJ55hJ1wZz9uMf1OzjRQ/2d8PdN+QKZ9n7i5wc0nFo
         syeKqcyXRxu+y1YbEVR2pw8wI2kei02xeQK/QgcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/247] gma500: clean up error handling in init
Date:   Mon,  1 Mar 2021 17:11:35 +0100
Message-Id: <20210301161035.359611963@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 15ccc39b3aab667c6fa131206f01f31bfbccdf6a ]

The main problem with this error handling was that it didn't clean up if
i2c_add_numbered_adapter() failed.  This code is pretty old, and doesn't
match with today's checkpatch.pl standards so I took the opportunity to
tidy it up a bit.  I changed the NULL comparison, and removed the
WARNING message if kzalloc() fails and updated the label names.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/X8ikkAqZfnDO2lu6@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
index e281070611480..fc9a34ed58bd1 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
@@ -279,11 +279,8 @@ int oaktrail_hdmi_i2c_init(struct pci_dev *dev)
 	hdmi_dev = pci_get_drvdata(dev);
 
 	i2c_dev = kzalloc(sizeof(struct hdmi_i2c_dev), GFP_KERNEL);
-	if (i2c_dev == NULL) {
-		DRM_ERROR("Can't allocate interface\n");
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!i2c_dev)
+		return -ENOMEM;
 
 	i2c_dev->adap = &oaktrail_hdmi_i2c_adapter;
 	i2c_dev->status = I2C_STAT_INIT;
@@ -300,16 +297,23 @@ int oaktrail_hdmi_i2c_init(struct pci_dev *dev)
 			  oaktrail_hdmi_i2c_adapter.name, hdmi_dev);
 	if (ret) {
 		DRM_ERROR("Failed to request IRQ for I2C controller\n");
-		goto err;
+		goto free_dev;
 	}
 
 	/* Adapter registration */
 	ret = i2c_add_numbered_adapter(&oaktrail_hdmi_i2c_adapter);
-	return ret;
+	if (ret) {
+		DRM_ERROR("Failed to add I2C adapter\n");
+		goto free_irq;
+	}
 
-err:
+	return 0;
+
+free_irq:
+	free_irq(dev->irq, hdmi_dev);
+free_dev:
 	kfree(i2c_dev);
-exit:
+
 	return ret;
 }
 
-- 
2.27.0



