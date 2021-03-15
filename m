Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D1433B849
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhCOOCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232069AbhCOOAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98EB064F05;
        Mon, 15 Mar 2021 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816786;
        bh=yOctb2DWSX1j9ncR181f6JnRrNfFuR3rmejQsGw0HCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJpimI5pgRx5po/wCjCc83TRnxiIVvuK/H4GM766aDI+3H9E43/Gf/gEoR7rKViuq
         dZcydqqhjo/9hdoDx+dkLkTSIHKy8eQw7vLQjDXR4Dpb45jDIHEDT6Yn+EUOXz8UI4
         EkoT/fVJWb8hh7gBUze99wsDMm82PZ+xkLzc80Ko=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.14 61/95] usbip: fix vhci_hcd to check for stream socket
Date:   Mon, 15 Mar 2021 14:57:31 +0100
Message-Id: <20210315135742.275255591@linuxfoundation.org>
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

commit f55a0571690c4aae03180e001522538c0927432f upstream.

Fix attach_store() to validate the passed in file descriptor is a
stream socket. If the file descriptor passed was a SOCK_DGRAM socket,
sock_recvmsg() can't detect end of stream.

Cc: stable@vger.kernel.org
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/52712aa308915bda02cece1589e04ee8b401d1f3.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vhci_sysfs.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -363,8 +363,16 @@ static ssize_t store_attach(struct devic
 
 	/* Extract socket from fd. */
 	socket = sockfd_lookup(sockfd, &err);
-	if (!socket)
+	if (!socket) {
+		dev_err(dev, "failed to lookup sock");
 		return -EINVAL;
+	}
+	if (socket->type != SOCK_STREAM) {
+		dev_err(dev, "Expecting SOCK_STREAM - found %d",
+			socket->type);
+		sockfd_put(socket);
+		return -EINVAL;
+	}
 
 	/* now need lock until setting vdev status as used */
 


