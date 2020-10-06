Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6749284535
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 07:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgJFFHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 01:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbgJFFHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 01:07:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEB2208C3;
        Tue,  6 Oct 2020 05:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601960849;
        bh=2Lw05Nw7Nnhr3LxvA9LzlEGXYUIliAN66z8CjuaPzuc=;
        h=Subject:To:From:Date:From;
        b=guXWUDuHxywjcaUMCRHBpHAJbYHDN/HS0tGOhZswZdjoDWSUSsxjG7FT0PRLVK/oS
         9k8+WI7TTX2eeET7XWqTyWPWHvRomgbLjsQDje8Wc37tA57fKblwB15qmuLtCGRPE8
         0le5H85wCt9kTNdRptsoYfA/rSSb50WLmNo31/uo=
Subject: patch "extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips" added to char-misc-next
To:     krzk@kernel.org, cw00.choi@samsung.com, stable@vger.kernel.org,
        vijaikumar.kanagarajan@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Oct 2020 07:07:15 +0200
Message-ID: <1601960835625@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 6aaad58c872db062f7ea2761421ca748bd0931cc Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 17 Aug 2020 09:00:00 +0200
Subject: extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips

The driver uses atomic version of gpiod_set_value() without any real
reason.  It is called in a workqueue under mutex so it could sleep
there.  Changing it to "can_sleep" flavor allows to use the driver with
all GPIO chips.

Fixes: 4ed754de2d66 ("extcon: Add support for ptn5150 extcon driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Vijai Kumar K <vijaikumar.kanagarajan@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-ptn5150.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-ptn5150.c b/drivers/extcon/extcon-ptn5150.c
index d1c997599390..5f5252752644 100644
--- a/drivers/extcon/extcon-ptn5150.c
+++ b/drivers/extcon/extcon-ptn5150.c
@@ -127,7 +127,7 @@ static void ptn5150_irq_work(struct work_struct *work)
 			case PTN5150_DFP_ATTACHED:
 				extcon_set_state_sync(info->edev,
 						EXTCON_USB_HOST, false);
-				gpiod_set_value(info->vbus_gpiod, 0);
+				gpiod_set_value_cansleep(info->vbus_gpiod, 0);
 				extcon_set_state_sync(info->edev, EXTCON_USB,
 						true);
 				break;
@@ -138,9 +138,9 @@ static void ptn5150_irq_work(struct work_struct *work)
 					PTN5150_REG_CC_VBUS_DETECTION_MASK) >>
 					PTN5150_REG_CC_VBUS_DETECTION_SHIFT);
 				if (vbus)
-					gpiod_set_value(info->vbus_gpiod, 0);
+					gpiod_set_value_cansleep(info->vbus_gpiod, 0);
 				else
-					gpiod_set_value(info->vbus_gpiod, 1);
+					gpiod_set_value_cansleep(info->vbus_gpiod, 1);
 
 				extcon_set_state_sync(info->edev,
 						EXTCON_USB_HOST, true);
@@ -156,7 +156,7 @@ static void ptn5150_irq_work(struct work_struct *work)
 					EXTCON_USB_HOST, false);
 			extcon_set_state_sync(info->edev,
 					EXTCON_USB, false);
-			gpiod_set_value(info->vbus_gpiod, 0);
+			gpiod_set_value_cansleep(info->vbus_gpiod, 0);
 		}
 	}
 
-- 
2.28.0


