Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1078B2A5713
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732712AbgKCVdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:33:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732246AbgKCU4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF9FC223AC;
        Tue,  3 Nov 2020 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437007;
        bh=3LmE73ilyoamoywy8JIeklBSBGD9wt2T9SyH+QaKNxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=criDklob6YwK7yAM7RW2UU2B3uiq7Wf+I6jwBr9av5PCRQ2ma+Q8DEGYEFgcXCLs+
         LupcZexmMQ3T7T9FnwnHurxdkxW4e7bA+TUr62djHjzRlbOruOggUHqR4TDkWVlSfj
         Y2Wep0/yKfduOXlGMTImY4e13VaqC9X1nya5OVgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Vijai Kumar K <vijaikumar.kanagarajan@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.4 105/214] extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips
Date:   Tue,  3 Nov 2020 21:35:53 +0100
Message-Id: <20201103203300.887564048@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 6aaad58c872db062f7ea2761421ca748bd0931cc upstream.

The driver uses atomic version of gpiod_set_value() without any real
reason.  It is called in a workqueue under mutex so it could sleep
there.  Changing it to "can_sleep" flavor allows to use the driver with
all GPIO chips.

Fixes: 4ed754de2d66 ("extcon: Add support for ptn5150 extcon driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Vijai Kumar K <vijaikumar.kanagarajan@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/extcon/extcon-ptn5150.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/extcon/extcon-ptn5150.c
+++ b/drivers/extcon/extcon-ptn5150.c
@@ -127,7 +127,7 @@ static void ptn5150_irq_work(struct work
 			case PTN5150_DFP_ATTACHED:
 				extcon_set_state_sync(info->edev,
 						EXTCON_USB_HOST, false);
-				gpiod_set_value(info->vbus_gpiod, 0);
+				gpiod_set_value_cansleep(info->vbus_gpiod, 0);
 				extcon_set_state_sync(info->edev, EXTCON_USB,
 						true);
 				break;
@@ -138,9 +138,9 @@ static void ptn5150_irq_work(struct work
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
@@ -156,7 +156,7 @@ static void ptn5150_irq_work(struct work
 					EXTCON_USB_HOST, false);
 			extcon_set_state_sync(info->edev,
 					EXTCON_USB, false);
-			gpiod_set_value(info->vbus_gpiod, 0);
+			gpiod_set_value_cansleep(info->vbus_gpiod, 0);
 		}
 	}
 


