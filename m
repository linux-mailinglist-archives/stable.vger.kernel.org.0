Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D1628340C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 12:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgJEKhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 06:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgJEKhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 06:37:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC302078D;
        Mon,  5 Oct 2020 10:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601894227;
        bh=K5j35gHwfZTqoh6N6V43Al4AERWlzj9auiUPa0UDa2M=;
        h=Subject:To:From:Date:From;
        b=hdZg2l0a2c7YM7ggr29udnaKEqSCJebF8t73WPL/7Q41Nx1+WkoGN9125NL7OwaG8
         mZJbUrRXr3wt2qH00k28c1tDKSELvvfPCHTPebd23tfOEnJptITC9ykEmVUh4BmytL
         KkC564RwpD/qn0gurooN4CXgcG5RalbINp+5RNU0=
Subject: patch "extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips" added to char-misc-testing
To:     krzk@kernel.org, cw00.choi@samsung.com, stable@vger.kernel.org,
        vijaikumar.kanagarajan@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Oct 2020 12:37:48 +0200
Message-ID: <16018942683451@kroah.com>
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
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

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


