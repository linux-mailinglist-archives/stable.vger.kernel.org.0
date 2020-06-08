Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBBD1F2C0C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgFIAUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgFHXSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9962083E;
        Mon,  8 Jun 2020 23:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658285;
        bh=eh0C+0x9mVrpmssuTcn3nRjVa4S+T2umUEJ6R35Nwt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8+S62+8aICqEuTpCzM7tox87cctIFziaqRVXKWMeGufqoZvXVNQn+ohBpAb1K95/
         uIvo4wLZ2xiKnc3JvgUO74zMDluBgOMwvhWQnDM+sXKAjF/juTOXxkuy0D8/lpHLcD
         TZzeSimkWhaCWnMxcGI38RL+SmF1MogbA0bO/luE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Shanks <bshanks@codeweavers.com>,
        Mathieu Maret <mathieu.maret@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 290/606] Input: evdev - call input_flush_device() on release(), not flush()
Date:   Mon,  8 Jun 2020 19:06:55 -0400
Message-Id: <20200608231211.3363633-290-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Shanks <bshanks@codeweavers.com>

[ Upstream commit 09264098ff153f60866039d60b31d39b66f55a31 ]

input_flush_device() should only be called once the struct file is being
released and no open descriptors remain, but evdev_flush() was calling
it whenever a file descriptor was closed.

This caused uploaded force-feedback effects to be erased when a process
did a dup()/close() on the event FD, called system(), etc.

Call input_flush_device() from evdev_release() instead.

Reported-by: Mathieu Maret <mathieu.maret@gmail.com>
Signed-off-by: Brendan Shanks <bshanks@codeweavers.com>
Link: https://lore.kernel.org/r/20200421231003.7935-1-bshanks@codeweavers.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/evdev.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index cb6e3a5f509c..0d57e51b8ba1 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -326,20 +326,6 @@ static int evdev_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &client->fasync);
 }
 
-static int evdev_flush(struct file *file, fl_owner_t id)
-{
-	struct evdev_client *client = file->private_data;
-	struct evdev *evdev = client->evdev;
-
-	mutex_lock(&evdev->mutex);
-
-	if (evdev->exist && !client->revoked)
-		input_flush_device(&evdev->handle, file);
-
-	mutex_unlock(&evdev->mutex);
-	return 0;
-}
-
 static void evdev_free(struct device *dev)
 {
 	struct evdev *evdev = container_of(dev, struct evdev, dev);
@@ -453,6 +439,10 @@ static int evdev_release(struct inode *inode, struct file *file)
 	unsigned int i;
 
 	mutex_lock(&evdev->mutex);
+
+	if (evdev->exist && !client->revoked)
+		input_flush_device(&evdev->handle, file);
+
 	evdev_ungrab(evdev, client);
 	mutex_unlock(&evdev->mutex);
 
@@ -1310,7 +1300,6 @@ static const struct file_operations evdev_fops = {
 	.compat_ioctl	= evdev_ioctl_compat,
 #endif
 	.fasync		= evdev_fasync,
-	.flush		= evdev_flush,
 	.llseek		= no_llseek,
 };
 
-- 
2.25.1

