Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB63BB8E6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 10:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhGEIXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 04:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhGEIXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 04:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6E14613D1;
        Mon,  5 Jul 2021 08:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625473240;
        bh=2qGaB+9dBhwuQSeXnep3Txw8p7mnzuwuscJcjkt04Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5gahN3fE88vqceXluYGEonIG66aX9sCDRemX9rLieY8wkPbyNuflgwi2HJRHOHQ8
         h6nDxpj5AYLsvTII33x+1z5QmPf2f1MxSpFYbJzhykDZJ9VmSfGJ2g5a72u8REUwo8
         UqeB/B7XUUJP8mvSqgtquwhzv9uUtu0kVfPx5xgcHEjE/MRH1Siv1bjohlU3gti+bv
         gxbwFkvwn/XBreVEq9SLE2QHf2GrA8F9mCnsmHy4UmKkRnD5elk7kLIPpGDvEfdtaq
         rPyWOI2gb+5Y5x7uTfEVVLtkDz31fFlrFQj1YZfIYkvVdidgP8BB6LPKKE9jwadHlJ
         IKw9LqrPx7Wqg==
Received: from johan by xi with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m0JqF-0004lp-46; Mon, 05 Jul 2021 10:20:35 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 1/6] USB: serial: cp210x: fix control-characters error handling
Date:   Mon,  5 Jul 2021 10:20:10 +0200
Message-Id: <20210705082015.18286-2-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210705082015.18286-1-johan@kernel.org>
References: <20210705082015.18286-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the unlikely event that setting the software flow-control characters
fails the other flow-control settings should still be updated (just like
all other terminal settings).

Move out the error message printed by the set_chars() helper to make it
more obvious that this is intentional.

Fixes: 7748feffcd80 ("USB: serial: cp210x: add support for software flow control")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 09b845d0da41..fd198031de71 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1163,10 +1163,8 @@ static int cp210x_set_chars(struct usb_serial_port *port,
 
 	kfree(dmabuf);
 
-	if (result < 0) {
-		dev_err(&port->dev, "failed to set special chars: %d\n", result);
+	if (result < 0)
 		return result;
-	}
 
 	return 0;
 }
@@ -1218,8 +1216,10 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 		chars.bXoffChar = STOP_CHAR(tty);
 
 		ret = cp210x_set_chars(port, &chars);
-		if (ret)
-			return;
+		if (ret) {
+			dev_err(&port->dev, "failed to set special chars: %d\n",
+					ret);
+		}
 	}
 
 	mutex_lock(&port_priv->mutex);
-- 
2.31.1

