Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4383285E1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhCARAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234728AbhCAQyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:54:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C813064F2F;
        Mon,  1 Mar 2021 16:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616467;
        bh=5DpQsodXPOTn/fgDG7frGSnzfafqEKAGHZrwfk2LHqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4+9qJs5/3y6YJGQlW/wWdrFcT1yKME3QkR+LLtDsZP2V1mkcRJgtkEsSHb+DbdsZ
         bBgEHT7fsZ0FdCkvphJLqb+4nYyvd0BghCbW2USvHWQaXrnbkt9vbdjhtSXnSA3lOt
         FxG+9YoJBxSsREY4SiGrtGHNN6cDLbYOiBX1KnBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 131/176] USB: serial: mos7840: fix error code in mos7840_write()
Date:   Mon,  1 Mar 2021 17:13:24 +0100
Message-Id: <20210301161027.497442870@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a70aa7dc60099bbdcbd6faca42a915d80f31161e upstream.

This should return -ENOMEM instead of 0 if the kmalloc() fails.

Fixes: 3f5429746d91 ("USB: Moschip 7840 USB-Serial Driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mos7840.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1352,8 +1352,10 @@ static int mos7840_write(struct tty_stru
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
 


