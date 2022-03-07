Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12BC4CF690
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiCGJmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240601AbiCGJlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E734B412;
        Mon,  7 Mar 2022 01:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F24461185;
        Mon,  7 Mar 2022 09:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFEFC340E9;
        Mon,  7 Mar 2022 09:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645877;
        bh=2obqsxI+/SH42dQ+X0D1aLLfemkok/28qdVTR7fdTIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkXlIAYoXmIkxwstjhK32pG+WmHgGLR37qO70jLSOEFJY/ezqAHfBJD/yDOGZ3/be
         q4yLmJaR89d+Gn8pt4oGI+vOsY/c2qNRce1uz57nohAERsLxejAsqJFkOtgTZyc70k
         U2TJ8J5BH9srxkAgXiDlOp48Gy1ClMphxtZiO42M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dario Binacchi <dariobin@libero.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/262] Input: ti_am335x_tsc - set ADCREFM for X configuration
Date:   Mon,  7 Mar 2022 10:16:48 +0100
Message-Id: <20220307091704.312755928@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

[ Upstream commit 73cca71a903202cddc8279fc76b2da4995da5bea ]

As reported by the STEPCONFIG[1-16] registered field descriptions of the
TI reference manual, for the ADC "in single ended, SEL_INM_SWC_3_0 must
be 1xxx".

Unlike the Y and Z coordinates, this bit has not been set for the step
configuration registers used to sample the X coordinate.

Fixes: 1b8be32e6914 ("Input: add support for TI Touchscreen controller")
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Link: https://lore.kernel.org/r/20211212125358.14416-2-dariobin@libero.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ti_am335x_tsc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 83e685557a197..fd3ffdd23470b 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -131,7 +131,8 @@ static void titsc_step_config(struct titsc *ts_dev)
 	u32 stepenable;
 
 	config = STEPCONFIG_MODE_HWSYNC |
-			STEPCONFIG_AVG_16 | ts_dev->bit_xp;
+			STEPCONFIG_AVG_16 | ts_dev->bit_xp |
+			STEPCONFIG_INM_ADCREFM;
 	switch (ts_dev->wires) {
 	case 4:
 		config |= STEPCONFIG_INP(ts_dev->inp_yp) | ts_dev->bit_xn;
-- 
2.34.1



