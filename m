Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2D01542E8
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgBFLSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:18:36 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44789 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgBFLSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 06:18:36 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so3802337lfa.11;
        Thu, 06 Feb 2020 03:18:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pwErtbI3xnwmywQ9OSFAG7Xr5a9dxG8gZfZfd//kVQI=;
        b=L0U6VuB2xaI6d6jxm2oXRiuesKaz9rc9RNF/FtLVcBTXzTzOyBqkM5pFk2xkVjaOF1
         lrfW8OAmPTLM3iwFvSvdkzO7xBwKGunovWqu1t5Sykrq/nmY7M7M+yamHDNXVI7TRkb9
         OwzrAmQC3OwiwiGDfuRwKpMsCVgpq+XYMPo+d0S1Ktxt7BKUom6Bdv99lnmXDWWLU4Ri
         CuunEQ+UmD09RFj/LUCNvt06taxhlMqzCW1GkFk5STJzexSSxtqfx0tZQdMc68lVw8g9
         k19JFUA6/R9JogoygGMZ2hSIB6Y0uPsswel/z1rJAb+ZcX15cqZpSU/X0Q+DQnNIzAD6
         0A4Q==
X-Gm-Message-State: APjAAAWsU96y7bqBDig4pyrsoJZ9fqSHsRSixRJT734BaC7d/MoYCPjQ
        LItZVdwU/EVFaO3J5pvEx9LirSOb
X-Google-Smtp-Source: APXvYqzIKTodeh1qrdc1d+WjRh4/+DavxB0azR7dC2tX7VBdVSFlpNMbZtl51pjy/iy7+/9DlSPbnQ==
X-Received: by 2002:a19:cc07:: with SMTP id c7mr1513704lfg.177.1580987914521;
        Thu, 06 Feb 2020 03:18:34 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id v26sm1363195ljh.90.2020.02.06.03.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:18:33 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1izfBG-0005Qi-G4; Thu, 06 Feb 2020 12:18:46 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Jakub Nantl <jn@forever.cz>, Jonathan Olds <jontio@i4free.co.nz>,
        Michael Dreher <michael@5dot1.de>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: serial: ch341: fix receiver regression
Date:   Thu,  6 Feb 2020 12:18:19 +0100
Message-Id: <20200206111819.20829-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While assumed not to make a difference, not using the factor 2 prescaler
makes the receiver more susceptible to errors.

Specifically, there have been reports of problems with devices that
cannot generate a 115200 rate with a smaller error than 2.1% (e.g.
117647 bps). But this can also be reproduced with a low-speed RS232
tranceiver at 115200 when the input rate is close to nominal.

So whenever possible, enable the factor 2 prescaler and halve the
divisor in order to use settings closer to that of the previous
algorithm.

Fixes: 35714565089e ("USB: serial: ch341: reimplement line-speed handling")
Cc: stable <stable@vger.kernel.org>	# 5.5
Reported-by: Jakub Nantl <jn@forever.cz>
Tested-by: Jakub Nantl <jn@forever.cz>
Signed-off-by: Johan Hovold <johan@kernel.org>
---

I was able to reproduce this using a MAX232 tranceiver at 115200 even
with a close-to-nominal input rate, so the receiver is definitely more
sensitive to errors with the 2-prescaler disabled.

Note that I had this step in the first version of the new algorithm, but
couldn't convince myself that it wasn't redundant.

Reverse-engineering is fun.

Johan


 drivers/usb/serial/ch341.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index df582fe855f0..415c3d31492b 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -205,6 +205,16 @@ static int ch341_get_divisor(speed_t speed)
 			16 * speed - 16 * CH341_CLKRATE / (clk_div * (div + 1)))
 		div++;
 
+	/*
+	 * Prefer lower base clock (fact = 0) if even divisor.
+	 *
+	 * Note that this makes the receiver more tolerant to errors.
+	 */
+	if (fact == 1 && div % 2 == 0) {
+		div /= 2;
+		fact = 0;
+	}
+
 	return (0x100 - div) << 8 | fact << 2 | ps;
 }
 
-- 
2.24.1

