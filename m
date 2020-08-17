Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0AC245CE8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 09:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgHQHDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 03:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgHQHA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 03:00:27 -0400
Received: from localhost.localdomain (unknown [194.230.155.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC5F2072D;
        Mon, 17 Aug 2020 07:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597647626;
        bh=PYY8uXXlmytuiAxIl2R7A+XdZTSPkLshPeJXisdTWNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNU0etOLQpWcb3qMjipDoDxDj9JLuaaIOnZ8yUNr38mQuFXWCJrdNvSYDcSIJ/7DV
         3PgKsoksU/zqkRnRaB7roOJqpU7csaHTLwzLuZEUguwDtmCaTVBXAnLomgt7KWOTno
         Skka53gMXQxzddzNfZFRJWHtXluIukgyR62ZdCGk=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vijai Kumar K <vijaikumar.kanagarajan@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 04/13] extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips
Date:   Mon, 17 Aug 2020 09:00:00 +0200
Message-Id: <20200817070009.4631-5-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817070009.4631-1-krzk@kernel.org>
References: <20200817070009.4631-1-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver uses atomic version of gpiod_set_value() without any real
reason.  It is called in a workqueue under mutex so it could sleep
there.  Changing it to "can_sleep" flavor allows to use the driver with
all GPIO chips.

Fixes: 4ed754de2d66 ("extcon: Add support for ptn5150 extcon driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
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
2.17.1

