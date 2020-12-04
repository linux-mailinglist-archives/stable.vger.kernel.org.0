Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B372CEA50
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 09:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgLDI4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 03:56:10 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36054 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLDI4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 03:56:10 -0500
Received: by mail-lj1-f194.google.com with SMTP id a1so4390949ljq.3;
        Fri, 04 Dec 2020 00:55:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDCSp0miPN9urc3464sy+Tdb5gq+YorHHrJWD0fSGKI=;
        b=jGcVGF9T83Ffd/TbOa1/EeBP1klmF0hdJfRtVsyHfr7qLA+loQ1sHxX4t2L25OoN87
         EpHFudiiji8S9JiSySQU8979zrL8x3iwBYElUIbmXzS/gWFzdmkhpGfuJMGEBOUfjFsA
         8PkJXasfIjtkYdYzFKVVWUqtzRkdgvquCnP/G+u0EYvRkEKCmEzXd4mH4TmxjrXtCREX
         ZpvdyL2xvcggHsyE47Uw1KRcCS6XVBQlrWe2FZvRXzXDqJDh9N/BACCVxHn6UH6aigJ4
         ihMtig++N9N4nwng8S82nsvGinnvmb0zQ6JUvTzIgR1kvMGh7NlyidqRDyXoaKZ9wW8E
         O1ww==
X-Gm-Message-State: AOAM530vq42s5FtcvFsNPxNFYnYyjhKdpFa4SdsZMEzO1tCuOK/J4jfv
        HxOSEqi6DK6l8s56IZIl4djqvzcwh2xOjg==
X-Google-Smtp-Source: ABdhPJypwncW4oaG4sAVGxO1SOdEGfqoiQERwJoYKMOM7n4E7ZpHin3qPLJxXhyO/i3pGhCzHOIFHQ==
X-Received: by 2002:a2e:9615:: with SMTP id v21mr2830397ljh.211.1607072127651;
        Fri, 04 Dec 2020 00:55:27 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id q14sm1458163lfb.281.2020.12.04.00.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 00:55:26 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kl6si-0005HD-H5; Fri, 04 Dec 2020 09:56:00 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] USB: serial: kl5kusb105: fix memleak on open
Date:   Fri,  4 Dec 2020 09:55:19 +0100
Message-Id: <20201204085519.20230-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix memory leak of control-message transfer buffer on successful open().

Fixes: 6774d5f53271 ("USB: serial: kl5kusb105: fix open error path")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---

While reviewing Himadri's control-message series I noticed we have a
related bug in klsi_105_open() that needs fixing.


 drivers/usb/serial/kl5kusb105.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 5ee48b0650c4..5f6b82ebccc5 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -276,12 +276,12 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
 	priv->cfg.unknown2 = cfg->unknown2;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	kfree(cfg);
+
 	/* READ_ON and urb submission */
 	rc = usb_serial_generic_open(tty, port);
-	if (rc) {
-		retval = rc;
-		goto err_free_cfg;
-	}
+	if (rc)
+		return rc;
 
 	rc = usb_control_msg(port->serial->dev,
 			     usb_sndctrlpipe(port->serial->dev, 0),
@@ -324,8 +324,6 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
 			     KLSI_TIMEOUT);
 err_generic_close:
 	usb_serial_generic_close(port);
-err_free_cfg:
-	kfree(cfg);
 
 	return retval;
 }
-- 
2.26.2

