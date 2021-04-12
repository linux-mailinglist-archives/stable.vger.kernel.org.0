Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687B135BE1C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238795AbhDLI5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238865AbhDLIzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F1D61286;
        Mon, 12 Apr 2021 08:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217599;
        bh=y3KG1NgS3Nm52IgCbN8DSzd6bCjSyulFreOec4vWczo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEQLYEy47ki+8TnyL4vP5Z5QcnpyzSWiJ7SSmBFcvNzLZJBhnfbz+kP4WlwAlTV+M
         RNYRyMAVjYom2X5rN8trWBacWd60c/QGmi5HZ/lo2ilm1kdZPaw8yIT/nPy/wdAAGm
         2Oc2SHp9eNzRW2qD8BhPQw7SFcuGKwpkCqFdiHnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 5.10 075/188] usbip: vudc synchronize sysfs code paths
Date:   Mon, 12 Apr 2021 10:39:49 +0200
Message-Id: <20210412084016.152698733@linuxfoundation.org>
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

commit bd8b82042269a95db48074b8bb400678dbac1815 upstream.

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to protect sysfs paths in vudc.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/caabcf3fc87bdae970509b5ff32d05bb7ce2fb15.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_dev.c   |    1 +
 drivers/usb/usbip/vudc_sysfs.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/usbip/vudc_dev.c
+++ b/drivers/usb/usbip/vudc_dev.c
@@ -572,6 +572,7 @@ static int init_vudc_hw(struct vudc *udc
 	init_waitqueue_head(&udc->tx_waitq);
 
 	spin_lock_init(&ud->lock);
+	mutex_init(&ud->sysfs_lock);
 	ud->status = SDEV_ST_AVAILABLE;
 	ud->side = USBIP_VUDC;
 
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -112,6 +112,7 @@ static ssize_t usbip_sockfd_store(struct
 		dev_err(dev, "no device");
 		return -ENODEV;
 	}
+	mutex_lock(&udc->ud.sysfs_lock);
 	spin_lock_irqsave(&udc->lock, flags);
 	/* Don't export what we don't have */
 	if (!udc->driver || !udc->pullup) {
@@ -187,6 +188,8 @@ static ssize_t usbip_sockfd_store(struct
 
 		wake_up_process(udc->ud.tcp_rx);
 		wake_up_process(udc->ud.tcp_tx);
+
+		mutex_unlock(&udc->ud.sysfs_lock);
 		return count;
 
 	} else {
@@ -207,6 +210,7 @@ static ssize_t usbip_sockfd_store(struct
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return count;
 
@@ -216,6 +220,7 @@ unlock_ud:
 	spin_unlock_irq(&udc->ud.lock);
 unlock:
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return ret;
 }


