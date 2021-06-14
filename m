Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DDA3A6493
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhFNL01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236273AbhFNLYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A7776148E;
        Mon, 14 Jun 2021 10:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668053;
        bh=21VDsJpGmE8rGqyBCfkppcYbfW2tihRVSaBbTlSFWcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3nrNwoqBj5EHOSMdgdeFHYfVa6nkXPeRgxU3y9DF5FbLnpagW4OZ+kcP8ifuWlYG
         s938iP+CsGUanUE3fnCgEtYP3AAhcrth2VV/Hnzb2urSyRsYzrfWKS/dgWfV1TyhIg
         RxIT0gjBcGSVxtVQRCSgF4/YsVuFiYOJFKddj0mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.12 136/173] hwmon: (tps23861) correct shunt LSB values
Date:   Mon, 14 Jun 2021 12:27:48 +0200
Message-Id: <20210614102702.693020353@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

commit e13d1127241404f1c3eb1379ac4dd100eaf385b4 upstream.

Current shunt LSB values got reversed during in the
original driver commit.

So, correct the current shunt LSB values according to
the datasheet.

This caused reading slightly skewed current values.

Fixes: fff7b8ab2255 ("hwmon: add Texas Instruments TPS23861 driver")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://lore.kernel.org/r/20210609220728.499879-3-robert.marko@sartura.hr
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/tps23861.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/tps23861.c
+++ b/drivers/hwmon/tps23861.c
@@ -105,8 +105,8 @@
 #define TEMPERATURE_LSB			652 /* 0.652 degrees Celsius */
 #define VOLTAGE_LSB			3662 /* 3.662 mV */
 #define SHUNT_RESISTOR_DEFAULT		255000 /* 255 mOhm */
-#define CURRENT_LSB_255			62260 /* 62.260 uA */
-#define CURRENT_LSB_250			61039 /* 61.039 uA */
+#define CURRENT_LSB_250			62260 /* 62.260 uA */
+#define CURRENT_LSB_255			61039 /* 61.039 uA */
 #define RESISTANCE_LSB			110966 /* 11.0966 Ohm*/
 #define RESISTANCE_LSB_LOW		157216 /* 15.7216 Ohm*/
 


