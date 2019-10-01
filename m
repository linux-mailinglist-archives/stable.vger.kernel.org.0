Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD5C2F33
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 10:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJAItW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 04:49:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36397 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfJAItV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 04:49:21 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so12455239ljj.3;
        Tue, 01 Oct 2019 01:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEnKuOgkKrLviOK0l9N8El4AVdrpE1iBgXB7qlP+GeQ=;
        b=srG7yudlO8VkBtzbNIoEmKFFBpOvbwD548Ek4AgYw+Im78BMM8rY/v9HPNL7bb+yKU
         rrClyCIsgza0T6aTdw4tagaiNElTrV1VKe8LGnnLWEkIyIic3ypzs09udhCJeNvu/Xib
         OUjfG+8YbnTs93euDYpr0I+dzEkGOQkSHw7FCKA4tPU6SRmIqlYZH1CVMAo48NLZezys
         3EKlF/Lkc4/ca9SUu0qrcX7Im4jvnHH44qVb324ToVCdsuz08/mOxvdUt+zpDWTNw1uc
         ujRH8WUZ1IXQwDCNMJEpeszZvVKzi9sQWAcF/mJXY+dH4IfGiyeBoVg1qeWdPuQ7yCsj
         /icg==
X-Gm-Message-State: APjAAAUu3NXguTmwEdbiFcKDNAR1hv6v7ULx+gsrwKPO1OyeA99qSFn5
        jrAxs76v10qcHiEUjCgY6Elx70N3
X-Google-Smtp-Source: APXvYqwNmxwDPfKwLfU3tI2fm/OOm/SmdNhB6Ir+FYReLs4k/zz841y6msaT/KEz9vT5NStVRqQyJg==
X-Received: by 2002:a2e:1409:: with SMTP id u9mr15376750ljd.162.1569919759420;
        Tue, 01 Oct 2019 01:49:19 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id l5sm3710079lfk.17.2019.10.01.01.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 01:49:16 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iFDqX-0000XJ-8f; Tue, 01 Oct 2019 10:49:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2 3/4] USB: serial: fix runtime PM after driver unbind
Date:   Tue,  1 Oct 2019 10:49:07 +0200
Message-Id: <20191001084908.2003-4-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191001084908.2003-1-johan@kernel.org>
References: <20191001084908.2003-1-johan@kernel.org>
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

