Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79469330697
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 04:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhCHDx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 22:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbhCHDxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 22:53:47 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE57C061763
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 19:53:36 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id g9so7630791ilc.3
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 19:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jfBcYPaGqJRmNnRXl3kKKp++fKO4JboST8Ge5jyVPcc=;
        b=iP3vnqBgO6g6UBsdc6FNQ+TgtCTXWzIxph2blsbQPe1q30swpPVPYVEQl0rTYoIYBt
         BlFHVhYXfTLbMtmmMc8e9+am1JdGY3Xco4L2nt6ZYwb0q99AgZxbdBBzVEosDCxYBulw
         SV1z3TJfcBQ19neLuD9ikHlZPOOH1BHV0SvGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jfBcYPaGqJRmNnRXl3kKKp++fKO4JboST8Ge5jyVPcc=;
        b=pf4pHPXGAevJsVZ0liC/OkXamvXOHd8O+CqTwEUS1cBfNFp17NZ1afkNcalAMzjM36
         wdLX5t8ets1KvVB+TNIRFh1sDW9Cmc6xTYf8qPDOwDhdJhxVHMObyhh1w8qDiRT+kxVP
         uxpAnwIAY7j0FajpKISJdrlbIyhuieKXYlsfKYOopat0FKE1/JscBLgNEFfAqakVSn1T
         egaZZZSk5devZX6I1SIcLLTSai41Iw6ud/OXwIvN6sVWvXUOcjp/Oi4zyINXVhOG7G7E
         aNC007RdCqm7+SrzEyKeddq7fYuNUxOcB3aw3zeaqj6DeBnRD3Imapv2TeMuPxpNJwtM
         jGAA==
X-Gm-Message-State: AOAM532dAyfCHMq15EXM3L5g5N8ggn6nNk4PNoiVIuTGYNp7gFGXVwUK
        wQlKgjF6SJjOFh+FMRfTjOCgXkPTefwMkg==
X-Google-Smtp-Source: ABdhPJwhnJ6mKBfzTVpwyXBlLAIHmtw5dq2N8RMO43ddhwsVBSTwEgp0dMD0+FChqHM1OXs3mLx7uw==
X-Received: by 2002:a05:6e02:e87:: with SMTP id t7mr18241869ilj.211.1615175616357;
        Sun, 07 Mar 2021 19:53:36 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g6sm5605242ilj.28.2021.03.07.19.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:53:36 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        stable@vger.kernel.org
Subject: [PATCH 3/6] usbip: fix vudc to check for stream socket
Date:   Sun,  7 Mar 2021 20:53:28 -0700
Message-Id: <387a670316002324113ac7ea1e8b53f4085d0c95.1615171203.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1615171203.git.skhan@linuxfoundation.org>
References: <cover.1615171203.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix usbip_sockfd_store() to validate the passed in file descriptor is
a stream socket. If the file descriptor passed was a SOCK_DGRAM socket,
sock_recvmsg() can't detect end of stream.

Cc: stable@vger.kernel.org
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_sysfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index 100f680c572a..83a0c59a3de8 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -138,6 +138,13 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 			goto unlock_ud;
 		}
 
+		if (socket->type != SOCK_STREAM) {
+			dev_err(dev, "Expecting SOCK_STREAM - found %d",
+				socket->type);
+			ret = -EINVAL;
+			goto sock_err;
+		}
+
 		udc->ud.tcp_socket = socket;
 
 		spin_unlock_irq(&udc->ud.lock);
@@ -177,6 +184,8 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 
 	return count;
 
+sock_err:
+	sockfd_put(socket);
 unlock_ud:
 	spin_unlock_irq(&udc->ud.lock);
 unlock:
-- 
2.27.0

