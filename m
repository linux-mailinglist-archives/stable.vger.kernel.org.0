Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8708F459EF5
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 10:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhKWJOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 04:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhKWJOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 04:14:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D2660F5A;
        Tue, 23 Nov 2021 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637658693;
        bh=uw8P7/0v1UxKq6wjCwJcO0k0TrTVKVVMdns8Y5hTk00=;
        h=From:To:Cc:Subject:Date:From;
        b=XgV4T7ldai2Qxq+dvxPzTs2iEBDoI9lnuFZMjPFEPxJDeorVjRdDzPeCyMXKIklCd
         EA4YBXc5zwap87uWJP9YdXq7h7A9wYHMOeeHVpWPlLQnHabGP0dihoAqHkTk6BE8IW
         uTMJzyrvryEUgSwSmWqLc/pUFQQmISKB2XKJOVOytcUruZcP2IaB3YCr2t0J7PHVYW
         T1Zsm95GTon/38o4PIuW0rszLUd3CBhugkvZjqMaTiRGGZp3imw3aiu4MSqwWgl8yN
         lfNSpP512uq9cjCyuJzklaSd5+epApiA23pLTeF6EsIrRRuJuqJmOAI60VMcUFYggy
         VhZOzlkWTjC0Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mpRpY-00080p-UQ; Tue, 23 Nov 2021 10:11:13 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Lundin <glance@acc.umu.se>, stable@vger.kernel.org
Subject: [PATCH] USB: serial: pl2303: fix GC type detection
Date:   Tue, 23 Nov 2021 10:10:17 +0100
Message-Id: <20211123091017.30708-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At least some PL2303GC have a bcdDevice of 0x105 instead of 0x100 as the
datasheet claims. Add it to the list of known release numbers for the
HXN (G) type.

Note the chip type could only be determined indirectly based on its
package being of QFP type, which appears to only be available for
PL2303GC.

Fixes: 894758d0571d ("USB: serial: pl2303: tighten type HXN (G) detection")
Reported-by: Anton Lundin <glance@acc.umu.se>
Link: https://lore.kernel.org/r/20211123071613.GZ108031@montezuma.acc.umu.se
Cc: stable@vger.kernel.org	# 5.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/pl2303.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index f45ca7ddf78e..a70fd86f735c 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -432,6 +432,7 @@ static int pl2303_detect_type(struct usb_serial *serial)
 	case 0x200:
 		switch (bcdDevice) {
 		case 0x100:
+		case 0x105:
 		case 0x305:
 		case 0x405:
 			/*
-- 
2.32.0

