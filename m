Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0A4531725
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbiEWRks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbiEWRiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15BC92D3F;
        Mon, 23 May 2022 10:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6502661148;
        Mon, 23 May 2022 17:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CA2C385A9;
        Mon, 23 May 2022 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327098;
        bh=KMJw0XGdeFrhnpx31BYQkcRwZavS3EmcsQkFOgcVIGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GroUAV+3v2UGpKiPqa335qPbF8Ufz/AdH90lmQ35thd6fpo3AE/S46tkc65vd1rlZ
         l0KLLCh2StZf2tKeGaEAm2HRnkksKhYUSa2eP6XCS6pT5ABGTlwgoRrBq5xPMujN/G
         3oTo2Y6Z42DfR6s27NVP1TcrXCjUiCYVt1Om38sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.17 155/158] Input: ili210x - fix reset timing
Date:   Mon, 23 May 2022 19:05:12 +0200
Message-Id: <20220523165855.871483935@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit e4920d42ce0e9c8aafb7f64b6d9d4ae02161e51e upstream.

According to Ilitek "231x & ILI251x Programming Guide" Version: 2.30
"2.1. Power Sequence", "T4 Chip Reset and discharge time" is minimum
10ms and "T2 Chip initial time" is maximum 150ms. Adjust the reset
timings such that T4 is 12ms and T2 is 160ms to fit those figures.

This prevents sporadic touch controller start up failures when some
systems with at least ILI251x controller boot, without this patch
the systems sometimes fail to communicate with the touch controller.

Fixes: 201f3c803544c ("Input: ili210x - add reset GPIO support")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20220518204901.93534-1-marex@denx.de
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ili210x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -951,9 +951,9 @@ static int ili210x_i2c_probe(struct i2c_
 		if (error)
 			return error;
 
-		usleep_range(50, 100);
+		usleep_range(12000, 15000);
 		gpiod_set_value_cansleep(reset_gpio, 0);
-		msleep(100);
+		msleep(160);
 	}
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);


