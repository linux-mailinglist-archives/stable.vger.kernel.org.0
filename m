Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7143D2982F0
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 18:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417872AbgJYRsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 13:48:05 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35431 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387660AbgJYRqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 13:46:39 -0400
Received: by mail-lf1-f66.google.com with SMTP id 77so8934560lfl.2;
        Sun, 25 Oct 2020 10:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=suE5N34er/4e4BcFNN72z7EVkNB7/KN/Giael/pa1Eg=;
        b=dcVgE0szjmvqDvecghcCSIlAMcXpIHSlb1rq1XGzxq6xciyPVWmyO4Sel255pRqtCw
         ackUrNRGrrq5PDD8U0kUozJlMsFf7Vhai1lz2E57YZh8q54tm8ttGRHoEJ3kTKpXNqLr
         5FYmyaV0pGT41DRoKG/NSA8boKpwsVX6n3uJEiM7P0WLMM6I5/qjeTGvjClMGAFpG4Y5
         8m5P0rvsibAMVJFRrjiPN++fukifcLT4ko3k7d3bphMH/DpoexAtd/uphuT9gsmjuN3c
         BloRiK4lQxEB8E2umsnDqQFlSAU1GZtDBG/rolV6w7UcNDkClWqcFdIceaV9s14pC6bn
         YFzw==
X-Gm-Message-State: AOAM531JcOMNTRI2nbhBV9o/wRutGQcXIjwPsqLfgRGn3cMgwKNEADfR
        DSk4u5BE4xucbXbNU3N6EwIm+3m42zuQCg==
X-Google-Smtp-Source: ABdhPJxIiOHtt8LWj7l6aKIHYE4NRB4+YxMnHGpo6FBMjKkduw2tIFd27OqFZ0B//u5KJzGeachBaw==
X-Received: by 2002:ac2:5699:: with SMTP id 25mr4135956lfr.396.1603647996348;
        Sun, 25 Oct 2020 10:46:36 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id f21sm793933lfc.122.2020.10.25.10.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 10:46:34 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kWk6I-0007HK-Md; Sun, 25 Oct 2020 18:46:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 03/14] USB: serial: keyspan_pda: fix stalled writes
Date:   Sun, 25 Oct 2020 18:45:49 +0100
Message-Id: <20201025174600.27896-4-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025174600.27896-1-johan@kernel.org>
References: <20201025174600.27896-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to clear the write-busy flag also in case no new data was
submitted due to lack of device buffer space so that writing is
resumed once space again becomes available.

Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 17b60e5a9f1f..d6ebde779e85 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -548,7 +548,7 @@ static int keyspan_pda_write(struct tty_struct *tty,
 
 	rc = count;
 exit:
-	if (rc < 0)
+	if (rc <= 0)
 		set_bit(0, &port->write_urbs_free);
 	return rc;
 }
-- 
2.26.2

