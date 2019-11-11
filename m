Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849D1F7BD1
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbfKKSkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbfKKSkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:40:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9248220659;
        Mon, 11 Nov 2019 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497607;
        bh=Bgj+vTIHeYXBAec2NYwGiMFpMeuXE8kZEl3wAglFYrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neJ8elc4LhhFiWWGirS2kT9QtaIbAHhtYW/D6p7+nyfzRLmKR7zRWVsgrbsYnEZ18
         yANgKn8ef7sya0CPUkFKVCTNyt0g2Iaabq7EwoVCniT4qCsOzzua2Z+bV0KATlHCyW
         pd54B5YsJgaS3jPwFlYUIPEmQjCX5Ai0c2ofUV7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 090/105] USB: ldusb: use unsigned size format specifiers
Date:   Mon, 11 Nov 2019 19:29:00 +0100
Message-Id: <20191111181447.904369742@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 88f6bf3846ee90bf33aa1ce848cd3bfb3229f4a4 ]

A recent info-leak bug manifested itself along with warning about a
negative buffer overflow:

	ldusb 1-1:0.28: Read buffer overflow, -131383859965943 bytes dropped

when it was really a rather large positive one.

A sanity check that prevents this has now been put in place, but let's
fix up the size format specifiers, which should all be unsigned.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191022143203.5260-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/ldusb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 6387545b17ea0..e16af177d4670 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -490,7 +490,7 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 	}
 	bytes_to_read = min(count, *actual_buffer);
 	if (bytes_to_read < *actual_buffer)
-		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
+		dev_warn(&dev->intf->dev, "Read buffer overflow, %zu bytes dropped\n",
 			 *actual_buffer-bytes_to_read);
 
 	/* copy one interrupt_in_buffer from ring_buffer into userspace */
@@ -565,8 +565,9 @@ static ssize_t ld_usb_write(struct file *file, const char __user *buffer,
 	/* write the data into interrupt_out_buffer from userspace */
 	bytes_to_write = min(count, write_buffer_size*dev->interrupt_out_endpoint_size);
 	if (bytes_to_write < count)
-		dev_warn(&dev->intf->dev, "Write buffer overflow, %zd bytes dropped\n", count-bytes_to_write);
-	dev_dbg(&dev->intf->dev, "%s: count = %zd, bytes_to_write = %zd\n",
+		dev_warn(&dev->intf->dev, "Write buffer overflow, %zu bytes dropped\n",
+			count - bytes_to_write);
+	dev_dbg(&dev->intf->dev, "%s: count = %zu, bytes_to_write = %zu\n",
 		__func__, count, bytes_to_write);
 
 	if (copy_from_user(dev->interrupt_out_buffer, buffer, bytes_to_write)) {
-- 
2.20.1



