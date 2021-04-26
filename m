Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6E36AD51
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhDZHdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhDZHdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0384611BF;
        Mon, 26 Apr 2021 07:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422379;
        bh=FOVNsP37ujZU56ZO0D/Mg7ahp3v4DxwECQ6+MyBv7tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lur5EpmLNh1/LlGkQqlEcI9SIjXnioAcCfCBePQfZ6AH/gjRkcbUWAcWrMDnMVnas
         qIdDTHjnblQr5k6eCs01xWv+y6761v4ncLI2sG9TWmSnJoRtCKgx4MzC0iLrT3Xugb
         4pY+4reR13s2S1yFx4CKh4jeT1Dsa3xS7VDOox7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Subject: [PATCH 4.9 26/37] usbip: vudc synchronize sysfs code paths
Date:   Mon, 26 Apr 2021 09:29:27 +0200
Message-Id: <20210426072818.135957668@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
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

Cc: stable@vger.kernel.org # 4.9.x # 4.14.x
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/caabcf3fc87bdae970509b5ff32d05bb7ce2fb15.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_dev.c   |    1 +
 drivers/usb/usbip/vudc_sysfs.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/usbip/vudc_dev.c
+++ b/drivers/usb/usbip/vudc_dev.c
@@ -582,6 +582,7 @@ static int init_vudc_hw(struct vudc *udc
 	init_waitqueue_head(&udc->tx_waitq);
 
 	spin_lock_init(&ud->lock);
+	mutex_init(&ud->sysfs_lock);
 	ud->status = SDEV_ST_AVAILABLE;
 	ud->side = USBIP_VUDC;
 
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -125,6 +125,7 @@ static ssize_t store_sockfd(struct devic
 		dev_err(dev, "no device");
 		return -ENODEV;
 	}
+	mutex_lock(&udc->ud.sysfs_lock);
 	spin_lock_irqsave(&udc->lock, flags);
 	/* Don't export what we don't have */
 	if (!udc->driver || !udc->pullup) {
@@ -200,6 +201,8 @@ static ssize_t store_sockfd(struct devic
 
 		wake_up_process(udc->ud.tcp_rx);
 		wake_up_process(udc->ud.tcp_tx);
+
+		mutex_unlock(&udc->ud.sysfs_lock);
 		return count;
 
 	} else {
@@ -220,6 +223,7 @@ static ssize_t store_sockfd(struct devic
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return count;
 
@@ -229,6 +233,7 @@ unlock_ud:
 	spin_unlock_irq(&udc->ud.lock);
 unlock:
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return ret;
 }


