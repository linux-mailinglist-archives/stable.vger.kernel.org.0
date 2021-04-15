Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61938360CF5
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhDOOzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233707AbhDOOyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02151613E8;
        Thu, 15 Apr 2021 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498384;
        bh=03lnoLwtvfakn9qS2j6N2xANgmHsXIC9ebr0dCjfQ0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMXzj788Ds1WriT8GgEprmVKId/MVN+dbQSzhrilp9il++c1K5tMFP0Vmk9uFureX
         LaUP22+1B+cBggwNFHHGDXmtRbXCZDSArrbTqg/oXYFM1YSg7kWxn3j2byb4K+mu4d
         iUqj4pE0xXP9Ezihy//4pFblUEphAfTUPlGOkKDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 4.14 19/68] usbip: stub-dev synchronize sysfs code paths
Date:   Thu, 15 Apr 2021 16:47:00 +0200
Message-Id: <20210415144415.094122560@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 9dbf34a834563dada91366c2ac266f32ff34641a upstream.

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to protect sysfs paths in stub-dev.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/2b182f3561b4a065bf3bf6dce3b0e9944ba17b3f.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/stub_dev.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -77,6 +77,7 @@ static ssize_t store_sockfd(struct devic
 
 		dev_info(dev, "stub up\n");
 
+		mutex_lock(&sdev->ud.sysfs_lock);
 		spin_lock_irq(&sdev->ud.lock);
 
 		if (sdev->ud.status != SDEV_ST_AVAILABLE) {
@@ -101,13 +102,13 @@ static ssize_t store_sockfd(struct devic
 		tcp_rx = kthread_create(stub_rx_loop, &sdev->ud, "stub_rx");
 		if (IS_ERR(tcp_rx)) {
 			sockfd_put(socket);
-			return -EINVAL;
+			goto unlock_mutex;
 		}
 		tcp_tx = kthread_create(stub_tx_loop, &sdev->ud, "stub_tx");
 		if (IS_ERR(tcp_tx)) {
 			kthread_stop(tcp_rx);
 			sockfd_put(socket);
-			return -EINVAL;
+			goto unlock_mutex;
 		}
 
 		/* get task structs now */
@@ -126,6 +127,8 @@ static ssize_t store_sockfd(struct devic
 		wake_up_process(sdev->ud.tcp_rx);
 		wake_up_process(sdev->ud.tcp_tx);
 
+		mutex_unlock(&sdev->ud.sysfs_lock);
+
 	} else {
 		dev_info(dev, "stub down\n");
 
@@ -136,6 +139,7 @@ static ssize_t store_sockfd(struct devic
 		spin_unlock_irq(&sdev->ud.lock);
 
 		usbip_event_add(&sdev->ud, SDEV_EVENT_DOWN);
+		mutex_unlock(&sdev->ud.sysfs_lock);
 	}
 
 	return count;
@@ -144,6 +148,8 @@ sock_err:
 	sockfd_put(socket);
 err:
 	spin_unlock_irq(&sdev->ud.lock);
+unlock_mutex:
+	mutex_unlock(&sdev->ud.sysfs_lock);
 	return -EINVAL;
 }
 static DEVICE_ATTR(usbip_sockfd, S_IWUSR, NULL, store_sockfd);
@@ -309,6 +315,7 @@ static struct stub_device *stub_device_a
 	sdev->ud.side		= USBIP_STUB;
 	sdev->ud.status		= SDEV_ST_AVAILABLE;
 	spin_lock_init(&sdev->ud.lock);
+	mutex_init(&sdev->ud.sysfs_lock);
 	sdev->ud.tcp_socket	= NULL;
 	sdev->ud.sockfd		= -1;
 


