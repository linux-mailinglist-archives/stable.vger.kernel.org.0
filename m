Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D752982D3
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 18:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417722AbgJYRqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 13:46:39 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38412 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1417705AbgJYRqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 13:46:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id m20so7303258ljj.5;
        Sun, 25 Oct 2020 10:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ryLZzM6AeLljw7FhT9jJjorgcKimBmMyaAgnsuFGOJ8=;
        b=sw5KEo9n0mtrgSpZuX/PubMGgcYb3gohfDN5lssABBRCO+RvKNN64gML3g10fjGosE
         a36zHJouFKw+7bkVI+EcGta0Yt0mvlvYX3pyspeR/Yv5y6FFjGmXOKztJ+2UlEqhH5Z7
         WAYKRlH2mx7wawrPgo+e++z2usFodGWwmhVgRE/PK20yj6KqNSQyiAh7dsFvZlimqctO
         tRDAoAhhdbUuk5IcAanZluJQnQfc1p20am79AcnHbvrlFl7R+8kb/rOTB+92Pzf7bl/E
         73H6GQr/58lHDF71G/DKI3zCKNvtWTz12+K9CrjWorFxdL04h7NN09U1CpM/lR9xy6+O
         9bdg==
X-Gm-Message-State: AOAM532BJ4aMpf+sR+TGy66kdxwf5MmedfpzHxy25sGHjfK5YdU9CKCb
        0+CzPGf1cfeTzEwUTMreoGbHIMQQWMTfxA==
X-Google-Smtp-Source: ABdhPJzp9+8tU7hNK8dUch6AG4rzoM8aZWmKlQbR7EyEo7boJbW7ZHtMArRSx2nMe9x4IKw+v/7V6A==
X-Received: by 2002:a2e:8096:: with SMTP id i22mr3937528ljg.176.1603647995906;
        Sun, 25 Oct 2020 10:46:35 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id d7sm875735ljg.140.2020.10.25.10.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 10:46:34 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kWk6I-0007HA-G8; Sun, 25 Oct 2020 18:46:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 01/14] USB: serial: keyspan_pda: fix dropped unthrottle interrupts
Date:   Sun, 25 Oct 2020 18:45:47 +0100
Message-Id: <20201025174600.27896-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025174600.27896-1-johan@kernel.org>
References: <20201025174600.27896-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c528fcb116e6 ("USB: serial: keyspan_pda: fix receive sanity
checks") broke write-unthrottle handling by dropping well-formed
unthrottle-interrupt packets which are precisely two bytes long. This
could lead to blocked writers not being woken up when buffer space again
becomes available.

Instead, stop unconditionally printing the third byte which is
(presumably) only valid on modem-line changes.

Fixes: c528fcb116e6 ("USB: serial: keyspan_pda: fix receive sanity checks")
Cc: stable <stable@vger.kernel.org>     # 4.11
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index c1333919716b..2d5ad579475a 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -172,11 +172,11 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 		break;
 	case 1:
 		/* status interrupt */
-		if (len < 3) {
+		if (len < 2) {
 			dev_warn(&port->dev, "short interrupt message received\n");
 			break;
 		}
-		dev_dbg(&port->dev, "rx int, d1=%d, d2=%d\n", data[1], data[2]);
+		dev_dbg(&port->dev, "rx int, d1=%d\n", data[1]);
 		switch (data[1]) {
 		case 1: /* modemline change */
 			break;
-- 
2.26.2

