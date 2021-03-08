Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9E4330693
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 04:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhCHDx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 22:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbhCHDxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 22:53:35 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862DEC061760
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 19:53:35 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n132so8548664iod.0
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 19:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjP5jnpjOCAAGVvM2wgeXDUNlH+i430AZmhAaZRiAsc=;
        b=P4mqjVrcRIoZvnHBTs8vz2AUyZS7YuVUCwejYaWNBf4NufH7g4nOfO+8f3VQfc/YZm
         /NlPoAUgCXi/BAClLpBTF4RLHxJ2QfM0Zmvl7aWFuEANkE36YyI0GzWgX2Tio0kMbtQL
         3TKnbCnjucceTqy/R2jBSMlh519RWcZ5aE88s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjP5jnpjOCAAGVvM2wgeXDUNlH+i430AZmhAaZRiAsc=;
        b=fYdEW31Z93k1W82oTQsdXA6Y0aZDFulULcGmJ5bysWoFdpEbkRPxKYlQ22o7dugxh7
         ndIg8uHlD7FP8FiLgyQF1dx14w9AyaM/G7mMLzGP3onOCi+CylC+cIQLyZlXHkTqS4UZ
         hriKnEvejvR2L4Hgoswba/7EUju2eUSN7BODHB8ljb4GxA0h1tmi6cS2MbwDTSC9atA9
         4stgzeCcB9eSwFFZEdeYvKlhFTFh3FVygN8wWC6i4FFBO2rj2KJCPtGAO5s9Ek8Ix5ic
         8rtecr3wNm1R2F9dJ+RCEith027bbJUUqBpueEYuSmKnHUL32KeE6e7KW2A0dEvqTRhP
         QfSg==
X-Gm-Message-State: AOAM532GNPluuUPFnLdZ9dEnzuPWyyNihpVNvXUs2SAhE6ShNtg1TjLX
        miZusaOAKAwL8wnL5GxJ5PyDKg==
X-Google-Smtp-Source: ABdhPJzDImSLEVxZQblxYwCjtei3KT0UduOf/H0kLlvtdtz8OHNNv1wqu3/i06fuhwpTUDy0ndyp8A==
X-Received: by 2002:a02:9986:: with SMTP id a6mr21528852jal.46.1615175614977;
        Sun, 07 Mar 2021 19:53:34 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g6sm5605242ilj.28.2021.03.07.19.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:53:34 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        stable@vger.kernel.org
Subject: [PATCH 1/6] usbip: fix stub_dev to check for stream socket
Date:   Sun,  7 Mar 2021 20:53:26 -0700
Message-Id: <e942d2bd03afb8e8552bd2a5d84e18d17670d521.1615171203.git.skhan@linuxfoundation.org>
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
 drivers/usb/usbip/stub_dev.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 2305d425e6c9..90c105469a07 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -69,8 +69,16 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 		}
 
 		socket = sockfd_lookup(sockfd, &err);
-		if (!socket)
+		if (!socket) {
+			dev_err(dev, "failed to lookup sock");
 			goto err;
+		}
+
+		if (socket->type != SOCK_STREAM) {
+			dev_err(dev, "Expecting SOCK_STREAM - found %d",
+				socket->type);
+			goto sock_err;
+		}
 
 		sdev->ud.tcp_socket = socket;
 		sdev->ud.sockfd = sockfd;
@@ -100,6 +108,8 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 
 	return count;
 
+sock_err:
+	sockfd_put(socket);
 err:
 	spin_unlock_irq(&sdev->ud.lock);
 	return -EINVAL;
-- 
2.27.0

