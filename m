Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E04123F8C2
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 22:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgHHUd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 16:33:58 -0400
Received: from gofer.mess.org ([88.97.38.141]:33539 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgHHUd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 16:33:58 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 6875BC6373; Sat,  8 Aug 2020 21:33:52 +0100 (BST)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 2/2] media: rc: do not access device via sysfs after rc_unregister_device()
Date:   Sat,  8 Aug 2020 21:33:52 +0100
Message-Id: <20200808203352.9793-2-sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200808203352.9793-1-sean@mess.org>
References: <20200808203352.9793-1-sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Device drivers do not expect to have change_protocol or wakeup
re-programming to be accesed after rc_unregister_device(). This can
cause the device driver to access deallocated resources.

Cc: <stable@vger.kernel.org> # 4.16
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index e1cda80a4b25..dee8a9f3d80a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1292,6 +1292,10 @@ static ssize_t store_protocols(struct device *device,
 	}
 
 	mutex_lock(&dev->lock);
+	if (!dev->registered) {
+		mutex_unlock(&dev->lock);
+		return -ENODEV;
+	}
 
 	old_protocols = *current_protocols;
 	new_protocols = old_protocols;
@@ -1430,6 +1434,10 @@ static ssize_t store_filter(struct device *device,
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
+	if (!dev->registered) {
+		mutex_unlock(&dev->lock);
+		return -ENODEV;
+	}
 
 	new_filter = *filter;
 	if (fattr->mask)
@@ -1544,6 +1552,10 @@ static ssize_t store_wakeup_protocols(struct device *device,
 	int i;
 
 	mutex_lock(&dev->lock);
+	if (!dev->registered) {
+		mutex_unlock(&dev->lock);
+		return -ENODEV;
+	}
 
 	allowed = dev->allowed_wakeup_protocols;
 
-- 
2.26.2

