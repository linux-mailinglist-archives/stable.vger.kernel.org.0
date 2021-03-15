Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F33833B8DD
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhCOOEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232978AbhCOOA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEF2964F1A;
        Mon, 15 Mar 2021 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816800;
        bh=7FnpRKc4Wvba20HFD+Q6GPJu64JtwqjEycgRBK0bmhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfjbruLd4pp73CMJqMSqeRuzfdYh/z2RT7Isafl6N5QaKduS/2OApT7ldTK6ZTQRY
         nAQr7lXvq1EQL9HhPW39rqHQx4herKCB4ieBvBKcrCODAxt7wys2/szGPu2Mw/FmjG
         vujGgDZNy+kLWnX9QahzEZ+jGBGPZ0UoQxF3ACLE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 119/168] usbip: fix stub_dev to check for stream socket
Date:   Mon, 15 Mar 2021 14:55:51 +0100
Message-Id: <20210315135554.270235407@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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


