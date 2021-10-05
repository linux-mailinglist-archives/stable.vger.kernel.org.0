Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB61342259C
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 13:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhJELr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 07:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJELr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 07:47:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E99611C5;
        Tue,  5 Oct 2021 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633434365;
        bh=+HBoEnJ7faWMoGEIf1nWeRGTU5MbqedydfT3aBBEHJU=;
        h=Subject:To:From:Date:From;
        b=iE7Xgq7rPrzRKrO9V6RyX9ZWV6UKzI7z8iLxV5L9QdKWIkg/PU1Frf7Re+z9CNq2b
         4POtivx9oY+T49dlSVklv2+ejoR5ZZq0ooIPA4kcIpEnWHKvX/0ptTNtCMCIjgQ6QA
         UUpMbFDd+73QjDChLvSS/p4BulJ6aNCb2HYfUWRE=
Subject: patch "Partially revert "usb: Kconfig: using select for USB_COMMON" added to usb-linus
To:     ben@decadent.org.uk, carnil@debian.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 13:46:04 +0200
Message-ID: <163343436493192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Partially revert "usb: Kconfig: using select for USB_COMMON

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4d1aa9112c8e6995ef2c8a76972c9671332ccfea Mon Sep 17 00:00:00 2001
From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 21 Sep 2021 16:34:42 +0200
Subject: Partially revert "usb: Kconfig: using select for USB_COMMON
 dependency"

This reverts commit cb9c1cfc86926d0e86d19c8e34f6c23458cd3478 for
USB_LED_TRIG.  This config symbol has bool type and enables extra code
in usb_common itself, not a separate driver.  Enabling it should not
force usb_common to be built-in!

Fixes: cb9c1cfc8692 ("usb: Kconfig: using select for USB_COMMON dependency")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Link: https://lore.kernel.org/r/20210921143442.340087-1-carnil@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/common/Kconfig b/drivers/usb/common/Kconfig
index 5e8a04e3dd3c..b856622431a7 100644
--- a/drivers/usb/common/Kconfig
+++ b/drivers/usb/common/Kconfig
@@ -6,8 +6,7 @@ config USB_COMMON
 
 config USB_LED_TRIG
 	bool "USB LED Triggers"
-	depends on LEDS_CLASS && LEDS_TRIGGERS
-	select USB_COMMON
+	depends on LEDS_CLASS && USB_COMMON && LEDS_TRIGGERS
 	help
 	  This option adds LED triggers for USB host and/or gadget activity.
 
-- 
2.33.0


