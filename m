Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F04531870
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbiEWRa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242681AbiEWR14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1EF8B0A0;
        Mon, 23 May 2022 10:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF9BC60919;
        Mon, 23 May 2022 17:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC546C385AA;
        Mon, 23 May 2022 17:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326628;
        bh=nScWFY4gOamTKpCNg1p1bMQC5EX4Fx5ExJONQ5sZ89k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMhG5g0uPt3YTEdcWoFYPEOh9wyBqBwtZ3VUb8wUur7O9QFnpsT0gzmKwkJ4VwWWd
         rWQX2o9xBIVbteZjIWgjOepV8msYyl4sngM9GPN6ck4/lxZ52K0TWI30wZqcN92Z8u
         MKQNQ0lGioOPtqGhorFX2JTLxQR6+ePG2jlkapoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 128/132] Input: ili210x - fix reset timing
Date:   Mon, 23 May 2022 19:05:37 +0200
Message-Id: <20220523165844.932797954@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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
@@ -420,9 +420,9 @@ static int ili210x_i2c_probe(struct i2c_
 		if (error)
 			return error;
 
-		usleep_range(50, 100);
+		usleep_range(12000, 15000);
 		gpiod_set_value_cansleep(reset_gpio, 0);
-		msleep(100);
+		msleep(160);
 	}
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);


