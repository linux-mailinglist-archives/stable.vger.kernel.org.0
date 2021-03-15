Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD7733B88E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhCOODv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233013AbhCOOAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E6864F16;
        Mon, 15 Mar 2021 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816811;
        bh=F54PcwDAnn2FMWaao0DWhknqEzjDpPH545XJu/fYX0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhmUj1NuBejK6oV+G4Mkesx+t27KGd7bIG7S2cz50L8rPtnQWjFd7UjiIYzhmeMo/
         4enMsAVe5gNaofFJkPixwoX0FVGF7ESvwG9r3nlZ2n7LkJ2ey/mzE2xMjxSytb/TUU
         pck0IlJMiVeD5Dwsp46PDz9F5/stFtLRjlAOSMMw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 084/120] usbip: fix vhci_hcd to check for stream socket
Date:   Mon, 15 Mar 2021 14:57:15 +0100
Message-Id: <20210315135722.714558186@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
@@ -349,8 +349,16 @@ static ssize_t attach_store(struct devic
 
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
 


