Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7C1328937
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhCARwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238579AbhCARqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:46:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F369C64F5B;
        Mon,  1 Mar 2021 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617942;
        bh=jxdL+NXLqAGrcWPfzTx4Ka+fkw2lSjx8W/G5Jhpuyac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSF2E9FFNYnusGd7QsQzh6JZbC1DbTOrCT7Q3LWpBx8dGiIwfN07v6QrYrdPiKsgQ
         TV1i8ZJnQyjIzPkdYKWExaXc5ZghVTSrThmUua+4LLVP60/gQ+9JKcQX+ESkb69bGL
         nkLsdQx/uNA/orX2PE2bvBnata3YNiHy4x0Fchpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 251/340] USB: serial: mos7720: fix error code in mos7720_write()
Date:   Mon,  1 Mar 2021 17:13:15 +0100
Message-Id: <20210301161100.648149801@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
@@ -1250,8 +1250,10 @@ static int mos7720_write(struct tty_stru
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
 


