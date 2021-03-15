Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D132233B81B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhCOOCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232885AbhCOOAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 051CC64F5B;
        Mon, 15 Mar 2021 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816788;
        bh=2BIycqwhJIlEfRFJTM7CLI8vnQgrYEVG62hH6jHCeWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SOolGir0w/6mgbALCTi6Q2mQNPaYHv68YjGcttUKKlHjBQRmd5gHGV1MLumz/Oc6
         /Ve7Bsh3MLFX0Ecnaezpv6lI55AYrYHIOPe8jR/9ZSR9uAOD/OZUllgD5aOKQ+nf/J
         G+g7hLW/53VTlXkOA25sHe8Uj4R80FrhnhpMd070=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.14 62/95] usbip: fix vudc to check for stream socket
Date:   Mon, 15 Mar 2021 14:57:32 +0100
Message-Id: <20210315135742.306599964@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shuah Khan <skhan@linuxfoundation.org>

commit 6801854be94fe8819b3894979875ea31482f5658 upstream.

Fix usbip_sockfd_store() to validate the passed in file descriptor is
a stream socket. If the file descriptor passed was a SOCK_DGRAM socket,
sock_recvmsg() can't detect end of stream.

Cc: stable@vger.kernel.org
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/387a670316002324113ac7ea1e8b53f4085d0c95.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_sysfs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -24,6 +24,7 @@
 #include <linux/usb/ch9.h>
 #include <linux/sysfs.h>
 #include <linux/kthread.h>
+#include <linux/file.h>
 #include <linux/byteorder/generic.h>
 
 #include "usbip_common.h"
@@ -150,6 +151,13 @@ static ssize_t store_sockfd(struct devic
 			goto unlock_ud;
 		}
 
+		if (socket->type != SOCK_STREAM) {
+			dev_err(dev, "Expecting SOCK_STREAM - found %d",
+				socket->type);
+			ret = -EINVAL;
+			goto sock_err;
+		}
+
 		udc->ud.tcp_socket = socket;
 
 		spin_unlock_irq(&udc->ud.lock);
@@ -189,6 +197,8 @@ static ssize_t store_sockfd(struct devic
 
 	return count;
 
+sock_err:
+	sockfd_put(socket);
 unlock_ud:
 	spin_unlock_irq(&udc->ud.lock);
 unlock:


