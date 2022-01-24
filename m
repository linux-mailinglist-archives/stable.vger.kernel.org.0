Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9DD49A4EF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387666AbiAYAFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842147AbiAXX2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED8EC075D02;
        Mon, 24 Jan 2022 13:34:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C598614FE;
        Mon, 24 Jan 2022 21:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D5EC340E4;
        Mon, 24 Jan 2022 21:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060059;
        bh=nwhDRCmxaQ9ylnl0o8WM7gB9W7pbXqOdwinkHErgie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9NeBzo2bVV7wgNir+PdvwDj57dhprLi4GR1Dhi6wmoD6zGkMatyYdJ/4xbOeLQe6
         5pHqSpbe7Xn3K5FqyvubhQb1X60fOzzJJUkGS5kAeNorzSiy/wIRXzfs4vUuLW+fY3
         /CXgJlxxK9S8QMQzx17GO+KJEvHHuo63nbB8sEio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dario Binacchi <dariobin@libero.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0798/1039] Input: ti_am335x_tsc - fix STEPCONFIG setup for Z2
Date:   Mon, 24 Jan 2022 19:43:07 +0100
Message-Id: <20220124184152.124989565@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

[ Upstream commit 6bfeb6c21e1bdc11c328b7d996d20f0f73c6b9b0 ]

The Z2 step configuration doesn't erase the SEL_INP_SWC_3_0 bit-field
before setting the ADC channel. This way its value could be corrupted by
the ADC channel selected for the Z1 coordinate.

Fixes: 8c896308feae ("input: ti_am335x_adc: use only FIFO0 and clean up a little")
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Link: https://lore.kernel.org/r/20211212125358.14416-3-dariobin@libero.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ti_am335x_tsc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index fd3ffdd23470b..cfc943423241f 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -196,7 +196,10 @@ static void titsc_step_config(struct titsc *ts_dev)
 			STEPCONFIG_OPENDLY);
 
 	end_step++;
-	config |= STEPCONFIG_INP(ts_dev->inp_yn);
+	config = STEPCONFIG_MODE_HWSYNC |
+			STEPCONFIG_AVG_16 | ts_dev->bit_yp |
+			ts_dev->bit_xn | STEPCONFIG_INM_ADCREFM |
+			STEPCONFIG_INP(ts_dev->inp_yn);
 	titsc_writel(ts_dev, REG_STEPCONFIG(end_step), config);
 	titsc_writel(ts_dev, REG_STEPDELAY(end_step),
 			STEPCONFIG_OPENDLY);
-- 
2.34.1



