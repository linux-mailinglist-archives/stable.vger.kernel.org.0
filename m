Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDEE3A6474
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhFNLZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235339AbhFNLWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC30619A0;
        Mon, 14 Jun 2021 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667960;
        bh=xHuUsyPLWFHNYlTsmzeufcHP+qhncdqzgX3JJvCHss0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUvCtUrDbP4820UpNU6/o2N+/zN4Vjq/zBHZd5pbvPHwsqfG99VpTCt2J7PESjGBP
         Q2x9xOJdQu5ibNmo8/n8YOSGQIs1KU4s7QEgV2A6pSoEAZPFkw2MGRcGrHVJo6jhLM
         2+nbrXXrHn5s60LQEoFPWgXaOt1L7S2HEpiUdQrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.12 134/173] hwmon: (tps23861) define regmap max register
Date:   Mon, 14 Jun 2021 12:27:46 +0200
Message-Id: <20210614102702.620998197@linuxfoundation.org>
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

commit fb8543fb863e89baa433b4d716d73395caa1b7f4 upstream.

Define the max register address the device supports.
This allows reading the whole register space via
regmap debugfs, without it only register 0x0 is visible.

This was forgotten in the original driver commit.

Fixes: fff7b8ab2255 ("hwmon: add Texas Instruments TPS23861 driver")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://lore.kernel.org/r/20210609220728.499879-1-robert.marko@sartura.hr
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/tps23861.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/tps23861.c
+++ b/drivers/hwmon/tps23861.c
@@ -117,6 +117,7 @@ struct tps23861_data {
 static struct regmap_config tps23861_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
+	.max_register = 0x6f,
 };
 
 static int tps23861_read_temp(struct tps23861_data *data, long *val)


