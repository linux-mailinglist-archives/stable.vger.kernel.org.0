Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38787D2A37
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 14:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387980AbfJJM65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 08:58:57 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43445 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbfJJM6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 08:58:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id n14so6072783ljj.10;
        Thu, 10 Oct 2019 05:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sFfJKZrsZ65QHdG/a6Vjdwobjv+Fk7Z1ecZ7AQainIo=;
        b=PFBusBVRzgPljPc+cHreTsNfSAxkcbWsYhHyRB0TI9kSHuNA+J9TFgSkZvPBF7bEhq
         AxdKaIfzITQXUCRgNV5BcUynpqGJsdcDA6VqmlfjcSSMbCw/QvO2KtGu8tKpvAB8nkxu
         00BMrsAUw2jOA/fAmS023KaVFGTVjj31UtjciWx4l5quuEeTylhTY+J1O7j/0gRnw6e7
         qT+zb6UYnMjoYA7Z1ZBBq6vZOjn76pgtqe9jAUcQNZcBYMR5R288HJcI0u9RPgXvLoP9
         iEIYCJtQ10HGosng4lOrQnzpwUTNsfggg6tRCL09mmz+vFQayTGws8QxC2gf5U64tRFA
         urSw==
X-Gm-Message-State: APjAAAX161qTIt014B/mIdHiMTnW3FEOrpDcGS/oUjjuKYnkXt3OpA1d
        SuVk9KxvlB9ejMzhh+FGqzs=
X-Google-Smtp-Source: APXvYqzrMxpqqH/x0hvuWkRUifQkU26w8tdkyxPlpaMcnr1jxd8rdd6qQGWg12N0vXP4j9dc3lkBXQ==
X-Received: by 2002:a2e:9a43:: with SMTP id k3mr6000549ljj.70.1570712327840;
        Thu, 10 Oct 2019 05:58:47 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id c26sm1358291ljj.45.2019.10.10.05.58.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 05:58:46 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIY1x-00072r-HT; Thu, 10 Oct 2019 14:58:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] USB: ldusb: fix memleak on disconnect
Date:   Thu, 10 Oct 2019 14:58:34 +0200
Message-Id: <20191010125835.27031-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010125835.27031-1-johan@kernel.org>
References: <20191010125835.27031-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If disconnect() races with release() after a process has been
interrupted, release() could end up returning early and the driver would
fail to free its driver data.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/ldusb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index f3108d85e768..147c90c2a4e5 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -380,10 +380,7 @@ static int ld_usb_release(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	if (mutex_lock_interruptible(&dev->mutex)) {
-		retval = -ERESTARTSYS;
-		goto exit;
-	}
+	mutex_lock(&dev->mutex);
 
 	if (dev->open_count != 1) {
 		retval = -ENODEV;
-- 
2.23.0

