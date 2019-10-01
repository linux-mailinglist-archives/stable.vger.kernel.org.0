Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C583C2F34
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 10:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733185AbfJAItX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 04:49:23 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44381 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733162AbfJAItW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 04:49:22 -0400
Received: by mail-lj1-f196.google.com with SMTP id m13so12409800ljj.11;
        Tue, 01 Oct 2019 01:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ca/INmDFVsC6VnPl4lbuo+UeGmswEkRdIM5NeHHd3ug=;
        b=Ww2Ryi3ltsDgPMrNrUxlUd1YCrtKo4JXAq66jwhEe5NhT3hH6bvP3PCNYNTXWWH/km
         rnASuR5wZ/e7lFdrzlwDbZwYGPdCB1pLom4PU5IGqCn0HUOzyhRoNuFZ3zS1Qv1Q0BlI
         OubmPXEvOAjpE2tmNxkggcT8p1DJPrSJ1bMKcXjdACiBJJFLIThbGNKqPbrIOjgdiSS8
         LLDdlphbJv0NC6KwYkn9T4+FhtqkWLBm8pMy78ACj4K7jpypqmXY02NCz7ip5kgwuByZ
         5odw/nPiZojdsFm7CCzljDuNapnvdx7u9/whkX0NFc8gNnqDp5VBYs2YZfzyCKKpQvKR
         /Wlw==
X-Gm-Message-State: APjAAAVQRnLGLiV7f6pH4I/zY1gt915BUquHgIQDjPfyMusTTv2k0uYo
        aUCRfvfq32JcZqMNBFnp6Jk=
X-Google-Smtp-Source: APXvYqx6zk0AODtqV62ey8fF5pZauaelQT9dehzN+xR3TYKKj5ckKfHYTVe4n8+ixmC52JRbSN1mxQ==
X-Received: by 2002:a2e:4296:: with SMTP id h22mr15418860ljf.208.1569919760229;
        Tue, 01 Oct 2019 01:49:20 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id h12sm3880087ljg.24.2019.10.01.01.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 01:49:18 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iFDqX-0000XP-BP; Tue, 01 Oct 2019 10:49:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v2 4/4] media: stkwebcam: fix runtime PM after driver unbind
Date:   Tue,  1 Oct 2019 10:49:08 +0200
Message-Id: <20191001084908.2003-5-johan@kernel.org>
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

Note that runtime PM has never actually been enabled for this driver
since the support_autosuspend flag in its usb_driver struct is not set.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index be8041e3e6b8..b0cfa4c1f8cc 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -643,8 +643,7 @@ static int v4l_stk_release(struct file *fp)
 		dev->owner = NULL;
 	}
 
-	if (is_present(dev))
-		usb_autopm_put_interface(dev->interface);
+	usb_autopm_put_interface(dev->interface);
 	mutex_unlock(&dev->lock);
 	return v4l2_fh_release(fp);
 }
-- 
2.23.0

