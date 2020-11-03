Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BDF2A58B8
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgKCUpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731001AbgKCUpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2D3223C6;
        Tue,  3 Nov 2020 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436319;
        bh=3LmE73ilyoamoywy8JIeklBSBGD9wt2T9SyH+QaKNxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLe5HS3te/5JS2FtY2rLfBrEshrTfPnwtTkdnQLyCQzotzCZsbCtOHudWJL2DVc+k
         iSDUyKOQJ1As3ov1R3y0tZN4ep1rY7Ab6042XwnkowlqTVE2k8qgsdueYfFMnDbxY5
         l2JNl8akW0Tm2sz7emWBceYN44UYzzJABsPpvVPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Vijai Kumar K <vijaikumar.kanagarajan@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.9 198/391] extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips
Date:   Tue,  3 Nov 2020 21:34:09 +0100
Message-Id: <20201103203400.254355642@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
 


