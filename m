Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A58C24F1
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 18:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732240AbfI3QNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 12:13:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39099 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732198AbfI3QNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 12:13:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id 72so7482353lfh.6;
        Mon, 30 Sep 2019 09:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KXfl4ww2DrWF3pEnl8LcNO7G+susED8wh9HsxIg0JQw=;
        b=M4uQ+uA3fD0ziLfOUH7Zf0ikcuehxgwFrpIjo7/66z67aCaCQhxJNpiHA1R3MZ6lld
         Pc4yaYkk28A2czKYX24Z+32tyuOb64T1DnbHDh4LgOCj77hqo2hKp6UcZDzCYG03049Z
         H0NvdmFo6PGKtM66IPfVXELySp758/4qp0IIAMaEJx5yMr0pI/d4lQar6szpW8vQ0wtf
         e9lyYdDYX97spZnasNnNdYjVFVO0ga9JFlRk39lWjMzGOnuMBrDRzwykbjBZnXlOyqmp
         VgNAf0O+RAp/3Hsfl3iMCP2PxYyjaWsYdx/WykhnL33lH1oBZsP5dL1SwOwM9gqQgC9l
         ttoQ==
X-Gm-Message-State: APjAAAVg1c9QTOizr7iadxGj2ow96aUiADt7WpaXJgY1EXEo7R5b89Gw
        C0Q74ITIscWYz8JyKxwUG04=
X-Google-Smtp-Source: APXvYqwrLdfKkzjvjreL0RNH/iUPmuMtOzANmSTvmM0nPK7ujkTyEPLdzjwvfColyZhp8/frTUwJ/Q==
X-Received: by 2002:ac2:5504:: with SMTP id j4mr12388515lfk.186.1569859977680;
        Mon, 30 Sep 2019 09:12:57 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id t16sm3457875ljj.29.2019.09.30.09.12.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 09:12:55 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iEyIG-0004ue-EZ; Mon, 30 Sep 2019 18:13:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 4/4] media: stkwebcam: fix runtime PM after driver unbind
Date:   Mon, 30 Sep 2019 18:12:05 +0200
Message-Id: <20190930161205.18803-5-johan@kernel.org>
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

