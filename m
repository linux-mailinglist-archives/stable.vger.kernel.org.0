Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B7A328768
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhCARXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236529AbhCARQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:16:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76B2B65032;
        Mon,  1 Mar 2021 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617157;
        bh=jxdL+NXLqAGrcWPfzTx4Ka+fkw2lSjx8W/G5Jhpuyac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SluCUSIeZrPd62iGjdn46eTfiv+PNs/Qyj3EAfEBR2pxcX20UPTITZF24SG5RQwT4
         cxqb2gKmQa72tQ3j+VVQJq1rpCRmqF0PfZkZ7GjEcS5c+pt0kBcEdCF5UyN52Zg3o8
         n+KplMyJujwdV706g+Wt/YJdytpmlthtUf4BWzTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 192/247] USB: serial: mos7720: fix error code in mos7720_write()
Date:   Mon,  1 Mar 2021 17:13:32 +0100
Message-Id: <20210301161041.056678560@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
 


