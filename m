Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E6837CB8A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242800AbhELQfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241692AbhELQ1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9500461452;
        Wed, 12 May 2021 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834909;
        bh=uUKBCEx+xu/CJ+3IUFcsmMbeVB37BPFrzy9AU3nZyzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aysXWxnVUb07oXAmkqmX9XssuIQIaZL3IleeHYyCXcbSqLLTI8lKbHOpzat9p2iWw
         HfK/OMoM13sSAgsIC7s3oN8/QuGktpcpDS/cm5offorpPSuBciUt06aXMTtO7TJMcR
         Ji+W7yEOwp1tbhAbfVGqpg94uoXm3dOI6gjvNRcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.12 132/677] mfd: stmpe: Revert "Constify static struct resource"
Date:   Wed, 12 May 2021 16:42:58 +0200
Message-Id: <20210512144841.615954646@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

commit cb9e880a797a77c21c0f0e7ccd553da8eb4870af upstream.

In stmpe_devices_init(), the start and end field of these structs are
modified, so they can not be const. Add a comment to those structs that
lacked it to reduce the risk that this happens again.

This reverts commit 8d7b3a6dac4eae22c58b0853696cbd256966741b.

Fixes: 8d7b3a6dac4e ("mfd: stmpe: Constify static struct resource")
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/stmpe.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -312,7 +312,7 @@ EXPORT_SYMBOL_GPL(stmpe_set_altfunc);
  * GPIO (all variants)
  */
 
-static const struct resource stmpe_gpio_resources[] = {
+static struct resource stmpe_gpio_resources[] = {
 	/* Start and end filled dynamically */
 	{
 		.flags	= IORESOURCE_IRQ,
@@ -336,7 +336,8 @@ static const struct mfd_cell stmpe_gpio_
  * Keypad (1601, 2401, 2403)
  */
 
-static const struct resource stmpe_keypad_resources[] = {
+static struct resource stmpe_keypad_resources[] = {
+	/* Start and end filled dynamically */
 	{
 		.name	= "KEYPAD",
 		.flags	= IORESOURCE_IRQ,
@@ -357,7 +358,8 @@ static const struct mfd_cell stmpe_keypa
 /*
  * PWM (1601, 2401, 2403)
  */
-static const struct resource stmpe_pwm_resources[] = {
+static struct resource stmpe_pwm_resources[] = {
+	/* Start and end filled dynamically */
 	{
 		.name	= "PWM0",
 		.flags	= IORESOURCE_IRQ,
@@ -445,7 +447,8 @@ static struct stmpe_variant_info stmpe80
  * Touchscreen (STMPE811 or STMPE610)
  */
 
-static const struct resource stmpe_ts_resources[] = {
+static struct resource stmpe_ts_resources[] = {
+	/* Start and end filled dynamically */
 	{
 		.name	= "TOUCH_DET",
 		.flags	= IORESOURCE_IRQ,
@@ -467,7 +470,8 @@ static const struct mfd_cell stmpe_ts_ce
  * ADC (STMPE811)
  */
 
-static const struct resource stmpe_adc_resources[] = {
+static struct resource stmpe_adc_resources[] = {
+	/* Start and end filled dynamically */
 	{
 		.name	= "STMPE_TEMP_SENS",
 		.flags	= IORESOURCE_IRQ,


