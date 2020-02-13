Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8591F15BED1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 13:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgBMM5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 07:57:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgBMM5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 07:57:54 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C2E2168B;
        Thu, 13 Feb 2020 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581598672;
        bh=itQ6h7CVo/FdRnRA+32H+mkhQxCxvoZHHeoXq9BO+NY=;
        h=Subject:To:From:Date:From;
        b=sGa0lmPGm1/qXm+nAij1VB2oZTQzK2eeP6UfvRx40J8xGMbyqeHyfQGOAIxD7N/EB
         HclPY4WufavOmCV6z1oBBUMgCCdEs1aydxUPucuBEywy5AhIuKKxAys63evHYpj0r5
         hOnMRzbV3Y84lkmoYx3m1a5/NPoWhwAE/nT5zwYk=
Subject: patch "USB: serial: ch341: fix receiver regression" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org, jn@forever.cz,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Feb 2020 04:57:44 -0800
Message-ID: <158159866430236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ch341: fix receiver regression

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7c3d02285ad558691f27fde760bcd841baa27eab Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 6 Feb 2020 12:18:19 +0100
Subject: USB: serial: ch341: fix receiver regression

While assumed not to make a difference, not using the factor-2 prescaler
makes the receiver more susceptible to errors.

Specifically, there have been reports of problems with devices that
cannot generate a 115200 rate with a smaller error than 2.1% (e.g.
117647 bps). But this can also be reproduced with a low-speed RS232
tranceiver at 115200 when the input rate matches the nominal rate.

So whenever possible, enable the factor-2 prescaler and halve the
divisor in order to use settings closer to that of the previous
algorithm.

Fixes: 35714565089e ("USB: serial: ch341: reimplement line-speed handling")
Cc: stable <stable@vger.kernel.org>	# 5.5
Reported-by: Jakub Nantl <jn@forever.cz>
Tested-by: Jakub Nantl <jn@forever.cz>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index d3f420f3a083..c5ecdcd51ffc 100644
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
2.25.0


