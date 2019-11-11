Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09B9F7DC2
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbfKKSzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:55:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730670AbfKKSzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF16421655;
        Mon, 11 Nov 2019 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498547;
        bh=/JfsXujUHOoaYr494pO+SoT6VdOaPt9/CvFBihZrpYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJ46zG0YaDNs1/J7l2vcTvgQ9pmuBjV1onzA4M1ErgdAiADNg1Li5UW5Dl2XwjnLT
         dmLYFxcuLQRctubnrdEBesu0kg53S8DyA3V9zBVLZi/vnz7hcEMnwKeQUkX4DT3Bzr
         rLEsy93VOL56wo9C6rZb35b6KggcUqzCCjJyiftM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, GwanYeong Kim <gy741.kim@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 149/193] usbip: tools: Fix read_usb_vudc_device() error path handling
Date:   Mon, 11 Nov 2019 19:28:51 +0100
Message-Id: <20191111181512.142337434@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: GwanYeong Kim <gy741.kim@gmail.com>

[ Upstream commit 28df0642abbf6d66908a2858922a7e4b21cdd8c2 ]

This isn't really accurate right. fread() doesn't always
return 0 in error. It could return < number of elements
and set errno.

Signed-off-by: GwanYeong Kim <gy741.kim@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20191018032223.4644-1-gy741.kim@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/usb/usbip/libsrc/usbip_device_driver.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/usb/usbip/libsrc/usbip_device_driver.c b/tools/usb/usbip/libsrc/usbip_device_driver.c
index 5a3726eb44abc..b237a43e62990 100644
--- a/tools/usb/usbip/libsrc/usbip_device_driver.c
+++ b/tools/usb/usbip/libsrc/usbip_device_driver.c
@@ -69,7 +69,7 @@ int read_usb_vudc_device(struct udev_device *sdev, struct usbip_usb_device *dev)
 	FILE *fd = NULL;
 	struct udev_device *plat;
 	const char *speed;
-	int ret = 0;
+	size_t ret;
 
 	plat = udev_device_get_parent(sdev);
 	path = udev_device_get_syspath(plat);
@@ -79,8 +79,10 @@ int read_usb_vudc_device(struct udev_device *sdev, struct usbip_usb_device *dev)
 	if (!fd)
 		return -1;
 	ret = fread((char *) &descr, sizeof(descr), 1, fd);
-	if (ret < 0)
+	if (ret != 1) {
+		err("Cannot read vudc device descr file: %s", strerror(errno));
 		goto err;
+	}
 	fclose(fd);
 
 	copy_descr_attr(dev, &descr, bDeviceClass);
-- 
2.20.1



