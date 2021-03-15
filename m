Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5CB33BAD8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhCOOKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233980AbhCOOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C3164EF1;
        Mon, 15 Mar 2021 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816964;
        bh=7FnpRKc4Wvba20HFD+Q6GPJu64JtwqjEycgRBK0bmhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZvEaIFka9dfJ9M0Qizw+0kWfQzInLS1E4TNNFv3jQ2YGfA0E/G3uZkEioJ4GsC/L
         I0sQ9Jxsx4mcVslmGciwFCRhqQtC2IVIFlnhZngsx6MKeUAPQU965x2GZAQ64v2A1F
         X/Ccc0qMl6pVMLv6S/UsTQpi75J36Mrl/nfhxilI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 216/290] usbip: fix stub_dev to check for stream socket
Date:   Mon, 15 Mar 2021 14:55:09 +0100
Message-Id: <20210315135549.266480936@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shuah Khan <skhan@linuxfoundation.org>

commit 47ccc8fc2c9c94558b27b6f9e2582df32d29e6e8 upstream.

Fix usbip_sockfd_store() to validate the passed in file descriptor is
a stream socket. If the file descriptor passed was a SOCK_DGRAM socket,
sock_recvmsg() can't detect end of stream.

Cc: stable@vger.kernel.org
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/e942d2bd03afb8e8552bd2a5d84e18d17670d521.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/stub_dev.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -69,8 +69,16 @@ static ssize_t usbip_sockfd_store(struct
 		}
 
 		socket = sockfd_lookup(sockfd, &err);
-		if (!socket)
+		if (!socket) {
+			dev_err(dev, "failed to lookup sock");
 			goto err;
+		}
+
+		if (socket->type != SOCK_STREAM) {
+			dev_err(dev, "Expecting SOCK_STREAM - found %d",
+				socket->type);
+			goto sock_err;
+		}
 
 		sdev->ud.tcp_socket = socket;
 		sdev->ud.sockfd = sockfd;
@@ -100,6 +108,8 @@ static ssize_t usbip_sockfd_store(struct
 
 	return count;
 
+sock_err:
+	sockfd_put(socket);
 err:
 	spin_unlock_irq(&sdev->ud.lock);
 	return -EINVAL;


