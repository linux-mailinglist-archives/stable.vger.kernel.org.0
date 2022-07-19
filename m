Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC51579F35
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243411AbiGSNMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiGSNLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:11:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FFA51A31;
        Tue, 19 Jul 2022 05:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99001B81B38;
        Tue, 19 Jul 2022 12:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0318BC341C6;
        Tue, 19 Jul 2022 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233743;
        bh=1BDzNVibBPwFTetTxO2mma3rWVto3LwloxGADTvjfGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDvjBsWb6FRGTZoGhIUO9PmZMg/kgFIvKpZXUkhsCY0ZDJaxMJmhrR2KJqGqejUO0
         TII6rds7aLtLKkFb2FmJbeacAivQEhKvRbChKY082XZiY9FMSh6xlZjstksqEav5Pr
         CYuQRbTTklkxfTCutTpLt/jBDPXBaCSmATiqIx2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dorian Rudolph <mail@dorianrudolph.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.18 226/231] power: supply: core: Fix boundary conditions in interpolation
Date:   Tue, 19 Jul 2022 13:55:11 +0200
Message-Id: <20220719114732.683402476@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dorian Rudolph <mail@dorianrudolph.com>

commit 093d27bb6f2d1963f927ef59c9a2d37059175426 upstream.

The functions power_supply_temp2resist_simple and power_supply_ocv2cap_simple
handle boundary conditions incorrectly.
The change was introduced in a4585ba2050f460f749bbaf2b67bd56c41e30283
("power: supply: core: Use library interpolation").
There are two issues: First, the lines "high = i - 1" and "high = i" in ocv2cap
have the wrong order compared to temp2resist. As a consequence, ocv2cap
sets high=-1 if ocv>table[0].ocv, which causes an out-of-bounds read.
Second, the logic of temp2resist is also not correct.
Consider the case table[] = {{20, 100}, {10, 80}, {0, 60}}.
For temp=5, we expect a resistance of 70% by interpolation.
However, temp2resist sets high=low=2 and returns 60.

Cc: stable@vger.kernel.org
Signed-off-by: Dorian Rudolph <mail@dorianrudolph.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: a4585ba2050f ("power: supply: core: Use library interpolation")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/power_supply_core.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -846,17 +846,17 @@ int power_supply_temp2resist_simple(stru
 {
 	int i, high, low;
 
-	/* Break loop at table_len - 1 because that is the highest index */
-	for (i = 0; i < table_len - 1; i++)
+	for (i = 0; i < table_len; i++)
 		if (temp > table[i].temp)
 			break;
 
 	/* The library function will deal with high == low */
-	if ((i == 0) || (i == (table_len - 1)))
-		high = i;
+	if (i == 0)
+		high = low = i;
+	else if (i == table_len)
+		high = low = i - 1;
 	else
-		high = i - 1;
-	low = i;
+		high = (low = i) - 1;
 
 	return fixp_linear_interpolate(table[low].temp,
 				       table[low].resistance,
@@ -958,17 +958,17 @@ int power_supply_ocv2cap_simple(struct p
 {
 	int i, high, low;
 
-	/* Break loop at table_len - 1 because that is the highest index */
-	for (i = 0; i < table_len - 1; i++)
+	for (i = 0; i < table_len; i++)
 		if (ocv > table[i].ocv)
 			break;
 
 	/* The library function will deal with high == low */
-	if ((i == 0) || (i == (table_len - 1)))
-		high = i - 1;
+	if (i == 0)
+		high = low = i;
+	else if (i == table_len)
+		high = low = i - 1;
 	else
-		high = i; /* i.e. i == 0 */
-	low = i;
+		high = (low = i) - 1;
 
 	return fixp_linear_interpolate(table[low].ocv,
 				       table[low].capacity,


