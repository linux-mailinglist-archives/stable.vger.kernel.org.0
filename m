Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EFE531A35
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbiEWRRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240874AbiEWRQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50CB3CA4B;
        Mon, 23 May 2022 10:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B7D160AB8;
        Mon, 23 May 2022 17:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797EBC385A9;
        Mon, 23 May 2022 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326191;
        bh=/Vk7ECsDXhpMvGRMfy4e9zNGXnb68sLiEKG/15Y2J1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJFlz376M95fHKT4usOpk1+DU/nlMnRhfnCUtso+mWTaaS8YUHut7kQUCINU1sE8T
         hHcMRGQ28r5KNFP7HbcebVgose+Loi7OsSZ3/EwluoMZ7LRTgevTCSOCtu83krd3O9
         ATzGQUIJKB5T8AcIl+dHxG3oINVimY/euVguw3Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 59/68] Input: ili210x - fix reset timing
Date:   Mon, 23 May 2022 19:05:26 +0200
Message-Id: <20220523165812.193006556@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
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
@@ -290,9 +290,9 @@ static int ili210x_i2c_probe(struct i2c_
 		if (error)
 			return error;
 
-		usleep_range(50, 100);
+		usleep_range(12000, 15000);
 		gpiod_set_value_cansleep(reset_gpio, 0);
-		msleep(100);
+		msleep(160);
 	}
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);


