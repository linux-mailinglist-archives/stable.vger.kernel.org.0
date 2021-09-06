Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA19401BC0
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242991AbhIFM7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242937AbhIFM6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ADE66103D;
        Mon,  6 Sep 2021 12:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933069;
        bh=aI/tw9ZEy2/QbQIju4vdgcAArBTdcRL2ytuXEqhp2og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoj5niqGnwV85ymVtL7nlqgYqL+kcxnjVWxteZ2m7mPRTDohhLiLd7Nm4J3ElluEW
         OadNIt5/YV8xPcjM8usPDSM0foXLekWDMFxwPaRKqeUqoCcPbYeyNX7uiTSnHJPuzO
         qoFGuCNUr0QTNaZMERmmW+sEJERhrnOmfsT0iMm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.13 18/24] USB: serial: cp210x: fix control-characters error handling
Date:   Mon,  6 Sep 2021 14:55:47 +0200
Message-Id: <20210906125449.717812358@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2d9a00705910ccea2dc5d9cba5469ff2de72fc87 upstream.

In the unlikely event that setting the software flow-control characters
fails the other flow-control settings should still be updated (just like
all other terminal settings).

Move out the error message printed by the set_chars() helper to make it
more obvious that this is intentional.

Fixes: 7748feffcd80 ("USB: serial: cp210x: add support for software flow control")
Cc: stable@vger.kernel.org	# 5.11
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1110,10 +1110,8 @@ static int cp210x_set_chars(struct usb_s
 
 	kfree(dmabuf);
 
-	if (result < 0) {
-		dev_err(&port->dev, "failed to set special chars: %d\n", result);
+	if (result < 0)
 		return result;
-	}
 
 	return 0;
 }
@@ -1165,8 +1163,10 @@ static void cp210x_set_flow_control(stru
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


