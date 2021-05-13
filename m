Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1B137FABB
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbhEMPc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEMPc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2804261168;
        Thu, 13 May 2021 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919875;
        bh=gJQymUYJvG24nRqBiebvHTdaPdORqoGurwa9CgpiCFs=;
        h=Subject:To:From:Date:From;
        b=Cptb8VBKHmdlN5c0hlR1cLyGBMb2x9DOCp8e5jmxYKiZhWsUkSf8P2ZC7fDYHO+la
         y/Dl1ZwIeHuU+/hxFLV6CZLCwC2dkDrfmqCU09ie1JVjkyKfAYx0rQdncVaplfZQ+L
         m81it5BiodXzuqXB9HJS5dHLS7EukLu6dIS1xQ+M=
Subject: patch "Revert "leds: lp5523: fix a missing check of return value of" added to char-misc-linus
To:     gregkh@linuxfoundation.org, jacek.anaszewski@gmail.com,
        kjlu@umn.edu, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:31:03 +0200
Message-ID: <16209198637232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "leds: lp5523: fix a missing check of return value of

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8d1beda5f11953ffe135a5213287f0b25b4da41b Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:35 +0200
Subject: Revert "leds: lp5523: fix a missing check of return value of
 lp55xx_read"

This reverts commit 248b57015f35c94d4eae2fdd8c6febf5cd703900.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit does not properly unwind if there is an error
condition so it needs to be reverted at this point in time.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 248b57015f35 ("leds: lp5523: fix a missing check of return value of lp55xx_read")
Link: https://lore.kernel.org/r/20210503115736.2104747-9-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp5523.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index fc433e63b1dc..5036d7d5f3d4 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -305,9 +305,7 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
-	if (ret)
-		return ret;
+	lp55xx_read(chip, LP5523_REG_STATUS, &status);
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status != LP5523_ENG_STATUS_MASK) {
-- 
2.31.1


