Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27CDC24E8
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 18:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732229AbfI3QM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 12:12:59 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:47067 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbfI3QM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 12:12:59 -0400
Received: by mail-lj1-f196.google.com with SMTP id d1so10081622ljl.13;
        Mon, 30 Sep 2019 09:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEnKuOgkKrLviOK0l9N8El4AVdrpE1iBgXB7qlP+GeQ=;
        b=hpG7/EyhFyE3ab0KAxqk0Q0ZWxHxQe1MYsJD5+oo5uhVFEJU0VQwPlwGaL/kbgVqaH
         4G72Gd10ntqLh5kqrW0o+HIaiYwvLQqlcm0Rv5W73f7EeOmTVU92BPIhDJNpzAOQr1Hy
         JRpoJVlNwTAiKi2SRLG567vLk4MJ0mdjtCVNGI+YmMyUoQu4PZ3CDCldagFjrXmqx2nD
         iT38dytEjxwILoLfqWuc+H50m6xUVmqDEAXMWHFyetIv5dqXuOguoIvbBXMPezIbbgF4
         NlawXEihshrQYMzfF1WsO6kIVI76kMx0CGIMr8rT4u/3knsi4BR0iLaFCC512y6YhehB
         brKg==
X-Gm-Message-State: APjAAAXUfQIMKy0o3kJE/0tmMsDB3Qh/gGc1gI9bN/6WPsN3N6rzB2HT
        GT6nFvoLTAAXfF1G3Sk8bMc=
X-Google-Smtp-Source: APXvYqwOF/N0CXWKmJ6fTpKEVqlteqCm3V7fFmaN4n3H0vUsPdCvx7havB2AnvyalvE/lHR5MrQ+CQ==
X-Received: by 2002:a2e:58a:: with SMTP id 132mr12149808ljf.132.1569859976722;
        Mon, 30 Sep 2019 09:12:56 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id r19sm3447505ljd.95.2019.09.30.09.12.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 09:12:54 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iEyIG-0004uZ-C4; Mon, 30 Sep 2019 18:13:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 3/4] USB: serial: fix runtime PM after driver unbind
Date:   Mon, 30 Sep 2019 18:12:04 +0200
Message-Id: <20190930161205.18803-4-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190930161205.18803-1-johan@kernel.org>
References: <20190930161205.18803-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/usb-serial.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index a3179fea38c8..8f066bb55d7d 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -314,10 +314,7 @@ static void serial_cleanup(struct tty_struct *tty)
 	serial = port->serial;
 	owner = serial->type->driver.owner;
 
-	mutex_lock(&serial->disc_mutex);
-	if (!serial->disconnected)
-		usb_autopm_put_interface(serial->interface);
-	mutex_unlock(&serial->disc_mutex);
+	usb_autopm_put_interface(serial->interface);
 
 	usb_serial_put(serial);
 	module_put(owner);
-- 
2.23.0

