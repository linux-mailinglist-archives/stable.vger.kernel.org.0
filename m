Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D926A329112
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243198AbhCAUSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239590AbhCAULP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:11:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C824653C2;
        Mon,  1 Mar 2021 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621647;
        bh=Srp7eACj6nViiSgYscfWjdEKWP/1BY+vFIdStxKvZzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/qAftBGFC2FO+spHb7vAWSAR9Ydg/SU5l72yhwBmWZjYQqVsVeB2v0EgDwx7TJv7
         X2p2raQZy8eJVnSyEIfgfY/gunUdvlh1qF9lLj+jJ+5IH+2n7x6Bu6AD39ZBnmQPXX
         WTbssZxG87ghUgxBvGg6C5A4LwEtq8pCBif37o4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 591/775] USB: serial: mos7720: fix error code in mos7720_write()
Date:   Mon,  1 Mar 2021 17:12:39 +0100
Message-Id: <20210301161230.637126173@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit fea7372cbc40869876df0f045e367f6f97a1666c upstream.

This code should return -ENOMEM if the kmalloc() fails but instead
it returns success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 0f64478cbc7a ("USB: add USB serial mos7720 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mos7720.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1092,8 +1092,10 @@ static int mos7720_write(struct tty_stru
 	if (urb->transfer_buffer == NULL) {
 		urb->transfer_buffer = kmalloc(URB_TRANSFER_BUFFER_SIZE,
 					       GFP_ATOMIC);
-		if (!urb->transfer_buffer)
+		if (!urb->transfer_buffer) {
+			bytes_sent = -ENOMEM;
 			goto exit;
+		}
 	}
 	transfer_size = min(count, URB_TRANSFER_BUFFER_SIZE);
 


