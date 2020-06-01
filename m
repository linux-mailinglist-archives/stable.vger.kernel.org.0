Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945791EAF5F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgFARzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbgFARzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:55:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E65242073B;
        Mon,  1 Jun 2020 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034151;
        bh=ExMKuf+azTmVVi/YGd55XhCM+QRC8qCRQFM9lqh3wtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ0UxQ98rrHOFa4s16pkXOlZ4X5L1NeIU01YdFjiufDcCWDU8hr7D5IirPMp39WJT
         4NagLxkHG5dIOHp9lLkHvL5IOxJ2J3faHh71FZLGW9h0B2ngV84BJrLpuj0f9rJh49
         Mthq5KMrvMWe1CB4530d5TNjDB82t6uwkIZSdO4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathieu Maret <mathieu.maret@gmail.com>,
        Brendan Shanks <bshanks@codeweavers.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/48] Input: evdev - call input_flush_device() on release(), not flush()
Date:   Mon,  1 Jun 2020 19:53:25 +0200
Message-Id: <20200601173956.976457109@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e9ae3d500a55..700f018df668 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -342,20 +342,6 @@ static int evdev_fasync(int fd, struct file *file, int on)
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
@@ -469,6 +455,10 @@ static int evdev_release(struct inode *inode, struct file *file)
 	unsigned int i;
 
 	mutex_lock(&evdev->mutex);
+
+	if (evdev->exist && !client->revoked)
+		input_flush_device(&evdev->handle, file);
+
 	evdev_ungrab(evdev, client);
 	mutex_unlock(&evdev->mutex);
 
@@ -1331,7 +1321,6 @@ static const struct file_operations evdev_fops = {
 	.compat_ioctl	= evdev_ioctl_compat,
 #endif
 	.fasync		= evdev_fasync,
-	.flush		= evdev_flush,
 	.llseek		= no_llseek,
 };
 
-- 
2.25.1



