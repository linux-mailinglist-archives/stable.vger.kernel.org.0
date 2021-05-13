Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F074037FABA
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhEMPcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEMPcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:32:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03448613BF;
        Thu, 13 May 2021 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919873;
        bh=X1ex2jrFvY07FQhcoRdNecEhAP9CUScGL9044NA6lDI=;
        h=Subject:To:From:Date:From;
        b=Zp4Dt/eJzsprou5KiGM5kQ+NBBse1OUPp4zMyx+cf810VG3YsJUEQkbl7Iu15geKp
         XN7N7NdPVzeD0NsUgN1MMJ1ftXQhHk0mwL4jL2s2ry1pBArTPfL3Z+FX3DtLOH4sRQ
         db7M2K/OiXZjGBVUOh7mi3c9zjrF+2C2GXu0zDbc=
Subject: patch "leds: lp5523: check return value of lp5xx_read and jump to cleanup" added to char-misc-linus
To:     phil@philpotter.co.uk, gregkh@linuxfoundation.org,
        jacek.anaszewski@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:31:03 +0200
Message-ID: <1620919863212249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    leds: lp5523: check return value of lp5xx_read and jump to cleanup

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6647f7a06eb030a2384ec71f0bb2e78854afabfe Mon Sep 17 00:00:00 2001
From: Phillip Potter <phil@philpotter.co.uk>
Date: Mon, 3 May 2021 13:56:36 +0200
Subject: leds: lp5523: check return value of lp5xx_read and jump to cleanup
 code

Check return value of lp5xx_read and if non-zero, jump to code at end of
the function, causing lp5523_stop_all_engines to be executed before
returning the error value up the call chain. This fixes the original
commit (248b57015f35) which was reverted due to the University of Minnesota
problems.

Cc: stable <stable@vger.kernel.org>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-10-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp5523.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 5036d7d5f3d4..b1590cb4a188 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -305,7 +305,9 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	if (ret)
+		goto out;
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status != LP5523_ENG_STATUS_MASK) {
-- 
2.31.1


