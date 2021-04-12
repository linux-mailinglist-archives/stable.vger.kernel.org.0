Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0680735BE16
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbhDLI4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238849AbhDLIzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E149061364;
        Mon, 12 Apr 2021 08:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217596;
        bh=V3K62p7xASqF4/kcg443c4LGHGZOyzifrcvMHsCyooA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvOT7EaUz6TIazITwUJYbkijseVq0Tcu5jQYLWghHMbzMMxX/VyKc9Kv1p2VPn65I
         m2boeAGjlX682xY9fhskpf3Gjz7RPaYVg5/vmEBWs1RqMc6XXgb5wEss1DsoL1a9a5
         rmPh9rtW/LE8e26BDPXw2RUiqF6qGnqa/sngTYdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 5.10 074/188] usbip: stub-dev synchronize sysfs code paths
Date:   Mon, 12 Apr 2021 10:39:48 +0200
Message-Id: <20210412084016.122570511@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -63,6 +63,7 @@ static ssize_t usbip_sockfd_store(struct
 
 		dev_info(dev, "stub up\n");
 
+		mutex_lock(&sdev->ud.sysfs_lock);
 		spin_lock_irq(&sdev->ud.lock);
 
 		if (sdev->ud.status != SDEV_ST_AVAILABLE) {
@@ -87,13 +88,13 @@ static ssize_t usbip_sockfd_store(struct
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
@@ -112,6 +113,8 @@ static ssize_t usbip_sockfd_store(struct
 		wake_up_process(sdev->ud.tcp_rx);
 		wake_up_process(sdev->ud.tcp_tx);
 
+		mutex_unlock(&sdev->ud.sysfs_lock);
+
 	} else {
 		dev_info(dev, "stub down\n");
 
@@ -122,6 +125,7 @@ static ssize_t usbip_sockfd_store(struct
 		spin_unlock_irq(&sdev->ud.lock);
 
 		usbip_event_add(&sdev->ud, SDEV_EVENT_DOWN);
+		mutex_unlock(&sdev->ud.sysfs_lock);
 	}
 
 	return count;
@@ -130,6 +134,8 @@ sock_err:
 	sockfd_put(socket);
 err:
 	spin_unlock_irq(&sdev->ud.lock);
+unlock_mutex:
+	mutex_unlock(&sdev->ud.sysfs_lock);
 	return -EINVAL;
 }
 static DEVICE_ATTR_WO(usbip_sockfd);
@@ -270,6 +276,7 @@ static struct stub_device *stub_device_a
 	sdev->ud.side		= USBIP_STUB;
 	sdev->ud.status		= SDEV_ST_AVAILABLE;
 	spin_lock_init(&sdev->ud.lock);
+	mutex_init(&sdev->ud.sysfs_lock);
 	sdev->ud.tcp_socket	= NULL;
 	sdev->ud.sockfd		= -1;
 


